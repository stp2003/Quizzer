import 'package:animated_text_kit/animated_text_kit.dart';
import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:quizzer/screens/quiz_screen.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          title: AnimatedTextKit(
            animatedTexts: [
              ScaleAnimatedText('Quizzer'),
            ],
            isRepeatingAnimation: true,
            repeatForever: true,
            pause: const Duration(milliseconds: 200),
          ),
        ),
        body: Container(
          width: double.infinity,
          height: double.infinity,
          padding: const EdgeInsets.all(12),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Lottie.asset('assets/lottie/quiz.json'),
              const SizedBox(height: 20),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 35.0),
                child: SizedBox(
                  width: double.infinity,
                  child: DefaultTextStyle(
                    style: const TextStyle(
                      fontSize: 30.0,
                    ),
                    child: AnimatedTextKit(
                      animatedTexts: [
                        TypewriterAnimatedText('Welcome to Quizzer 😀'),
                        TypewriterAnimatedText(
                          'Are you ready to test your limits.',
                        ),
                        TypewriterAnimatedText(
                          'Do not panic, that part comes later.',
                        ),
                      ],
                      isRepeatingAnimation: true,
                      repeatForever: true,
                      pause: const Duration(milliseconds: 2500),
                    ),
                  ),
                ),
              ),
              const Spacer(),
              Align(
                alignment: Alignment.center,
                child: GestureDetector(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const QuizScreen(),
                      ),
                    );
                  },
                  child: Container(
                    margin: const EdgeInsets.only(bottom: 20),
                    alignment: Alignment.center,
                    width: size.width - 100,
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: Colors.purple[400],
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: const Text(
                      'Continue',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 24.0,
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
