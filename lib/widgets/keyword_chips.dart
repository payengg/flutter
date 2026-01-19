import 'package:flutter/material.dart';
import '../pages/search_page.dart';

typedef KeywordTapCallback = void Function(String keyword);

class KeywordChipsWidget extends StatelessWidget {
  final KeywordTapCallback? onKeywordTap;
  const KeywordChipsWidget({Key? key, this.onKeywordTap}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final popularKeywords = ['Cabai Merah', 'Tomat', 'Nanas'];
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'KATA KUNCI POPULER',
          style: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 13,
            color: Colors.black54,
          ),
        ),
        const SizedBox(height: 8),
        Row(
          children: popularKeywords
              .map((keyword) => GestureDetector(
                    onTap: () {
                      if (onKeywordTap != null) {
                        onKeywordTap!(keyword);
                      }
                    },
                    child: Container(
                      margin: const EdgeInsets.only(right: 8),
                      padding: const EdgeInsets.symmetric(
                          horizontal: 16, vertical: 8),
                      decoration: BoxDecoration(
                        border: Border.all(color: Color(0xFF4CAF50)),
                        borderRadius: BorderRadius.circular(20),
                        color: Colors.white,
                      ),
                      child: Text(
                        keyword,
                        style: const TextStyle(
                          color: Color(0xFF4CAF50),
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                  ))
              .toList(),
        ),
      ],
    );
  }
}
