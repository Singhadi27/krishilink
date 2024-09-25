import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';

import 'krishilinkHomepage.dart';

class CropDoctorPage extends StatefulWidget {
  @override
  _CropDoctorPageState createState() => _CropDoctorPageState();
}

class _CropDoctorPageState extends State<CropDoctorPage> {
  XFile? _image;
  final ImagePicker _picker = ImagePicker();
  final TextEditingController _messageController = TextEditingController();

  // Function to pick image from camera or gallery
  Future<void> _pickImage(ImageSource source) async {
    final XFile? selectedImage = await _picker.pickImage(source: source);
    setState(() {
      _image = selectedImage;
    });
  }

  // Function to show confirmation dialog
  void _showConfirmationDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text("Thank you for your query"),
          content: Text("Our experts will soon be in touch with you."),
          actions: [
            TextButton(
              child: Text("Ok"),
              onPressed: () {
                Navigator.of(context).pushAndRemoveUntil(
                  MaterialPageRoute(builder: (context) => HomePage()), // Navigate to HomePage
                      (Route<dynamic> route) => false, // Remove all previous routes
                );
              },
            ),

          ],
        );
      },
    );
  }

  // Send function when the farmer submits their issue
  void _sendQuery() {
    if (_messageController.text.isEmpty || _image == null) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text('Please upload a picture and enter a message.'),
      ));
      return;
    }
    // Here you can handle the upload of the image and message to your backend

    // Showing the confirmation dialog after sending
    _showConfirmationDialog();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: true, // This will prevent the overflow
      appBar: AppBar(
        title: Text("Crop Doctor"),
        backgroundColor: Colors.green,
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
      ),
      body: SingleChildScrollView( // Wrap content in SingleChildScrollView
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              // Display the selected image
              Container(
                height: 200,
                width: double.infinity,
                color: Colors.grey[300],
                child: _image != null
                    ? Image.file(File(_image!.path), fit: BoxFit.cover)
                    : Center(
                  child: Text('No image selected'),
                ),
              ),
              SizedBox(height: 20),

              // Buttons to take a picture or select from gallery
              ElevatedButton.icon(
                onPressed: () => _pickImage(ImageSource.camera),
                icon: Icon(Icons.camera_alt),
                label: Text("Take a picture"),
              ),
              ElevatedButton.icon(
                onPressed: () => _pickImage(ImageSource.gallery),
                icon: Icon(Icons.photo_library),
                label: Text("Select from gallery"),
              ),

              SizedBox(height: 20),

              // Message input field
              TextField(
                controller: _messageController,
                decoration: InputDecoration(
                  border: OutlineInputBorder(),
                  hintText: 'Type something...',
                ),
                maxLines: 3,
              ),

              SizedBox(height: 20),

              // Send button
              ElevatedButton(
                onPressed: _sendQuery,
                child: Text("Send"),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.green, // Send button color
                  padding: EdgeInsets.symmetric(horizontal: 50, vertical: 15),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
