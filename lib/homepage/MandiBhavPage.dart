import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'dart:io';

class MandiBhavPage extends StatefulWidget {
  @override
  _MandiBhavPageState createState() => _MandiBhavPageState();
}

class _MandiBhavPageState extends State<MandiBhavPage> {
  final _formKey = GlobalKey<FormState>();
  String? selectedCrop;
  String? selectedState;
  String? selectedDistrict;
  List<String> crops = [];
  List<String> states = [];
  List<String> districts = [];
  double? mandiPrice;
  bool isLoadingCrops = true;
  bool isLoadingStates = true;
  bool isLoadingDistricts = false;
  bool isLoadingPrice = false;

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

  Future<void> fetchMandiPrice(String crop, String district) async {
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
          mandiPrice = double.tryParse(filteredRecords.first['modal_price'] as String);
        }
      });
    } else {
      print('Failed to fetch mandi price. Status code: ${response.statusCode}');
    }
    setState(() {
      isLoadingPrice = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.green,
        title: Row(
          children: [
            Icon(Icons.store),
            SizedBox(width: 10),
            Text('Mandi Bhav'),
          ],
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Form(
          key: _formKey,
          child: ListView(
            children: [
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
                    fetchMandiPrice(selectedCrop!, selectedDistrict!);
                  });
                },
              ),

              isLoadingPrice
                  ? CircularProgressIndicator()
                  : mandiPrice != null
                  ? Text('Mandi Price in $selectedDistrict: ₹$mandiPrice')
                  : SizedBox.shrink(),

              SizedBox(height: 20),
            ],
          ),
        ),
      ),
    );
  }

  void fetchStates() {}
}
