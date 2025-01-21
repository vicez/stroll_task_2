import 'dart:io';

import 'package:flutter/material.dart';
import 'package:just_audio/just_audio.dart';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:record/record.dart';
import 'package:stroll_task_2/models/recorder_prop_model.dart';
import 'package:stroll_task_2/models/recording.dart';
import 'package:stroll_task_2/widgets/waveform.dart';

import '../enums.dart';
import '../services/audio_player_service.dart';
import '../services/permission_service.dart';

class Recorder extends StatefulWidget {
  const Recorder({
    super.key,
    required this.firstScreenLoad,
    required this.animationDuration,
  });

  final bool firstScreenLoad;
  final Duration animationDuration;

  @override
  State<Recorder> createState() => _RecorderState();
}

class _RecorderState extends State<Recorder>
    with SingleTickerProviderStateMixin {
  late AudioRecorder _audioRecorder;
  late AudioPlayerService _player;
  AudioFile? lastRecordedFile;
  RecorderState recorderState = RecorderState.rest;
  Duration _currentPosition = Duration.zero;
  Duration _tickerElapsed = Duration.zero;

  late final _ticker = createTicker((elapsed) {
    setState(() {
      if (recorderState == RecorderState.playing && lastRecordedFile != null) {
        if ((_currentPosition + _tickerElapsed) <
            lastRecordedFile!.fileDuration) {
          _tickerElapsed = elapsed;
        } else {
          _stopTicker();
        }
      } else if (recorderState == RecorderState.recording) {
        _tickerElapsed = elapsed;
      }
    });
  });

  @override
  void initState() {
    _audioRecorder = AudioRecorder();
    _player = AudioPlayerService();

    _player.playerState.listen((event) {
      if (event.processingState == ProcessingState.completed) {
        debugPrint('completed');
        _resetTicker();
        _player.pause();
        _player.resetPosition();
      }
    });
    super.initState();
  }

  @override
  void dispose() {
    _audioRecorder.dispose();
    _player.stop();
    _player.dispose();
    _ticker.dispose();
    deleteFile(reloadScreen: false);
    super.dispose();
  }

  void _startTicker() {
    if (_ticker.isTicking) {
      _stopTicker();
    }
    _currentPosition += _tickerElapsed;
    _tickerElapsed = Duration.zero;
    _ticker.start();
  }

  void _stopTicker() => _ticker.stop();
  void _resetTicker() {
    _stopTicker();
    setState(() => _tickerElapsed = _currentPosition = Duration.zero);
  }

  Future<void> startRecording() async {
    final permnissionGranted = await PermissionService.checkPermissionStatus();

    if (permnissionGranted) {
      try {
        Directory appDirectory = await getApplicationDocumentsDirectory();
        String filepath =
            '${appDirectory.path}/${DateTime.now().millisecondsSinceEpoch.toString()}.wav';

        setState(() {
          recorderState = RecorderState.recording;
        });
        _startTicker();
        await _audioRecorder.start(
          const RecordConfig(encoder: AudioEncoder.wav),
          path: filepath,
        );
      } catch (e) {
        _resetTicker();
        setState(() {
          recorderState = RecorderState.rest;
        });
        debugPrint('Error while recording: $e');
      }
    }
  }

  Future<void> stopRecording() async {
    try {
      final path = await _audioRecorder.stop();
      _resetTicker();
      if (path != null) {
        getRecording(path);
      } else {
        throw 'Error fetching audio';
      }
    } catch (e) {
      debugPrint('Error occured: $e');
    }
  }

  Future<void> getRecording(String path) async {
    final storageStatus = await Permission.storage.request();
    if (storageStatus.isGranted) {
      final fileExists = File(path).existsSync();
      if (fileExists) {
        _player.stop();
        Duration? fileDuration = await _player.setPath(path);
        if (fileDuration != null) {
          setState(() {
            lastRecordedFile =
                AudioFile(file: File(path), fileDuration: fileDuration);
            recorderState = RecorderState.stopped;
          });
        }
      }
    }
  }

  void deleteFile({bool reloadScreen = true}) {
    if (lastRecordedFile != null &&
        File(lastRecordedFile!.file.path).existsSync()) {
      File(lastRecordedFile!.file.path).deleteSync();
      if (reloadScreen) {
        setState(() {
          lastRecordedFile = null;
          recorderState = RecorderState.rest;
        });
        _resetTicker();
      } else {
        lastRecordedFile = null;
        recorderState = RecorderState.rest;
      }
    }
  }

  RecorderPropModel _getRecorderProps() {
    final totalTimeFromTicker = _currentPosition + _tickerElapsed;
    switch (recorderState) {
      case RecorderState.rest:
        return RecorderPropModel(
          actionBtnIcon: Icons.fiber_manual_record_rounded,
          durationTextColor: const Color(0xff5D6369),
          actionTextColor: const Color(0xff5D6369),
          recorderLabel: _durationString(totalTimeFromTicker),
          iconSize: 64,
        );
      case RecorderState.recording:
        return RecorderPropModel(
          actionBtnIcon: Icons.stop_rounded,
          durationTextColor: const Color(0xffBFBDFF),
          actionTextColor: const Color(0xff5D6369),
          recorderLabel: _durationString(totalTimeFromTicker),
          iconSize: 50,
        );
      case RecorderState.stopped:
      case RecorderState.paused:
        return RecorderPropModel(
          actionBtnIcon: Icons.play_arrow_rounded,
          durationTextColor: const Color(0xffF5F5F5),
          actionTextColor: Colors.white,
          recorderLabel:
              '${_durationString(totalTimeFromTicker)} / ${_durationString(lastRecordedFile!.fileDuration)}',
          iconSize: 50,
        );
      case RecorderState.playing:
        return RecorderPropModel(
          actionBtnIcon: Icons.pause_rounded,
          durationTextColor: const Color(0xffF5F5F5),
          actionTextColor: Colors.white,
          recorderLabel:
              '${_durationString(totalTimeFromTicker)} / ${_durationString(lastRecordedFile!.fileDuration)}',
          iconSize: 40,
        );
    }
  }

  String _durationString(Duration duration) {
    String twoDigits(int n) => n.toString().padLeft(2, "0");
    String twoDigitMinutes = twoDigits(duration.inMinutes.remainder(60));
    String twoDigitSeconds = twoDigits(duration.inSeconds.remainder(60));
    return "$twoDigitMinutes:$twoDigitSeconds";
  }

  @override
  Widget build(BuildContext context) {
    final props = _getRecorderProps();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Text(
          props.recorderLabel,
          textAlign: TextAlign.center,
          style: TextStyle(
            color: props.durationTextColor,
            fontSize: 16,
          ),
        ),
        const SizedBox(height: 25),
        WaveForm(
          audioRecorder: _audioRecorder,
          recorderState: recorderState,
          audioFile: lastRecordedFile,
          currentPosition: _currentPosition + _tickerElapsed,
        ),
        const SizedBox(height: 35),
        Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            GestureDetector(
              onTap: () => deleteFile(),
              child: AnimatedSlide(
                offset: widget.firstScreenLoad
                    ? const Offset(-5, 0)
                    : const Offset(0, 0),
                duration: widget.animationDuration,
                curve: Curves.easeOut,
                child: Text(
                  'Delete',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: props.actionTextColor,
                    fontSize: 16,
                  ),
                ),
              ),
            ),
            const SizedBox(width: 40),
            GestureDetector(
              onTap: () async {
                switch (recorderState) {
                  case RecorderState.rest:
                    await startRecording();
                    break;
                  case RecorderState.recording:
                    await stopRecording();
                    break;
                  case RecorderState.stopped:
                  case RecorderState.paused:
                    recorderState = RecorderState.playing;
                    _startTicker();
                    await _player.play();
                    setState(() {
                      recorderState = RecorderState.stopped;
                    });
                    break;
                  case RecorderState.playing:
                    _stopTicker();
                    await _player.pause();
                    setState(() {
                      recorderState = RecorderState.paused;
                    });
                    break;
                }
              },
              child: AnimatedContainer(
                alignment: Alignment.center,
                padding: const EdgeInsets.all(0),
                duration: widget.animationDuration,
                curve: Curves.easeOut,
                width: widget.firstScreenLoad ? 2 : 64,
                height: widget.firstScreenLoad ? 2 : 64,
                decoration: BoxDecoration(
                  border: Border.all(
                    color: const Color.fromRGBO(245, 245, 245, 0.7),
                    width: 3,
                  ),
                  shape: BoxShape.circle,
                ),
                child: FittedBox(
                  fit: BoxFit.fill,
                  child: Icon(
                    props.actionBtnIcon,
                    color: const Color(0xff8B88EF),
                    size: props.iconSize,
                  ),
                ),
              ),
            ),
            const SizedBox(width: 40),
            AnimatedSlide(
              offset: widget.firstScreenLoad
                  ? const Offset(5, 0)
                  : const Offset(0, 0),
              duration: widget.animationDuration,
              curve: Curves.easeOut,
              child: Text(
                'Submit',
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: props.actionTextColor,
                  fontSize: 16,
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }
}
