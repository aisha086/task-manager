import 'package:flutter/material.dart';

class CustomTextField extends StatelessWidget {
  final String label;
  final TextEditingController controller;
  final bool isMultiline;
  final bool readOnly;
  final Function()? onTap;

  const CustomTextField({
    super.key,
    required this.label,
    required this.controller,
    this.isMultiline = false, this.readOnly = false, this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14.0),
        ),
        const SizedBox(height: 6.0),
        TextField(
          controller: controller,
          maxLines: isMultiline ? null : 1,
          decoration: InputDecoration(
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8.0),
            ),
          ),
          readOnly: readOnly,
          onTap: onTap,
        ),
        const SizedBox(height: 16.0),
      ],
    );
  }
}
