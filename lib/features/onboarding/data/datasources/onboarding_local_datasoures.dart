import 'package:shared_preferences/shared_preferences.dart';

const String _keyonboarding = 'is_onboarding_seen';

class OnboardingLocalDatasoures {
  final SharedPreferences sp;
  OnboardingLocalDatasoures(this.sp);

  bool isOnBoardingSeen() {
    return sp.getBool(_keyonboarding) ?? false;
  }

  Future<void> completeOnBoarding() async {
    await sp.setBool(_keyonboarding, true);
  }
}
