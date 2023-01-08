import 'package:flutter/material.dart';

MouseRegion gameCard(String title, String img) {
  return MouseRegion(
    cursor: SystemMouseCursors.click,
    child: SizedBox(
      width: 120,
      height: 120,
      child: Card(
        elevation: 10,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
        margin: EdgeInsets.zero,
        child: Padding(
          padding: const EdgeInsets.all(15),
          child: SizedBox(
            height: 26,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                ClipRRect(
                  borderRadius: BorderRadius.circular(8),
                  child: Image.asset(
                    img,
                    width: 65,
                  ),
                ),
                const SizedBox(height: 5),
                Text(
                  title,
                  style: const TextStyle(
                      fontSize: 14, fontWeight: FontWeight.w500),
                )
              ],
            ),
          ),
        ),
      ),
    ),
  );
}
