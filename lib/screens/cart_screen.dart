import 'package:flutter/material.dart';
import '../models/cart.dart';
import '../services/cart_service.dart'; // Sử dụng service trực tiếp

class CartScreen extends StatefulWidget {
  @override
  _CartScreenState createState() => _CartScreenState();
}

class _CartScreenState extends State<CartScreen> {
  Cart? _cart;
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    _fetchCart();
  }

  Future<void> _fetchCart() async {
    setState(() => _isLoading = true);
    try {
      _cart = await CartService.getCart();
    } catch (e) {
      print('Error fetching cart: $e');
    } finally {
      setState(() => _isLoading = false);
    }
  }

  Future<void> _removeFromCart(int cartItemId) async {
    setState(() => _isLoading = true);
    try {
      await CartService.removeFromCart(cartItemId);
      _fetchCart(); // Cập nhật lại giỏ hàng
    } catch (e) {
      print('Error removing item from cart: $e');
    } finally {
      setState(() => _isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Cart')),
      body: _isLoading
          ? Center(child: CircularProgressIndicator())
          : ListView.builder(
        itemCount: _cart?.items.length ?? 0,
        itemBuilder: (context, index) {
          final item = _cart!.items[index];
          return ListTile(
            title: Text(item.product.name),
            subtitle: Text('Quantity: ${item.quantity}'),
            trailing: IconButton(
              icon: Icon(Icons.delete),
              onPressed: () => _removeFromCart(item.id!),
            ),
          );
        },
      ),
    );
  }
}