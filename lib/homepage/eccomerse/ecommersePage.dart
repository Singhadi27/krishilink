import 'package:flutter/material.dart';
import 'package:carousel_slider/carousel_slider.dart'; // Use for auto-scrolling banners
// Import the new file
import 'package:localvue/homepage/eccomerse/cart_provider.dart'; // Import the provider
import 'package:localvue/homepage/eccomerse/cart_page.dart'; // Import the cart page
 // Import provider
import 'package:localvue/homepage/eccomerse/pincode_checker.dart';
import 'package:localvue/homepage/eccomerse/product_details_page.dart';
import 'package:provider/provider.dart'; // Add this line

class ProductModel {
  final String imageUrl;
  final String name;
  final double price;

  ProductModel({required this.imageUrl, required this.name, required this.price});
}

// Updated product list variables
final List<ProductModel> carouselProductList = [
  ProductModel(
    imageUrl: 'https://www.rallis.com/Upload/homepage/banner-lead-rallis-03.JPG',
    name: 'Crop Protection',
    price: 120.0,
  ),
  ProductModel(
    imageUrl: 'https://encrypted-tbn2.gstatic.com/shopping?q=tbn:ANd9GcRz4m3BPX7vf5d1dZ5qZtC04iYxh173fxf7iQpIuNHu-PIJaK_lJjvsi-mzi1fjU2qIiIQVwVAqWR76R4QsjXO5ibBW_TbwPXckhvfzoSzS&usqp=CAE',
    name: 'Seed Care',
    price: 200.0,
  ),
  ProductModel(
    imageUrl: 'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcQBX7B05c9RW9JAiB8zVYnQB47Xj_4kmRUwjg&s',
    name: 'Fertilizers',
    price: 180.0,
  ),
  ProductModel(
    imageUrl: 'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcT3fsrU47Po_h3eBuFvlnZx3gUVjGpb5uYx-A&s',
    name: 'Agri Tools',
    price: 220.0,
  ),
];

final List<ProductModel> gridProductList = [
  ProductModel(
    imageUrl: 'https://www.crystalcropprotection.com/images/cropProtection/160066289120200921.jpg',
    name: 'Talwar Zinc',
    price: 100.0,
  ),
  ProductModel(
    imageUrl: 'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcQX9Wk1dFowOIPKhi83P5dfhUHb9kbMY0e6yA&s',
    name: 'Herbicide',
    price: 150.0,
  ),
  ProductModel(
    imageUrl: 'https://www.agriplexindia.com/cdn/shop/products/Gracia_3.png?v=1679921631',
    name: 'Gracia insecticide',
    price: 200.0,
  ),
  ProductModel(
    imageUrl: 'https://rukminim2.flixcart.com/image/850/1000/xif0q/plant-seed/v/z/l/500-cofs29-fodder-sorghum-jowar-seeds-multicut-perennial-original-imahfc9gtyupfkph.jpeg?q=90&crop=false',
    name: 'Fodder Sorghum Seed',
    price: 250.0,
  ),
];

final List<ProductModel> popularProductList = [
  ProductModel(
    imageUrl: 'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcSfUhRKQ45xzl1P0BwGeguhuHEkn-VuydwQHg&s',
    name: 'Green Peas Seed',
    price: 180.0,
  ),
  ProductModel(
    imageUrl: 'https://nurserylive.com/cdn/shop/products/nurserylive-g-soil-and-fertilizers-polestar-organic-food-waste-compost-1-kg-set-of-2_512x512.jpg?v=1634226541',
    name: 'Soil nutrient',
    price: 200.0,
  ),
];

class NewHomePage extends StatelessWidget {
  const NewHomePage({super.key});

  @override
  Widget build(BuildContext context) {
    final cartProvider = Provider.of<CartProvider>(context);

    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.location_on),
          onPressed: () {
            // Handle location logic
          },
        ),
        title: const Text('Enter Pincode'),
        actions: [
          IconButton(
            icon: const Icon(Icons.search),
            onPressed: () {
              // Handle search logic
            },
          ),
          IconButton(
            icon: Stack(
              children: [
                const Icon(Icons.shopping_cart),
                if (cartProvider.itemCount > 0)
                  Positioned(
                    right: 0,
                    top: 0,
                    child: CircleAvatar(
                      radius: 10,
                      backgroundColor: Colors.red,
                      child: Text(
                        '${cartProvider.itemCount}',
                        style: const TextStyle(
                          fontSize: 12,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ),
              ],
            ),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => CartPage()),
              );
            },
          ),
          IconButton(
            icon: const Icon(Icons.person),
            onPressed: () {
              // Handle profile logic
            },
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            const PincodeChecker(),
            // Auto-scrolling banners
            CarouselSlider(
              options: CarouselOptions(
                height: 200.0,
                autoPlay: true,
                enlargeCenterPage: true,
              ),
              items: carouselProductList.map((product) {
                return Builder(
                  builder: (BuildContext context) {
                    return Container(
                      width: MediaQuery.of(context).size.width,
                      margin: const EdgeInsets.symmetric(horizontal: 5.0),
                      decoration: const BoxDecoration(
                        color: Colors.white,
                      ),
                      child: Image.network(
                        product.imageUrl,
                        fit: BoxFit.cover,
                      ),
                    );
                  },
                );
              }).toList(),
            ),
            const SizedBox(height: 20),
            // Product grid
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: GridView.builder(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  childAspectRatio: 0.5,
                  crossAxisSpacing: 10,
                  mainAxisSpacing: 10,
                ),
                itemCount: gridProductList.length,
                itemBuilder: (context, index) {
                  final product = gridProductList[index];
                  return ProductCardWidget(
                    imageUrl: product.imageUrl,
                    productName: product.name,
                    price: product.price,
                  );
                },
              ),
            ),
            const SizedBox(height: 20),
            // Most Popular Products Section
            const Padding(
              padding: EdgeInsets.symmetric(horizontal: 8.0),
              child: Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  'Most Popular Products',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: GridView.builder(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  childAspectRatio: 0.5,
                  crossAxisSpacing: 10,
                  mainAxisSpacing: 10,
                ),
                itemCount: popularProductList.length,
                itemBuilder: (context, index) {
                  final product = popularProductList[index];
                  return ProductCardWidget(
                    imageUrl: product.imageUrl,
                    productName: product.name,
                    price: product.price,
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class ProductCardWidget extends StatelessWidget {
  final String imageUrl;
  final String productName;
  final double price;

  const ProductCardWidget({
    Key? key,
    required this.imageUrl,
    required this.productName,
    required this.price,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => ProductDetailsPage(
              imageUrl: imageUrl,
              productName: productName,
              price: price,
            ),
          ),
        );
      },
      child: Card(
        elevation: 2.0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10.0),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              flex: 6,
              child: ClipRRect(
                borderRadius: const BorderRadius.only(
                  topLeft: Radius.circular(10.0),
                  topRight: Radius.circular(10.0),
                ),
                child: Image.network(
                  imageUrl,
                  width: double.infinity,
                  fit: BoxFit.cover,
                ),
              ),
            ),
            const SizedBox(height: 10.0),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8.0),
              child: Text(
                productName,
                style: const TextStyle(
                  fontSize: 16.0,
                  fontWeight: FontWeight.bold,
                ),
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8.0),
              child: Text(
                '₹${price.toStringAsFixed(2)}', // Display price in INR
                style: const TextStyle(
                  fontSize: 16.0,
                  color: Colors.green,
                ),
              ),
            ),
            const SizedBox(height: 8.0),
          ],
        ),
      ),
    );
  }
}


