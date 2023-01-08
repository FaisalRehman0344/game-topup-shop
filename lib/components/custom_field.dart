import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

TextFormField customField(String title, var onChange) {
  return TextFormField(
    obscureText: title == "Password",
    keyboardType: TextInputType.number,
    inputFormatters: [FilteringTextInputFormatter.digitsOnly],
    decoration: InputDecoration(
      border: OutlineInputBorder(
          borderSide: const BorderSide(color: Colors.orange),
          borderRadius: BorderRadius.circular(15)),
      labelText: title,
    ),
    onChanged: onChange,
    validator: (value) {
      if (value == null || value.isEmpty) {
        return "Please enter " + title;
      }
      return null;
    },
  );
}
