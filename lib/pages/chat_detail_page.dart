// lib/pages/chat_detail_page.dart

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

// Model sederhana untuk data pesan
class ChatMessage {
  final String text;
  final String time;
  final bool isSentByMe;

  ChatMessage({
    required this.text,
    required this.time,
    required this.isSentByMe,
  });
}

class ChatDetailPage extends StatefulWidget {
  const ChatDetailPage({super.key});

  @override
  State<ChatDetailPage> createState() => _ChatDetailPageState();
}

class _ChatDetailPageState extends State<ChatDetailPage> {
  // Data dummy untuk pesan chat
  final List<ChatMessage> messages = [
    ChatMessage(text: 'Lorem Ipsum Dolor Sit Amet, Consectetur Adipiscing Elit, Sed Do Eiusmod Tempor Incididunt Ut Labore Et Dolore.', time: '10 AM', isSentByMe: false),
    ChatMessage(text: 'Sed Do Eiusmod Tempor Incididunt Ut Labore Et Magna Aliqua. Ut Enim Ad Minim Veniam, Quis Nostrud Exercitation Ullamco Laboris Nisi Ut Aliqui.', time: '10 AM', isSentByMe: false),
    ChatMessage(text: 'Lorem Ipsum Dolor Sit', time: '10 AM', isSentByMe: true),
    ChatMessage(text: 'Sed Do Eiusmod Tempor Incididunt Ut Labore Et Magna Aliqua. Ut Enim Ad Minim Veniam,', time: '10 AM', isSentByMe: false),
    ChatMessage(text: 'Lorem Ipsum Dolor Sit Amet, Consectetur Adipiscing', time: '10 AM', isSentByMe: true),
    ChatMessage(text: 'Sed Do Eiusmod Tempor Incididunt Ut Labore Et', time: '10 AM', isSentByMe: false),
    ChatMessage(text: 'Ok', time: '10 AM', isSentByMe: true),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // ✅ 1. Ubah warna background Scaffold agar sesuai dengan AppBar
      backgroundColor: const Color(0xFF859F3D),
      appBar: AppBar(
        // Buat AppBar transparan agar menyatu dengan Scaffold
        backgroundColor: Colors.transparent,
        elevation: 0,
        automaticallyImplyLeading: false,
        flexibleSpace: SafeArea(
          child: Container(
            padding: const EdgeInsets.only(right: 16),
            child: Row(
              children: <Widget>[
                IconButton(
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  icon: const Icon(Icons.arrow_back, color: Colors.white),
                ),
                const SizedBox(width: 2),
                const CircleAvatar(
                  backgroundImage: NetworkImage("https://i.pravatar.cc/150?img=5"),
                  maxRadius: 20,
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      Text(
                        "Michael tony",
                        style: GoogleFonts.poppins(
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                          color: Colors.white,
                        ),
                      ),
                    ],
                  ),
                ),
                const Icon(Icons.notifications_none, color: Colors.white),
                const SizedBox(width: 8),
                const Icon(Icons.more_vert, color: Colors.white),
              ],
            ),
          ),
        ),
      ),
      // ✅ 2. Bungkus body dengan Container dan ClipRRect untuk membuat lengkungan
      body: ClipRRect(
        borderRadius: const BorderRadius.only(
          topLeft: Radius.circular(30.0),
          topRight: Radius.circular(30.0),
        ),
        child: Container(
          color: Colors.white,
          child: Column(
            children: <Widget>[
              Expanded(
                child: ListView.builder(
                  itemCount: messages.length,
                  padding: const EdgeInsets.all(16),
                  itemBuilder: (context, index) {
                    final message = messages[index];
                    return _buildMessage(message);
                  },
                ),
              ),
              _buildMessageComposer(),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildMessage(ChatMessage message) {
    final CrossAxisAlignment align = message.isSentByMe ? CrossAxisAlignment.end : CrossAxisAlignment.start;
    final Color color = message.isSentByMe ? const Color(0xFF859F3D) : const Color(0xFFA2A2A2);
    final Color textColor = message.isSentByMe ? Colors.white : Colors.white;
    final String avatarUrl = message.isSentByMe ? "https://i.pravatar.cc/150?img=3" : "https://i.pravatar.cc/150?img=5";
    
    return Container(
      margin: const EdgeInsets.only(bottom: 16.0),
      child: Column(
        crossAxisAlignment: align,
        children: [
          Row(
            mainAxisAlignment: message.isSentByMe ? MainAxisAlignment.end : MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              if (!message.isSentByMe)
                CircleAvatar(
                  backgroundImage: NetworkImage(avatarUrl),
                  radius: 20,
                ),
              if (!message.isSentByMe) const SizedBox(width: 8),
              Container(
                constraints: BoxConstraints(maxWidth: MediaQuery.of(context).size.width * 0.7),
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                decoration: BoxDecoration(
                  color: color,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Text(
                  message.text,
                  style: GoogleFonts.poppins(color: textColor),
                ),
              ),
              if (message.isSentByMe) const SizedBox(width: 8),
              if (message.isSentByMe)
                CircleAvatar(
                  backgroundImage: NetworkImage(avatarUrl),
                  radius: 20,
                ),
            ],
          ),
          const SizedBox(height: 4),
          Padding(
            padding: message.isSentByMe 
              ? const EdgeInsets.only(right: 50.0) 
              : const EdgeInsets.only(left: 50.0),
            child: Text(
              message.time,
              style: GoogleFonts.poppins(color: Colors.grey[600], fontSize: 10),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildMessageComposer() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border(top: BorderSide(color: Colors.grey[200]!))
      ),
      child: SafeArea(
        child: Container(
          decoration: BoxDecoration(
            color: Colors.grey[100],
            borderRadius: BorderRadius.circular(30),
          ),
          child: Row(
            children: <Widget>[
              IconButton(
                icon: const Icon(Icons.emoji_emotions_outlined),
                onPressed: () {},
                color: Colors.grey[600],
              ),
              Expanded(
                child: TextField(
                  decoration: InputDecoration.collapsed(
                    hintText: 'Type message here...',
                    hintStyle: GoogleFonts.poppins(color: Colors.grey[600]),
                  ),
                ),
              ),
              Container(
                margin: const EdgeInsets.all(4),
                decoration: const BoxDecoration(
                  color: Color(0xFF859F3D),
                  shape: BoxShape.circle,
                ),
                child: IconButton(
                  icon: const Icon(Icons.send_rounded, color: Colors.white),
                  onPressed: () {},
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
