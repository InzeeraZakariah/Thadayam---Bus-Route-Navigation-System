import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'busstand_page.dart';

class SearchPage extends StatefulWidget {
  const SearchPage({super.key});

  @override
  State<SearchPage> createState() => _SearchPageState();
}

class _SearchPageState extends State<SearchPage> {

  final TextEditingController sourceController = TextEditingController();
  final TextEditingController destController = TextEditingController();

  List<String> stopsList = [];

  @override
  void initState() {
    super.initState();
    fetchStops();
  }

  Future<void> fetchStops() async {
    final snapshot =
    await FirebaseFirestore.instance.collection('busStops').get();

    stopsList =
        snapshot.docs.map((doc) => doc['name'].toString()).toList();

    setState(() {});
  }

  Widget autoField({
    required TextEditingController controller,
    required String hint,
    required IconData icon,
  }) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 15),
      decoration: BoxDecoration(
        color: const Color(0xFFF2F4F7),
        borderRadius: BorderRadius.circular(15),
      ),
      child: Autocomplete<String>(
        optionsBuilder: (value) {
          if (value.text.isEmpty) return [];
          return stopsList.where((s) =>
              s.toLowerCase().contains(value.text.toLowerCase()));
        },
        onSelected: (val) => controller.text = val,
        fieldViewBuilder: (context, textCtrl, focusNode, _) {
          return TextField(
            controller: textCtrl,
            focusNode: focusNode,
            decoration: InputDecoration(
              icon: Icon(icon, color: Colors.grey),
              hintText: hint,
              border: InputBorder.none,
            ),
          );
        },
      ),
    );
  }

  void search() {
    if (sourceController.text.isEmpty ||
        destController.text.isEmpty) return;

    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => BusStandPage(
          source: sourceController.text,
          destination: destController.text,
        ),
      ),
    );
  }

  Widget recentItem(String text) {
    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      padding: const EdgeInsets.all(15),
      decoration: BoxDecoration(
        color: Colors.grey.shade200,
        borderRadius: BorderRadius.circular(15),
      ),
      child: Row(
        children: [
          const Icon(Icons.history, color: Colors.grey),
          const SizedBox(width: 10),
          Text(text)
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(

      appBar: AppBar(
        title: const Text("Search Buses"),
        backgroundColor: Colors.white,
        foregroundColor: Colors.black,
        elevation: 0,
      ),

      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [

            /// Search Card
            Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(25),
                boxShadow: [
                  BoxShadow(
                    blurRadius: 10,
                    color: Colors.grey.withOpacity(0.2),
                    offset: const Offset(0, 5),
                  )
                ],
              ),
              child: Column(
                children: [

                  autoField(
                    controller: sourceController,
                    hint: "Current Location",
                    icon: Icons.gps_fixed,
                  ),

                  const SizedBox(height: 15),

                  autoField(
                    controller: destController,
                    hint: "Where to?",
                    icon: Icons.location_on,
                  ),

                  const SizedBox(height: 20),

                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: search,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.blue,
                        padding: const EdgeInsets.all(15),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(15),
                        ),
                      ),
                      child: const Text(
                        "Search Routes",
                        style: TextStyle(fontSize: 16),
                      ),
                    ),
                  )
                ],
              ),
            ),

            const SizedBox(height: 25),

            /// Recent Searches
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: const [
                Text("Recent Searches",
                    style:
                    TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                Text("Clear All", style: TextStyle(color: Colors.blue))
              ],
            ),

            const SizedBox(height: 15),

            recentItem("Vadasery bus stand"),
            recentItem("veppamoodu"),

            const SizedBox(height: 25),

            /// Map Preview
            Container(
              height: 180,
              width: double.infinity,
              decoration: BoxDecoration(
                color: Colors.green.shade200,
                borderRadius: BorderRadius.circular(20),
              ),
              child: const Center(
                child: Text("Map Preview"),
              ),
            ),

            const SizedBox(height: 10),

            const Center(
              child: Text(
                "Explore Live Map",
                style: TextStyle(color: Colors.blue),
              ),
            )
          ],
        ),
      ),


    );
  }
}