import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:terraserve_app/pages/checkout_page.dart';
import 'package:terraserve_app/pages/models/cart_item_model.dart';
import 'package:terraserve_app/pages/models/product_model.dart';
import 'package:terraserve_app/pages/product_detail_page.dart';
import 'package:terraserve_app/pages/services/cart_service.dart';
import 'package:terraserve_app/pages/services/product_service.dart';
import 'package:terraserve_app/pages/widgets/recommendation_card.dart';

class CartPage extends StatefulWidget {
  const CartPage({super.key});

  @override
  State<CartPage> createState() => _CartPageState();
}

class _CartPageState extends State<CartPage> {
  @override
  Widget build(BuildContext context) {
    final cartService = Provider.of<CartService>(context);

    return Scaffold(
      backgroundColor: const Color(0xFFF9F9F9),
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 1,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () => Navigator.of(context).pop(),
        ),
        title: Text(
          'Keranjang Saya',
          style: GoogleFonts.poppins(
            color: Colors.black,
            fontWeight: FontWeight.bold,
          ),
        ),
        centerTitle: true,
      ),
      body: CustomScrollView(
        slivers: [
          SliverPadding(
            padding: const EdgeInsets.only(top: 16),
            sliver: SliverList(
              delegate: SliverChildBuilderDelegate(
                (context, index) {
                  final item = cartService.items[index];
                  return _buildCartItemCard(context, item, cartService);
                },
                childCount: cartService.items.length,
              ),
            ),
          ),
          if (cartService.items.isEmpty)
            SliverFillRemaining(
              child: Center(
                child: Text(
                  'Keranjang Anda masih kosong.',
                  style: GoogleFonts.poppins(color: Colors.grey),
                ),
              ),
            ),
          if (cartService.items.isNotEmpty) ...[
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.fromLTRB(16, 32, 16, 16),
                child: Text(
                  'Kamu Mungkin Suka',
                  style: GoogleFonts.poppins(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
            SliverPadding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              sliver: FutureBuilder<List<Product>>(
                future: ProductService().getProducts(),
                builder: (context, snapshot) {
                  if (!snapshot.hasData) {
                    return const SliverToBoxAdapter(child: SizedBox.shrink());
                  }
                  final allProducts = snapshot.data!;
                  return SliverGrid(
                    gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 2,
                      crossAxisSpacing: 16,
                      mainAxisSpacing: 16,
                      childAspectRatio: 0.75,
                    ),
                    delegate: SliverChildBuilderDelegate(
                      (context, index) {
                        final product = allProducts[index];
                        return GestureDetector(
                          onTap: () {
                             Navigator.push(
                              context,
                              MaterialPageRoute(builder: (context) => ProductDetailPage(product: product)),
                            );
                          },
                          child: RecommendationCard(product: product),
                        );
                      },
                      childCount: allProducts.length > 4 ? 4 : allProducts.length,
                    ),
                  );
                },
              ),
            ),
            const SliverToBoxAdapter(
              child: SizedBox(height: 120),
            )
          ],
        ],
      ),
      bottomSheet: _buildCheckoutSection(context, cartService),
    );
  }

  Widget _buildCartItemCard(BuildContext context, CartItem item, CartService cartService) {
    return Container(
      margin: const EdgeInsets.fromLTRB(16, 0, 16, 16),
      padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 8),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(15),
      ),
      child: Row(
        children: [
          Checkbox(
            value: item.isSelected,
            onChanged: (val) {
              cartService.toggleItemSelected(item);
            },
            activeColor: const Color(0xFF859F3D),
          ),
          ClipRRect(
            borderRadius: BorderRadius.circular(10),
            child: Image.network(
              item.product.galleries.first,
              width: 60,
              height: 60,
              fit: BoxFit.cover,
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  item.product.name,
                  style: GoogleFonts.poppins(fontWeight: FontWeight.bold, fontSize: 16),
                ),
                Text(
                  item.product.unit ?? 'per item',
                  style: GoogleFonts.poppins(color: Colors.grey, fontSize: 12),
                ),
                Text(
                  'Rp${item.product.price.toStringAsFixed(0)}',
                  style: GoogleFonts.poppins(
                    fontWeight: FontWeight.bold,
                    fontSize: 14,
                    color: const Color(0xFF859F3D),
                  ),
                ),
              ],
            ),
          ),
          Row(
            children: [
              _buildQuantityButton(
                icon: Icons.remove,
                onTap: () => cartService.decrementQuantity(item),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 8.0),
                child: Text(
                  item.quantity.toString(),
                  style: GoogleFonts.poppins(fontWeight: FontWeight.bold, fontSize: 16),
                ),
              ),
              _buildQuantityButton(
                icon: Icons.add,
                onTap: () => cartService.incrementQuantity(item),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildQuantityButton({required IconData icon, required VoidCallback onTap}) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(5),
      child: Container(
        padding: const EdgeInsets.all(4),
        decoration: BoxDecoration(
          color: Colors.grey[200],
          borderRadius: BorderRadius.circular(5),
        ),
        child: Icon(icon, size: 16),
      ),
    );
  }

  Widget _buildCheckoutSection(BuildContext context, CartService cartService) {
    if (cartService.items.isEmpty) {
      return const SizedBox.shrink();
    }
    
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      decoration: const BoxDecoration(
        color: Colors.white,
      ),
      child: Row(
        children: [
          Checkbox(
            value: cartService.areAllItemsSelected,
            onChanged: (val) {
              cartService.toggleSelectAll(val ?? false);
            },
            activeColor: const Color(0xFF859F3D),
          ),
          Text(
            'Pilih Semua',
            style: GoogleFonts.poppins(),
          ),
          const Spacer(),
          Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text(
                'Total',
                style: GoogleFonts.poppins(color: Colors.grey),
              ),
              Text(
                'Rp${cartService.totalPrice.toStringAsFixed(0)}',
                style: GoogleFonts.poppins(
                  fontWeight: FontWeight.bold,
                  fontSize: 20,
                ),
              ),
            ],
          ),
          const SizedBox(width: 16),
          Expanded(
            flex: 2,
            child: ElevatedButton(
              onPressed: () {
                // ✅ Navigasi ke Halaman Checkout
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const CheckoutPage()),
                );
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF859F3D),
                padding: const EdgeInsets.symmetric(vertical: 14),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(15),
                ),
              ),
              child: Text(
                'Checkout',
                style: GoogleFonts.poppins(
                  fontWeight: FontWeight.bold,
                  fontSize: 16,
                  color: Colors.white,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}