import 'package:flutter/material.dart';
import 'dart:io'; // Import the dart:io package for File

class TradeDetailPage extends StatelessWidget {
  final Map<String, dynamic> tradeData;

  TradeDetailPage({required this.tradeData});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.green,
        title: Row(
          children: [
            Icon(Icons.shopping_cart),
            SizedBox(width: 10),
            Text('Trade Details'),
          ],
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Display image if available
            tradeData['image'] != null
                ? Container(
              height: 200,
              decoration: BoxDecoration(
                color: Colors.grey.shade200,
                borderRadius: BorderRadius.circular(12.0),
              ),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(12.0),
                child: Image.file(
                  File(tradeData['image'].path), // Ensure tradeData['image'] is a valid file path
                  fit: BoxFit.cover,
                ),
              ),
            )
                : SizedBox.shrink(),

            SizedBox(height: 16),

            // Display other trade data in containers
            _buildDetailContainer('Crop:', tradeData['crop']),
            _buildDetailContainer('State:', tradeData['state']),
            _buildDetailContainer('District:', tradeData['district']),
            _buildDetailContainer('Quantity:', '${tradeData['quantity']} ${tradeData['unit']}'),
            _buildDetailContainer('Price:', '₹${tradeData['price']}'),

            Spacer(), // Push the button to the bottom

            Align(
              alignment: Alignment.bottomRight,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.green, // Green background color
                  shape: CircleBorder(), // Circular button
                ),
                onPressed: () {
                  // Navigate to AddTradePage
                  Navigator.pushNamed(context, '/addtrade');
                },
                child: Icon(Icons.add, color: Colors.white), // Add icon
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDetailContainer(String label, String? value) {
    return Container(
      padding: EdgeInsets.all(12.0),
      margin: EdgeInsets.only(bottom: 8.0),
      decoration: BoxDecoration(
        color: Colors.green.shade50,
        borderRadius: BorderRadius.circular(8.0),
        border: Border.all(color: Colors.grey),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16.0),
          ),
          Expanded(
            child: Text(
              value ?? 'N/A',
              textAlign: TextAlign.end,
              style: TextStyle(fontSize: 16.0),
            ),
          ),
        ],
      ),
    );
  }
}
