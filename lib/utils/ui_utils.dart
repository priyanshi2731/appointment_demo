import 'dart:math';

import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';

class UiUtils {
  static bool _isShowingToast = false;

  static Future toast(message) async {
    Future showToast() {
      FToast fToast = FToast();
      fToast.removeQueuedCustomToasts();
      fToast.removeCustomToast();
      return Fluttertoast.showToast(
        msg: message,
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.BOTTOM,
        timeInSecForIosWeb: 1,
        fontSize: 16.0,
      );
    }

    if (!_isShowingToast) {
      _isShowingToast = true;
      showToast().then((_) async {
        await Future.delayed(const Duration(seconds: 1));
        _isShowingToast = false;
      });
    }
  }

  static Widget fadeSwitcherWidget({Duration? duration, required Widget child}) {
    return AnimatedSwitcher(
      duration: duration ?? const Duration(milliseconds: 300),
      transitionBuilder: (Widget child, Animation<double> animation) {
        return FadeTransition(
          opacity: CurvedAnimation(parent: animation, curve: Curves.easeIn),
          child: child,
        );
      },
      //? Anytime child key passing deferent.
      child: child,
    );
  }

  /// Randoms
  static String randomString = '😀😃😄😁😆😇🥲🤗😌';

  static final Random random = Random();

  static String getRandomString(int length) => String.fromCharCodes(
        Iterable.generate(
          length,
          (_) => randomString.codeUnitAt(
            random.nextInt(randomString.length),
          ),
        ),
      );

  static String getRandomStringWithLengthRange(int minLength, int maxLength) {
    final int length = getRandomIntGenerator(maxLength, minLength);

    return getRandomString(length);
  }

  static final Random intRandom = Random();

  static int getRandomIntGenerator(int minLength, int maxLength) {
    return minLength + intRandom.nextInt(maxLength - minLength + 1);
  }
}
