import 'package:flutter/material.dart';
// import 'package:flutter_webrtc/flutter_webrtc.dart'; // Temporarily disabled
import 'package:google_fonts/google_fonts.dart';
import '../services/call_service.dart';

class CallScreen extends StatefulWidget {
  const CallScreen({super.key, required this.callId, required this.isCaller});
  final String callId;
  final bool isCaller;

  @override
  State<CallScreen> createState() => _CallScreenState();
}

class _CallScreenState extends State<CallScreen> {
  // final RTCVideoRenderer _localRenderer = RTCVideoRenderer(); // Temporarily disabled
  // final RTCVideoRenderer _remoteRenderer = RTCVideoRenderer(); // Temporarily disabled
  final CallService _service = CallService();
  bool _muted = false;

  @override
  void initState() {
    super.initState();
    // _localRenderer.initialize(); // Temporarily disabled
    // _remoteRenderer.initialize(); // Temporarily disabled
    // _attachStreams(); // Temporarily disabled
  }

  Future<void> _attachStreams() async {
    // Temporarily disabled
  }

  @override
  void dispose() {
    // _localRenderer.dispose(); // Temporarily disabled
    // _remoteRenderer.dispose(); // Temporarily disabled
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: Colors.black,
        iconTheme: const IconThemeData(color: Colors.white),
        title: Text('Call', style: GoogleFonts.poppins(color: Colors.white)),
      ),
      body: Stack(
        children: [
          Positioned.fill(
            child: Container(
              color: Colors.grey[900],
              child: Center(
                child: Text(
                  'Call Feature Temporarily Disabled',
                  style: GoogleFonts.poppins(color: Colors.white, fontSize: 18),
                ),
              ),
            ),
          ),
          Align(
            alignment: Alignment.bottomCenter,
            child: Padding(
              padding: const EdgeInsets.only(bottom: 32),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  _circleBtn(
                    color: Colors.white24,
                    icon: Icons.mic_off,
                    onTap: () {
                      // Temporarily disabled
                    },
                  ),
                  const SizedBox(width: 16),
                  _circleBtn(
                    color: Colors.red,
                    icon: Icons.call_end,
                    onTap: () async {
                      await _service.endCall(widget.callId);
                      if (mounted) Navigator.pop(context);
                    },
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _circleBtn({required Color color, required IconData icon, required VoidCallback onTap}) {
    return InkResponse(
      onTap: onTap,
      child: Container(
        width: 64,
        height: 64,
        decoration: BoxDecoration(color: color, shape: BoxShape.circle),
        child: Icon(icon, color: Colors.white),
      ),
    );
  }
}


