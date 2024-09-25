import 'package:flutter/foundation.dart';

class CartProvider with ChangeNotifier {
  final List<CartItem> _cartItems = [];

  List<CartItem> get cartItems => _cartItems;

  int get itemCount => _cartItems.fold(0, (total, item) => total + item.quantity);

  double get totalAmount {
    return _cartItems.fold(0, (total, item) => total + item.price * item.quantity);
  }

  void addItem(String name, double price, int quantity, {String imageUrl = ''}) {
    final existingIndex = _cartItems.indexWhere((item) => item.name == name);
    if (existingIndex >= 0) {
      // If the item already exists in the cart, update its quantity
      _cartItems[existingIndex] = CartItem(
        name: name,
        price: price,
        quantity: _cartItems[existingIndex].quantity + quantity,
        imageUrl: imageUrl,
      );
    } else {
      // Otherwise, add the new item to the cart
      _cartItems.add(CartItem(
        name: name,
        price: price,
        quantity: quantity,
        imageUrl: imageUrl,
      ));
    }
    notifyListeners(); // Notify listeners to refresh the UI
  }

  void removeItem(String name) {
    _cartItems.removeWhere((item) => item.name == name);
    notifyListeners();
  }

  void removeSingleItem(String name) {
    final existingIndex = _cartItems.indexWhere((item) => item.name == name);
    if (existingIndex >= 0) {
      if (_cartItems[existingIndex].quantity > 1) {
        _cartItems[existingIndex] = CartItem(
          name: name,
          price: _cartItems[existingIndex].price,
          quantity: _cartItems[existingIndex].quantity - 1,
          imageUrl: _cartItems[existingIndex].imageUrl,
        );
      } else {
        _cartItems.removeAt(existingIndex);
      }
      notifyListeners();
    }
  }

  void clearCart() {
    _cartItems.clear();
    notifyListeners();
  }
}

class CartItem {
  final String imageUrl;
  final String name;
  final double price;
  final int quantity;

  CartItem({
    required this.imageUrl,
    required this.name,
    required this.price,
    required this.quantity,
  });
}