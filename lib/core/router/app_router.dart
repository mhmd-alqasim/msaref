import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:msaref/features/onboarding/presentation/bloc/onboarding_cubit.dart';
import 'package:msaref/features/onboarding/presentation/pages/onboarding_page.dart';
import 'package:msaref/features/splash/pages/splash_decider.dart';
import 'package:msaref/injection_container.dart' as di;

class AppRouter {
  // ──const route fucking────────────────────────────────
  static const String splash = '/';
  static const String onboarding = '/onboarding';
  static const String main = '/main';
  static const String addWallet = '/wallet/add';
  static const String editWallet = '/wallet/edit';

  static Route<dynamic> generateRoute(RouteSettings settings) {
    switch (settings.name) {
      //splash
      case splash:
        return _buildRoute(
          settings,
          BlocProvider(
            create: (_) => di.sl<OnboardingCubit>()..checkOnboaring(),
            child: const SplashDecider(),
          ),
        );
      //onboarding
      case onboarding:
        return _buildRoute(
          settings,
          BlocProvider(
            create: (_) => di.sl<OnboardingCubit>(),
            child: OnboardingPage(),
          ),
        );

      default:
        return _buildRoute(settings, const _PageNotFound());
    }
  }

  static MaterialPageRoute _buildRoute(RouteSettings settings, Widget page) {
    return MaterialPageRoute(settings: settings, builder: (_) => page);
  }
}

class _PageNotFound extends StatelessWidget {
  const _PageNotFound();

  @override
  Widget build(BuildContext context) {
    return Scaffold(body: Center(child: Text('الصفحة غير موجودة')));
  }
}
