// lib/pages/pesan_page.dart

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:terraserve_app/pages/chat_detail_page.dart'; // ✅ 1. Impor halaman detail chat
import 'package:terraserve_app/pages/models/chat_contact_model.dart';

class PesanPage extends StatelessWidget {
  final ScrollController? controller;
  const PesanPage({super.key, this.controller});

  @override
  Widget build(BuildContext context) {
    final List<ChatContact> contacts = [
      ChatContact(name: 'Petani Yanti', lastMessage: 'Baik kak, pesanan sedang disiapkan ya.', imageUrl: 'assets/images/farmer.png', time: '10 min', unreadCount: 2),
      ChatContact(name: 'Admin TerraServe', lastMessage: 'Ada yang bisa kami bantu?', imageUrl: 'assets/images/user_avatar.png', time: '1 jam', unreadCount: 1),
      ChatContact(name: 'Mang Ujang', lastMessage: 'Stok cabai masih banyak, kak.', imageUrl: 'assets/images/farmer.png', time: '5 jam', unreadCount: 0),
      ChatContact(name: 'Petani Yanti', lastMessage: 'Baik kak, pesanan sedang disiapkan ya.', imageUrl: 'assets/images/farmer.png', time: '10 min', unreadCount: 2),
      ChatContact(name: 'Admin TerraServe', lastMessage: 'Ada yang bisa kami bantu?', imageUrl: 'assets/images/user_avatar.png', time: '1 jam', unreadCount: 1),
      ChatContact(name: 'Mang Ujang', lastMessage: 'Stok cabai masih banyak, kak.', imageUrl: 'assets/images/farmer.png', time: '5 jam', unreadCount: 0),
      ChatContact(name: 'Petani Yanti', lastMessage: 'Baik kak, pesanan sedang disiapkan ya.', imageUrl: 'assets/images/farmer.png', time: '10 min', unreadCount: 2),
      ChatContact(name: 'Admin TerraServe', lastMessage: 'Ada yang bisa kami bantu?', imageUrl: 'assets/images/user_avatar.png', time: '1 jam', unreadCount: 1),
      ChatContact(name: 'Mang Ujang', lastMessage: 'Stok cabai masih banyak, kak.', imageUrl: 'assets/images/farmer.png', time: '5 jam', unreadCount: 0),
      ChatContact(name: 'Petani Yanti', lastMessage: 'Baik kak, pesanan sedang disiapkan ya.', imageUrl: 'assets/images/farmer.png', time: '10 min', unreadCount: 2),
      ChatContact(name: 'Admin TerraServe', lastMessage: 'Ada yang bisa kami bantu?', imageUrl: 'assets/images/user_avatar.png', time: '1 jam', unreadCount: 1),
      ChatContact(name: 'Mang Ujang', lastMessage: 'Stok cabai masih banyak, kak.', imageUrl: 'assets/images/farmer.png', time: '5 jam', unreadCount: 0),
      ChatContact(name: 'Petani Yanti', lastMessage: 'Baik kak, pesanan sedang disiapkan ya.', imageUrl: 'assets/images/farmer.png', time: '10 min', unreadCount: 2),
      ChatContact(name: 'Admin TerraServe', lastMessage: 'Ada yang bisa kami bantu?', imageUrl: 'assets/images/user_avatar.png', time: '1 jam', unreadCount: 1),
      ChatContact(name: 'Mang Ujang', lastMessage: 'Stok cabai masih banyak, kak.', imageUrl: 'assets/images/farmer.png', time: '5 jam', unreadCount: 0),
    ];

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        automaticallyImplyLeading: false,
        title: Text(
          'Pesan',
          style: GoogleFonts.poppins(
            color: Colors.black,
            fontWeight: FontWeight.bold,
          ),
        ),
        centerTitle: true,
      ),
      body: ListView.separated(
        controller: controller,
        itemCount: contacts.length,
        separatorBuilder: (context, index) => Divider(
          height: 1,
          thickness: 1,
          color: const Color(0xFF859F3D),
          indent: 20, // Ubah indent agar lebih pas dengan desain
          endIndent: 16,
        ),
        itemBuilder: (context, index) {
          final contact = contacts[index];
          // ✅ 2. Teruskan 'context' ke metode _buildContactTile
          return _buildContactTile(context, contact);
        },
      ),
    );
  }

  // ✅ 2. Tambahkan parameter BuildContext
  Widget _buildContactTile(BuildContext context, ChatContact contact) {
    return ListTile(
      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      leading: CircleAvatar(
        radius: 28,
        backgroundImage: AssetImage(contact.imageUrl),
      ),
      title: Text(
        contact.name,
        style: GoogleFonts.poppins(fontWeight: FontWeight.bold, color: Colors.black),
      ),
      subtitle: Text(
        contact.lastMessage,
        style: GoogleFonts.poppins(color: Colors.grey[600]),
        maxLines: 1,
        overflow: TextOverflow.ellipsis,
      ),
      trailing: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          Text(
            contact.time,
            style: GoogleFonts.poppins(color: Colors.grey[600], fontSize: 12),
          ),
          const SizedBox(height: 4),
          if (contact.unreadCount > 0)
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
              decoration: BoxDecoration(
                color: const Color(0xFF31511E),
                borderRadius: BorderRadius.circular(6),
              ),
              child: Text(
                contact.unreadCount.toString(),
                style: const TextStyle(color: Colors.white, fontSize: 12, fontWeight: FontWeight.bold),
              ),
            )
        ],
      ),
      // ✅ 3. Tambahkan aksi onTap untuk navigasi
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => const ChatDetailPage()),
        );
      },
    );
  }
}
