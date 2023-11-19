import 'package:flutter/material.dart';

class FieldWidget extends StatelessWidget {
  final TextEditingController? controller;
  final Function(String)? onChanged;
  const FieldWidget({
    super.key,
    this.controller,
    this.onChanged,
  });
  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: controller,
      onChanged: onChanged,
      decoration: const InputDecoration(
        border: OutlineInputBorder(),
        hintText: 'Search movies...',
        hintStyle: TextStyle(
          color: Colors.grey,
        ),
      ),
    );
  }
}
