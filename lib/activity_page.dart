import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_gauges/gauges.dart'; // Import the flutter_gauges package

class Speedometer extends StatelessWidget {
  final double speed;

  Speedometer({required this.speed});

  @override
  Widget build(BuildContext context) {
    return SfRadialGauge(axes: <RadialAxis>[
      RadialAxis(minimum: 0, maximum: 150, ranges: <GaugeRange>[
        GaugeRange(startValue: 0, endValue: 50, color: Colors.blueGrey),
        GaugeRange(startValue: 50, endValue: 100, color: Colors.blue),
        GaugeRange(startValue: 100, endValue: 150, color: Colors.blueAccent)
      ], pointers: <GaugePointer>[
        NeedlePointer(value: speed)
      ], annotations: <GaugeAnnotation>[
        GaugeAnnotation(
            widget: Container(child: Text('')),
            angle: speed,
            positionFactor: speed)
      ])
    ]);
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
    this.startTime, // Initialize startTime as an optional parameter
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
                  height: 250, // Set the desired height
                  child: Padding(
                    padding: EdgeInsets.all(16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Center(
                          child: Container(
                    child: SfLinearGauge(
                      ranges: [
                      LinearGaugeRange(
                      startValue: 35,
                      endValue: 35,
                    ),
                      ],
                  markerPointers: [
                  LinearShapePointer(
                  value: 35,
                  ),
                    ],
                    barPointers: [LinearBarPointer(value: 100,color: Colors.red,thickness: 10,),],
          ),
                        ),
                        ),
                      SizedBox(
                        height: 10,
                      ),
                      Row(children: [
                        Text('  28 bpm',style: TextStyle(fontSize: 15,fontWeight: FontWeight.bold),),
                        SizedBox(width: 180,),
                        Text('  58 bpm',style: TextStyle(fontSize: 15,fontWeight: FontWeight.bold),)
                      ],),
                        Row(children: [
                          Text('  min',style: TextStyle(fontSize: 15,),),
                          SizedBox(width: 210,),
                          Text('max',style: TextStyle(fontSize: 15,),)
                        ],),
                        Row(children: [
                         Container(
                           height:125,
                             width: 100,
                             child: Image.network('https://static.vecteezy.com/system/resources/previews/000/599/773/non_2x/heart-beat-wave-logo-line-vector.jpg',fit: BoxFit.cover,)),
                          SizedBox(width: 10,),
                          Text('35',style: TextStyle(fontSize: 60,fontWeight: FontWeight.bold),),
                          SizedBox(width: 5,),
                          Text('bpm',style: TextStyle(fontSize: 60,color: Colors.grey),)
                        ],),
                      ]
                    ),
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(2.0),
                child: Row(
                  children: [
                    Center(
                      child: Card(
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
                                SizedBox(
                                  height: 40,
                                ),
                                Divider(
                                  thickness: 2,
                                  color: Colors.green,
                                ),
                                SizedBox(
                                  height: 40,
                                ),
                                Center(
                                  child: Text(
                                    '${widget.averageSpeed.toStringAsFixed(2)} m/s',
                                    style: TextStyle(
                                        fontSize: 25,
                                        fontWeight: FontWeight.bold),
                                  ),
                                ),
                              ],
                            ),
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
                              SizedBox(
                                height: 40,
                              ),
                              Divider(
                                thickness: 2,
                                color: Color(0xffff9999),
                              ),
                              SizedBox(
                                height: 40,
                              ),
                              Center(
                                child: Text(
                                  '${widget.totalDistance.toStringAsFixed(2)} km',
                                  style: TextStyle(
                                      fontSize: 25,
                                      fontWeight: FontWeight.bold),
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
                            SizedBox(
                              height: 5,
                            ),
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
                            SizedBox(
                              height: 5,
                            ),
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
