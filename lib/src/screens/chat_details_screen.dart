import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_sound/flutter_sound.dart';
import 'package:audio_session/audio_session.dart';
import 'package:harmony/src/models/chat_model.dart';
import 'package:harmony/src/theme/app_styles.dart';
import 'package:harmony/src/widgets/chat_tile.dart';
import 'package:harmony/src/widgets/profile_image.dart';
import 'dart:io';
import 'package:logger/logger.dart';
import 'package:flutter_sound_platform_interface/flutter_sound_recorder_platform_interface.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';

import '../theme/app_colors.dart';

class ChatDetailsScreen extends StatefulWidget {
  final Chat chat;

  const ChatDetailsScreen({super.key, required this.chat});

  @override
  ChatDetailsScreenState createState() => ChatDetailsScreenState();
}

class ChatDetailsScreenState extends State<ChatDetailsScreen> {
  final TextEditingController _messageController = TextEditingController();
  final FlutterSoundRecorder _recorder =
      FlutterSoundRecorder(logLevel: Level.off);
  final FlutterSoundPlayer _player = FlutterSoundPlayer(logLevel: Level.off);

  List<Message> _messages = [];
  bool _isRecording = false;
  String? _currentAudioFilePath;
  Message? _currentPlayingMessage;
  bool _isPlaying = false;
  double _playbackProgress = 0.0;
  StreamSubscription? _mPlayerSubscription;

  // New variables for audio duration tracking
  Duration _audioDuration = Duration.zero;
  Duration _audioPosition = Duration.zero;

  Codec _codec = Codec.aacMP4;
  bool _recorderIsInitialized = false;
  bool _playerIsInitialized = false;

  @override
  void initState() {
    super.initState();
    _initializeAudioComponents();
  }

  Future<void> _initializeAudioComponents() async {
    try {
      // Open recorder and player
      await _recorder.openRecorder();
      await _player.openPlayer();

      // Configure audio session
      final session = await AudioSession.instance;
      await session.configure(AudioSessionConfiguration(
        avAudioSessionCategory: AVAudioSessionCategory.playAndRecord,
        avAudioSessionCategoryOptions:
            AVAudioSessionCategoryOptions.allowBluetooth |
                AVAudioSessionCategoryOptions.defaultToSpeaker,
        avAudioSessionMode: AVAudioSessionMode.spokenAudio,
        avAudioSessionRouteSharingPolicy:
            AVAudioSessionRouteSharingPolicy.defaultPolicy,
        avAudioSessionSetActiveOptions: AVAudioSessionSetActiveOptions.none,
        androidAudioAttributes: const AndroidAudioAttributes(
          contentType: AndroidAudioContentType.speech,
          flags: AndroidAudioFlags.none,
          usage: AndroidAudioUsage.voiceCommunication,
        ),
        androidAudioFocusGainType: AndroidAudioFocusGainType.gain,
        androidWillPauseWhenDucked: true,
      ));

      // Request permissions
      var micStatus = await Permission.microphone.request();
      var storageStatus = await Permission.storage.request();

      if (micStatus.isDenied || storageStatus.isDenied) {
        _showErrorSnackBar("Microphone or storage permission denied");
        return;
      }

      // Check codec support
      if (!await _recorder.isEncoderSupported(_codec)) {
        _codec = Codec.opusWebM;
        if (!await _recorder.isEncoderSupported(_codec)) {
          _showErrorSnackBar("No supported audio codec found");
          return;
        }
      }

      setState(() {
        _recorderIsInitialized = true;
        _playerIsInitialized = true;
      });
    } catch (e) {
      print("Comprehensive audio initialization error: $e");
      _showErrorSnackBar("Failed to initialize audio components");
    }
  }

  @override
  void dispose() {
    _messageController.dispose();
    _player.closePlayer();
    _recorder.closeRecorder();
    _mPlayerSubscription?.cancel();
    if (_currentAudioFilePath != null) {
      File(_currentAudioFilePath!).delete();
    }
    super.dispose();
  }

  void _sendMessage() {
    if (_messageController.text.isNotEmpty) {
      setState(() {
        _messages.add(Message(
          text: _messageController.text,
          isAudio: false,
        ));
        _messageController.clear();
      });
    }
  }

  Future<void> _startRecording() async {
    if (!_recorderIsInitialized) {
      _showErrorSnackBar("Audio recorder not initialized");
      return;
    }

    try {
      final tempDir = await getTemporaryDirectory();
      final audioFilePath =
          '${tempDir.path}/${DateTime.now().millisecondsSinceEpoch}.mp4';

      print("Attempting to record to: $audioFilePath");

      await _recorder.startRecorder(
        toFile: audioFilePath,
        codec: _codec,
        audioSource: AudioSource.microphone,
      );

      setState(() {
        _isRecording = true;
        _currentAudioFilePath = audioFilePath;
      });
    } catch (e) {
      print("Error starting recording: $e");
      _showErrorSnackBar("Failed to start audio recording");
    }
  }

  Future<void> _stopRecording() async {
    if (!_isRecording) return;

    try {
      final path = await _recorder.stopRecorder();
      print("Recording stopped. Path: $path");

      setState(() {
        _isRecording = false;
        if (path != null) {
          final file = File(path);
          if (file.existsSync() && file.lengthSync() > 0) {
            _messages.add(
              Message(
                text: 'Audio message',
                isAudio: true,
                audioFilePath: path,
              ),
            );
          } else {
            _showErrorSnackBar("Audio recording failed or file is empty");
          }
        }
      });
    } catch (e) {
      print("Error stopping recording: $e");
      _showErrorSnackBar("Failed to stop audio recording");
    }
  }

  Future<void> _playAudioMessage(Message message) async {
    if (!_playerIsInitialized) {
      _showErrorSnackBar("Audio player not initialized");
      return;
    }

    try {
      // Stop any previous playback subscription
      if (_mPlayerSubscription != null) {
        await _mPlayerSubscription?.cancel();
      }

      // Toggle play/pause for the same message
      if (_currentPlayingMessage == message) {
        if (_isPlaying) {
          // If currently playing, pause
          await _player.pausePlayer();
          setState(() {
            _isPlaying = false;
          });
        } else {
          // If paused, resume
          await _player.resumePlayer();

          // Re-establish progress tracking when resuming
          _mPlayerSubscription = _player.onProgress!.listen((event) {
            if (mounted) {
              setState(() {
                _audioPosition = event.position;
                _audioDuration = event.duration;
                _playbackProgress = event.position.inMilliseconds /
                    event.duration.inMilliseconds;

                // Ensure progress is between 0 and 1
                _playbackProgress = _playbackProgress.clamp(0.0, 1.0);

                _currentPlayingMessage = message;
                _isPlaying = true;
              });
            }
          }, onError: (error) {
            print("Playback progress error: $error");
            _showErrorSnackBar("Error during audio playback");
          });

          setState(() {
            _isPlaying = true;
          });
        }
        return;
      }

      // Validate audio file
      if (message.audioFilePath == null) {
        _showErrorSnackBar("Invalid audio file");
        return;
      }

      final audioFile = File(message.audioFilePath!);
      if (!audioFile.existsSync() || audioFile.lengthSync() == 0) {
        _showErrorSnackBar("Invalid or empty audio file");
        return;
      }

      // Open the audio file
      await _player.openPlayer();
      _player.setSubscriptionDuration(const Duration(milliseconds: 10));

      // Start playing the audio
      await _player.startPlayer(
        fromURI: message.audioFilePath,
        whenFinished: () {
          setState(() {
            _isPlaying = false;
            _currentPlayingMessage = null;
            _audioPosition = Duration.zero;
            _playbackProgress = 0.0;
          });
        },
      );

      // Listen to playback progress
      _mPlayerSubscription = _player.onProgress!.listen((event) {
        if (mounted) {
          setState(() {
            _audioPosition = event.position;
            _audioDuration = event.duration;
            _playbackProgress =
                event.position.inMilliseconds / event.duration.inMilliseconds;

            // Ensure progress is between 0 and 1
            _playbackProgress = _playbackProgress.clamp(0.0, 1.0);

            // Update current playing message
            _currentPlayingMessage = message;
            _isPlaying = true;
          });
        }
      }, onError: (error) {
        print("Playback progress error: $error");
        _showErrorSnackBar("Error during audio playback");
      });
    } catch (e) {
      print("Comprehensive audio playback error: $e");
      _showErrorSnackBar("Failed to play audio message");
    }
  }

  // Helper method to format duration
  String _formatDuration(Duration duration) {
    return '${duration.inMinutes.remainder(60).toString().padLeft(2, '0')}:'
        '${duration.inSeconds.remainder(60).toString().padLeft(2, '0')}';
  }

  void _showErrorSnackBar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: Colors.red,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          Padding(
            padding:
                EdgeInsets.only(top: MediaQuery.of(context).viewPadding.top),
            child: Row(
              children: [
                IconButton(
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  icon: Image.asset(
                    "assets/images/back_arrow.png",
                    width: 13.w,
                    height: 14.39.h,
                    color: Theme.of(context).iconTheme.color?.withOpacity(1),
                  ),
                ),
                ProfileImage(image: widget.chat.profileImageUrl),
                Text(
                  widget.chat.userName,
                  style: Theme.of(context).primaryTextTheme.titleMedium,
                ),
                const Spacer(),
                Image.asset(
                  "assets/images/caller.png",
                  width: 15.3.w,
                  height: 20.1.h,
                  color: Theme.of(context).iconTheme.color?.withOpacity(1),
                ),
                Padding(
                  padding: EdgeInsets.only(right: 19.w, left: 33.w),
                  child: Image.asset(
                    "assets/images/video_recorder.png",
                    width: 24.3.w,
                    height: 17.32.h,
                    color: Theme.of(context).iconTheme.color?.withOpacity(1),
                  ),
                ),
              ],
            ),
          ),
          SizedBox(height: 12.h),
          Divider(color: AppColors.chatFillColor, height: 1.h),
          Expanded(
            child: ListView.builder(
              padding: EdgeInsets.only(top: 30.h),
              itemCount: _messages.length,
              itemBuilder: (context, index) {
                final message = _messages[index];
                return Padding(
                  padding: const EdgeInsets.symmetric(
                      vertical: 8.0, horizontal: 16.0),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      ProfileImage(image: widget.chat.profileImageUrl),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            ChatTile(
                              text: message.text,
                              isAudio: message.isAudio,
                              message: message,
                              isCurrentlyPlaying:
                                  _currentPlayingMessage == message &&
                                      _isPlaying,
                              playbackProgress:
                                  _currentPlayingMessage == message
                                      ? _playbackProgress
                                      : 0.0,
                              audioPosition: _currentPlayingMessage == message
                                  ? _audioPosition
                                  : Duration.zero,
                              audioDuration: _currentPlayingMessage == message
                                  ? _audioDuration
                                  : Duration.zero,
                              onPlayPausePressed: (message) =>
                                  _playAudioMessage(message),
                              isReceived: true, // or false based on your logic
                            )
                          ],
                        ),
                      ),
                    ],
                  ),
                );
              },
            ),
          ),
          Padding(
            padding: EdgeInsets.only(
                left: 16.w, right: 16.w, bottom: 12.h, top: 17.h),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    cursorColor: Theme.of(context).primaryColor,
                    controller: _messageController,
                    cursorHeight: 15.sp,
                    style: AppStyles.secondaryText.merge(
                      const TextStyle(color: AppColors.fieldInputColor),
                    ),
                    decoration: InputDecoration(
                      contentPadding: EdgeInsets.only(
                          left: 22.w, right: 15.w, top: 13.h, bottom: 13.h),
                      suffixIconConstraints: BoxConstraints(
                          maxWidth: 50.w,
                          maxHeight: 18.h,
                          minWidth: 50.w,
                          minHeight: 18.h),
                      suffixIcon: GestureDetector(
                        onTap: () => _sendMessage(),
                        child: Image.asset(
                          "assets/images/send_icon.png",
                          width: 18.w,
                          height: 18.h,
                        ),
                      ),
                      hintStyle: AppStyles.secondaryText.merge(
                        const TextStyle(color: AppColors.fieldInputColor),
                      ),
                      fillColor: AppColors.primaryTextColor.withOpacity(0.15),
                      filled: true,
                      hintText: 'Send Message',
                      border: OutlineInputBorder(
                        borderSide: BorderSide.none,
                        borderRadius: BorderRadius.circular(28.r),
                      ),
                    ),
                  ),
                ),
                Padding(
                  padding: EdgeInsets.only(left: 8.w),
                  child: GestureDetector(
                    onTap: () async {
                      if (_isRecording) {
                        await _stopRecording();
                      } else {
                        await _startRecording();
                      }
                    },
                    child: CircleAvatar(
                      backgroundColor: Theme.of(context).primaryColor,
                      radius: 25.r,
                      child: _isRecording
                          ? Icon(Icons.stop, size: 30.sp, color: Colors.white)
                          : Image.asset(
                              "assets/images/recorder.png",
                              color: Colors.white,
                              width: 16.w,
                              height: 21.h,
                            ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class Message {
  final String text;
  final bool isAudio;
  final String? audioFilePath;

  Message({
    required this.text,
    required this.isAudio,
    this.audioFilePath,
  });
}
