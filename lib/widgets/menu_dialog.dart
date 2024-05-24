import 'package:flutter/material.dart';

class MenuDialog extends StatelessWidget {
  const MenuDialog({super.key});

  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(8),
      ),
      child: Container(
        padding: const EdgeInsets.all(12),
        height: 500,
        width: 400,
        child: Column(
          children: [
            Expanded(
              flex: 4,
              child: Container(color: Colors.black38),
            ),
            Expanded(
              flex: 6,
              child: Container(color: Colors.black26),
            )
          ],
        ),
      ),
    );
  }
}
