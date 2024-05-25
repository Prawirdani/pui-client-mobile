import 'package:flutter/material.dart';

enum ButtonVariant {
  primary,
  secondary,
  destructive
}

class Button extends StatelessWidget {
  const Button(
      {super.key,
      this.onPressed,
      this.variant = ButtonVariant.primary,
      this.minWidth = 100,
      required this.text});

  final String text;
  final VoidCallback? onPressed;
  final ButtonVariant variant;
  final double minWidth;

  @override
  Widget build(BuildContext context) {
    Map<ButtonVariant, Color> bgColor = {
      ButtonVariant.primary: Theme.of(context).primaryColor,
      ButtonVariant.secondary: Theme.of(context).indicatorColor,
      ButtonVariant.destructive: Colors.red
    };

    Map<ButtonVariant, Color> textColor = {
      ButtonVariant.primary: Colors.white,
      ButtonVariant.secondary: Colors.black87,
      ButtonVariant.destructive: Colors.white
    };
    return ConstrainedBox(
      constraints: BoxConstraints(minWidth: minWidth),
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
          style: TextStyle(color: textColor[variant], fontSize: 16),
        ),
      ),
    );
  }
}
