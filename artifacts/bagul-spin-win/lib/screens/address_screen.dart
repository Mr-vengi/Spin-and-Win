import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../providers/app_state.dart';
import '../theme/app_theme.dart';

class AddressScreen extends StatefulWidget {
  const AddressScreen({super.key});

  @override
  State<AddressScreen> createState() => _AddressScreenState();
}

class _AddressScreenState extends State<AddressScreen> {
  final _formKey = GlobalKey<FormState>();
  late final TextEditingController _name;
  late final TextEditingController _phone;
  late final TextEditingController _pincode;
  late final TextEditingController _fullAddress;

  @override
  void initState() {
    super.initState();
    final state = context.read<AppState>();
    _name = TextEditingController(
      text: state.address['name'] ?? state.user?.name ?? '',
    );
    _phone = TextEditingController(text: state.address['phone'] ?? '');
    _pincode = TextEditingController(text: state.address['pincode'] ?? '');
    _fullAddress = TextEditingController(
      text: state.address['fullAddress'] ?? '',
    );
  }

  @override
  void dispose() {
    _name.dispose();
    _phone.dispose();
    _pincode.dispose();
    _fullAddress.dispose();
    super.dispose();
  }

  void _save() {
    if (!_formKey.currentState!.validate()) return;
    final state = context.read<AppState>();
    final hasPendingGift = state.pendingPrize != null;
    state.saveAddress(
      name: _name.text,
      phone: _phone.text,
      pincode: _pincode.text,
      fullAddress: _fullAddress.text,
    );
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          hasPendingGift
              ? 'Gift claimed! It is now in tracking.'
              : 'Address saved.',
        ),
      ),
    );
    if (hasPendingGift) {
      Navigator.pushReplacementNamed(context, '/tracking');
    } else {
      Navigator.pop(context);
    }
  }

  @override
  Widget build(BuildContext context) {
    final isClaimingGift = context.select<AppState, bool>(
      (state) => state.pendingPrize != null,
    );
    return Scaffold(
      appBar: AppBar(
        title: Text(isClaimingGift ? 'Claim your gift' : 'Delivery address'),
      ),
      body: Form(
        key: _formKey,
        child: ListView(
          padding: const EdgeInsets.fromLTRB(20, 7, 20, 26),
          children: [
            if (isClaimingGift)
              Container(
                padding: const EdgeInsets.all(15),
                decoration: BoxDecoration(
                  color: AppColors.green,
                  borderRadius: BorderRadius.circular(16),
                ),
                child: const Row(
                  children: [
                    Icon(Icons.card_giftcard, color: AppColors.gold),
                    SizedBox(width: 11),
                    Expanded(
                      child: Text(
                        'Add your delivery details to claim your prize.',
                        style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            if (isClaimingGift) const SizedBox(height: 18),
            const _FieldTitle('NAME'),
            TextFormField(
              controller: _name,
              textCapitalization: TextCapitalization.words,
              decoration: const InputDecoration(hintText: 'Name on delivery'),
              validator: _required,
            ),
            const SizedBox(height: 15),
            const _FieldTitle('PHONE'),
            TextFormField(
              controller: _phone,
              keyboardType: TextInputType.phone,
              decoration: const InputDecoration(
                hintText: '10-digit mobile number',
              ),
              validator: (value) {
                if (value == null || value.trim().length != 10) {
                  return 'Enter a 10-digit phone number';
                }
                return null;
              },
            ),
            const SizedBox(height: 15),
            const _FieldTitle('PINCODE'),
            TextFormField(
              controller: _pincode,
              keyboardType: TextInputType.number,
              maxLength: 6,
              decoration: const InputDecoration(
                hintText: '6-digit pincode',
                counterText: '',
              ),
              validator: (value) {
                if (value == null ||
                    !RegExp(r'^\d{6}$').hasMatch(value.trim())) {
                  return 'Enter a 6-digit pincode';
                }
                return null;
              },
            ),
            const SizedBox(height: 15),
            const _FieldTitle('FULL ADDRESS'),
            TextFormField(
              controller: _fullAddress,
              minLines: 3,
              maxLines: 5,
              textCapitalization: TextCapitalization.sentences,
              decoration: const InputDecoration(
                hintText: 'House, street, area, city, state',
              ),
              validator: _required,
            ),
            const SizedBox(height: 9),
            const Row(
              children: [
                Icon(Icons.schedule, color: AppColors.green, size: 17),
                SizedBox(width: 7),
                Text(
                  'Max 5 to 7 Days for delivery',
                  style: TextStyle(color: AppColors.green),
                ),
              ],
            ),
            const SizedBox(height: 22),
            SizedBox(
              height: 53,
              child: FilledButton(
                onPressed: _save,
                style: FilledButton.styleFrom(
                  backgroundColor: AppColors.green,
                  foregroundColor: Colors.white,
                ),
                child: Text(
                  isClaimingGift ? 'Save address & claim gift' : 'Save address',
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

String? _required(String? value) =>
    value == null || value.trim().isEmpty ? 'This field is required' : null;

class _FieldTitle extends StatelessWidget {
  const _FieldTitle(this.value);

  final String value;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 7),
      child: Text(
        value,
        style: const TextStyle(
          fontWeight: FontWeight.w800,
          letterSpacing: 1.2,
          fontSize: 11,
        ),
      ),
    );
  }
}
