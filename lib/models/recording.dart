import 'dart:io';

class AudioFile {
  AudioFile({
    required this.file,
    required this.fileDuration,
  });

  final FileSystemEntity file;
  final Duration fileDuration;
}
