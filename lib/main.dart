import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:msaref/core/router/app_router.dart';
import 'package:msaref/features/onboarding/presentation/bloc/onboarding_cubit.dart';
import 'package:msaref/features/splash/pages/splash_decider.dart';
import 'package:msaref/injection_container.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await initDependencies();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      initialRoute: AppRouter.splash,
      onGenerateRoute: AppRouter.generateRoute,
      // SplashPage =  first page decides where we go.
      home: BlocProvider(
        create: (_) => sl<OnboardingCubit>()..checkOnboaring(),
        child: const SplashDecider(),
      ),
    );
  }
}
