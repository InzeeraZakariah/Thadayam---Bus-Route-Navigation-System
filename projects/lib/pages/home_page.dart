import 'package:flutter/material.dart';
import 'search_page.dart';
import 'profile_page.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {

  int currentIndex = 0;

  @override
  Widget build(BuildContext context) {

    final pages = [
      homeContent(),
      const SearchPage(),
      const ProfilePage(),
    ];

    return Scaffold(

      backgroundColor: const Color(0xFFF5F7FB),
      appBar: currentIndex == 0
          ? AppBar(
        title: const Text(
          "THADAYAM",
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
      )
          : null,



      body: pages[currentIndex],

      bottomNavigationBar: BottomNavigationBar(
        currentIndex: currentIndex,
        selectedItemColor: const Color(0xFF2F80ED),

        onTap: (index){
          setState(() {
            currentIndex = index;
          });
        },

        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: "Home",
          ),

          BottomNavigationBarItem(
            icon: Icon(Icons.search),
            label: "Search",
          ),

          BottomNavigationBarItem(
            icon: Icon(Icons.person),
            label: "Profile",
          ),
        ],
      ),
    );
  }

  Widget homeContent() {
    return SafeArea(
      child: SingleChildScrollView(
        padding: const EdgeInsets.all(20),

        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [

            /// HEADER
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [

                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: const [
                    Text(
                      "Good Morning",
                      style: TextStyle(color: Colors.grey),
                    ),
                    Text(
                      "Alex 👋",
                      style: TextStyle(
                        fontSize: 22,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),

                const CircleAvatar(
                  radius: 22,
                  child: Icon(Icons.person),
                ),
              ],
            ),

            const SizedBox(height: 25),

            /// SEARCH BAR
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 15),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(20),
                boxShadow: const [
                  BoxShadow(
                    color: Colors.black12,
                    blurRadius: 8,
                  )
                ],
              ),
              child: const TextField(
                decoration: InputDecoration(
                  icon: Icon(Icons.search),
                  hintText: "Where are you going today?",
                  border: InputBorder.none,
                ),
              ),
            ),

            const SizedBox(height: 30),

            /// RECOMMENDED ROUTES
            const Text(
              "Recommended Routes",
              style: TextStyle(
                fontSize: 17,
                fontWeight: FontWeight.bold,
              ),
            ),

            const SizedBox(height: 15),

            Row(
              children: [

                routeCard("42", "Marthandam", "Vadasery"),
                const SizedBox(width: 15),
                routeCard("31A", "Parvathipuram", "Nagercoil"),

              ],
            ),

            const SizedBox(height: 30),

            /// NEARBY STANDS
            const Text(
              "Nearby Bus Stands",
              style: TextStyle(
                fontSize: 17,
                fontWeight: FontWeight.bold,
              ),
            ),

            const SizedBox(height: 15),

            Container(
              height: 160,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(20),
                color: Colors.green.shade100,
              ),
              child: const Center(
                child: Text("Map Preview"),
              ),
            ),

            const SizedBox(height: 25),

            /// QUICK ROUTES
            const Text(
              "Quick Routes",
              style: TextStyle(
                fontSize: 17,
                fontWeight: FontWeight.bold,
              ),
            ),

            const SizedBox(height: 10),

            Wrap(
              spacing: 10,
              children: const [
                Chip(label: Text("Home → College")),
                Chip(label: Text("Market → Bus Stand")),
                Chip(label: Text("Station → Mall")),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget routeCard(String bus, String start, String end) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.all(15),

        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(20),
          boxShadow: const [
            BoxShadow(
              color: Colors.black12,
              blurRadius: 6,
            )
          ],
        ),

        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [

            Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: const Color(0xFFE8F1FD),
                borderRadius: BorderRadius.circular(10),
              ),
              child: const Icon(
                Icons.directions_bus,
                color: Color(0xFF2F80ED),
              ),
            ),

            const SizedBox(height: 10),

            Text(
              "Route $bus",
              style: const TextStyle(
                fontWeight: FontWeight.bold,
              ),
            ),

            Text(
              "$start → $end",
              style: const TextStyle(
                color: Colors.grey,
                fontSize: 12,
              ),
            ),
          ],
        ),
      ),
    );
  }
}