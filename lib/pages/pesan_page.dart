// lib/pages/pesan_page.dart

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:terraserve_app/pages/chat_detail_page.dart'; // ✅ Pastikan path ini benar
import 'package:terraserve_app/pages/models/chat_contact_model.dart';

class PesanPage extends StatelessWidget {
  final ScrollController? controller;
  const PesanPage({super.key, this.controller});

  @override
  Widget build(BuildContext context) {
    // Dummy Data
    final List<ChatContact> contacts = [
      ChatContact(
          name: 'Petani Yanti',
          lastMessage: 'Baik kak, pesanan sedang disiapkan ya.',
          imageUrl: 'assets/images/farmer.png',
          time: '10 min',
          unreadCount: 2),
      ChatContact(
          name: 'Admin TerraServe',
          lastMessage: 'Ada yang bisa kami bantu?',
          imageUrl: 'assets/images/user_avatar.png',
          time: '1 jam',
          unreadCount: 1),
      ChatContact(
          name: 'Mang Ujang',
          lastMessage: 'Stok cabai masih banyak, kak.',
          imageUrl: 'assets/images/farmer.png',
          time: '5 jam',
          unreadCount: 0),
      ChatContact(
          name: 'Petani Yanti',
          lastMessage: 'Baik kak, pesanan sedang disiapkan ya.',
          imageUrl: 'assets/images/farmer.png',
          time: '10 min',
          unreadCount: 2),
      ChatContact(
          name: 'Admin TerraServe',
          lastMessage: 'Ada yang bisa kami bantu?',
          imageUrl: 'assets/images/user_avatar.png',
          time: '1 jam',
          unreadCount: 1),
      ChatContact(
          name: 'Mang Ujang',
          lastMessage: 'Stok cabai masih banyak, kak.',
          imageUrl: 'assets/images/farmer.png',
          time: '5 jam',
          unreadCount: 0),
      ChatContact(
          name: 'Petani Yanti',
          lastMessage: 'Baik kak, pesanan sedang disiapkan ya.',
          imageUrl: 'assets/images/farmer.png',
          time: '10 min',
          unreadCount: 2),
      ChatContact(
          name: 'Admin TerraServe',
          lastMessage: 'Ada yang bisa kami bantu?',
          imageUrl: 'assets/images/user_avatar.png',
          time: '1 jam',
          unreadCount: 1),
      ChatContact(
          name: 'Mang Ujang',
          lastMessage: 'Stok cabai masih banyak, kak.',
          imageUrl: 'assets/images/farmer.png',
          time: '5 jam',
          unreadCount: 0),
      ChatContact(
          name: 'Petani Yanti',
          lastMessage: 'Baik kak, pesanan sedang disiapkan ya.',
          imageUrl: 'assets/images/farmer.png',
          time: '10 min',
          unreadCount: 2),
      ChatContact(
          name: 'Admin TerraServe',
          lastMessage: 'Ada yang bisa kami bantu?',
          imageUrl: 'assets/images/user_avatar.png',
          time: '1 jam',
          unreadCount: 1),
      ChatContact(
          name: 'Mang Ujang',
          lastMessage: 'Stok cabai masih banyak, kak.',
          imageUrl: 'assets/images/farmer.png',
          time: '5 jam',
          unreadCount: 0),
      ChatContact(
          name: 'Petani Yanti',
          lastMessage: 'Baik kak, pesanan sedang disiapkan ya.',
          imageUrl: 'assets/images/farmer.png',
          time: '10 min',
          unreadCount: 2),
      ChatContact(
          name: 'Admin TerraServe',
          lastMessage: 'Ada yang bisa kami bantu?',
          imageUrl: 'assets/images/user_avatar.png',
          time: '1 jam',
          unreadCount: 1),
      ChatContact(
          name: 'Mang Ujang',
          lastMessage: 'Stok cabai masih banyak, kak.',
          imageUrl: 'assets/images/farmer.png',
          time: '5 jam',
          unreadCount: 0),
    ];

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        automaticallyImplyLeading: false, // Menghilangkan tombol back
        // ------------------
        // Bagian Kiri: Tombol Back (Custom)
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new,
              color: Colors.black, size: 20),
          onPressed: () {
            // Bisa kosong kalau ini main page, atau Navigator.pop(context) kalau sub-page
            // Navigator.pop(context);
          },
        ),
        // ------------------
        title: Text(
          'Pesan',
          style: GoogleFonts.poppins(
            color: Colors.black,
            fontWeight: FontWeight.bold,
            fontSize: 18,
          ),
        ),
        centerTitle: true,
      ),
      body: ListView.separated(
        controller: controller,
        itemCount: contacts.length,
        separatorBuilder: (context, index) => const Divider(
          height: 1,
          thickness: 1,
          // --- UBAH WARNA GARIS DISINI ---
          color: Color(0xFF389841),
          indent: 20,
          endIndent: 20,
        ),
        itemBuilder: (context, index) {
          final contact = contacts[index];
          return _buildContactTile(context, contact);
        },
      ),
    );
  }

  Widget _buildContactTile(BuildContext context, ChatContact contact) {
    return ListTile(
      contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
      leading: CircleAvatar(
        radius: 28,
        backgroundImage: AssetImage(contact.imageUrl),
        backgroundColor: Colors.grey[200], // Fallback color
      ),
      title: Text(
        contact.name,
        style: GoogleFonts.poppins(
          fontWeight: FontWeight.bold,
          color: Colors.black,
          fontSize: 16,
        ),
      ),
      subtitle: Padding(
        padding: const EdgeInsets.only(top: 4.0),
        child: Text(
          contact.lastMessage,
          style: GoogleFonts.poppins(
            color: Colors.grey[600],
            fontSize: 13,
          ),
          maxLines: 2, // Biarkan 2 baris seperti di gambar
          overflow: TextOverflow.ellipsis,
        ),
      ),
      trailing: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          Text(
            contact.time,
            style: GoogleFonts.poppins(
              color: Colors.black, // Warna jam hitam di gambar
              fontSize: 12,
              fontWeight: FontWeight.w500,
            ),
          ),
          const SizedBox(height: 8),
          if (contact.unreadCount > 0)
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
              decoration: BoxDecoration(
                // --- UBAH WARNA BUBBLE NOTIFIKASI DISINI ---
                color: const Color(0xFF389841),
                borderRadius:
                    BorderRadius.circular(6), // Kotak rounded seperti di gambar
              ),
              child: Text(
                contact.unreadCount.toString(),
                style: GoogleFonts.poppins(
                    color: Colors.white,
                    fontSize: 11,
                    fontWeight: FontWeight.bold),
              ),
            )
        ],
      ),
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => const ChatDetailPage()),
        );
      },
    );
  }
}
