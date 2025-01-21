import 'package:flutter/material.dart';
import 'package:record/record.dart';

import '../enums.dart';
import '../models/recording.dart';

class WaveForm extends StatefulWidget {
  const WaveForm({
    super.key,
    required this.audioRecorder,
    required this.recorderState,
    required this.audioFile,
    required this.currentPosition,
  });

  final AudioRecorder audioRecorder;
  final RecorderState recorderState;
  final AudioFile? audioFile;
  final Duration currentPosition;

  @override
  State<WaveForm> createState() => _WaveFormState();
}

class _WaveFormState extends State<WaveForm> {
  late List<double> _waveformValues;
  late ScrollController _scrollController;
  final maxDecibel = 40.0;

  Stream<double> aplitudeStream() async* {
    while (true) {
      await Future.delayed(
        const Duration(milliseconds: 100),
      );
      final amplitude = await widget.audioRecorder.getAmplitude();
      yield amplitude.current;
    }
  }

  @override
  void initState() {
    super.initState();
    _waveformValues = [];
    _scrollController = ScrollController();

    aplitudeStream().listen((volume) {
      if (widget.recorderState == RecorderState.recording) {
        setState(() {
          _waveformValues.add(volume);
        });

        if (_scrollController.hasClients) {
          _scrollController.animateTo(
            _scrollController.position.maxScrollExtent,
            duration: const Duration(milliseconds: 400),
            curve: Curves.easeOut,
          );
        }
      }
    });
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    const widgetHeight = 30.0;
    final waveBarHeightFactor = (maxDecibel / widgetHeight);
    final widgetWidth = MediaQuery.of(context).size.width;
    final visibleBars = widgetWidth / 8;

    if (widget.recorderState == RecorderState.rest) {
      _waveformValues.clear();
    } else if (widget.recorderState == RecorderState.stopped) {
      _scrollController.jumpTo(0.0);
    } else if (widget.recorderState == RecorderState.playing) {
      _scrollController.animateTo(
        _scrollController.position.maxScrollExtent,
        duration: widget.audioFile!.fileDuration,
        curve: Curves.easeOut,
      );
    } else if (widget.recorderState == RecorderState.paused) {
      _scrollController.position.hold(() {});
    }

    return Container(
      height: widgetHeight,
      color: Colors.transparent,
      child: SingleChildScrollView(
        controller: _scrollController,
        scrollDirection: Axis.horizontal,
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            if (widget.recorderState == RecorderState.rest ||
                widget.recorderState == RecorderState.recording)
              Container(
                color: const Color(0xff36393E),
                height: 1,
                width: widgetWidth,
              ),
            ..._waveformValues.asMap().entries.map((entry) {
              final waveformValue = entry.value;
              final index = entry.key;
              bool isPlayed = false;
              if (widget.audioFile != null &&
                  (widget.recorderState == RecorderState.playing ||
                      widget.recorderState == RecorderState.paused)) {
                final playbackFraction = widget.currentPosition.inMilliseconds /
                    widget.audioFile!.fileDuration.inMilliseconds;
                int playbackBarIndex =
                    (playbackFraction * _waveformValues.length).ceil();

                playbackBarIndex = (_waveformValues.length - playbackBarIndex) < 10 ? playbackBarIndex : (playbackBarIndex + 5);
                 isPlayed = index <= playbackBarIndex;
              }
              return Container(
                width: 4,
                //to make waveform bar's height more distinct
                //decibels below -40 are represented by a height of 1
                height: waveformValue < (maxDecibel * -1)
                    ? 1.0
                    : ((waveformValue + maxDecibel) / waveBarHeightFactor)
                        .ceilToDouble(),
                margin: const EdgeInsets.only(left: 4),
                color: isPlayed
                    ? const Color(0xffBFBDFF)
                    : const Color(0xff36393E),
              );
            }).toList(),
            const SizedBox(width: 50),
          ],
        ),
      ),
    );
  }
}
