import 'dart:io';
import 'dart:math';
import 'package:flutter/material.dart';
import 'package:flutter_sound/flutter_sound.dart';
import 'package:path/path.dart' as path;

class AudioWaveformWidget extends StatefulWidget {
  final String audioFilePath;
  final bool isPlaying;
  final Color primaryColor;

  const AudioWaveformWidget({
    Key? key,
    required this.audioFilePath,
    required this.isPlaying,
    required this.primaryColor,
  }) : super(key: key);

  @override
  _AudioWaveformWidgetState createState() => _AudioWaveformWidgetState();
}

class _AudioWaveformWidgetState extends State<AudioWaveformWidget> {
  List<double> _audioAmplitudes = [];

  @override
  void initState() {
    super.initState();
    _generateRandomWaveform();
  }

  void _generateRandomWaveform() {
    // Create a pseudo-random but consistent waveform based on file path
    final random = Random(path.basename(widget.audioFilePath).hashCode);
    
    // Generate 50 amplitude points
    _audioAmplitudes = List.generate(50, (_) {
      // Generate values between 0.2 and 1.0 for more natural look
      return 0.2 + random.nextDouble() * 0.8;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 40,
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.end,
        children: _buildWaveformBars(),
      ),
    );
  }

  List<Widget> _buildWaveformBars() {
    return _audioAmplitudes.map((amplitude) {
      // Create a bar with height proportional to amplitude
      return Expanded(
        child: Container(
          margin: const EdgeInsets.symmetric(horizontal: 1),
          decoration: BoxDecoration(
            color: widget.isPlaying 
              ? widget.primaryColor.withOpacity(amplitude) 
              : widget.primaryColor.withOpacity(0.2),
            borderRadius: BorderRadius.circular(2),
          ),
          height: max(4, amplitude * 30), // Ensure minimum height
        ),
      );
    }).toList();
  }
}