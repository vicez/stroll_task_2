
import 'package:just_audio/just_audio.dart';

class AudioPlayerService {
  final _audioPlayer = AudioPlayer();

  Future<Duration?> setPath(String filePath) async {
    final duration = await _audioPlayer.setFilePath(filePath);
    return duration;
  }

  Future<void> play() async {
    await _audioPlayer.play();
  }

  Future<void> pause() async {
    await _audioPlayer.pause();
  }

  Future<void> stop() async {
    await _audioPlayer.stop();
  }

  Future<void> resetPosition() async {
    await _audioPlayer.seek(Duration.zero);
  }

  Stream<PlayerState> get playerState => _audioPlayer.playerStateStream;

  Future<void> dispose() async {
    await _audioPlayer.dispose();
  }
}
