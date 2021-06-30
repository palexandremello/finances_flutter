import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class AdaptativeTextField extends StatelessWidget {
  final TextEditingController controller;
  final TextInputType keyboardType;
  final Function(String) onSubmitted;
  final String label;

  const AdaptativeTextField({
    Key key,
    this.controller,
    this.keyboardType = TextInputType.text,
    this.onSubmitted,
    this.label,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Platform.isIOS
        ? Padding(
            padding: const EdgeInsets.only(bottom: 10),
            child: CupertinoTextField(
              keyboardType: keyboardType,
              controller: controller,
              onSubmitted: onSubmitted,
              placeholder: label,
              padding: EdgeInsets.symmetric(
                horizontal: 6,
                vertical: 12,
              ),
            ),
          )
        : Padding(
            padding: const EdgeInsets.only(bottom: 10),
            child: TextField(
              decoration: InputDecoration(labelText: label),
              keyboardType: keyboardType,
              controller: controller,
              onSubmitted: onSubmitted,
            ),
          );
  }
}
