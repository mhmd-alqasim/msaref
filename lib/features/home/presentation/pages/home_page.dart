import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:msaref/features/wallet/domain/entities/wallet_entity.dart';
import 'package:msaref/features/wallet/presentation/bloc/wallet_cubit.dart';
import 'package:msaref/features/wallet/presentation/bloc/wallet_state.dart';
import 'package:msaref/features/wallet/presentation/widgets/wallet_card.dart';
import 'package:msaref/core/router/app_router.dart';
import 'package:msaref/injection_container.dart' as di;

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => di.sl<WalletCubit>()..loadWallets(),
      child: const _HomeView(),
    );
  }
}

class _HomeView extends StatelessWidget {
  const _HomeView();

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return Scaffold(
      backgroundColor: colorScheme.background,
      appBar: AppBar(
        backgroundColor: colorScheme.primary,
        title: const Text(
          'مصاريفي',
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.add, color: Colors.white),
            onPressed: () {
              Navigator.pushNamed(context, AppRouter.addWallet);
            },
          ),
        ],
      ),

      body: BlocConsumer<WalletCubit, WalletState>(
        listener: (context, state) {
          if (state is WalletActionSuccess) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(state.message),
                backgroundColor: Colors.green,
              ),
            );
          }
          if (state is WalletError) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(state.message),
                backgroundColor: Colors.red,
              ),
            );
          }
        },
        builder: (context, state) {
          if (state is WalletLoading) {
            return const Center(child: CircularProgressIndicator());
          }

          if (state is WalletLoaded) {
            return _buildContent(context, state);
          }

          return const SizedBox.shrink();
        },
      ),
    );
  }

  Widget _buildContent(BuildContext context, WalletLoaded state) {
    return RefreshIndicator(
      onRefresh: () async {
        context.read<WalletCubit>().loadWallets();
      },
      child: SingleChildScrollView(
        physics: const AlwaysScrollableScrollPhysics(),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // ── إجمالي الرصيد ──────────────────────
            _TotalBalanceSection(total: state.totalBalance),

            const SizedBox(height: 24),

            // ── المحافظ ────────────────────────────
            _WalletsSection(wallets: state.wallets),

            const SizedBox(height: 24),

            // ── آخر المعاملات (قريباً) ─────────────
            _ComingSoonSection(),

            const SizedBox(height: 32),
          ],
        ),
      ),
    );
  }
}

// ── Total Balance Section ─────────────────────────────
class _TotalBalanceSection extends StatelessWidget {
  final double total;
  const _TotalBalanceSection({required this.total});

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: colorScheme.primary,
        borderRadius: const BorderRadius.only(
          bottomLeft: Radius.circular(32),
          bottomRight: Radius.circular(32),
        ),
      ),
      child: Column(
        children: [
          const Text(
            'إجمالي الرصيد',
            style: TextStyle(color: Colors.white70, fontSize: 14),
          ),
          const SizedBox(height: 8),
          Text(
            '\$${total.toStringAsFixed(2)}',
            style: const TextStyle(
              color: Colors.white,
              fontSize: 40,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }
}

// ── Wallets Section ───────────────────────────────────
class _WalletsSection extends StatelessWidget {
  final List<WalletEntity> wallets;
  const _WalletsSection({required this.wallets});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // العنوان
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                'محافظي',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              TextButton(
                onPressed: () async {
                  await Navigator.pushNamed(context, AppRouter.addWallet);
                  if (context.mounted) {
                    context.read<WalletCubit>().loadWallets();
                  }
                },
                child: const Text('+ إضافة'),
              ),
            ],
          ),

          const SizedBox(height: 12),

          // لا توجد محافظ
          if (wallets.isEmpty)
            _EmptyWallets()
          // قائمة المحافظ
          else
            ListView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: wallets.length,
              itemBuilder: (context, index) {
                final wallet = wallets[index];
                return WalletCard(
                  wallet: wallet,
                  onEdit: () {
                    Navigator.pushNamed(
                      context,
                      AppRouter.editWallet,
                      arguments: wallet,
                    );
                  },
                  onDelete: () {
                    _confirmDelete(context, wallet);
                  },
                );
              },
            ),
        ],
      ),
    );
  }

  void _confirmDelete(BuildContext context, WalletEntity wallet) {
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text('حذف المحفظة'),
        content: Text('هل تريد حذف "${wallet.name}"؟'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('إلغاء'),
          ),
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              context.read<WalletCubit>().deleteWallet(wallet.id);
            },
            style: TextButton.styleFrom(foregroundColor: Colors.red),
            child: const Text('حذف'),
          ),
        ],
      ),
    );
  }
}

// ── Empty Wallets ─────────────────────────────────────
class _EmptyWallets extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        children: [
          Icon(
            Icons.account_balance_wallet_outlined,
            size: 64,
            color: Colors.grey[400],
          ),
          const SizedBox(height: 16),
          Text(
            'لا توجد محافظ بعد',
            style: TextStyle(color: Colors.grey[600], fontSize: 16),
          ),
        ],
      ),
    );
  }
}

// ── Coming Soon ───────────────────────────────────────
class _ComingSoonSection extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'آخر المعاملات',
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 12),
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(24),
            decoration: BoxDecoration(
              color: Colors.grey[100],
              borderRadius: BorderRadius.circular(12),
            ),
            child: const Text(
              'قريباً...',
              textAlign: TextAlign.center,
              style: TextStyle(color: Colors.grey),
            ),
          ),
        ],
      ),
    );
  }
}
