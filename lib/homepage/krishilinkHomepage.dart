import 'package:flutter/material.dart';
import 'package:carousel_slider/carousel_slider.dart'; // For the auto-scrolling banner
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:google_sign_in/google_sign_in.dart'; // Import Google Sign-In

import 'package:localvue/homepage/weather_page.dart';
import '../views/onboarding_screen.dart';
import 'MandiBhavPage.dart';
import 'contactus.dart';
import 'cropDoctor.dart';
import 'eccomerse/ecommersePage.dart';
import 'mytrade_page.dart';
import 'newspage.dart';
import 'add_trade_page.dart'; // Import AddTradePage

final GoogleSignIn _googleSignIn = GoogleSignIn();
GoogleSignInAccount? _currentUser; // To hold user info

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  String weather = 'Loading...'; // Default weather info
  String location = 'Fetching...'; // Default location info

  @override
  void initState() {
    super.initState();
    fetchWeatherAndLocation();
    _googleSignIn.onCurrentUserChanged.listen((GoogleSignInAccount? account) {
      setState(() {
        _currentUser = account;
      });
    });
    _googleSignIn.signInSilently(); // Sign in user silently if already signed in
  }

  Future<void> fetchWeatherAndLocation() async {
    const weatherApiKey = 'ff073be2bd205fdd8debe474f5ac7a7a';
    const weatherUrl =
        'https://api.openweathermap.org/data/2.5/weather?q=noida&appid=$weatherApiKey&units=metric';

    try {
      final weatherResponse = await http.get(Uri.parse(weatherUrl));
      if (weatherResponse.statusCode == 200) {
        final weatherData = json.decode(weatherResponse.body);
        setState(() {
          weather =
          '${weatherData['main']['temp']}°C, ${weatherData['weather'][0]['description']}';
          location = '${weatherData['name']}, ${weatherData['sys']['country']}';
        });
      } else {
        setState(() {
          weather = 'Error fetching weather';
        });
      }
    } catch (e) {
      setState(() {
        weather = 'Error fetching weather';
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        title: Row(
          children: [
            Icon(
              Icons.grain,
              color: Colors.green, // Set the color to green
            ),
            SizedBox(width: 10),
            Text(
              'KrishiLink',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: Colors.green,
                fontFamily: 'Roboto',
                letterSpacing: 1.5,
              ),
            ),
          ],
        ),
        actions: [
          IconButton(
            icon: Icon(Icons.notifications_on_outlined),
            onPressed: () {},
          ),
          IconButton(
            icon: Icon(Icons.phone, color: Colors.green), // Set the color here
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => ContactUsPage()),
              );
            },
          ),

          IconButton(
            icon: Icon(Icons.language),
            onPressed: () {},
          ),
        ],
      ),
      drawer: Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: <Widget>[
            UserAccountsDrawerHeader(
              accountName: Text(
                _currentUser != null
                    ? _currentUser!.displayName ?? "Farmer Name"
                    : "Farmer Name",
              ),
              accountEmail: null, // Remove the email display
              currentAccountPicture: CircleAvatar(
                backgroundImage: _currentUser != null && _currentUser!.photoUrl != null
                    ? NetworkImage(_currentUser!.photoUrl!) as ImageProvider
                    : AssetImage('assets/default_avatar.png') as ImageProvider,
                // Default image if no profile picture
                backgroundColor: Colors.white,
              ),
              decoration: BoxDecoration(
                color: Colors.green,
              ),
            ),
            ListTile(
              leading: Icon(Icons.exit_to_app),
              title: Text("Log out"),
              onTap: () {
                Navigator.pop(context);
                // Perform log out logic (clear any user data, session, etc.)
                _googleSignIn.signOut();

                // Navigate to OnBoardingScreen
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(builder: (context) => const OnBoardingScreen()),
                );
              },
            ),
          ],
        ),
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Weather and location info
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Weather: $weather',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w400,
                      color: Colors.black54,
                    ),
                  ),
                  SizedBox(height: 4),
                  Text(
                    'Location: $location',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w400,
                      color: Colors.black54,
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(height: 10), // Gap between weather and banner
            // Auto-scrolling banner with margins
            Container(
              width: screenWidth,
              padding: EdgeInsets.symmetric(horizontal: 16.0),
              child: CarouselSlider(
                options: CarouselOptions(
                  autoPlay: true,
                  autoPlayInterval: Duration(seconds: 3),
                  viewportFraction: 1.0,
                  autoPlayAnimationDuration: Duration(milliseconds: 800),
                ),
                items: [
                  'assets/banner01.png.jpg',
                  'assets/banner02.jpg',
                  'assets/onboardFarmer1.png',
                ].map((imagePath) {
                  return Builder(
                    builder: (BuildContext context) {
                      return Image.asset(
                        imagePath,
                        fit: BoxFit.cover,
                        width: screenWidth - 32,
                      );
                    },
                  );
                }).toList(),
              ),
            ),
            SizedBox(height: 20),
            // Grid of buttons similar to AgriBazaar
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: GridView.count(
                crossAxisCount: 3,
                shrinkWrap: true,
                physics: NeverScrollableScrollPhysics(),
                crossAxisSpacing: 10,
                mainAxisSpacing: 10,
                children: [

                  buildFeatureButton(Icons.add_shopping_cart, 'Add Crop'),
                  buildFeatureButton(Icons.store, 'Mandi Bhaav'),
                  buildFeatureButton(Icons.local_hospital, 'Crop Doctor'),
                  buildFeatureButton(Icons.store_mall_directory, 'Input Store'),
                  buildFeatureButton(Icons.health_and_safety, 'GAP'),
                  buildFeatureButton(Icons.wb_sunny, 'Weather Forecast'),



                  buildFeatureButton(Icons.calculate, 'Fertilizer Calculator'),
                  buildFeatureButton(Icons.calendar_today, 'Crop Calendar'),
                  buildFeatureButton(Icons.add_location, 'Add Farm'),
                  buildFeatureButton(Icons.agriculture, 'My Farm'),

                ],
              ),
            ),
            SizedBox(height: 24),
          ],
        ),
      ),
        bottomNavigationBar: BottomNavigationBar(
          type: BottomNavigationBarType.fixed,
          selectedItemColor: Colors.green,
          unselectedItemColor: Colors.grey,
          items: const <BottomNavigationBarItem>[
            BottomNavigationBarItem(
              icon: Icon(Icons.home),
              label: 'Home',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.shopping_bag),
              label: 'MyTrade',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.store),
              label: 'Mandi',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.article),
              label: 'News',
            ),
          ],
          onTap: (index) {
            switch (index) {
              case 0:
              // Navigate to Home page
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => HomePage()), // Replace HomePage with your actual Home page widget
                );
                break;
              case 1:
              // Navigate to MyTrade page
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) =>  TradeDetailPage(tradeData: {},)), // Replace MyTradePage with your actual MyTrade page widget
                );
                break;
              case 2:
              // Navigate to MandiBhavPage
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => MandiBhavPage()), // Navigate to MandiBhavPage
                );
                break;
              case 3:
              // Navigate to News page
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => NewsPage()), // Replace NewsPage with your actual News page widget
                );
                break;
            }
          },
        )

    );
  }

  // Helper function to build feature buttons
  Widget buildFeatureButton(IconData icon, String label) {
    return GestureDetector(
      onTap: () {
        if (icon == Icons.add_shopping_cart) {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => AddTradePage()),
          );
        }

        if (icon == Icons.wb_sunny) {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => WeatherPage()),
          );
        }

        if (icon == Icons.local_hospital) {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => CropDoctorPage()),
          );
        }

        if (icon == Icons.store) {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) =>  MandiBhavPage()),
          );
        }

        if (icon == Icons.store_mall_directory) {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => NewHomePage()),
          );
        }


        // Add more navigation logic if needed for other buttons

      },
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          CircleAvatar(
            radius: 30,
            backgroundColor: Colors.green.shade100,
            child: Icon(icon, color: Colors.green, size: 30),
          ),
          SizedBox(height: 8),
          Text(
            label,
            textAlign: TextAlign.center,
            style: TextStyle(fontSize: 12, color: Colors.green),
          ),
        ],
      ),
    );
  }
}
