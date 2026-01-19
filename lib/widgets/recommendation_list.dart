import 'package:flutter/material.dart';

class RecommendationListWidget extends StatelessWidget {
  const RecommendationListWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: const Color(0xFFE0E0E0)),
        boxShadow: [
          BoxShadow(
            color: Colors.black12,
            blurRadius: 4,
            offset: Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        children: const [
          _RecommendationRow(
            icon: Icons.show_chart,
            text: 'Beras Ketan',
            label: 'Populer',
            labelColor: Color(0xFF4CAF50),
          ),
          _RecommendationRow(
            icon: Icons.flash_on,
            text: 'Cabai Merah',
            label: 'Terlaris',
            labelColor: Color(0xFFFFA726),
          ),
          _RecommendationRow(
            icon: Icons.access_time,
            text: 'Bayam Merah',
          ),
          _RecommendationRow(
            icon: Icons.access_time,
            text: 'Strawberry',
          ),
        ],
      ),
    );
  }
}

class _RecommendationRow extends StatelessWidget {
  final IconData icon;
  final String text;
  final String? label;
  final Color? labelColor;

  const _RecommendationRow({
    required this.icon,
    required this.text,
    this.label,
    this.labelColor,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: Row(
        children: [
          Icon(icon, color: labelColor ?? Colors.grey, size: 20),
          const SizedBox(width: 10),
          Expanded(
            child: Text(
              text,
              style: const TextStyle(fontWeight: FontWeight.w500),
            ),
          ),
          if (label != null)
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
              decoration: BoxDecoration(
                color: (labelColor ?? Colors.grey).withOpacity(0.1),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Text(
                label!,
                style: TextStyle(
                  color: labelColor ?? Colors.grey,
                  fontWeight: FontWeight.bold,
                  fontSize: 12,
                ),
              ),
            ),
        ],
      ),
    );
  }
}
