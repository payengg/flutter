// lib/pages/chat_detail_page.dart

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class ChatMessage {
  final String text;
  final bool isSentByMe;

  ChatMessage({
    required this.text,
    required this.isSentByMe,
  });
}

class ChatDetailPage extends StatefulWidget {
  const ChatDetailPage({super.key});

  @override
  State<ChatDetailPage> createState() => _ChatDetailPageState();
}

class _ChatDetailPageState extends State<ChatDetailPage> {
  final TextEditingController _controller = TextEditingController();

  // Data Dummy sesuai gambar
  final List<ChatMessage> messages = [
    ChatMessage(text: 'Hi kak, Ada yang bisa dibantu?', isSentByMe: false),
    ChatMessage(text: 'Iya ni kak, mau nanya', isSentByMe: true),
    ChatMessage(text: 'Kalo mau beli bayam 70kg bisa ga ya?', isSentByMe: true),
    ChatMessage(
        text: 'Bisa kak, Kira-Kira untuk dikirim kapan ya..',
        isSentByMe: false),
    ChatMessage(text: 'Untuk dikirim besok kak..', isSentByMe: true),
    ChatMessage(
        text:
            'Kalo untuk besok kita belum bisa kirim 70kg kak, dikarenakan keterbatasan stok🙏',
        isSentByMe: false),
    ChatMessage(
        text: 'Namun untuk besok bisa kita kirimkan di 20kg kak',
        isSentByMe: false),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,

      // --- APP BAR ---
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new,
              color: Colors.black, size: 20),
          onPressed: () => Navigator.pop(context),
        ),
        titleSpacing: 0,
        title: Row(
          children: [
            const CircleAvatar(
              radius: 20,
              backgroundImage:
                  AssetImage('assets/images/farmer.png'), // Ganti sesuai asetmu
            ),
            const SizedBox(width: 12),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "Yanti",
                  style: GoogleFonts.poppins(
                    color: Colors.black,
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Row(
                  children: [
                    Container(
                      width: 8,
                      height: 8,
                      decoration: const BoxDecoration(
                        color: Color(0xFF389841), // Dot hijau online
                        shape: BoxShape.circle,
                      ),
                    ),
                    const SizedBox(width: 5),
                    Text(
                      "Online",
                      style: GoogleFonts.poppins(
                        color: Colors.grey,
                        fontSize: 12,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ],
        ),
        actions: [
          Container(
            margin: const EdgeInsets.only(right: 16),
            width: 40,
            height: 40,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              border: Border.all(color: Colors.grey.shade200),
            ),
            child: IconButton(
              icon: const Icon(Icons.more_horiz, color: Colors.grey),
              onPressed: () {},
            ),
          ),
        ],
      ),

      // --- BODY ---
      body: Column(
        children: [
          const SizedBox(height: 20),
          // Tanggal
          Text(
            "Hari ini 08.21 AM",
            style: GoogleFonts.poppins(color: Colors.grey[400], fontSize: 12),
          ),
          const SizedBox(height: 10),

          // List Pesan
          Expanded(
            child: ListView.builder(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
              itemCount: messages.length,
              itemBuilder: (context, index) {
                return _buildMessageItem(messages[index]);
              },
            ),
          ),

          // Input Bar
          _buildMessageComposer(),
        ],
      ),
    );
  }

  Widget _buildMessageItem(ChatMessage message) {
    // Layout Pesan: Kanan (Saya) atau Kiri (Orang Lain)
    return Padding(
      padding: const EdgeInsets.only(bottom: 16.0),
      child: Row(
        mainAxisAlignment: message.isSentByMe
            ? MainAxisAlignment.end
            : MainAxisAlignment.start,
        crossAxisAlignment:
            CrossAxisAlignment.end, // Agar avatar sejajar bawah bubble
        children: [
          // Jika pesan dari orang lain, tampilkan Avatar kecil
          if (!message.isSentByMe) ...[
            const CircleAvatar(
              radius: 16,
              backgroundImage: AssetImage('assets/images/farmer.png'),
            ),
            const SizedBox(width: 8),
          ],

          // Bubble Chat
          Flexible(
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              decoration: BoxDecoration(
                // Warna Bubble:
                // Kanan (Saya) -> Hijau Muda Pastel (EFF8D3)
                // Kiri (Orang) -> Abu-abu Muda (F2F4F5)
                color: message.isSentByMe
                    ? const Color(0xFFEFF8D3)
                    : const Color(0xFFF2F4F5),
                borderRadius: BorderRadius.only(
                  topLeft: const Radius.circular(20),
                  topRight: const Radius.circular(20),
                  bottomLeft: message.isSentByMe
                      ? const Radius.circular(20)
                      : const Radius.circular(5),
                  bottomRight: message.isSentByMe
                      ? const Radius.circular(5)
                      : const Radius.circular(20),
                ),
              ),
              child: Text(
                message.text,
                style: GoogleFonts.poppins(
                  color:
                      const Color(0xFF333333), // Warna teks abu tua/hitam soft
                  fontSize: 14,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildMessageComposer() {
    return SafeArea(
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        color: Colors.white,
        child: Row(
          children: [
            // TextField dengan Border Bulat
            Expanded(
              child: Container(
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(30),
                  border: Border.all(color: Colors.grey.shade400),
                ),
                child: Row(
                  children: [
                    Expanded(
                      child: TextField(
                        controller: _controller,
                        decoration: InputDecoration(
                          hintText: "Ketik pesan...",
                          hintStyle: GoogleFonts.poppins(color: Colors.grey),
                          border: InputBorder.none,
                          contentPadding: const EdgeInsets.symmetric(
                              horizontal: 20, vertical: 14),
                        ),
                      ),
                    ),
                    // Ikon Mic di dalam TextField
                    Padding(
                      padding: const EdgeInsets.only(right: 12.0),
                      child: Icon(Icons.mic_none, color: Colors.grey[600]),
                    ),
                  ],
                ),
              ),
            ),

            const SizedBox(width: 12),

            // Tombol Kirim (Hijau Bulat)
            GestureDetector(
              onTap: () {
                // Logika kirim pesan dummy
                if (_controller.text.isNotEmpty) {
                  setState(() {
                    messages.add(
                        ChatMessage(text: _controller.text, isSentByMe: true));
                    _controller.clear();
                  });
                }
              },
              child: Container(
                width: 50,
                height: 50,
                decoration: const BoxDecoration(
                  color: Color(0xFF389841), // Hijau Utama
                  shape: BoxShape.circle,
                ),
                child: const Icon(Icons.send_rounded,
                    color: Colors.white, size: 22),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
