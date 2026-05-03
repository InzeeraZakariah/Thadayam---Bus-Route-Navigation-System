import 'package:flutter/material.dart';

class ProfilePage extends StatelessWidget {
  const ProfilePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xffF6F8FB),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(20),
            child: Column(
              children: [

                /// PROFILE CARD
                Container(
                  padding: const EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(20),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black12,
                        blurRadius: 10,
                        offset: Offset(0, 5),
                      )
                    ],
                  ),
                  child: Column(
                    children: [

                      /// PROFILE IMAGE
                      CircleAvatar(
                        radius: 40,
                        backgroundImage: NetworkImage(
                          "https://randomuser.me/api/portraits/men/32.jpg",
                        ),
                      ),

                      const SizedBox(height: 10),

                      const Text(
                        "Alex Sterling",
                        style: TextStyle(
                          fontSize: 22,
                          fontWeight: FontWeight.bold,
                        ),
                      ),

                      const SizedBox(height: 5),

                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: const [
                          Icon(Icons.location_on,
                              size: 16, color: Colors.grey),
                          SizedBox(width: 4),
                          Text(
                            "San Francisco, CA",
                            style: TextStyle(color: Colors.grey),
                          ),
                        ],
                      ),

                      const SizedBox(height: 12),

                      /// PREMIUM BADGE
                      Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 16, vertical: 6),
                        decoration: BoxDecoration(
                          color: const Color(0xffE3F2FD),
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: const Text(
                          "PREMIUM MEMBER",
                          style: TextStyle(
                            color: Color(0xff2F80ED),
                            fontWeight: FontWeight.bold,
                            fontSize: 12,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 20),

                /// STATS ROW
                Row(
                  children: [

                    Expanded(
                      child: statCard("128", "TOTAL TRIPS"),
                    ),

                    const SizedBox(width: 10),

                    Expanded(
                      child: statCard("12", "SAVED HUBS"),
                    ),
                  ],
                ),

                const SizedBox(height: 20),

                /// OPTIONS CARD
                Container(
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Column(
                    children: [

                      listTile(Icons.bookmark, "Saved Routes"),
                      divider(),

                      listTile(Icons.history, "Travel History"),
                      divider(),

                      listTile(Icons.settings, "Settings"),
                    ],
                  ),
                ),

                const SizedBox(height: 20),

                /// LOGOUT BUTTON
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(15),
                  decoration: BoxDecoration(
                    color: const Color(0xffFCEAEA),
                    borderRadius: BorderRadius.circular(15),
                  ),
                  child: const Center(
                    child: Text(
                      "Logout",
                      style: TextStyle(
                        color: Colors.red,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),

                const SizedBox(height: 20),

                /// ECO CARD
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    gradient: const LinearGradient(
                      colors: [
                        Color(0xff2F80ED),
                        Color(0xff56CCF2),
                      ],
                    ),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: const [

                      Text(
                        "Eco-Friendly Commuter",
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),

                      SizedBox(height: 5),

                      Text(
                        "By using public transit, you've saved 42kg of CO2 this month.",
                        style: TextStyle(color: Colors.white70),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  /// STAT CARD
  Widget statCard(String number, String label) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Column(
        children: [
          Text(
            number,
            style: const TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
              color: Color(0xff2F80ED),
            ),
          ),
          const SizedBox(height: 5),
          Text(
            label,
            style: const TextStyle(
              fontSize: 12,
              color: Colors.grey,
            ),
          ),
        ],
      ),
    );
  }

  /// LIST TILE
  Widget listTile(IconData icon, String title) {
    return ListTile(
      leading: Icon(icon, color: const Color(0xff2F80ED)),
      title: Text(title),
      trailing: const Icon(Icons.arrow_forward_ios, size: 16),
    );
  }

  Widget divider() {
    return const Divider(height: 1);
  }
}