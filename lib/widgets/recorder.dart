import 'package:flutter/material.dart';

class Recorder extends StatefulWidget {
  const Recorder({super.key});

  @override
  State<Recorder> createState() => _RecorderState();
}

class _RecorderState extends State<Recorder> {
  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        const Text(
          '00:00',
          textAlign: TextAlign.center,
          style: TextStyle(
            color: Color(0xff5D6369),
            fontSize: 16,
          ),
        ),
        const SizedBox(height: 30),
        const Divider(color: Color(0xff36393E), height: 1),
        const SizedBox(height: 40),
        Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text(
              'Delete',
              textAlign: TextAlign.center,
              style: TextStyle(
                color: Color(0xff5D6369),
                fontSize: 16,
              ),
            ),
            const SizedBox(width: 40),
            Container(
              alignment: Alignment.center,
              padding: const EdgeInsets.all(2),
              width: 64,
              height: 64,
              decoration: BoxDecoration(
                border: Border.all(
                  color: const Color(0xF5F5F5B2),
                  width: 3,
                ),
                shape: BoxShape.circle,
              ),
              child: const Icon(
                Icons.fiber_manual_record_rounded,
                color: Color(0xff8B88EF),
                size: 55,
              ),
            ),
            const SizedBox(width: 40),
            const Text(
              'Submit',
              textAlign: TextAlign.center,
              style: TextStyle(
                color: Color(0xff5D6369),
                fontSize: 16,
              ),
            ),
          ],
        ),
      ],
    );
  }
}
