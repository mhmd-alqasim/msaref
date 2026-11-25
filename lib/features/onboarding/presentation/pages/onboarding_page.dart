import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:msaref/core/router/app_router.dart';
import 'package:msaref/features/onboarding/presentation/bloc/onboarding_cubit.dart';
import 'package:msaref/features/onboarding/presentation/bloc/onboarding_state.dart';
import 'package:msaref/features/onboarding/presentation/widget/dot_indicator.dart';

// بيانات كل شاشة
class OnboardingData {
  final String title;
  final String subtitle;
  final IconData icon;

  const OnboardingData({
    required this.title,
    required this.subtitle,
    required this.icon,
  });
}

class OnboardingPage extends StatefulWidget {
  const OnboardingPage({super.key});

  @override
  State<OnboardingPage> createState() => _OnboardingPageState();
}

class _OnboardingPageState extends State<OnboardingPage> {
  final PageController _pageController = PageController();
  int _currentIndex = 0;

  // بيانات الشاشات
  final List<OnboardingData> _pages = const [
    OnboardingData(
      title: 'تابع مصروفاتك',
      subtitle: 'سجّل كل عملية مالية وتعرّف على أين تذهب أموالك',
      icon: Icons.account_balance_wallet,
    ),
    OnboardingData(
      title: 'خطط وادّخر',
      subtitle: 'أنشئ أهدافاً مالية والتزم بها عبر محافظ مخصصة',
      icon: Icons.savings,
    ),
    OnboardingData(
      title: 'افهم عاداتك',
      subtitle: 'احصل على تقارير دقيقة تساعدك في قرارات مالية أفضل',
      icon: Icons.bar_chart,
    ),
  ];

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return BlocListener<OnboardingCubit, OnboardingState>(
      listener: (context, state) {
        if (state is OnboardingCompleted) {
          Navigator.pushReplacementNamed(context, AppRouter.main);
        }
      },
      child: Scaffold(
        backgroundColor: colorScheme.background,
        body: SafeArea(
          child: Column(
            children: [
              // ── الشاشات ──────────────────────────
              Expanded(
                child: PageView.builder(
                  controller: _pageController,
                  itemCount: _pages.length,
                  onPageChanged: (index) {
                    setState(() => _currentIndex = index);
                  },
                  itemBuilder: (context, index) {
                    return _OnboardingSlide(data: _pages[index]);
                  },
                ),
              ),

              // ── النقاط والأزرار ───────────────────
              Padding(
                padding: const EdgeInsets.all(24),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    // نقاط التنقل
                    DotsIndicator(
                      count: _pages.length,
                      currentIndex: _currentIndex,
                    ),

                    // زر التالي أو ابدأ
                    _NavigationButton(
                      isLast: _currentIndex == _pages.length - 1,
                      onNext: _goToNext,
                      onStart: _completeOnboarding,
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _goToNext() {
    _pageController.nextPage(
      duration: const Duration(milliseconds: 300),
      curve: Curves.easeInOut,
    );
  }

  void _completeOnboarding() {
    context.read<OnboardingCubit>().completeOnboarding();
  }
}

// ── Slide Widget ──────────────────────────────────────
class _OnboardingSlide extends StatelessWidget {
  final OnboardingData data;
  const _OnboardingSlide({required this.data});

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;

    return Padding(
      padding: const EdgeInsets.all(32),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          // أيقونة
          Icon(data.icon, size: 120, color: colorScheme.primary),

          const SizedBox(height: 48),

          // العنوان
          Text(
            data.title,
            style: textTheme.headlineMedium?.copyWith(
              fontWeight: FontWeight.bold,
              color: colorScheme.onBackground,
            ),
            textAlign: TextAlign.center,
          ),

          const SizedBox(height: 16),

          // الوصف
          Text(
            data.subtitle,
            style: textTheme.bodyLarge?.copyWith(
              color: colorScheme.onBackground.withOpacity(0.7),
              height: 1.6,
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }
}

// ── Navigation Button ─────────────────────────────────
class _NavigationButton extends StatelessWidget {
  final bool isLast;
  final VoidCallback onNext;
  final VoidCallback onStart;

  const _NavigationButton({
    required this.isLast,
    required this.onNext,
    required this.onStart,
  });

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return ElevatedButton(
      onPressed: isLast ? onStart : onNext,
      style: ElevatedButton.styleFrom(
        backgroundColor: colorScheme.primary,
        foregroundColor: colorScheme.onPrimary,
        padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 16),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
      ),
      child: Text(isLast ? 'ابدأ الآن' : 'التالي'),
    );
  }
}
