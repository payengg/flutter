// lib/pages/payment_method_page.dart

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:terraserve_app/pages/models/bank_model.dart';
import 'package:terraserve_app/pages/models/cart_item_model.dart';
import 'package:terraserve_app/pages/payment_details_page.dart';

class PaymentMethodPage extends StatefulWidget {
  final List<CartItem> cartItems;

  const PaymentMethodPage({
    super.key,
    required this.cartItems,
  });

  @override
  State<PaymentMethodPage> createState() => _PaymentMethodPageState();
}

class _PaymentMethodPageState extends State<PaymentMethodPage> {
  bool _isBankExpanded = true;
  bool _isEwalletExpanded = false;
  Bank? _selectedBank;

  final List<Bank> _banks = [
    Bank(name: 'Bank BCA', logoAsset: 'assets/images/icon_bca.png'),
    Bank(name: 'Bank BNI', logoAsset: 'assets/images/icon_bni.png'),
    Bank(name: 'Bank BRI', logoAsset: 'assets/images/icon_bri.png'),
    Bank(name: 'Bank Mandiri', logoAsset: 'assets/images/icon_mandiri.png'),
    Bank(name: 'Bank Permata', logoAsset: 'assets/images/icon_permata.png'),
    Bank(
        name: 'Bank CIMB Niaga', logoAsset: 'assets/images/icon_cimbniaga.png'),
    Bank(name: 'Bank BSI', logoAsset: 'assets/images/icon_bsi.png'),
  ];

  @override
  Widget build(BuildContext context) {
    String bottomButtonText = 'Pilih Pembayaran';
    VoidCallback? onBottomButtonPressed;

    if (_isBankExpanded) {
      bottomButtonText = 'Pilih Pembayaran';
      onBottomButtonPressed = () {
        if (_selectedBank != null) {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => PaymentDetailsPage(
                selectedBank: _selectedBank!,
                cartItems: widget.cartItems,
              ),
            ),
          );
        } else {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
                content: Text('Silakan pilih bank terlebih dahulu.')),
          );
        }
      };
    } else if (_isEwalletExpanded) {
      bottomButtonText = 'Lanjutkan dengan E-wallet';
      onBottomButtonPressed = () {
        // Logika untuk E-wallet
      };
    }

    return Scaffold(
      backgroundColor: const Color(0xFFF9F9F9),
      appBar: AppBar(
        backgroundColor: const Color(0xFFF9F9F9),
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () => Navigator.of(context).pop(),
        ),
        title: Text(
          'Metode Pembayaran',
          style: GoogleFonts.poppins(
            color: Colors.black,
            fontWeight: FontWeight.bold,
          ),
        ),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            _buildPaymentOption(
              title: 'Transfer Bank',
              isExpanded: _isBankExpanded,
              onExpansionChanged: (expanding) {
                setState(() {
                  _isBankExpanded = expanding;
                  if (expanding) _isEwalletExpanded = false;
                });
              },
              children: ListTile.divideTiles(
                context: context,
                tiles: _banks.map((bank) => _buildBankTile(bank)),
                color: Colors.grey[200],
              ).toList(),
            ),
            const SizedBox(height: 16),
            _buildPaymentOption(
              title: 'E-wallet',
              isExpanded: _isEwalletExpanded,
              onExpansionChanged: (expanding) {
                setState(() {
                  _isEwalletExpanded = expanding;
                  if (expanding) {
                    _isBankExpanded = false;
                    _selectedBank = null;
                  }
                });
              },
              children: [_buildQrCodeSection()],
            ),
            const Spacer(),
          ],
        ),
      ),
      bottomSheet: _buildBottomButton(
        text: bottomButtonText,
        onPressed: onBottomButtonPressed,
      ),
    );
  }

  Widget _buildPaymentOption({
    required String title,
    required bool isExpanded,
    required ValueChanged<bool> onExpansionChanged,
    required List<Widget> children,
  }) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(15),
      ),
      child: ExpansionTile(
        tilePadding: const EdgeInsets.symmetric(horizontal: 16.0),
        key: GlobalKey(),
        initiallyExpanded: isExpanded,
        onExpansionChanged: onExpansionChanged,
        shape: const Border(),
        title: Text(
          title,
          style: GoogleFonts.poppins(
            fontSize: 15,
            fontWeight: FontWeight.w500,
            color: Colors.black,
          ),
        ),
        trailing: Icon(
          isExpanded ? Icons.keyboard_arrow_up : Icons.keyboard_arrow_down,
        ),
        children: children,
      ),
    );
  }

  Widget _buildBankTile(Bank bank) {
    bool isSelected = _selectedBank == bank;
    return ListTile(
      contentPadding:
          const EdgeInsets.symmetric(horizontal: 16.0, vertical: 4.0),
      onTap: () {
        setState(() {
          _selectedBank = bank;
        });
      },
      leading: SizedBox(
        width: 60,
        child: Image.asset(
          bank.logoAsset,
          height: 24,
          fit: BoxFit.contain,
        ),
      ),
      title: Text(
        bank.name,
        style: GoogleFonts.poppins(fontWeight: FontWeight.w500),
      ),
      trailing: isSelected
          ? const Icon(Icons.check_circle,
              color: Color(0xFF389841)) // Checkmark Hijau
          : null,
    );
  }

  Widget _buildQrCodeSection() {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        children: [
          Image.asset('assets/images/qrr.png', height: 200),
          const SizedBox(height: 16),
        ],
      ),
    );
  }

  Widget _buildBottomButton({required String text, VoidCallback? onPressed}) {
    return Container(
      color: Colors.transparent,
      child: Padding(
        padding: const EdgeInsets.fromLTRB(16, 8, 16, 24),
        child: ElevatedButton(
          onPressed: onPressed,
          style: ElevatedButton.styleFrom(
            // ✅ UBAH WARNA TOMBOL DISINI KE 0xFF389841
            backgroundColor: const Color(0xFF389841),
            minimumSize: const Size(double.infinity, 55),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(15),
            ),
          ),
          child: Text(
            text,
            style: GoogleFonts.poppins(
              fontWeight: FontWeight.bold,
              fontSize: 16,
              color: Colors.white,
            ),
          ),
        ),
      ),
    );
  }
}
