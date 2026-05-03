import 'dart:async';
import 'dart:math';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class MapPage extends StatefulWidget {
  final List stops;

  const MapPage({super.key, required this.stops});

  @override
  State<MapPage> createState() => _MapPageState();
}

class _MapPageState extends State<MapPage> {
  Set<Marker> markers = {};
  Set<Polyline> polylines = {};
  List<LatLng> points = [];

  List<double> segmentDistances = [];
  double totalKm = 0;

  Timer? timer;

  /// 🖼️ Icons
  BitmapDescriptor? mainStopIcon;
  BitmapDescriptor? stopIcon;
  BitmapDescriptor? busIcon;

  @override
  void initState() {
    super.initState();
    loadIcons();
  }

  @override
  void dispose() {
    timer?.cancel();
    super.dispose();
  }

  /// 🔄 LOAD ICONS
  Future<void> loadIcons() async {
    mainStopIcon = await BitmapDescriptor.fromAssetImage(
      const ImageConfiguration(size: Size(48, 48)),
      'assets/src_des.png',
    );

    stopIcon = await BitmapDescriptor.fromAssetImage(
      const ImageConfiguration(size: Size(48, 48)),
      'assets/busstop.png',
    );

    busIcon = await BitmapDescriptor.fromAssetImage(
      const ImageConfiguration(size: Size(64, 64)),
      'assets/bus.png',
    );

    buildMap();
    startBusTimer();

    setState(() {});
  }

  /// ⏱️ TIMER
  void startBusTimer() {
    timer = Timer.periodic(const Duration(seconds: 3), (_) {
      updateBusPosition();
    });
  }

  /// 📏 DISTANCE (HAVERSINE)
  double calculateDistance(lat1, lon1, lat2, lon2) {
    const R = 6371;
    double dLat = (lat2 - lat1) * pi / 180;
    double dLon = (lon2 - lon1) * pi / 180;

    double a =
        sin(dLat / 2) * sin(dLat / 2) +
        cos(lat1 * pi / 180) *
            cos(lat2 * pi / 180) *
            sin(dLon / 2) *
            sin(dLon / 2);

    return 2 * R * atan2(sqrt(a), sqrt(1 - a));
  }

  /// 🧠 TIME → MINUTES
  int timeToMinutes(String time) {
    final parts = time.split(":");
    return int.parse(parts[0]) * 60 + int.parse(parts[1]);
  }

  /// 📍 INTERPOLATION
  LatLng interpolate(LatLng start, LatLng end, double t) {
    return LatLng(
      start.latitude + (end.latitude - start.latitude) * t,
      start.longitude + (end.longitude - start.longitude) * t,
    );
  }

  /// 🗺️ BUILD MAP
  void buildMap() {
    if (mainStopIcon == null || stopIcon == null) return;

    markers.clear();
    polylines.clear();
    points.clear();
    segmentDistances.clear();
    totalKm = 0;

    for (int i = 0; i < widget.stops.length; i++) {
      final stop = widget.stops[i];

      LatLng pos = LatLng(stop['lat'], stop['lng']);
      points.add(pos);

      /// 🎯 ICON LOGIC
      BitmapDescriptor icon;

      if (i == 0 || i == widget.stops.length - 1) {
        icon = mainStopIcon!;
      } else {
        icon = stopIcon!;
      }

      markers.add(
        Marker(
          markerId: MarkerId(stop['name']),
          position: pos,
          icon: icon,
          infoWindow: InfoWindow(
            title: stop['name'],
            snippet: stop['time'],
          ),
        ),
      );

      /// 📏 DISTANCE
      if (i > 0) {
        double segmentKm = calculateDistance(
          widget.stops[i - 1]['lat'],
          widget.stops[i - 1]['lng'],
          stop['lat'],
          stop['lng'],
        );

        segmentDistances.add(segmentKm);
        totalKm += segmentKm;
      }
    }

    /// 🔵 THIN ROUTE
    polylines.add(
      Polyline(
        polylineId: const PolylineId("route"),
        points: points,
        width: 2,
        color: const Color.fromARGB(255, 0, 140, 255),
      ),
    );
  }

  /// 🚍 BUS MOVEMENT
  void updateBusPosition() {
    if (widget.stops.length < 2 || busIcon == null) return;

    final now = DateTime.now();
    int currentMinutes = now.hour * 60 + now.minute;

    for (int i = 0; i < widget.stops.length - 1; i++) {
      int startTime = timeToMinutes(widget.stops[i]['time']);
      int endTime = timeToMinutes(widget.stops[i + 1]['time']);

      if (currentMinutes >= startTime && currentMinutes <= endTime) {
        double t =
            (currentMinutes - startTime) / (endTime - startTime);

        LatLng start = LatLng(
          widget.stops[i]['lat'],
          widget.stops[i]['lng'],
        );

        LatLng end = LatLng(
          widget.stops[i + 1]['lat'],
          widget.stops[i + 1]['lng'],
        );

        LatLng busPos = interpolate(start, end, t);

        setState(() {
          markers.removeWhere((m) => m.markerId.value == "bus");

          markers.add(
            Marker(
              markerId: const MarkerId("bus"),
              position: busPos,
              icon: busIcon!,
              anchor: const Offset(0.5, 0.5),
              flat: true,
              infoWindow: const InfoWindow(
                title: "Bus",
                snippet: "Running",
              ),
            ),
          );
        });

        break;
      }
    }
  }

  /// 🎯 CENTER MAP
  LatLng getCenter() {
    double lat = 0, lng = 0;

    for (var s in widget.stops) {
      lat += s['lat'];
      lng += s['lng'];
    }

    return LatLng(lat / widget.stops.length, lng / widget.stops.length);
  }

  @override
  Widget build(BuildContext context) {
    if (points.isEmpty) {
      return const Scaffold(
        body: Center(child: Text("No route data")),
      );
    }

    return Scaffold(
      appBar: AppBar(title: const Text("Route Map")),

      body: Stack(
        children: [
          /// 🌍 MAP
          GoogleMap(
            initialCameraPosition: CameraPosition(
              target: getCenter(),
              zoom: 12,
            ),
            markers: markers,
            polylines: polylines,
          ),

          /// 📊 TOTAL DISTANCE
          Positioned(
            top: 20,
            left: 20,
            right: 20,
            child: Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(12),
                boxShadow: const [
                  BoxShadow(color: Colors.black12, blurRadius: 6),
                ],
              ),
              child: Text(
                "Total Distance: ${totalKm.toStringAsFixed(2)} KM",
                textAlign: TextAlign.center,
                style: const TextStyle(fontWeight: FontWeight.bold),
              ),
            ),
          ),

          /// 📋 DISTANCE LIST
         
        ],
      ),
    );
  }
}