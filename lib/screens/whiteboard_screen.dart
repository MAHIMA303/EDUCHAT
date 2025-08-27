import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:uuid/uuid.dart';
import '../services/whiteboard_service.dart';
import '../constants/app_colors.dart';

class WhiteboardScreen extends StatefulWidget {
  final String whiteboardId;
  final String title;

  const WhiteboardScreen({
    super.key,
    required this.whiteboardId,
    required this.title,
  });

  @override
  State<WhiteboardScreen> createState() => _WhiteboardScreenState();
}

class _WhiteboardScreenState extends State<WhiteboardScreen> {
  final WhiteboardService _whiteboardService = WhiteboardService();
  final List<DrawingStroke> _strokes = [];
  final List<DrawingPoint> _currentStroke = [];
  final String _currentUserId = 'u_current';
  final String _currentUserName = 'You';
  
  Color _selectedColor = Colors.black;
  double _strokeWidth = 2.0;
  bool _isDrawing = false;

  final List<Color> _colorPalette = [
    Colors.black,
    Colors.red,
    Colors.blue,
    Colors.green,
    Colors.yellow,
    Colors.purple,
    Colors.orange,
    Colors.pink,
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
        backgroundColor: AppColors.primary,
        foregroundColor: Colors.white,
        actions: [
          IconButton(
            icon: const Icon(Icons.clear),
            onPressed: _clearWhiteboard,
            tooltip: 'Clear Whiteboard',
          ),
          IconButton(
            icon: const Icon(Icons.save),
            onPressed: _saveWhiteboard,
            tooltip: 'Save Whiteboard',
          ),
        ],
      ),
      body: Column(
        children: [
          // Color and stroke width selector
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.white,
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.1),
                  blurRadius: 4,
                  offset: const Offset(0, 2),
                ),
              ],
            ),
            child: Row(
              children: [
                // Color palette
                Expanded(
                  child: Wrap(
                    spacing: 8,
                    children: _colorPalette.map((color) {
                      final isSelected = _selectedColor == color;
                      return GestureDetector(
                        onTap: () => setState(() => _selectedColor = color),
                        child: Container(
                          width: 32,
                          height: 32,
                          decoration: BoxDecoration(
                            color: color,
                            shape: BoxShape.circle,
                            border: Border.all(
                              color: isSelected ? Colors.black : Colors.grey,
                              width: isSelected ? 3 : 1,
                            ),
                          ),
                        ),
                      );
                    }).toList(),
                  ),
                ),
                const SizedBox(width: 16),
                // Stroke width slider
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Stroke Width',
                        style: GoogleFonts.inter(fontSize: 12, fontWeight: FontWeight.w500),
                      ),
                      Slider(
                        value: _strokeWidth,
                        min: 1.0,
                        max: 10.0,
                        divisions: 9,
                        onChanged: (value) => setState(() => _strokeWidth = value),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          // Drawing canvas
          Expanded(
            child: StreamBuilder<List<DrawingStroke>>(
              stream: _whiteboardService.getWhiteboardStream(widget.whiteboardId),
              builder: (context, snapshot) {
                if (snapshot.hasData) {
                  _strokes.clear();
                  _strokes.addAll(snapshot.data!);
                }
                
                return GestureDetector(
                  onPanStart: _onPanStart,
                  onPanUpdate: _onPanUpdate,
                  onPanEnd: _onPanEnd,
                  child: Container(
                    color: Colors.white,
                    child: CustomPaint(
                      painter: WhiteboardPainter(_strokes, _currentStroke),
                      size: Size.infinite,
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  void _onPanStart(DragStartDetails details) {
    setState(() {
      _isDrawing = true;
      _currentStroke.clear();
      _currentStroke.add(DrawingPoint(
        x: details.localPosition.dx,
        y: details.localPosition.dy,
        pressure: 1.0,
        color: _selectedColor,
        strokeWidth: _strokeWidth,
      ));
    });
  }

  void _onPanUpdate(DragUpdateDetails details) {
    if (!_isDrawing) return;
    
    setState(() {
      _currentStroke.add(DrawingPoint(
        x: details.localPosition.dx,
        y: details.localPosition.dy,
        pressure: 1.0,
        color: _selectedColor,
        strokeWidth: _strokeWidth,
      ));
    });
  }

  void _onPanEnd(DragEndDetails details) {
    if (!_isDrawing || _currentStroke.isEmpty) return;
    
    setState(() {
      _isDrawing = false;
    });

    // Create and save the stroke
    final stroke = DrawingStroke(
      id: const Uuid().v4(),
      userId: _currentUserId,
      userName: _currentUserName,
      points: List.from(_currentStroke),
      timestamp: DateTime.now(),
      color: _selectedColor,
    );

    _whiteboardService.addStroke(widget.whiteboardId, stroke);
    _currentStroke.clear();
  }

  void _clearWhiteboard() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Clear Whiteboard'),
        content: const Text('Are you sure you want to clear the whiteboard? This action cannot be undone.'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
              _whiteboardService.clearWhiteboard(widget.whiteboardId);
            },
            style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
            child: const Text('Clear'),
          ),
        ],
      ),
    );
  }

  void _saveWhiteboard() {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Whiteboard saved successfully!'),
        backgroundColor: AppColors.success,
      ),
    );
  }
}

class WhiteboardPainter extends CustomPainter {
  final List<DrawingStroke> strokes;
  final List<DrawingPoint> currentStroke;

  WhiteboardPainter(this.strokes, this.currentStroke);

  @override
  void paint(Canvas canvas, Size size) {
    // Draw all completed strokes
    for (final stroke in strokes) {
      _drawStroke(canvas, stroke.points, stroke.color);
    }
    
    // Draw current stroke
    if (currentStroke.isNotEmpty) {
      _drawStroke(canvas, currentStroke, currentStroke.first.color);
    }
  }

  void _drawStroke(Canvas canvas, List<DrawingPoint> points, Color color) {
    if (points.length < 2) return;

    final paint = Paint()
      ..color = color
      ..strokeWidth = points.first.strokeWidth
      ..strokeCap = StrokeCap.round
      ..strokeJoin = StrokeJoin.round
      ..style = PaintingStyle.stroke;

    final path = Path();
    path.moveTo(points.first.x, points.first.y);
    
    for (int i = 1; i < points.length; i++) {
      path.lineTo(points[i].x, points[i].y);
    }
    
    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => true;
}
