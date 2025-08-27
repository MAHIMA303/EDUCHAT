import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:fl_chart/fl_chart.dart';
import '../constants/app_colors.dart';
import '../services/analytics_service.dart';

class AnalyticsScreen extends StatefulWidget {
  const AnalyticsScreen({super.key});

  @override
  State<AnalyticsScreen> createState() => _AnalyticsScreenState();
}

class _AnalyticsScreenState extends State<AnalyticsScreen> {
  final AnalyticsService _analyticsService = AnalyticsService();
  bool _loading = true;
  List<StudentEngagementMetrics> _metrics = [];

  @override
  void initState() {
    super.initState();
    _load();
  }

  Future<void> _load() async {
    setState(() {
      _loading = true;
    });
    final data = await _analyticsService.getClassroomMetrics(teacherId: 't_current');
    if (!mounted) return;
    setState(() {
      _metrics = data;
      _loading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Analytics'),
      ),
      backgroundColor: Theme.of(context).colorScheme.background,
      body: _loading
          ? const Center(child: CircularProgressIndicator())
          : RefreshIndicator(
              onRefresh: _load,
              child: ListView(
                padding: const EdgeInsets.all(16),
                children: [
                  if (_metrics.isEmpty) ...[
                    _buildEmptyOrDemo(),
                    const SizedBox(height: 16),
                  ],

                  _buildSectionTitle('Assignments Submitted per Student'),
                  const SizedBox(height: 12),
                  _buildBarChart(
                    values: _metrics.map((m) => m.assignmentsSubmitted.toDouble()).toList(),
                    labels: _metrics.map((m) => _initials(m.studentName)).toList(),
                    barColor: AppColors.primaryBlue,
                  ),
                  const SizedBox(height: 24),

                  _buildSectionTitle('Messages Sent per Student'),
                  const SizedBox(height: 12),
                  _buildBarChart(
                    values: _metrics.map((m) => m.messagesSent.toDouble()).toList(),
                    labels: _metrics.map((m) => _initials(m.studentName)).toList(),
                    barColor: AppColors.primaryPurple,
                  ),
                  const SizedBox(height: 24),

                  _buildSectionTitle('Points Earned'),
                  const SizedBox(height: 12),
                  _buildLineChart(
                    values: _metrics.map((m) => m.pointsEarned.toDouble()).toList(),
                    labels: _metrics.map((m) => _initials(m.studentName)).toList(),
                    lineColor: AppColors.success,
                  ),
                ],
              ),
            ),
    );
  }

  Widget _buildEmptyOrDemo() {
    // If no data, show demo data in debug; otherwise show empty-state text
    assert(() {
      // In debug mode, seed demo data
      _metrics = [
        StudentEngagementMetrics(studentId: 's1', studentName: 'Alice Brown', assignmentsSubmitted: 5, messagesSent: 18, pointsEarned: 120),
        StudentEngagementMetrics(studentId: 's2', studentName: 'Bob Carter', assignmentsSubmitted: 3, messagesSent: 9, pointsEarned: 90),
        StudentEngagementMetrics(studentId: 's3', studentName: 'Chris Diaz', assignmentsSubmitted: 7, messagesSent: 22, pointsEarned: 160),
        StudentEngagementMetrics(studentId: 's4', studentName: 'Dana Evans', assignmentsSubmitted: 2, messagesSent: 6, pointsEarned: 60),
      ];
      return true;
    }());

    if (_metrics.isEmpty) {
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'No data yet',
            style: GoogleFonts.poppins(fontSize: 16, fontWeight: FontWeight.w600),
          ),
          const SizedBox(height: 8),
          Text(
            'Once students submit assignments, send messages, and earn points, charts will appear here.',
            style: TextStyle(color: Colors.grey[600]),
          ),
        ],
      );
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Demo data shown',
          style: GoogleFonts.poppins(fontSize: 12, fontWeight: FontWeight.w500, color: Colors.grey[500]),
        ),
      ],
    );
  }

  Widget _buildSectionTitle(String title) {
    return Text(
      title,
      style: GoogleFonts.poppins(fontSize: 18, fontWeight: FontWeight.w600),
    );
  }

  String _initials(String name) {
    final parts = name.trim().split(' ');
    if (parts.isEmpty) return '?';
    if (parts.length == 1) return parts.first.substring(0, 1).toUpperCase();
    return (parts[0].substring(0, 1) + parts[1].substring(0, 1)).toUpperCase();
  }

  Widget _buildBarChart({required List<double> values, required List<String> labels, required Color barColor}) {
    final spots = values.asMap().entries.map((e) => BarChartRodData(toY: e.value, color: barColor)).toList();
    return AspectRatio(
      aspectRatio: 1.6,
      child: BarChart(
        BarChartData(
          titlesData: FlTitlesData(
            leftTitles: const AxisTitles(sideTitles: SideTitles(showTitles: true, reservedSize: 32)),
            rightTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
            topTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
            bottomTitles: AxisTitles(
              sideTitles: SideTitles(
                showTitles: true,
                getTitlesWidget: (value, meta) {
                  final idx = value.toInt();
                  if (idx < 0 || idx >= labels.length) return const SizedBox.shrink();
                  return Padding(
                    padding: const EdgeInsets.only(top: 4),
                    child: Text(labels[idx], style: const TextStyle(fontSize: 10)),
                  );
                },
              ),
            ),
          ),
          gridData: const FlGridData(show: true),
          borderData: FlBorderData(show: false),
          barGroups: values
              .asMap()
              .entries
              .map((e) => BarChartGroupData(x: e.key, barRods: [BarChartRodData(toY: e.value, color: barColor)]))
              .toList(),
        ),
      ),
    );
  }

  Widget _buildLineChart({required List<double> values, required List<String> labels, required Color lineColor}) {
    return AspectRatio(
      aspectRatio: 1.6,
      child: LineChart(
        LineChartData(
          titlesData: FlTitlesData(
            leftTitles: const AxisTitles(sideTitles: SideTitles(showTitles: true, reservedSize: 32)),
            rightTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
            topTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
            bottomTitles: AxisTitles(
              sideTitles: SideTitles(
                showTitles: true,
                getTitlesWidget: (value, meta) {
                  final idx = value.toInt();
                  if (idx < 0 || idx >= labels.length) return const SizedBox.shrink();
                  return Padding(
                    padding: const EdgeInsets.only(top: 4),
                    child: Text(labels[idx], style: const TextStyle(fontSize: 10)),
                  );
                },
              ),
            ),
          ),
          gridData: const FlGridData(show: true),
          borderData: FlBorderData(show: false),
          lineBarsData: [
            LineChartBarData(
              isCurved: true,
              spots: values.asMap().entries.map((e) => FlSpot(e.key.toDouble(), e.value)).toList(),
              color: lineColor,
              barWidth: 3,
              dotData: const FlDotData(show: false),
            ),
          ],
        ),
      ),
    );
  }
}


