import 'package:flutter/material.dart';

enum ButtonVariant {
  Primary,
  Secondary,
}

class Button extends StatelessWidget {
  const Button(
      {super.key,
      this.onPressed,
      this.variant = ButtonVariant.Primary,
      required this.text});

  final String text;
  final VoidCallback? onPressed;
  final ButtonVariant variant;

  @override
  Widget build(BuildContext context) {
    Map<ButtonVariant, Color> bgColor = {
      ButtonVariant.Primary: Theme.of(context).primaryColor,
      ButtonVariant.Secondary: Theme.of(context).indicatorColor
    };

    Map<ButtonVariant, Color> textColor = {
      ButtonVariant.Primary: Colors.white,
      ButtonVariant.Secondary: Colors.black87
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
