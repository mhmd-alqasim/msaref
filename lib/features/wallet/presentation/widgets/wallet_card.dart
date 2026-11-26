import 'package:flutter/material.dart';
import 'package:msaref/features/wallet/domain/entities/wallet_entity.dart';

class WalletCard extends StatelessWidget {
  final WalletEntity wallet;
  final VoidCallback onEdit;
  final VoidCallback onDelete;

  const WalletCard({
    super.key,
    required this.wallet,
    required this.onEdit,
    required this.onDelete,
  });

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: colorScheme.surface,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Row(
        children: [
          // ── أيقونة المحفظة ──────────────────────
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: colorScheme.primary.withOpacity(0.1),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(
              Icons.account_balance_wallet,
              color: colorScheme.primary,
            ),
          ),

          const SizedBox(width: 16),

          // ── الاسم والرصيد ────────────────────────
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  wallet.name,
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  '${wallet.currency} ${wallet.balance.toStringAsFixed(2)}',
                  style: TextStyle(
                    color: wallet.balance >= 0 ? Colors.green : Colors.red,
                    fontWeight: FontWeight.w600,
                    fontSize: 14,
                  ),
                ),
              ],
            ),
          ),

          // ── أزرار التعديل والحذف ─────────────────
          IconButton(
            icon: const Icon(Icons.edit_outlined),
            color: Colors.blue,
            onPressed: onEdit,
          ),
          IconButton(
            icon: const Icon(Icons.delete_outline),
            color: Colors.red,
            onPressed: onDelete,
          ),
        ],
      ),
    );
  }
}
