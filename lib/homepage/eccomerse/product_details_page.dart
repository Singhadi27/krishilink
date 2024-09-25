import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:localvue/homepage/eccomerse/cart_provider.dart';
import 'cart_provider.dart';

class ProductDetailsPage extends StatefulWidget {
  final String imageUrl;
  final String productName;
  final double price;

  const ProductDetailsPage({
    Key? key,
    required this.imageUrl,
    required this.productName,
    required this.price,
  }) : super(key: key);

  @override
  _ProductDetailsPageState createState() => _ProductDetailsPageState();
}

class _ProductDetailsPageState extends State<ProductDetailsPage> {
  int _quantity = 1;

  // Placeholder for cart items count
  int _cartItemCount = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.productName),
        actions: [
          IconButton(
            icon: Stack(
              children: [
                const Icon(Icons.shopping_cart),
                if (_cartItemCount > 0)
                  Positioned(
                    right: 0,
                    top: 0,
                    child: Container(
                      padding: const EdgeInsets.all(2.0),
                      decoration: BoxDecoration(
                        color: Colors.red,
                        borderRadius: BorderRadius.circular(6.0),
                      ),
                      constraints: const BoxConstraints(
                        minWidth: 20,
                        minHeight: 20,
                      ),
                      child: Center(
                        child: Text(
                          '$_cartItemCount',
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 12,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),
                  ),
              ],
            ),
            onPressed: () {
              // Handle cart navigation or logic
            },
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Product Image
            Center(
              child: Image.network(
                widget.imageUrl,
                height: 250,
                fit: BoxFit.cover,
              ),
            ),
            const SizedBox(height: 16),

            // Product Name
            Text(
              widget.productName,
              style: const TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 8),

            // Product Price
            Text(
              '₹${widget.price.toStringAsFixed(2)}',
              style: const TextStyle(
                fontSize: 20,
                color: Colors.green,
              ),
            ),
            const SizedBox(height: 16),

            // Quantity Selector
            Row(
              children: [
                IconButton(
                  icon: const Icon(Icons.remove),
                  onPressed: () {
                    setState(() {
                      if (_quantity > 1) _quantity--;
                    });
                  },
                ),
                Text(
                  '$_quantity',
                  style: const TextStyle(fontSize: 18),
                ),
                IconButton(
                  icon: const Icon(Icons.add),
                  onPressed: () {
                    setState(() {
                      _quantity++;
                    });
                  },
                ),
              ],
            ),
            const SizedBox(height: 16),

            // Add to Cart Button
            // Add to Cart Button
            ElevatedButton(
              onPressed: () {
                // Access the CartProvider
                final cartProvider = Provider.of<CartProvider>(context, listen: false);

                // Add the product to the cart using the CartProvider
                cartProvider.addItem(
                  widget.productName,
                  widget.price,
                  _quantity,
                  imageUrl: widget.imageUrl,
                );

                // Optionally: Show a snackbar to indicate that the item was added to the cart
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text('${widget.productName} added to cart'),
                    duration: const Duration(seconds: 2),
                  ),
                );

                // You can also update the local _cartItemCount if you need it,
                // but the global cart state is handled by CartProvider
                setState(() {
                  _cartItemCount += _quantity;
                });
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.green,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8.0),
                ),
              ),
              child: const Text('Add to Cart'),
            ),
            const SizedBox(height: 16),

            // Product Description
            const Text(
              'Product Description:\nLorem ipsum dolor sit amet, consectetur adipiscing elit. Quisque euismod justo vitae urna tincidunt, non bibendum erat posuere.',
              style: TextStyle(fontSize: 16),
            ),
          ],
        ),
      ),
    );
  }
}