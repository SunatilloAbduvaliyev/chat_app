import 'package:flutter/material.dart';

class PasswordFormField extends StatefulWidget {
  const PasswordFormField({
    super.key,
    required this.controller,
  });

  final TextEditingController controller;

  @override
  State<PasswordFormField> createState() => _PasswordFormFieldState();
}

class _PasswordFormFieldState extends State<PasswordFormField> {
  bool isShow = false;

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      autovalidateMode: AutovalidateMode.onUserInteraction,
      validator: (value) {
        if (value!.isEmpty) {
          return "Ma'lumot to'ldiring";
        }
        return null;
      },
      controller: widget.controller,
      obscureText: isShow,
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
          labelText: "Password",
          suffixIcon: IconButton(
            onPressed: () {
              setState(() {
                isShow = !isShow;
              });
            },
            icon: Icon(
                isShow ? Icons.visibility_off : Icons.remove_red_eye),
          )),
    );
  }
}