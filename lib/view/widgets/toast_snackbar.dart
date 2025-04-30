import 'package:flutter/material.dart';

class ToastSnackbar {
  static void show({required  context,required String message,required Color color}) {
    final overlay = Overlay.of(context);
    final overlayEntry = OverlayEntry(
      builder: (context) => Positioned(
     bottom: MediaQuery.of(context).size.height * 0.12, // Moves up from the bottom
        left: MediaQuery.of(context).size.width * 0.15,
        right: MediaQuery.of(context).size.width * 0.15,

        child: Material(
          color: Colors.transparent,
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            decoration: BoxDecoration(
              color: color,
              borderRadius: BorderRadius.circular(10),
              boxShadow: [
                BoxShadow(color: Colors.black26, blurRadius: 8, spreadRadius: 2),
              ],
            ),
            child: Center(
              child: Text(
                message,
                style: const TextStyle(color: Colors.white, fontSize: 16),
              ),
            ),
          ),
        ),
      ),
    );

    overlay.insert(overlayEntry);

    // Remove toast after a delay
    Future.delayed(const Duration(seconds: 2), () {
      overlayEntry.remove();
    });
  }
}