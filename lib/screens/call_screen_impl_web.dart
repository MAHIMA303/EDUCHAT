import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class CallScreen extends StatelessWidget {
  const CallScreen({super.key, required this.callId, required this.isCaller});
  final String callId;
  final bool isCaller;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: Colors.black,
        iconTheme: const IconThemeData(color: Colors.white),
        title: Text('Call', style: GoogleFonts.poppins(color: Colors.white)),
      ),
      body: const Center(
        child: Text(
          'Web calling is not available in this build.',
          style: TextStyle(color: Colors.white),
        ),
      ),
    );
  }
}


