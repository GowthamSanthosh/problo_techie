import 'package:flutter/material.dart';
class Speedometer extends StatelessWidget {
  final double speed;

  Speedometer({required this.speed});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Container(
        width: 200,
        height: 200,
        child: Stack(
          children: [
            // Outer circle (Speedometer background)
            Container(
              width: 200,
              height: 200,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: Colors.grey,
              ),
            ),
            // Colored arc to represent the speed
            CustomPaint(
              size: Size(200, 200),
              painter: SpeedometerPainter(speed),
            ),
            // Current speed text
            Center(
              child: Text(
                speed.toStringAsFixed(1),
                style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class SpeedometerPainter extends CustomPainter {
  final double speed;

  SpeedometerPainter(this.speed);

  @override
  void paint(Canvas canvas, Size size) {
    final double strokeWidth = 20;
    final Paint paint = Paint()
      ..color = Colors.blue
      ..style = PaintingStyle.stroke
      ..strokeWidth = strokeWidth;

    final double center = size.width / 2;
    final double radius = center - strokeWidth / 2;

    final startAngle = -3.14 / 4;
    final sweepAngle = 3.14 / 2 * (speed / 100); // Assuming speed ranges from 0 to 100

    canvas.drawArc(
      Rect.fromCircle(center: Offset(center, center), radius: radius),
      startAngle,
      sweepAngle,
      false,
      paint,
    );
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return false;
  }
}

class ActivitySummaryPage extends StatefulWidget {
  final String activityType;
  final double speed;
  final int duration;
  final double averageSpeed;
  final double totalDistance;
  final DateTime? startTime;
  final DateTime? endTime;

  ActivitySummaryPage({
    required this.activityType,
    required this.speed,
    required this.duration,
    required this.averageSpeed,
    required this.totalDistance,
    this.startTime,   // Initialize startTime as an optional parameter
    this.endTime,
  });

  @override
  _ActivitySummaryPageState createState() => _ActivitySummaryPageState();
}

class _ActivitySummaryPageState extends State<ActivitySummaryPage> {

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Color(0xff9457eb),
        title: Text('Data Location'),
      ),
      body: SingleChildScrollView(
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Card(
                elevation: 20,
                margin: EdgeInsets.all(16),
                child: Container(
                  width: 340, // Set the desired width
                  height: 105, // Set the desired height
                  child: Padding(
                    padding: EdgeInsets.all(16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Center(
                          child: Text(
                            'Activity Type',
                            style: TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                        SizedBox(height: 5 ,),
                        Divider(
                          thickness: 2,
                          color: Colors.redAccent,
                        ),
                        SizedBox(height: 5 ,),
                        Center(
                          child: Text(
                            widget.activityType,
                            style: TextStyle(fontSize: 18),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Row(
                  children: [
                    Card(
                      color: Color(0xffd4f0f7),
                      elevation: 20,
                      margin: EdgeInsets.all(16),
                      child: Container(
                        width: 140, // Set the desired width
                        height: 200, // Set the desired height
                        child: Padding(
                          padding: EdgeInsets.all(16),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Center(
                                child: Text(
                                  'Avg Speed',
                                  style: TextStyle(
                                    fontSize: 18,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                              SizedBox(height: 40 ,),
                              Divider(
                                thickness: 2,
                                color: Colors.green,
                              ),
                              SizedBox(height: 40 ,),
                              Center(
                                child: Text(
                                  '${widget.averageSpeed.toStringAsFixed(2)} m/s',
                                  style: TextStyle(fontSize: 25,fontWeight: FontWeight.bold),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),

                    Card(
                      color: Color(0xfff6dae4),
                      elevation: 20,
                      margin: EdgeInsets.all(16),
                      child: Container(
                        width: 140, // Set the desired width
                        height: 200, // Set the desired height
                        child: Padding(
                          padding: EdgeInsets.all(16),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Center(
                                child: Text(
                                  'Total Distance',
                                  style: TextStyle(
                                    fontSize: 18,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                              SizedBox(height: 40 ,),
                              Divider(
                                thickness: 2,
                                color: Color(0xffff9999),
                              ),
                              SizedBox(height: 40 ,),
                              Center(
                                child: Text(
                                  '${widget.totalDistance.toStringAsFixed(2)} km',
                                  style: TextStyle(fontSize:25,fontWeight: FontWeight.bold),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),

                  ],
                ),

              ),
              Column(
                children: [
                  Card(
                    elevation: 20,
                    margin: EdgeInsets.all(16),
                    child: Container(
                      width: 340, // Set the desired width
                      height: 100, // Set the desired height
                      child: Padding(
                        padding: EdgeInsets.all(16),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Center(
                              child: Text(
                                'Duration',
                                style: TextStyle(
                                  fontSize: 20,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                            SizedBox(height: 5  ,),
                            Center(
                              child: Text(
                                '${(widget.duration / 60).toStringAsFixed(2)} minutes',
                                style: TextStyle(fontSize: 18),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              Column(
                children: [
                  Card(
                    elevation: 20,
                    margin: EdgeInsets.all(16),
                    child: Container(
                      width: 340, // Set the desired width
                      height: 100, // Set the desired height
                      child: Padding(
                        padding: EdgeInsets.all(16),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Center(
                              child: Text(
                                'Speed',
                                style: TextStyle(
                                  fontSize: 20,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                            SizedBox(height: 5  ,),
                            Center(
                              child: Text(
                                '${widget.speed.toStringAsFixed(2)} m/s',
                                style: TextStyle(fontSize: 18),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ],
              )
            ],
          ),
        ),
      ),
    );
  }
}