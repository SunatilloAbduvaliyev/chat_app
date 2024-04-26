import 'package:flutter/material.dart';
class EmailFormField extends StatelessWidget {
  const EmailFormField({
    super.key,
    required this.controller,
  });

  final TextEditingController controller;

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      autovalidateMode: AutovalidateMode.onUserInteraction,
      validator: (value) {
        if (value!.isEmpty) {
          return "Ma'lumotni to'ldiring";
        }
        return null;
      },
      controller: controller,
      style: const TextStyle(
        color: Colors.white,
      ),
      decoration: InputDecoration(
        labelStyle: const TextStyle(
          color: Colors.white,
        ),
        errorStyle: const TextStyle(
          color: Colors.red,
        ),
        border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10),
            borderSide: const BorderSide(
              width: 0,
              color: Color(0xFF262626),
            )),
        labelText: "Email",
      ),
    );
  }
}