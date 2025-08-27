import 'package:flutter/material.dart';
import '../services/offline_service.dart';

class OfflineBanner extends StatelessWidget {
  const OfflineBanner({super.key});

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<bool>(
      valueListenable: OfflineService.instance.isOffline,
      builder: (context, offline, _) {
        if (!offline) return const SizedBox.shrink();
        return Container(
          width: double.infinity,
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
          color: Colors.amber.shade800,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: const [
              Icon(Icons.wifi_off, size: 16, color: Colors.white),
              SizedBox(width: 8),
              Text('Offline – changes will sync when you are back online', style: TextStyle(color: Colors.white)),
            ],
          ),
        );
      },
    );
  }
}


