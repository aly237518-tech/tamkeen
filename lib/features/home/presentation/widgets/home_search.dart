import 'package:flutter/material.dart';

class HomeSearch extends StatelessWidget {
  final ValueChanged<String>? onChanged;

  const HomeSearch({
    super.key,
    this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(18),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(.05),
            blurRadius: 12,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      child: TextField(
        onChanged: onChanged,
        decoration: InputDecoration(
          hintText: "ابحثي عن وظيفة، شركة، أو محافظة...",
          hintStyle: const TextStyle(
            color: Colors.grey,
          ),
          prefixIcon: const Icon(
            Icons.search_rounded,
            color: Color(0xff6A1B9A),
          ),
          suffixIcon: const Icon(
            Icons.tune_rounded,
            color: Color(0xff6A1B9A),
          ),
          filled: true,
          fillColor: Colors.white,
          contentPadding: const EdgeInsets.symmetric(
            vertical: 18,
            horizontal: 16,
          ),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(18),
            borderSide: BorderSide.none,
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(18),
            borderSide: BorderSide.none,
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(18),
            borderSide: const BorderSide(
              color: Color(0xff6A1B9A),
              width: 1.5,
            ),
          ),
        ),
      ),
    );
  }
}