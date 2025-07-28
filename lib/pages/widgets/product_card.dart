// lib/pages/widgets/product_card.dart

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:terraserve_app/pages/models/cart_item_model.dart';
import 'package:terraserve_app/pages/models/product_model.dart';
import 'package:terraserve_app/pages/services/cart_service.dart';

class ProductCard extends StatelessWidget {
  final Product product;
  const ProductCard({super.key, required this.product});

  @override
  Widget build(BuildContext context) {
    final cartService = Provider.of<CartService>(context);
    
    // Cek apakah item ini sudah ada di keranjang dan berapa kuantitasnya
    final itemInCart = cartService.items.firstWhere(
      (item) => item.product.id == product.id,
      orElse: () => CartItem(product: product, quantity: 0), 
    );
    final quantity = itemInCart.quantity;

    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(15),
        border: Border.all(color: Colors.grey[200]!),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.1),
            spreadRadius: 1,
            blurRadius: 5,
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          AspectRatio(
            aspectRatio: 1,
            child: Container(
              decoration: BoxDecoration(
                borderRadius: const BorderRadius.only(
                  topLeft: Radius.circular(15),
                  topRight: Radius.circular(15),
                ),
                image: product.galleries.isNotEmpty
                    ? DecorationImage(
                        image: NetworkImage(product.galleries.first),
                        fit: BoxFit.cover,
                      )
                    : null,
              ),
              child: product.galleries.isEmpty
                  ? const Center(
                      child: Icon(Icons.image_not_supported, color: Colors.grey),
                    )
                  : null,
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  product.name,
                  style: GoogleFonts.poppins(fontWeight: FontWeight.bold, fontSize: 16),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: 4),
                Text(
                  product.unit ?? '',
                  style: GoogleFonts.poppins(color: Colors.grey[600], fontSize: 12),
                ),
                const SizedBox(height: 8),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Flexible(
                      child: Text(
                        'Rp${product.price.toStringAsFixed(0)}',
                        style: GoogleFonts.poppins(
                          color: Colors.black,
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                        ),
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                    quantity == 0
                        ? _buildAddButton(context, product)
                        : _buildQuantityControls(context, itemInCart),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildAddButton(BuildContext context, Product product) {
    final cartService = Provider.of<CartService>(context, listen: false);
    return Container(
      height: 30,
      width: 30,
      decoration: BoxDecoration(
        color: const Color(0xFFF0F4E8),
        borderRadius: BorderRadius.circular(8),
      ),
      child: IconButton(
        padding: EdgeInsets.zero,
        onPressed: () {
          cartService.addToCart(product);
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('${product.name} ditambahkan ke keranjang!'),
              duration: const Duration(seconds: 1),
              backgroundColor: const Color(0xFF859F3D),
            ),
          );
        },
        icon: Image.asset('assets/images/icon_tambah.png', height: 16),
      ),
    );
  }

  Widget _buildQuantityControls(BuildContext context, CartItem item) {
    final cartService = Provider.of<CartService>(context, listen: false);
    return Row(
      children: [
        Container(
          height: 30,
          width: 30,
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(8),
            border: Border.all(color: Colors.grey[300]!),
          ),
          child: IconButton(
            padding: EdgeInsets.zero,
            onPressed: () => cartService.decrementQuantity(item),
            icon: Image.asset('assets/images/icon_minus.png', height: 16),
          ),
        ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 10.0),
          child: Text(
            '${item.quantity}',
            style: GoogleFonts.poppins(fontWeight: FontWeight.bold, fontSize: 14),
          ),
        ),
        Container(
          height: 30,
          width: 30,
          decoration: BoxDecoration(
            color: const Color(0xFFF0F4E8),
            borderRadius: BorderRadius.circular(8),
          ),
          child: IconButton(
            padding: EdgeInsets.zero,
            onPressed: () => cartService.incrementQuantity(item),
            icon: Image.asset('assets/images/icon_tambah.png', height: 16),
          ),
        ),
      ],
    );
  }
}