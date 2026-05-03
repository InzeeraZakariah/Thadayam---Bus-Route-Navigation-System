import 'package:flutter/material.dart';
import 'map_page.dart';

class TimelinePage extends StatelessWidget {
  final String busId;
  final List stops;

  const TimelinePage({
    super.key,
    required this.busId,
    required this.stops,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF6F7FB),

      appBar: AppBar(
        title: Text("Bus $busId"),
        backgroundColor: Colors.white,
        foregroundColor: Colors.black,
        elevation: 0,
      ),

      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.blue,
        child: const Icon(Icons.map),
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (_) => MapPage(stops: stops),
            ),
          );
        },
      ),

      body: ListView.builder(
        padding: const EdgeInsets.all(20),
        itemCount: stops.length,
        itemBuilder: (_, i) {
          final stop = stops[i];

          return Container(
            margin: const EdgeInsets.only(bottom: 12),
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

                /// timeline dot
                Column(
                  children: [
                    Container(
                      width: 12,
                      height: 12,
                      decoration: const BoxDecoration(
                        color: Colors.blue,
                        shape: BoxShape.circle,
                      ),
                    ),
                    if (i != stops.length - 1)
                      Container(
                        width: 2,
                        height: 30,
                        color: Colors.blue.withOpacity(0.4),
                      )
                  ],
                ),

                const SizedBox(width: 15),

                /// stop name
                Expanded(
                  child: Text(
                    stop['name'],
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),

                /// stop time
                Text(
                  stop['time'],
                  style: TextStyle(
                    color: Colors.grey[700],
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}