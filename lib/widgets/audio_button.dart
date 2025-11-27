import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../services/audio_service.dart';

class AudioButton extends StatelessWidget {
  const AudioButton({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<AudioService>(
      builder: (context, audioService, child) {
        return IconButton(
          onPressed: () {
            if (audioService.isPlaying) {
              audioService.pauseMusic();
            } else {
              audioService.resumeMusic();
            }
          },
          icon: Icon(
            audioService.isPlaying ? Icons.pause : Icons.play_arrow,
          ),
        );
      },
    );
  }
}
