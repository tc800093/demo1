import 'package:flutter/material.dart';
import 'package:poweriot/core/constants/secure_storage_constant.dart';
import 'package:poweriot/core/secure_storage/secure_storage.dart';

class TutorialProvider extends ChangeNotifier {
  final SecureStorageService secureStorageService;
  TutorialProvider({required this.secureStorageService});

  String? _hasShownTutorial = 'true';

  String? get hasShownTutorial => _hasShownTutorial;

  String? _hasAnalyticsShownTutorial = 'true';

  String? get hasAnalyticsShownTutorial => _hasAnalyticsShownTutorial;

  Future<void> init() async {
    String? s = await secureStorageService.read(tutorialShown);
    if (s != null && s != '') {
      _hasShownTutorial = s;
    } else {
      _hasShownTutorial = 'true';
    }

    String? a = await secureStorageService.read(analyticsTutorialShown);
    if (a != null && a != '') {
      _hasAnalyticsShownTutorial = s;
    } else {
      _hasAnalyticsShownTutorial = 'true';
    }
    notifyListeners();
  }

  Future<bool> shouldShowAnalyticsTutorial() async {
    await init();
    return _hasAnalyticsShownTutorial.toString() == 'true' ? true : false;
  }

  Future<bool> shouldShowTutorial() async {
    await init();
    return _hasShownTutorial.toString() == 'true' ? true : false;
  }

  Future<void> markAnalyticsTutorialAsShown() async {
    await secureStorageService.write(
      key: analyticsTutorialShown,
      value: 'false',
    );
    _hasAnalyticsShownTutorial = "false";
    notifyListeners();
  }

  Future<void> markTutorialAsShown() async {
    await secureStorageService.write(key: tutorialShown, value: 'false');
    _hasShownTutorial = "false";
    notifyListeners();
  }

  Future<void> resetTutorial() async {
    await secureStorageService.delete(tutorialShown);
    await secureStorageService.delete(analyticsTutorialShown);
    _hasShownTutorial = 'true';
    _hasAnalyticsShownTutorial = "true";
    notifyListeners();
  }
}
