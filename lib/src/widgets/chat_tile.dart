import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../screens/chat_details_screen.dart';
import '../theme/app_colors.dart';
import '../theme/app_styles.dart';
import 'audio_waveform.dart';

class ChatTile extends StatefulWidget {
  final String text;
  final bool isReceived;
  final Message message;
  final bool isAudio;

  // New parameters for audio playback
  final bool isCurrentlyPlaying;
  final double playbackProgress;
  final Duration audioPosition;
  final Duration audioDuration;
  final Function(Message message) onPlayPausePressed;

  const ChatTile({
    super.key,
    required this.text,
    this.isReceived = true,
    required this.message,
    this.isAudio = false,
    this.isCurrentlyPlaying = false,
    this.playbackProgress = 0.0,
    this.audioPosition = Duration.zero,
    this.audioDuration = Duration.zero,
    required this.onPlayPausePressed,
  });

  @override
  ChatTileState createState() => ChatTileState();
}

class ChatTileState extends State<ChatTile> {
  bool isExpanded = false;

  // Helper method to format duration
  String _formatDuration(Duration duration) {
    return '${duration.inMinutes.toString().padLeft(2, '0')}:'
        '${(duration.inSeconds % 60).toString().padLeft(2, '0')}';
  }

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        // Audio message layout
        if (widget.isAudio) {
          return Align(
            alignment: widget.isReceived
                ? Alignment.centerLeft
                : Alignment.centerRight,
            child: Container(
              width: constraints.maxWidth - 48.w,
              margin: EdgeInsets.symmetric(horizontal: 10.w, vertical: 8.h),
              decoration: BoxDecoration(
                color: widget.isReceived == false
                    ? Theme.of(context).primaryColor
                    : AppColors.chatFillColor,
                borderRadius: widget.isReceived == false
                    ? BorderRadius.only(
                        topRight: Radius.circular(50.r),
                        topLeft: Radius.circular(50.r),
                        bottomLeft: Radius.circular(50.r),
                      )
                    : BorderRadius.only(
                        topRight: Radius.circular(50.r),
                        topLeft: Radius.circular(50.r),
                        bottomRight: Radius.circular(50.r),
                      ),
              ),
              child: Padding(
                padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 12.h),
                child: Column(
                  children: [
                    Row(
                      children: [
                        IconButton(
                          icon: Icon(
                            widget.isCurrentlyPlaying
                                ? Icons.pause
                                : Icons.play_arrow,
                            color: AppColors.tertiaryTextColor,
                          ),
                          onPressed: () {
                            widget.onPlayPausePressed(widget.message);
                          },
                        ),
                        Expanded(
                          child: Column(
                            children: [
                              LinearProgressIndicator(
                                value: widget.playbackProgress,
                                backgroundColor: Colors.grey.shade300,
                                valueColor: AlwaysStoppedAnimation(
                                    widget.isReceived
                                        ? Theme.of(context).primaryColor
                                        : AppColors.darkBackgroundColor),
                              ),
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(
                                    _formatDuration(widget.audioPosition),
                                    style: TextStyle(fontSize: 12.sp),
                                  ),
                                  Text(
                                    _formatDuration(widget.audioDuration),
                                    style: TextStyle(fontSize: 12.sp),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          );
        }

        // Text message layout (existing implementation)
        final textPainter = TextPainter(
          text: TextSpan(
            text: widget.text,
            style: TextStyle(fontSize: 16.0.sp),
          ),
          maxLines: null,
          textDirection: TextDirection.ltr,
        )..layout(maxWidth: constraints.maxWidth - 48.w);

        final textWidth = textPainter.size.width;
        final needsExpansion = textPainter.computeLineMetrics().length > 5;

        return Align(
          alignment:
              widget.isReceived ? Alignment.centerLeft : Alignment.centerRight,
          child: Container(
            width: textWidth + 48.w,
            margin: EdgeInsets.symmetric(horizontal: 12.w, vertical: 8.h),
            decoration: BoxDecoration(
              color: widget.isReceived == false
                  ? Theme.of(context).primaryColor
                  : AppColors.chatFillColor,
              borderRadius: widget.isReceived == false
                  ? BorderRadius.only(
                      topRight: Radius.circular(50.r),
                      topLeft: Radius.circular(50.r),
                      bottomLeft: Radius.circular(50.r),
                    )
                  : BorderRadius.only(
                      topRight: Radius.circular(50.r),
                      topLeft: Radius.circular(50.r),
                      bottomRight: Radius.circular(50.r),
                    ),
            ),
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 12.h),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    widget.text,
                    style: widget.isReceived
                        ? Theme.of(context).primaryTextTheme.labelLarge?.merge(
                            TextStyle(color: AppColors.tertiaryTextColor))
                        : Theme.of(context).primaryTextTheme.labelLarge,
                    maxLines: isExpanded ? null : 5,
                    overflow: isExpanded
                        ? TextOverflow.visible
                        : TextOverflow.ellipsis,
                  ),
                  if (needsExpansion)
                    GestureDetector(
                      onTap: () {
                        setState(() {
                          isExpanded = !isExpanded;
                        });
                      },
                      child: Padding(
                        padding: EdgeInsets.only(top: 8.h, bottom: 8.h),
                        child: Text(
                          isExpanded ? 'Show Less' : 'Read More',
                          textAlign: TextAlign.end,
                          style: TextStyle(
                            color:
                                Theme.of(context).brightness == Brightness.light
                                    ? AppColors.lightReadMoreTextColor
                                    : AppColors.darkReadMoreTextColor,
                            fontSize: 14.0.sp,
                          ),
                        ),
                      ),
                    ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}
