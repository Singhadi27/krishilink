import 'package:flutter/material.dart';

class PincodeChecker extends StatefulWidget {
  const PincodeChecker({Key? key}) : super(key: key);

  @override
  _PincodeCheckerState createState() => _PincodeCheckerState();
}

class _PincodeCheckerState extends State<PincodeChecker> {
  final TextEditingController _pincodeController = TextEditingController();
  String _message = '';

  void _checkPincode() {
    // This is a mock check. In a real app, you'd validate against a database or API
    if (_pincodeController.text.length == 6) {
      setState(() {
        _message = 'Delivery available in your area!';
      });
    } else {
      setState(() {
        _message = 'Please enter a valid 6-digit pincode.';
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.all(16.0),
          child: TextField(
            controller: _pincodeController,
            decoration: InputDecoration(
              labelText: 'Enter Pincode',
              border: OutlineInputBorder(),
              suffixIcon: IconButton(
                icon: Icon(Icons.search),
                onPressed: _checkPincode,
              ),
            ),
            keyboardType: TextInputType.number,
            maxLength: 6,
          ),
        ),
        Text(
          _message,
          style: TextStyle(
            color: _message.startsWith('Delivery') ? Colors.green : Colors.red,
          ),
        ),
      ],
    );
  }

  @override
  void dispose() {
    _pincodeController.dispose();
    super.dispose();
  }
}