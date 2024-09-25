import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'dart:io';

import 'mytrade_page.dart';

class AddTradePage extends StatefulWidget {
  @override
  _AddTradePageState createState() => _AddTradePageState();
}

class _AddTradePageState extends State<AddTradePage> {
  final _formKey = GlobalKey<FormState>();
  String? selectedCrop;
  String? selectedState;
  String? selectedDistrict;
  double? price;
  String? quantityType = 'KG';
  TextEditingController quantityController = TextEditingController();
  File? _image;

  List<String> crops = [];
  List<String> states = [];
  List<String> districts = [];
  double? apmcPrice;
  bool isLoadingCrops = true;
  bool isLoadingStates = true;
  bool isLoadingDistricts = false;
  bool isLoadingPrice = false;

  final picker = ImagePicker();

  @override
  void initState() {
    super.initState();
    fetchCrops();
    fetchStates();
  }

  Future<void> fetchCrops() async {
    setState(() {
      isLoadingCrops = true;
    });
    const apiKey = '579b464db66ec23bdd000001cdd3946e44ce4aad7209ff7b23ac571b';
    final url = Uri.parse('https://api.data.gov.in/resource/9ef84268-d588-465a-a308-a864a43d0070?api-key=$apiKey&format=json');

    final response = await http.get(url);

    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      final records = data['records'] as List;

      setState(() {
        crops = records.map((e) => e['commodity'] as String).toSet().toList();
        states = records.map((e) => e['state'] as String).toSet().toList();
      });
    } else {
      print('Failed to fetch crops. Status code: ${response.statusCode}');
    }
    setState(() {
      isLoadingCrops = false;
      isLoadingStates = false;
    });
  }

  Future<void> fetchDistricts(String state) async {
    setState(() {
      isLoadingDistricts = true;
    });
    const apiKey = '579b464db66ec23bdd000001cdd3946e44ce4aad7209ff7b23ac571b';
    final url = Uri.parse('https://api.data.gov.in/resource/9ef84268-d588-465a-a308-a864a43d0070?api-key=$apiKey&format=json');

    final response = await http.get(url);

    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      final records = data['records'] as List;

      setState(() {
        districts = records.where((e) => e['state'] == state).map((e) => e['district'] as String).toSet().toList();
      });
    } else {
      print('Failed to fetch districts. Status code: ${response.statusCode}');
    }
    setState(() {
      isLoadingDistricts = false;
    });
  }

  Future<void> fetchAPMCPrice(String crop, String district) async {
    setState(() {
      isLoadingPrice = true;
    });
    const apiKey = '579b464db66ec23bdd000001cdd3946e44ce4aad7209ff7b23ac571b';
    final url = Uri.parse('https://api.data.gov.in/resource/9ef84268-d588-465a-a308-a864a43d0070?api-key=$apiKey&format=json');

    final response = await http.get(url);

    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      final records = data['records'] as List;
      final filteredRecords = records.where((e) => e['commodity'] == crop && e['district'] == district).toList();

      setState(() {
        if (filteredRecords.isNotEmpty) {
          apmcPrice = double.tryParse(filteredRecords.first['modal_price'] as String);
        }
      });
    } else {
      print('Failed to fetch APMC price. Status code: ${response.statusCode}');
    }
    setState(() {
      isLoadingPrice = false;
    });
  }

  Future<void> fetchStates() async {
    setState(() {
      isLoadingStates = true;
    });

    try {
      const apiKey = '579b464db66ec23bdd000001cdd3946e44ce4aad7209ff7b23ac571b';
      final url = Uri.parse('https://api.data.gov.in/resource/9ef84268-d588-465a-a308-a864a43d0070?api-key=$apiKey&format=json');

      final response = await http.get(url);

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        final records = data['records'] as List;

        setState(() {
          states = records.map((e) => e['state'] as String).toSet().toList();
        });
      } else {
        print('Failed to fetch states. Status code: ${response.statusCode}');
      }
    } catch (e) {
      print('Error fetching states: $e');
    } finally {
      setState(() {
        isLoadingStates = false;
      });
    }
  }

  Future<void> _pickImage() async {
    final pickedFile = await picker.pickImage(source: ImageSource.camera);
    if (pickedFile != null) {
      setState(() {
        _image = File(pickedFile.path);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.green,
        title: Row(
          children: [
            Icon(Icons.add_shopping_cart),
            SizedBox(width: 10),
            Text('Add Trade'),
          ],
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Form(
          key: _formKey,
          child: ListView(
            children: [
              Text('Add Crop Image'),
              _image == null
                  ? ElevatedButton(
                onPressed: _pickImage,
                child: Text('Pick Image from Camera'),
              )
                  : Image.file(_image!),

              isLoadingCrops
                  ? CircularProgressIndicator()
                  : DropdownButtonFormField<String>(
                value: selectedCrop,
                decoration: InputDecoration(labelText: 'Select Crop'),
                items: crops.map((crop) {
                  return DropdownMenuItem(value: crop, child: Text(crop));
                }).toList(),
                onChanged: (value) {
                  setState(() {
                    selectedCrop = value;
                  });
                },
              ),

              TextFormField(
                controller: quantityController,
                decoration: InputDecoration(labelText: 'Enter Quantity'),
                keyboardType: TextInputType.number,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter quantity';
                  }
                  return null;
                },
              ),

              DropdownButtonFormField<String>(
                value: quantityType,
                decoration: InputDecoration(labelText: 'Select Unit'),
                items: ['KG', 'QT'].map((unit) {
                  return DropdownMenuItem(value: unit, child: Text(unit));
                }).toList(),
                onChanged: (value) {
                  setState(() {
                    quantityType = value;
                  });
                },
              ),

              isLoadingStates
                  ? CircularProgressIndicator()
                  : DropdownButtonFormField<String>(
                value: selectedState,
                decoration: InputDecoration(labelText: 'Select State'),
                items: states.map((state) {
                  return DropdownMenuItem(value: state, child: Text(state));
                }).toList(),
                onChanged: (value) {
                  setState(() {
                    selectedState = value;
                    fetchDistricts(selectedState!);
                  });
                },
              ),

              isLoadingDistricts
                  ? CircularProgressIndicator()
                  : DropdownButtonFormField<String>(
                value: selectedDistrict,
                decoration: InputDecoration(labelText: 'Select District'),
                items: districts.map((district) {
                  return DropdownMenuItem(value: district, child: Text(district));
                }).toList(),
                onChanged: (value) {
                  setState(() {
                    selectedDistrict = value;
                    fetchAPMCPrice(selectedCrop!, selectedDistrict!);
                  });
                },
              ),

              isLoadingPrice
                  ? CircularProgressIndicator()
                  : apmcPrice != null
                  ? Text('APMC Price in $selectedDistrict: ₹$apmcPrice')
                  : SizedBox.shrink(),

              TextFormField(
                decoration: InputDecoration(labelText: 'Set Price'),
                keyboardType: TextInputType.number,
                onChanged: (value) {
                  price = double.tryParse(value);
                },
              ),

              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.green, // Green background color
                ),
                onPressed: () {
                  if (_formKey.currentState!.validate()) {
                    // Save the trade data
                    final tradeData = {
                      'crop': selectedCrop,
                      'state': selectedState,
                      'district': selectedDistrict,
                      'quantity': quantityController.text,
                      'unit': quantityType,
                      'price': price,
                      'image': _image,
                    };

                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => TradeDetailPage(tradeData: tradeData),
                      ),
                    );
                  }
                },
                child: Text('Submit'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
