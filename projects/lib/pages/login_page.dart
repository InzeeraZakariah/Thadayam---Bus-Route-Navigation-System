import 'package:flutter/material.dart';

import 'signup_page.dart';

import 'home_page.dart';



class LoginPage extends StatelessWidget {

  const LoginPage({super.key});



  @override

  Widget build(BuildContext context) {

    return Scaffold(

      backgroundColor: Color(0xFFF5F7FB),

      body: Center(

        child: SingleChildScrollView(

          child: Padding(

            padding: EdgeInsets.all(24),

            child: Column(

              children: [



                /// APP ICON

                Icon(

                  Icons.directions_bus,

                  size: 80,

                  color: Color(0xFF2F80ED),

                ),



                SizedBox(height: 10),



                /// APP NAME

                Text(

                  "Thadayam",

                  style: TextStyle(

                    fontSize: 28,

                    fontWeight: FontWeight.bold,

                  ),

                ),



                SizedBox(height: 30),



                /// LOGIN CARD

                Container(

                  padding: EdgeInsets.all(25),

                  decoration: BoxDecoration(

                    color: Colors.white,

                    borderRadius: BorderRadius.circular(25),

                    boxShadow: [

                      BoxShadow(

                        color: Colors.black12,

                        blurRadius: 15,

                        offset: Offset(0, 8),

                      )

                    ],

                  ),

                  child: Column(

                    children: [



                      /// EMAIL / USERNAME

                      TextField(

                        decoration: InputDecoration(

                          hintText: "Enter mail id",

                          prefixIcon: Icon(Icons.person_outline),

                          border: OutlineInputBorder(

                            borderRadius: BorderRadius.circular(15),

                          ),

                        ),

                      ),



                      SizedBox(height: 20),



                      /// PASSWORD

                      TextField(

                        obscureText: true,

                        decoration: InputDecoration(

                          hintText: "Password",

                          prefixIcon: Icon(Icons.lock_outline),

                          border: OutlineInputBorder(

                            borderRadius: BorderRadius.circular(15),

                          ),

                        ),

                      ),



                      SizedBox(height: 25),



                      /// LOGIN BUTTON

                      ElevatedButton(

                        style: ElevatedButton.styleFrom(

                          backgroundColor: Color(0xFF2F80ED),

                          minimumSize: Size(double.infinity, 50),

                          shape: RoundedRectangleBorder(

                            borderRadius: BorderRadius.circular(15),

                          ),

                        ),

                        child: Text(

                          "Login to Dashboard",

                          style: TextStyle(

                            fontSize: 16,

                            color: Colors.white,

                          ),

                        ),

                        onPressed: () {

                          Navigator.push(

                            context,

                            MaterialPageRoute(

                              builder: (context) => HomePage(),

                            ),

                          );

                        },

                      ),



                      SizedBox(height: 15),



                      /// SIGN UP LINK

                      GestureDetector(

                        onTap: () {

                          Navigator.push(

                            context,

                            MaterialPageRoute(

                              builder: (context) => SignUpPage(),

                            ),

                          );

                        },

                        child: RichText(

                          text: TextSpan(

                            style: TextStyle(

                              fontSize: 14,

                              color: Colors.black,

                            ),

                            children: [

                              TextSpan(text: "Don't have an account? "),

                              TextSpan(

                                text: "Sign Up",

                                style: TextStyle(

                                  color: Color(0xFF2F80ED), // blue

                                  fontWeight: FontWeight.bold,

                                ),

                              ),

                            ],

                          ),

                        ),

                      )

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

}

