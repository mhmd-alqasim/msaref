import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:msaref/features/wallet/domain/entities/wallet_entity.dart';
import 'package:msaref/features/wallet/presentation/bloc/wallet_cubit.dart';
import 'package:msaref/features/wallet/presentation/bloc/wallet_state.dart';

class AddWalletPage extends StatefulWidget {
  final WalletEntity? walletToEdit;
  const AddWalletPage({super.key, this.walletToEdit});

  bool get isEditing => walletToEdit != null;

  @override
  State<AddWalletPage> createState() => _AddWalletPageState();
}

class _AddWalletPageState extends State<AddWalletPage> {
  final _formKey = GlobalKey<FormState>();
  late final TextEditingController _nameController;
  late final TextEditingController _balanceController;

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController(
      text: widget.walletToEdit?.name ?? '',
    );
    _balanceController = TextEditingController(
      text: widget.walletToEdit?.balance.toString() ?? '',
    );
  }

  @override
  void dispose() {
    _nameController.dispose();
    _balanceController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return Scaffold(
      appBar: AppBar(
        backgroundColor: colorScheme.primary,
        foregroundColor: Colors.white,
        title: Text(widget.isEditing ? 'تعديل المحفظة' : 'محفظة جديدة'),
      ),

      body: BlocListener<WalletCubit, WalletState>(
        listener: (context, state) {
          if (state is WalletActionSuccess) {
            Navigator.pop(context);
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
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Form(
            key: _formKey,
            child: Column(
              children: [
                // ── اسم المحفظة ──────────────────────
                TextFormField(
                  controller: _nameController,
                  decoration: InputDecoration(
                    labelText: 'اسم المحفظة',
                    prefixIcon: const Icon(Icons.wallet),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  validator: (value) {
                    if (value == null || value.trim().isEmpty) {
                      return 'الرجاء إدخال اسم المحفظة';
                    }
                    return null;
                  },
                ),

                const SizedBox(height: 16),

                // ── الرصيد ───────────────────────────
                TextFormField(
                  controller: _balanceController,
                  keyboardType: TextInputType.number,
                  decoration: InputDecoration(
                    labelText: 'الرصيد',
                    prefixIcon: const Icon(Icons.attach_money),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  validator: (value) {
                    if (value == null || value.trim().isEmpty) {
                      return 'الرجاء إدخال الرصيد';
                    }
                    if (double.tryParse(value) == null) {
                      return 'الرجاء إدخال رقم صحيح';
                    }
                    return null;
                  },
                ),

                const SizedBox(height: 32),

                // ── زر الحفظ ─────────────────────────
                BlocBuilder<WalletCubit, WalletState>(
                  builder: (context, state) {
                    final isLoading = state is WalletLoading;
                    return SizedBox(
                      width: double.infinity,
                      height: 50,
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: colorScheme.primary,
                          foregroundColor: Colors.white,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                        onPressed: isLoading ? null : _onSubmit,
                        child: isLoading
                            ? const CircularProgressIndicator(
                                color: Colors.white,
                              )
                            : Text(
                                widget.isEditing ? 'تحديث' : 'إضافة',
                                style: const TextStyle(fontSize: 16),
                              ),
                      ),
                    );
                  },
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  void _onSubmit() {
    if (!_formKey.currentState!.validate()) return;

    final name = _nameController.text.trim();
    final balance = double.parse(_balanceController.text);
    final cubit = context.read<WalletCubit>();

    if (widget.isEditing) {
      cubit.updateWallet(
        oldWallet: widget.walletToEdit!,
        newName: name,
        newBalance: balance,
      );
    } else {
      cubit.addWallet(name: name, balance: balance);
    }
  }
}
