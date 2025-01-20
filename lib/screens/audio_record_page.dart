import 'package:flutter/material.dart';
import 'package:stroll_task_2/widgets/recorder.dart';

class AudioRecordPage extends StatefulWidget {
  const AudioRecordPage({super.key});

  @override
  State<AudioRecordPage> createState() => _AudioRecordPageState();
}

class _AudioRecordPageState extends State<AudioRecordPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          Container(
            height: MediaQuery.of(context).size.height * 0.65,
            decoration: const BoxDecoration(
              image: DecorationImage(
                image: AssetImage('assets/images/joey.png'),
                fit: BoxFit.cover,
                alignment: Alignment.topCenter,
              ),
            ),
          ),
          Container(
            height: MediaQuery.of(context).size.height,
            decoration: const BoxDecoration(
              image: DecorationImage(
                image: AssetImage('assets/images/fade.png'),
                fit: BoxFit.cover,
              ),
            ),
          ),
          Positioned(
            top: 0,
            left: 0,
            width: MediaQuery.of(context).size.width,
            child: SafeArea(
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Expanded(
                          child: Container(
                            height: 4,
                            decoration: const BoxDecoration(
                              color: Color(0xffD2D2D2),
                              boxShadow: [
                                BoxShadow(
                                  blurRadius: 30,
                                  offset: Offset(0, 12),
                                  color: Color(0x00000026),
                                ),
                              ],
                            ),
                          ),
                        ),
                        const SizedBox(width: 20),
                        Expanded(
                          child: Container(
                            height: 4,
                            decoration: const BoxDecoration(
                              color: Color(0x87878780),
                              boxShadow: [
                                BoxShadow(
                                  blurRadius: 30,
                                  offset: Offset(0, 12),
                                  color: Color(0x00000026),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 18),
                    const Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Icon(
                          Icons.arrow_back_ios_new,
                          color: Colors.white,
                          size: 20,
                        ),
                        Text(
                          'Angelina, 28',
                          style: TextStyle(
                            fontWeight: FontWeight.w700,
                            fontSize: 20,
                            color: Color(0xffF5F5F5),
                            shadows: [
                              Shadow(
                                offset: Offset(0, 1.08),
                                blurRadius: 1.08,
                                color: Color(0x00000040),
                              ),
                            ],
                          ),
                        ),
                        Icon(
                          Icons.more_horiz,
                          color: Colors.white,
                          size: 20,
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ),
          Positioned(
            bottom: 0,
            left: 0,
            width: MediaQuery.of(context).size.width,
            child: SafeArea(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Stack(
                      children: [
                        const SizedBox(height: 70),
                        Align(
                          alignment: Alignment.center,
                          child: Container(
                            decoration: BoxDecoration(
                              border: Border.all(
                                color: const Color(0xff0D0F11),
                                width: 3,
                              ),
                              shape: BoxShape.circle,
                            ),
                            child: const CircleAvatar(
                              backgroundImage: AssetImage(
                                'assets/images/joey.png',
                              ),
                              radius: 20,
                            ),
                          ),
                        ),
                        Positioned(
                          bottom: 3,
                          width: (MediaQuery.of(context).size.width - 40),
                          child: Center(
                            child: Container(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 8, vertical: 3),
                              decoration: BoxDecoration(
                                color: const Color(0xff0D0F11),
                                borderRadius: BorderRadius.circular(10),
                              ),
                              child: const Text(
                                'Stroll Question',
                                style: TextStyle(
                                  fontWeight: FontWeight.w600,
                                  fontSize: 13,
                                  color: Color(0xffF5F5F5),
                                ),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 12),
                    const Padding(
                      padding: EdgeInsets.symmetric(horizontal: 20),
                      child: Text(
                        'What is your favorite time of the day?',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontWeight: FontWeight.w700,
                          fontSize: 28,
                          height: 1,
                          color: Color(0xffF5F5F5),
                          shadows: [
                            Shadow(
                              offset: Offset(0, 2),
                              blurRadius: 2,
                              color: Color(0x00000040),
                            ),
                          ],
                        ),
                      ),
                    ),
                    const SizedBox(height: 10),
                    const Padding(
                      padding: EdgeInsets.symmetric(horizontal: 20),
                      child: Text(
                        '“Mine is definitely the peace in the morning.”',
                        style: TextStyle(
                          fontSize: 15,
                          fontStyle: FontStyle.italic,
                          color: Color.fromRGBO(203, 201, 255, 0.7),
                        ),
                      ),
                    ),
                    const SizedBox(height: 34),
                    const Recorder(),
                    const SizedBox(height: 22),
                    const Text(
                      'Unmatch',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 15,
                        color: Color(0xffBE2020),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
