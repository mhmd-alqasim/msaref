import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:msaref/features/home/presentation/pages/home_page.dart';

import 'package:msaref/features/main/bloc/main_cubit.dart';
import 'package:msaref/features/main/bloc/main_state.dart';
import 'package:msaref/injection_container.dart' as di;

class MainPage extends StatelessWidget {
  const MainPage({super.key});

  // الصفحات
  static const List<Widget> _pages = [
    HomePage(),
    // BudgetPage(),
    // SizedBox.shrink(), // Add - تفتح كـ modal
    // GoalsPage(),
    // StatisticsPage(),
  ];

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => di.sl<MainCubit>(),
      child: const _MainView(),
    );
  }
}

class _MainView extends StatelessWidget {
  const _MainView();

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return BlocBuilder<MainCubit, MainState>(
      builder: (context, state) {
        return Scaffold(
          // ── الصفحة الحالية ──────────────────────
          body: MainPage._pages[state.currentIndex],

          // ── Bottom Navigation ────────────────────
          bottomNavigationBar: BottomAppBar(
            color: colorScheme.primary,
            shape: const CircularNotchedRectangle(),
            notchMargin: 8,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                _NavItem(
                  icon: Icons.home,
                  label: 'الرئيسية',
                  index: 0,
                  currentIndex: state.currentIndex,
                ),
                _NavItem(
                  icon: Icons.account_balance,
                  label: 'الميزانية',
                  index: 1,
                  currentIndex: state.currentIndex,
                ),

                // مساحة للزر الوسط
                const SizedBox(width: 48),

                _NavItem(
                  icon: Icons.flag,
                  label: 'الأهداف',
                  index: 3,
                  currentIndex: state.currentIndex,
                ),
                _NavItem(
                  icon: Icons.bar_chart,
                  label: 'التقارير',
                  index: 4,
                  currentIndex: state.currentIndex,
                ),
              ],
            ),
          ),

          // ── زر الإضافة الوسط ────────────────────
          floatingActionButton: FloatingActionButton(
            backgroundColor: colorScheme.primary,
            onPressed: () => _showAddTransaction(context),
            child: const Icon(Icons.add, color: Colors.white),
          ),
          floatingActionButtonLocation:
              FloatingActionButtonLocation.centerDocked,
        );
      },
    );
  }

  void _showAddTransaction(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,

      // builder: (_) => const AddTransactionPage(),
      builder: (_) => Container(),
    );
  }
}

// ── Nav Item ──────────────────────────────────────────
class _NavItem extends StatelessWidget {
  final IconData icon;
  final String label;
  final int index;
  final int currentIndex;

  const _NavItem({
    required this.icon,
    required this.label,
    required this.index,
    required this.currentIndex,
  });

  @override
  Widget build(BuildContext context) {
    final isActive = index == currentIndex;
    Theme.of(context).colorScheme;

    return InkWell(
      onTap: () => context.read<MainCubit>().changePage(index),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            icon,
            color: isActive ? Colors.white : Colors.white.withOpacity(0.5),
          ),
          Text(
            label,
            style: TextStyle(
              fontSize: 10,
              color: isActive ? Colors.white : Colors.white.withOpacity(0.5),
            ),
          ),
        ],
      ),
    );
  }
}
