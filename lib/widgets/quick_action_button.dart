import 'package:flutter/material.dart';

class QuickActionButton extends StatelessWidget {

  final String title;
  final IconData icon;
  final VoidCallback onTap;

  const QuickActionButton({
    super.key,
    required this.title,
    required this.icon,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {

    return SizedBox(
      width: double.infinity,
      child: ElevatedButton.icon(

        style: ElevatedButton.styleFrom(
          padding: const EdgeInsets.symmetric(
            vertical: 16,
          ),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(15),
          ),
        ),

        onPressed: onTap,

        icon: Icon(icon),

        label: Text(
          title,
          style: const TextStyle(
            fontSize: 16,
          ),
        ),
      ),
    );

  }
}