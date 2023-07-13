import 'package:flutter/material.dart';

Widget customField(key, value) {
  return Wrap(
    children: [
      Text(
        key,
        style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
      ),
      Text(
        value,
        style: const TextStyle(fontSize: 20),
      ),
    ],
  );
}
