import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:msaref/core/router/app_router.dart';
import 'package:msaref/features/onboarding/presentation/bloc/onboarding_cubit.dart';
import 'package:msaref/features/onboarding/presentation/bloc/onboarding_state.dart';

class SplashDecider extends StatelessWidget {
  const SplashDecider({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocListener<OnboardingCubit, OnboardingState>(
      listener: (context, state) {
        if (state is ISOnboarding) {
          Navigator.pushReplacementNamed(context, AppRouter.onboarding);
        }

        if (state is OnboardingCompleted) {
          Navigator.pushReplacementNamed(context, AppRouter.main);
        }
      },
      child: const Scaffold(body: Center(child: CircularProgressIndicator())),
    );
  }
}
