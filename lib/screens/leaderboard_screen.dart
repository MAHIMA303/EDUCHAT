import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../services/points_service.dart';

class LeaderboardScreen extends StatelessWidget {
  const LeaderboardScreen({super.key, this.currentUserId = 'u_current'});

  final String currentUserId;

  @override
  Widget build(BuildContext context) {
    final service = PointsService();
    return Scaffold(
      backgroundColor: Colors.grey[50],
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        title: Text(
          'Leaderboard',
          style: GoogleFonts.poppins(
            fontSize: 24,
            fontWeight: FontWeight.bold,
            color: const Color(0xFF4B6CB7),
          ),
        ),
      ),
      body: StreamBuilder<List<UserPoints>>(
        stream: service.leaderboardStream(limit: 100),
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return const Center(child: CircularProgressIndicator());
          }
          final users = snapshot.data!;
          if (users.isEmpty) {
            return Center(
              child: Padding(
                padding: const EdgeInsets.all(24),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(Icons.leaderboard, size: 48, color: const Color(0xFF4B6CB7).withOpacity(0.4)),
                    const SizedBox(height: 12),
                    Text('Leaderboard unavailable in web demo or no scores yet.',
                        textAlign: TextAlign.center, style: GoogleFonts.inter(color: Colors.grey[600])),
                  ],
                ),
              ),
            );
          }
          return ListView.builder(
            padding: const EdgeInsets.all(16),
            itemCount: users.length,
            itemBuilder: (context, index) {
              final up = users[index];
              final rank = index + 1;
              final isYou = up.userId == currentUserId;
              return Container(
                margin: const EdgeInsets.only(bottom: 12),
                decoration: BoxDecoration(
                  color: isYou ? const Color(0xFF4B6CB7).withOpacity(0.08) : Colors.white,
                  borderRadius: BorderRadius.circular(12),
                  boxShadow: [
                    BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 10, offset: const Offset(0, 2)),
                  ],
                ),
                child: ListTile(
                  leading: CircleAvatar(
                    backgroundColor: rank == 1
                        ? const Color(0xFFFFD700)
                        : rank == 2
                            ? const Color(0xFFC0C0C0)
                            : rank == 3
                                ? const Color(0xFFCD7F32)
                                : const Color(0xFF4B6CB7).withOpacity(0.15),
                    child: Text('$rank', style: GoogleFonts.poppins(color: Colors.black, fontWeight: FontWeight.bold)),
                  ),
                  title: Text(
                    isYou ? '${up.username} (You)' : up.username,
                    style: GoogleFonts.poppins(fontWeight: FontWeight.w600),
                  ),
                  trailing: Text(
                    '${up.points} pts',
                    style: GoogleFonts.inter(fontWeight: FontWeight.w600, color: const Color(0xFF4B6CB7)),
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }
}


