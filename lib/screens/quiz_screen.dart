import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:quizzer/helper/loader.dart';
import 'package:quizzer/screens/result_screen.dart';

import '../services/api_services.dart';

class QuizScreen extends StatefulWidget {
  const QuizScreen({super.key});

  @override
  State<QuizScreen> createState() => _QuizScreenState();
}

class _QuizScreenState extends State<QuizScreen> {
  var currentQuestionIndex = 0;
  int seconds = 60;
  Timer? timer;
  late Future quiz;

  int points = 0;
  int inPoints = 0;

  var isLoaded = false;
  var data;
  var optionsList = [];

  var optionsColor = [
    Colors.white,
    Colors.white,
    Colors.white,
    Colors.white,
    Colors.white,
  ];

  @override
  void initState() {
    super.initState();
    quiz = getQuiz();
    startTimer();
  }

  @override
  void dispose() {
    timer!.cancel();
    super.dispose();
  }

  resetColors() {
    optionsColor = [
      Colors.white,
      Colors.white,
      Colors.white,
      Colors.white,
      Colors.white,
    ];
  }

  startTimer() {
    timer = Timer.periodic(
      const Duration(seconds: 1),
      (timer) {
        setState(
          () {
            if (seconds > 0) {
              seconds--;
            } else {
              timer.cancel();
              gotoNextQuestion();
            }
          },
        );
      },
    );
  }

  gotoNextQuestion() {
    if (currentQuestionIndex < data.length - 1) {
      isLoaded = false;
      currentQuestionIndex++;
      resetColors();
      seconds = 60;
      timer?.cancel();
      startTimer();
    } else {
      timer?.cancel();
    }
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return Scaffold(
      body: SafeArea(
        child: Container(
          width: double.infinity,
          height: double.infinity,
          padding: const EdgeInsets.all(12),
          child: FutureBuilder(
            future: quiz,
            builder: (BuildContext context, AsyncSnapshot snapshot) {
              if (snapshot.hasData) {
                data = snapshot.data!["results"];

                if (isLoaded == false) {
                  optionsList = data[currentQuestionIndex]["incorrect_answers"];
                  optionsList.add(data[currentQuestionIndex]["correct_answer"]);
                  optionsList.shuffle();
                  isLoaded = true;
                }
                return SingleChildScrollView(
                  child: Column(
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          IconButton(
                            onPressed: () {
                              Navigator.pop(context);
                            },
                            icon: const Icon(
                              CupertinoIcons.xmark,
                              color: Colors.white,
                              size: 28,
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Stack(
                              alignment: Alignment.center,
                              children: [
                                Text(
                                  '$seconds',
                                  style: const TextStyle(
                                    color: Colors.white,
                                    fontSize: 24.0,
                                  ),
                                ),
                                SizedBox(
                                  width: 80,
                                  height: 80,
                                  child: CircularProgressIndicator(
                                    value: seconds / 60,
                                    valueColor: const AlwaysStoppedAnimation(
                                      Colors.green,
                                    ),
                                    backgroundColor: Colors.white,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                      Lottie.asset(
                        'assets/lottie/idea.json',
                        height: 220.0,
                        width: 220.0,
                      ),
                      const SizedBox(height: 20),
                      Align(
                        alignment: Alignment.centerLeft,
                        child: Text(
                          "Question ${currentQuestionIndex + 1} of ${data.length}",
                          style: const TextStyle(
                            color: Colors.orangeAccent,
                            fontSize: 19.0,
                          ),
                        ),
                      ),
                      const SizedBox(height: 20),
                      Text(
                        data[currentQuestionIndex]["question"],
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 20.0,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 20),
                      ListView.builder(
                        shrinkWrap: true,
                        itemCount: optionsList.length,
                        itemBuilder: (BuildContext context, int index) {
                          var answer =
                              data[currentQuestionIndex]["correct_answer"];

                          return GestureDetector(
                            onTap: () {
                              setState(
                                () {
                                  if (answer.toString() ==
                                      optionsList[index].toString()) {
                                    optionsColor[index] = Colors.green;
                                    points = points + 1;
                                  } else {
                                    optionsColor[index] = Colors.red;
                                  }
                                  if (currentQuestionIndex < data.length - 1) {
                                    Future.delayed(
                                      const Duration(seconds: 1),
                                      () {
                                        gotoNextQuestion();
                                      },
                                    );
                                  } else {
                                    timer!.cancel();
                                  }
                                },
                              );
                            },
                            child: Container(
                              margin: const EdgeInsets.only(bottom: 20),
                              alignment: Alignment.center,
                              width: size.width - 100,
                              padding: const EdgeInsets.all(16),
                              decoration: BoxDecoration(
                                color: optionsColor[index],
                                borderRadius: BorderRadius.circular(12),
                              ),
                              child: Text(
                                optionsList[index].toString(),
                                style: const TextStyle(
                                  color: Colors.black,
                                  fontSize: 19.0,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                          );
                        },
                      ),
                      const SizedBox(height: 20.0),
                      if (currentQuestionIndex + 1 == data.length)
                        SizedBox(
                          width: 150.0,
                          height: 50.0,
                          child: ElevatedButton(
                            style: ButtonStyle(
                              shape: MaterialStateProperty.all<
                                  RoundedRectangleBorder>(
                                RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(18.0),
                                  side: const BorderSide(color: Colors.red),
                                ),
                              ),
                            ),
                            onPressed: () {
                              Navigator.of(context).pushReplacement(
                                MaterialPageRoute(
                                  builder: (_) => ResultScreen(
                                    points: points,
                                  ),
                                ),
                              );
                            },
                            child: const Text(
                              'Submit',
                              style: TextStyle(
                                fontSize: 18.0,
                                fontWeight: FontWeight.bold,
                                letterSpacing: 0.8,
                              ),
                            ),
                          ),
                        ),
                      const SizedBox(height: 20.0),
                    ],
                  ),
                );
              } else {
                return const Center(child: Loading(size: 150.0));
              }
            },
          ),
        ),
      ),
    );
  }
}
