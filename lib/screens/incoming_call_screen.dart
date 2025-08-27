import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../services/call_service.dart';
import 'call_screen.dart';

class IncomingCallScreen extends StatelessWidget {
  const IncomingCallScreen({super.key, required this.callId, required this.callerName});
  final String callId;
  final String callerName;

  @override
  Widget build(BuildContext context) {
    final service = CallService();
    return Scaffold(
      backgroundColor: Colors.black,
      body: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text('Incoming call', style: GoogleFonts.poppins(color: Colors.white70, fontSize: 16)),
            const SizedBox(height: 8),
            Text(callerName, style: GoogleFonts.poppins(color: Colors.white, fontSize: 24, fontWeight: FontWeight.bold)),
            const SizedBox(height: 24),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                _btn(color: Colors.red, icon: Icons.call_end, onTap: () => Navigator.pop(context)),
                const SizedBox(width: 24),
                _btn(
                  color: Colors.green,
                  icon: Icons.call,
                  onTap: () async {
                    final session = await service.answerCall(callId: callId);
                    if (context.mounted && session != null) {
                      Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(
                          builder: (_) => CallScreen(callId: session.callId, isCaller: false),
                        ),
                      );
                    }
                  },
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _btn({required Color color, required IconData icon, required VoidCallback onTap}) {
    return InkResponse(
      onTap: onTap,
      child: Container(
        width: 72,
        height: 72,
        decoration: BoxDecoration(color: color, shape: BoxShape.circle),
        child: Icon(icon, color: Colors.white, size: 28),
      ),
    );
  }
}


