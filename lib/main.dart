import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:location/location.dart';
import 'dart:math' as math;
import 'dart:async';
import 'package:problo_techie/activity_page.dart';

void main() {
  runApp(MaterialApp(
    debugShowCheckedModeBanner: false,
    home: GoogleMapsPage(),
  ));
}

class GoogleMapsPage extends StatefulWidget {
  @override
  _GoogleMapsPageState createState() => _GoogleMapsPageState();
}

class _GoogleMapsPageState extends State<GoogleMapsPage> {
  Timer? _updateTimer;
  DateTime? startTime;
  DateTime? endTime;
  bool firstLocationUpdate = true;
  Set<Marker> _markers = {};
  Set<Polyline> _polylines = {};
  bool trackingActive = false;
  GoogleMapController? _mapController;
  LocationData? _currentLocation;
  List<LocationData> _locationHistory = [];
  double _averageSpeed = 0.0;
  double _totalDistance = 0.0;
  int _totalDuration = 0; // in seconds

  final List<String> activityTypes = ['Walking', 'Running', 'Driving'];
  String selectedActivity = 'Walking';
  void updateSpeedometer(double speed) {
    setState(() {
      _currentLocation?.speed!= speed;
    });
  }

  @override
  void initState() {
    super.initState();
    _initLocationService();
  }

  void _initLocationService() async {
    final Location location = Location();
    location.changeSettings(
      accuracy: LocationAccuracy.high,
      interval: 1000, // Update interval in milliseconds
    );

    location.onLocationChanged.listen((LocationData newLocation) {
      // Handle new location updates here
      setState(() {
        _currentLocation = newLocation;
        _locationHistory.add(newLocation);
      });

      // Inside the onLocationChanged listener
      if (_mapController != null) {
        // Add a marker for the current location
        _markers.add(
          Marker(
            markerId: MarkerId('currentLocation'),
            position: LatLng(newLocation.latitude!, newLocation.longitude!),
            infoWindow: InfoWindow(title: 'Current Location'),
          ),
        );

        // Update the map with the new markers
        _mapController!.animateCamera(CameraUpdate.newLatLng(
          LatLng(newLocation.latitude!, newLocation.longitude!),
        ));
        setState(() {});
      }
      // Inside the onLocationChanged listener
      if (_mapController != null) {
        if (_locationHistory.length > 1) {
          LocationData prevLocation =
              _locationHistory[_locationHistory.length - 2];
          LatLng startLatLng =
              LatLng(prevLocation.latitude!, prevLocation.longitude!);
          LatLng endLatLng =
              LatLng(newLocation.latitude!, newLocation.longitude!);

          // Add a new polyline segment to the list
          _polylines.add(
            Polyline(
              polylineId: PolylineId('path_${_locationHistory.length - 2}'),
              points: [startLatLng, endLatLng],
              color: Colors.blue,
              width: 5,
            ),
          );

          // Update the map with the new polylines
          _mapController!.animateCamera(CameraUpdate.newLatLng(endLatLng));
          setState(() {});
          firstLocationUpdate = false;
        }
      }

      // Calculate average speed and total distance
      if (trackingActive) {
        if (_locationHistory.length > 1) {
          LocationData prevLocation =
              _locationHistory[_locationHistory.length - 2];
          double distance = _calculateDistance(prevLocation, newLocation);
          // Calculate time difference
          DateTime prevTime =
              DateTime.fromMillisecondsSinceEpoch(prevLocation.time!.toInt());
          DateTime currentTime =
              DateTime.fromMillisecondsSinceEpoch(newLocation.time!.toInt());
          int durationInSeconds = currentTime.difference(prevTime).inSeconds;

          _totalDistance += distance;
          _totalDuration += durationInSeconds;
        }
        if (_totalDuration > 0) {
          _averageSpeed = (_totalDistance / _totalDuration).toDouble();
        }
        updateSpeedometer(newLocation.speed!);
      }

      // Update Google Map camera position to track the user
      if (_mapController != null) {
        _mapController!.animateCamera(
          CameraUpdate.newLatLng(
            LatLng(newLocation.latitude!, newLocation.longitude!),
          ),
        );
      }
    });

    // Request location permissions
    bool serviceEnabled = await location.serviceEnabled();
    if (!serviceEnabled) {
      serviceEnabled = await location.requestService();
      if (!serviceEnabled) {
        // Handle case where location service is not enabled
      }
    }

    PermissionStatus permissionStatus = await location.hasPermission();
    if (permissionStatus == PermissionStatus.denied) {
      permissionStatus = await location.requestPermission();
      if (permissionStatus != PermissionStatus.granted) {
        // Handle case where location permissions are not granted
      }
    }
  }

  double _calculateDistance(LocationData start, LocationData end) {
    // Calculate distance between two location points (Haversine formula)
    // Replace this calculation with your preferred method/library
    const double radius = 6371; // Earth's radius in kilometers
    double lat1 = start.latitude!;
    double lon1 = start.longitude!;
    double lat2 = end.latitude!;
    double lon2 = end.longitude!;
    double dLat = _toRadians(lat2 - lat1);
    double dLon = _toRadians(lon2 - lon1);

    double a = math.sin(dLat / 2) * math.sin(dLat / 2) +
        math.cos(_toRadians(lat1)) *
            math.cos(_toRadians(lat2)) *
            math.sin(dLon / 2) *
            math.sin(dLon / 2);

    double c = 2 * math.atan2(math.sqrt(a), math.sqrt(1 - a));
    double distance = radius * c;

    return distance;
  }

  double _toRadians(double degrees) {
    return degrees * (math.pi / 180);
  }
  void _startUpdatingSpeedometer() {
    // Create a Timer that updates the speedometer every second
    _updateTimer = Timer.periodic(Duration(seconds: 1), (timer) {
      // Call a function to update the speedometer data
      _updateSpeedometerData();
    });
  }

  void _updateSpeedometerData() {
    // Update the speedometer data inside the AlertDialog
    setState(() {
      // You can update your speedometer data here
    });
  }

  void _stopUpdatingSpeedometer() {
    // Cancel the update timer when the AlertDialog is closed
    _updateTimer?.cancel();
  }
  void _showSpeedometerDialog() {
    showDialog(
      context: context,
      builder: (context) {
        _startUpdatingSpeedometer(); // Start the update timer
        return AlertDialog(
          title: Text('Tracking', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              if (startTime != null)
                Row(
                  children: [
                    Text('Start Time         ${startTime!.hour}:${startTime!.minute}:${startTime!.second}'),
                  ],
                ),
              SizedBox(height: 10,),
              if (endTime != null)
                Row(
                  children: [
                    Text('End Time           ${endTime!.hour}:${endTime!.minute}:${endTime!.second}'),
                  ],
                ),
              SizedBox(height: 10,),
              Divider(
                thickness: 2,
                color: Colors.black,
              ),
              SizedBox(height: 10,),
              Speedometer(speed: _currentLocation?.speed ?? 0.0),
              Text('Speed',style: TextStyle(fontSize: 20),),
              SizedBox(height: 10,),
              Text(
                '${_currentLocation?.speed?.toStringAsFixed(2) ?? '0.0'} m/s',
                style: TextStyle(fontSize: 25, fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 10,),
              ElevatedButton(
                style: ElevatedButton.styleFrom(backgroundColor: Color(0xff9457eb)),
                onPressed: () {
                  _stopUpdatingSpeedometer(); // Stop the update timer when the dialog is closed
                  Navigator.of(context).pop(); // Close the dialog
                },
                child: Text('Stop Tracking'),
              ),
            ],
          ),
        );
      },
    );
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(

      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: <Widget>[
              Container(
                height: 650,
                child: GoogleMap(
                  onMapCreated: (GoogleMapController controller) {
                    _mapController = controller;
                  },
                  initialCameraPosition: CameraPosition(
                    target: LatLng(37.4223, -122.0848),
                    zoom: 15,
                  ),
                  markers: _markers, // Add this line to display markers
                  polylines: _polylines, // Add this line to display polylines
                ),
              ),
              if (trackingActive)
                ElevatedButton(style: ElevatedButton.styleFrom(backgroundColor: Color(0xff9457eb), // Button color
                  minimumSize: Size(double.infinity, 60),),
                  onPressed: () {
                    _showSpeedometerDialog(); // Show the speedometer in an alert dialog
                  },
                  child: Text('Show Tracking', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),),
                ),
              SizedBox(height: 5,),
              ElevatedButton(style: ElevatedButton.styleFrom(backgroundColor: Color(0xff9457eb), // Button color
                minimumSize: Size(double.infinity, 60),),
                // ... (Start/Stop Tracking button)
                onPressed: () {
                  if (trackingActive) {
                    // Stop tracking
                    trackingActive = false;
                    endTime = DateTime.now(); // Record the end time
                    Navigator.of(context).push(
                      MaterialPageRoute(
                        builder: (context) => ActivitySummaryPage(
                          activityType: selectedActivity,
                          speed: _currentLocation?.speed ?? 0.0,
                          duration: _totalDuration,
                          averageSpeed: _averageSpeed,
                          totalDistance: _totalDistance,
                          startTime: startTime,
                          endTime: endTime,
                        ),
                      ),
                    );
                    // Add code to handle the stopping of tracking here
                  } else {
                    // Start tracking
                    trackingActive = true;
                    startTime = DateTime.now(); // Record the start time
                    // Add code to handle the starting of tracking here

                    // Reset the data when tracking starts
                    _totalDuration = 0;
                    _totalDistance = 0;
                    _averageSpeed = 0.0;
                    _locationHistory.clear();
                    _markers.clear();
                    _polylines.clear();
                  }
                  setState(() {});
                },
                child: Text(
                  trackingActive ? 'Stop Tracking' : 'Locate',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
