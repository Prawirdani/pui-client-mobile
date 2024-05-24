import 'package:flutter/material.dart';

enum ButtonVariant {
  primary,
  secondary,
}

class Button extends StatelessWidget {
  const Button(
      {super.key,
      this.onPressed,
      this.variant = ButtonVariant.primary,
      required this.text});

  final String text;
  final VoidCallback? onPressed;
  final ButtonVariant variant;

  @override
  Widget build(BuildContext context) {
    Map<ButtonVariant, Color> bgColor = {
      ButtonVariant.primary: Theme.of(context).primaryColor,
      ButtonVariant.secondary: Theme.of(context).indicatorColor
    };

    Map<ButtonVariant, Color> textColor = {
      ButtonVariant.primary: Colors.white,
      ButtonVariant.secondary: Colors.black87
    };
    return ConstrainedBox(
      constraints: const BoxConstraints(minWidth: 100),
      child: ElevatedButton(
        onPressed: onPressed,
        style: ElevatedButton.styleFrom(
          backgroundColor: bgColor[variant],
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8),
          ),
        ),
        child: Text(
          text,
          style: TextStyle(color: textColor[variant]),
        ),
      ),
    );
  }
}
