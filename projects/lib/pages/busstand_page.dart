import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'buses_page.dart';

class BusStandPage extends StatefulWidget {
  final String source;
  final String destination;

  const BusStandPage({
    super.key,
    required this.source,
    required this.destination,
  });

  @override
  State<BusStandPage> createState() => _BusStandPageState();
}

class _BusStandPageState extends State<BusStandPage> {
  List<Map<String, dynamic>> result = [];

  @override
  void initState() {
    super.initState();
    loadData();
  }

  Future<void> loadData() async {
    final routesSnap =
        await FirebaseFirestore.instance.collection('Routes').get();

    final stopsSnap =
        await FirebaseFirestore.instance.collection('busStops').get();

    final schedulesSnap =
        await FirebaseFirestore.instance.collection('Schedules').get();

    Map<String, dynamic> stopMap = {
      for (var doc in stopsSnap.docs) doc.id: doc.data()
    };

    Map<String, Map<String, dynamic>> standMap = {};

    for (var route in routesSnap.docs) {
      List routeStops = route['stops'];

      String? sourceId;
      String? destId;

      /// 🔍 Find IDs
      for (var id in routeStops) {
        if (stopMap[id]['name'] == widget.source) sourceId = id;
        if (stopMap[id]['name'] == widget.destination) destId = id;
      }

      if (sourceId == null || destId == null) continue;

      int sIndex = routeStops.indexOf(sourceId);
      int dIndex = routeStops.indexOf(destId);

      String? standId;

      /// 🔥 FIND NEAREST STAND
      if (sIndex < dIndex) {
        /// forward → before source
        for (int i = sIndex; i >= 0; i--) {
          if (stopMap[routeStops[i]]['is_busstand'] == true) {
            standId = routeStops[i];
            break;
          }
        }
      } else {
        /// reverse → after source
        for (int i = sIndex; i < routeStops.length; i++) {
          if (stopMap[routeStops[i]]['is_busstand'] == true) {
            standId = routeStops[i];
            break;
          }
        }
      }

      if (standId == null) continue;

      /// 🔍 FIND BUSES FROM STAND → DEST
      for (var sched in schedulesSnap.docs) {
        if (sched['route_id'] != route.id) continue;

        String busId = sched['bus_id'];
        List stops = sched['stops'];

        List names =
            stops.map((s) => stopMap[s['stop_id']]['name']).toList();

        int si = names.indexOf(stopMap[standId]['name']);
        int di = names.indexOf(widget.destination);

        if (si == -1 || di == -1 || si >= di) continue;

        /// 🔥 GROUPING
        if (!standMap.containsKey(standId)) {
          standMap[standId] = {
            "id": standId,
            "name": stopMap[standId]['name'],
            "route_id": route.id,
            "buses": <String>[],
          };
        }

        if (!standMap[standId]!['buses'].contains(busId)) {
          standMap[standId]!['buses'].add(busId);
        }
      }
    }

    setState(() {
      result = standMap.values.toList();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Select Bus Stand')),

      body: result.isEmpty
          ? const Center(child: Text("No routes found"))
          : ListView.builder(
              padding: const EdgeInsets.all(16),
              itemCount: result.length,
              itemBuilder: (_, i) {
                final stand = result[i];

                return GestureDetector(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => BusesPage(
                          source: widget.source,
                          destination: widget.destination,
                          routeId: stand['route_id'],
                          buses: stand['buses'],
                        ),
                      ),
                    );
                  },

                  child: Container(
                    margin: const EdgeInsets.only(bottom: 14),
                    padding: const EdgeInsets.all(18),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(18),
                      boxShadow: const [
                        BoxShadow(
                          color: Colors.black12,
                          blurRadius: 8,
                          offset: Offset(0, 4),
                        )
                      ],
                    ),

                    child: Row(
                      children: [
                        /// ICON
                        Container(
                          padding: const EdgeInsets.all(12),
                          decoration: BoxDecoration(
                            color: Colors.blue.shade50,
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: const Icon(
                            Icons.location_city,
                            color: Colors.blue,
                          ),
                        ),

                        const SizedBox(width: 14),

                        /// TEXT
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                stand['name'],
                                style: const TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 16,
                                ),
                              ),

                              const SizedBox(height: 6),

                              Text(
                                "${stand['buses'].length} buses available",
                                style: const TextStyle(color: Colors.grey),
                              ),

                              const SizedBox(height: 6),

                              /// BUS LIST
                              Wrap(
                                spacing: 6,
                                children: stand['buses']
                                    .map<Widget>((b) => Chip(
                                          label: Text(b),
                                        ))
                                    .toList(),
                              ),
                            ],
                          ),
                        ),

                        const Icon(Icons.arrow_forward_ios, size: 14),
                      ],
                    ),
                  ),
                );
              },
            ),
    );
  }
}