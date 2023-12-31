import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';

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

  var isLoaded = false;

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
        setState(() {
          if (seconds > 0) {
            seconds--;
          } else {
            gotoNextQuestion();
          }
        });
      },
    );
  }

  gotoNextQuestion() {
    isLoaded = false;
    currentQuestionIndex++;
    resetColors();
    timer!.cancel();
    seconds = 60;
    startTimer();
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
              var data = snapshot.data["results"];

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
                                  points = points + 10;
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
                  ],
                ),
              );
            } else {
              return const Center(
                child: CircularProgressIndicator(
                  valueColor: AlwaysStoppedAnimation(Colors.white),
                ),
              );
            }
          },
        ),
      )),
    );
  }
}
