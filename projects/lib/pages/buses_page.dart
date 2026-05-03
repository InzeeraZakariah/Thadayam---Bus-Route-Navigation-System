import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'timeline_page.dart';

class BusesPage extends StatelessWidget {
  final String source;
  final String destination;
  final String routeId;
  final List buses;

  const BusesPage({
    super.key,
    required this.source,
    required this.destination,
    required this.routeId,
    required this.buses,
  });

  Future<List<Map<String, dynamic>>> getBuses() async {
    final schedulesSnap =
    await FirebaseFirestore.instance.collection('Schedules').get();

    final stopsSnap =
    await FirebaseFirestore.instance.collection('busStops').get();

    Map<String, dynamic> stopMap = {
      for (var doc in stopsSnap.docs) doc.id: doc.data()
    };

    List<Map<String, dynamic>> result = [];

    for (var doc in schedulesSnap.docs) {
      if (doc['route_id'] != routeId) continue;
      if (!buses.contains(doc['bus_id'])) continue;

      List schedStops = doc['stops'];

      List names =
      schedStops.map((s) => stopMap[s['stop_id']]['name']).toList();

      int sIndex = names.indexOf(source);
      int dIndex = names.indexOf(destination);

      if (sIndex == -1 || dIndex == -1 || sIndex >= dIndex) continue;

      List filteredStops = [];

      for (int i = sIndex; i <= dIndex; i++) {
        var stopId = schedStops[i]['stop_id'];
        var geo = stopMap[stopId]['location'];

        filteredStops.add({
          "name": stopMap[stopId]['name'],
          "time": schedStops[i]['time'],
          "lat": geo.latitude,
          "lng": geo.longitude,
        });
      }

      result.add({
        "busId": doc['bus_id'],
        "stops": filteredStops,
      });
    }

    return result;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF6F7FB),

      appBar: AppBar(
        title: const Text("Available Buses"),
        backgroundColor: Colors.white,
        foregroundColor: Colors.black,
        elevation: 0,
      ),

      body: FutureBuilder(
        future: getBuses(),
        builder: (_, snapshot) {

          if (!snapshot.hasData) {
            return const Center(child: CircularProgressIndicator());
          }

          final busesList = snapshot.data!;

          return ListView.builder(
            padding: const EdgeInsets.all(20),
            itemCount: busesList.length,
            itemBuilder: (_, i) {

              final bus = busesList[i];

              return InkWell(
                borderRadius: BorderRadius.circular(20),

                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => TimelinePage(
                        busId: bus['busId'],
                        stops: bus['stops'],
                      ),
                    ),
                  );
                },

                child: Container(
                  margin: const EdgeInsets.only(bottom: 15),
                  padding: const EdgeInsets.all(18),

                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(20),

                    boxShadow: [
                      BoxShadow(
                        blurRadius: 10,
                        color: Colors.grey.withOpacity(0.15),
                        offset: const Offset(0, 5),
                      )
                    ],
                  ),

                  child: Row(
                    children: [

                      /// bus icon circle
                      Container(
                        padding: const EdgeInsets.all(12),
                        decoration: BoxDecoration(
                          color: Colors.blue.withOpacity(0.1),
                          shape: BoxShape.circle,
                        ),
                        child: const Icon(
                          Icons.directions_bus,
                          color: Colors.blue,
                        ),
                      ),

                      const SizedBox(width: 15),

                      /// bus details
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [

                            Text(
                              "Bus ${bus['busId']}",
                              style: const TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                              ),
                            ),

                            const SizedBox(height: 4),

                            Text(
                              "Tap to view route timeline",
                              style: TextStyle(
                                color: Colors.grey[600],
                              ),
                            ),
                          ],
                        ),
                      ),

                      const Icon(
                        Icons.arrow_forward_ios,
                        size: 18,
                        color: Colors.grey,
                      ),
                    ],
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