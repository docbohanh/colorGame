import 'dart:io';
import 'dart:math';

import 'package:colorgame/bloc/bloc.dart';
import 'package:colorgame/utils/utils.dart';
import 'package:colorgame/view/game_screen/color_picker.dart';
import 'package:colorgame/widget/neu_button.dart';
import 'package:colorgame/widget/neu_slider.dart';
//import 'package:firebase_admob/firebase_admob.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class NormalMode extends StatefulWidget {
  @override
  _NormalModeState createState() => _NormalModeState();
}

class _NormalModeState extends State<NormalMode>
    with SingleTickerProviderStateMixin {
  ColorPickerBloc _colorPickerBloc;
  HighScoreBloc _highScoreBloc;
  // ignore: close_sinks
  LanguageBloc _languageBloc;
  int level = 1;
  int adLevel = 0;
  int second = 4;
  int millisecond = 100;
  double height;
  double width;
  bool isInit = false;
  AnimationController _animationController;
//  RewardedVideoAd _rewardedVideoAd = RewardedVideoAd.instance;
  bool _hasConnect = false;
  int _videoAds = 0;

//  InterstitialAd createInterstitialAd() {
//    return InterstitialAd(
//        adUnitId: Admob.middleID,
//        targetingInfo: Admob.targetingInfo,
//        listener: (MobileAdEvent event) {});
//  }

  secondToWait(bool run) {
    if (isInit) {
      _animationController.duration =
          Duration(milliseconds: second * 1000 + millisecond);
    } else {
      _animationController = AnimationController(
        vsync: this,
        duration: Duration(milliseconds: second * 1000 + millisecond),
      );
      isInit = true;
    }

    if (run)
      _animationController.forward();
    else
      _animationController.value = 0;
  }

  double getPercent() =>
      ((second * 1000 + millisecond) -
          _animationController.value * (second * 1000 + millisecond)) /
      (second * 1000 + millisecond);

  List<Widget> gameOverButton() => [
        NeuButton(
          shadowLength: 4,
          shadowFallLength: 0,
          borderRadius: BorderRadius.circular(height / 10),
          position: 5,
          height: width / 5,
          width: width / 5,
          child:
              Icon(Icons.refresh, size: width / 10, color: AppColors.textColor),
          onTap: () {
            setState(() => _colorPickerBloc.add(ReplayEvent()));
          },
        ),
        NeuButton(
            shadowLength: 4,
            shadowFallLength: 0,
            borderRadius: BorderRadius.circular(height / 10),
            position: 5,
            height: width / 5,
            width: width / 5,
            child:
                Icon(Icons.close, size: width / 10, color: AppColors.textColor),
            onTap: () async {
              try {
                final result = await InternetAddress.lookup('google.com');
                if (result.isNotEmpty && result[0].rawAddress.isNotEmpty) {
//                  createInterstitialAd()
//                    ..load()
//                    ..show();
                }
              } on SocketException catch (_) {}
              Navigator.pop(context);
            })
      ];

  @override
  void dispose() {
    _animationController.stop();
    _animationController.dispose();
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
    secondToWait(false);
    _animationController.addListener(() {
      if (_animationController.value == 1) {
        _animationController.value = 0;

        _colorPickerBloc.add(GameOverEvent(
          level > highScore ? true : false,
        ));
      }

      setState(() {});
    });
//    if (!kIsWeb) {
//      FirebaseAdMob.instance.initialize(appId: Admob.appID);
//      _rewardedVideoAd.listener =
//          (RewardedVideoAdEvent event, {String rewardType, int rewardAmount}) {
//        if (event == RewardedVideoAdEvent.rewarded) {
//          _colorPickerBloc.add(ContinueEvent());
//          setState(() => _videoAds++);
//        }
//        if (event == RewardedVideoAdEvent.loaded) {
//          _rewardedVideoAd.show();
//        }
//        if (event == RewardedVideoAdEvent.failedToLoad) {}
//      };
//      _hasConnectSet();
//    }
  }

  _hasConnectSet() async {
    try {
      final result = await InternetAddress.lookup('google.com');
      if (result.isNotEmpty && result[0].rawAddress.isNotEmpty) {
        _hasConnect = true;
      }
    } on SocketException catch (_) {
      _hasConnect = false;
    }
    setState(() {});
  }

  int numOfColorPerLevel(int level) {
    if (level < 10) {
      return 2;
    } else if (level < 20) {
      return 3;
    } else if (level < 30) {
      return 4;
    } else if (level < 100) {
      return 5;
    } else {
      return 6;
    }
  }

  durationChange(bool run) {
    if (level == 10) {
      second = 3;
      millisecond = 700;
      secondToWait(run);
    } else if (level == 20) {
      second = 3;
      millisecond = 200;
      secondToWait(run);
    } else if (level == 30) {
      second = 3;
      millisecond = 0;
      secondToWait(run);
    } else if (level == 100) {
      second = 2;
      millisecond = 500;
      secondToWait(run);
    }
  }

  durationContinuesChange() {
    if (level <= 10) {
      second = 4;
      millisecond = 500;
      secondToWait(false);
    } else if (level >= 10 && level <= 30) {
      second = 3;
      millisecond = 700;
      secondToWait(false);
    } else if (level >= 30 && level <= 100) {
      second = 3;
      millisecond = 0;
      secondToWait(false);
    } else if (level > 100) {
      second = 2;
      millisecond = 500;
      secondToWait(false);
    }
  }

  Future<bool> _onWillPop() async {
    if (kIsWeb) return true;
    try {
      final result = await InternetAddress.lookup('google.com');
      if (result.isNotEmpty && result[0].rawAddress.isNotEmpty) {
//        createInterstitialAd()
//          ..load()
//          ..show();
      }
    } on SocketException catch (_) {}
    return true;
  }

  @override
  Widget build(BuildContext context) {
    _colorPickerBloc = BlocProvider.of<ColorPickerBloc>(context);
    _highScoreBloc = BlocProvider.of<HighScoreBloc>(context);
    _languageBloc = BlocProvider.of<LanguageBloc>(context);
    height = MediaQuery.of(context).size.height;
    width = MediaQuery.of(context).size.width;

    return WillPopScope(
        onWillPop: _onWillPop,
        child: Scaffold(
            body: Container(
                height: height,
                width: width,
                decoration: BoxDecoration(
                    gradient: LinearGradient(
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                        colors: [AppColors.lightShadow, AppColors.darkShadow])),
                child: SafeArea(
                  child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        Column(children: [
                          Text(
                              _languageBloc.language == 'us'
                                  ? 'Time:'
                                  : 'Thời gian:',
                              style: TextStyle(
                                  fontFamily: 'Bungee',
                                  fontSize: height / 20,
                                  color: AppColors.textColor)),
                          SizedBox(height: 15),
                          AnimatedBuilder(
                              animation: _animationController,
                              builder: (context, child) => Padding(
                                  padding: EdgeInsets.symmetric(horizontal: 30),
                                  child: NeuSlider(
                                      height: height / 35,
                                      percent: getPercent(),
                                      width: height / 2 + 10,
                                      borderRadius:
                                          BorderRadius.circular(width / 5)))),
                          SizedBox(height: 15),
                          Text(
                              _languageBloc.language == 'us'
                                  ? 'Level: $level'
                                  : 'Cấp: $level',
                              style: TextStyle(
                                  fontFamily: 'Bungee',
                                  fontSize: height / 20,
                                  color: AppColors.textColor))
                        ]),
                        BlocConsumer(
                            bloc: _colorPickerBloc,
                            listener: (context, state) async {
                              if (state is ColorPickerDone) {
                                _animationController.value = 0;
                                if (_animationController.isDismissed)
                                  _animationController.forward();
                                durationChange(true);
                                setState(() => level++);
                              }
                              if (state is ColorPickerContinue) {
                                durationChange(false);
                                setState(() {});
                              }
                              if (state is ColorPickerContinue) {
                                second = 4;
                                millisecond = 500;
                                durationContinuesChange();
                              }
                              if (state is ColorPickerInitial) {
                                second = 4;
                                millisecond = 500;
                                level = 1;
                                _videoAds = 0;
                                durationChange(false);
                              }
                              if (state is ColorPickerGameOver) {
                                secondToWait(false);
                                if (state.isNewHighScore)
                                  _highScoreBloc.add(SetHighScoreEvent(level));
                                if (level > 10 && adLevel % 2 == 1 && !kIsWeb) {
                                  try {
                                    final result = await InternetAddress.lookup(
                                        'google.com');
                                    if (result.isNotEmpty &&
                                        result[0].rawAddress.isNotEmpty) {
//                                      createInterstitialAd()
//                                        ..load()
//                                        ..show();
                                    }
                                  } on SocketException catch (_) {}
                                }
                                adLevel++;
                              }
                              print(second + millisecond / 1000);
                            },
                            builder: (BuildContext context, state) {
                              if (state is ColorPickerWaiting ||
                                  state is ColorPickerInitial ||
                                  state is ColorPickerDone ||
                                  state is ColorPickerContinue) {
                                return SizedBox(
                                  height: width,
                                  width: width,
                                  child: ColorPicker(
                                    level: level,
                                    numOfColor: numOfColorPerLevel(level),
                                  ),
                                );
                              }
                              if (state is ColorPickerGameOver) {
                                if (state.isNewHighScore) {
                                  return _buildGameOverNoti(context, true);
                                }
                              }
                              return _buildGameOverNoti(context, false);
                            })
                      ]),
                ))));
  }

  Widget _buildGameOverNoti(BuildContext context, bool isNewHighScore) {
    return Padding(
        padding: const EdgeInsets.symmetric(horizontal: 25),
        child: NeuButton(
            shadowLength: 4,
            shadowFallLength: 0,
            borderRadius: BorderRadius.circular(15),
            position: 30,
            height: width,
            width: width,
            child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  Column(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        Text(
                          _languageBloc.language == "us"
                              ? "Game Over!"
                              : "Kết thúc!",
                          style: TextStyle(
                            fontFamily: 'Bungee',
                            color: AppColors.textColor,
                            fontSize: width / 10,
                          ),
                        ),
                        Container(height: 15),
                        isNewHighScore
                            ? Column(children: [
                                Text(
                                  _languageBloc.language == "us"
                                      ? "Congratulation!!!"
                                      : "Chúc mừng!!!",
                                  style: TextStyle(
                                    fontFamily: 'Bungee Inline',
                                    color: Colors.yellow[200],
                                    fontSize: width / 25,
                                  ),
                                ),
                                Text(
                                  _languageBloc.language == "us"
                                      ? "Level $level is your new high score!"
                                      : "Cấp $level là điểm cao mới của bạn!",
                                  style: TextStyle(
                                    fontFamily: 'Bungee Inline',
                                    color: Colors.yellow[200],
                                    fontSize: width / 25,
                                  ),
                                )
                              ])
                            : Container(height: 0)
                      ]),
                  (_hasConnect && _videoAds < 2)
                      ? Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: List.generate(
                            3,
                            (index) {
                              if (index == 2)
                                return NeuButton(
                                    shadowLength: 4,
                                    shadowFallLength: 0,
                                    borderRadius: BorderRadius.circular(
                                      width / 5,
                                    ),
                                    position: 5,
                                    lightAndDarkShadow: {
                                      'darkShadow': AppColors.subBackground
                                          .withGreen(100),
                                      'lightShadow':
                                          AppColors.sliderColor.withBlue(4),
                                    },
                                    height: width / 5,
                                    width: width / 5,
                                    switchShadow: false,
                                    child: Center(
                                        child: Stack(children: [
                                      Center(
                                          child: Transform.rotate(
                                              angle: pi / 2,
                                              child: Icon(Icons.local_movies,
                                                  size: width / 10,
                                                  color: AppColors.textColor))),
                                      Center(
                                          child: Text('+1',
                                              style: TextStyle(
                                                  fontFamily: 'Bungee',
                                                  color: Colors.black45,
                                                  fontSize: height / (17 * 3.3),
                                                  fontWeight: FontWeight.bold)))
                                    ])),
                                    onTap: () async {
//                                      try {
//                                        await _rewardedVideoAd.load(
//                                          adUnitId: Admob.continuationID,
//                                          targetingInfo: Admob.targetingInfo,
//                                        );
//                                      } catch (PlatformException) {}
                                    });
                              List<Widget> _button = gameOverButton();
                              return _button[index];
                            },
                          ))
                      : Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: gameOverButton(),
                        )
                ])));
  }
}
