import 'package:flutter/material.dart';

class ContactUsPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Contact Us'),
      ),
      body: Container(
        padding: EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ContactInfo(
              name: 'Krishna Upadhyay',
              phone: '9142793190',
              email: 'e22cseu0675@bennett.edu.in',
            ),
            SizedBox(height: 20.0),
            ContactInfo(
              name: 'Aditya Singh',
              phone: '8789228956',
              email: 'adityassingh6513@gmail.com',
            ),

          ],
        ),
      ),
    );
  }
}

class ContactInfo extends StatelessWidget {
  final String name;
  final String phone;
  final String email;

  const ContactInfo({
    required this.name,
    required this.phone,
    required this.email,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          name,
          style: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 18.0,
          ),
        ),
        SizedBox(height: 5.0),
        Text('Phone: $phone'),
        Text('Email: $email'),
        Divider(), // Add a divider between contact info
      ],
    );
  }
}
