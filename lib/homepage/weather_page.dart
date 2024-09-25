import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:flutter_spinkit/flutter_spinkit.dart';

class WeatherPage extends StatefulWidget {
  @override
  _WeatherPageState createState() => _WeatherPageState();
}

class _WeatherPageState extends State<WeatherPage> {
  String _city = 'Noida';
  String _apiKey = 'ce1c445e89999d7456d3b789dfd7165b'; // Replace with your API key
  Map<String, dynamic>? _weatherData;
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _fetchWeatherData();
  }

  Future<void> _fetchWeatherData() async {
    setState(() {
      _isLoading = true;
    });

    final response = await http.get(
        Uri.parse('https://api.openweathermap.org/data/2.5/weather?q=$_city&appid=$_apiKey&units=metric'));

    if (response.statusCode == 200) {
      setState(() {
        _weatherData = json.decode(response.body);
        _isLoading = false;
      });
    } else {
      throw Exception('Failed to load weather data');
    }
  }

  String _getWeatherImage() {
    if (_weatherData == null) return 'assets/default.png'; // Fallback image

    final weatherDescription = _weatherData!['weather'][0]['description'].toLowerCase();

    if (weatherDescription.contains('clear')) {
      return 'assets/sunny.png';
    } else if (weatherDescription.contains('rain')) {
      return 'assets/rainy.png';
    } else if (weatherDescription.contains('thunder')) {
      return 'assets/thunder.png';
    } else if (weatherDescription.contains('haze')) {
      return 'assets/haze.png';
    } else {
      return 'assets/default.jpg'; // Fallback image
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.lime[100], // Light lime background
      appBar: AppBar(
        title: Text('Weather Forecast'),
        backgroundColor: Colors.green, // Dark lime app bar
      ),
      body: _isLoading
          ? Center(
        child: SpinKitFadingCircle(
          color: Colors.lime[700],
          size: 60.0,
        ),
      )
          : _weatherData != null
          ? Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Image.asset(_getWeatherImage(), height: 200), // Weather image
            SizedBox(height: 10.0),
            Text(
              '${_weatherData!['name']}',
              style: TextStyle(
                fontSize: 32.0,
                fontWeight: FontWeight.bold,
                color: Colors.lime[900], // Darker lime text
              ),
            ),
            SizedBox(height: 10.0),
            Text(
              '${_weatherData!['main']['temp']}°C',
              style: TextStyle(
                fontSize: 72.0,
                color: Colors.lime[800], // Dark lime text
              ),
            ),
            SizedBox(height: 10.0),
            Text(
              '${_weatherData!['weather'][0]['description']}',
              style: TextStyle(
                fontSize: 24.0,
                color: Colors.lime[600], // Medium lime text
              ),
            ),
            SizedBox(height: 20.0),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                Column(
                  children: [
                    Image.asset('assets/humidity.jpg', width: 40.0),
                    SizedBox(height: 5.0),
                    Text(
                      '${_weatherData!['main']['humidity']}% Humidity',
                      style: TextStyle(
                          fontSize: 18.0, color: Colors.lime[800]),
                    ),
                  ],
                ),
                Column(
                  children: [
                    Image.asset('assets/wind.png', width: 40.0),
                    SizedBox(height: 5.0),
                    Text(
                      '${_weatherData!['wind']['speed']} m/s Wind',
                      style: TextStyle(
                          fontSize: 18.0, color: Colors.lime[800]),
                    ),
                  ],
                ),
              ],
            ),
          ],
        ),
      )
          : Center(
        child: Text(
          'Failed to load weather data',
          style: TextStyle(
            color: Colors.lime[900],
            fontSize: 20.0,
          ),
        ),
      ),
    );
  }
}
