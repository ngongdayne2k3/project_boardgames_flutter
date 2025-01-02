import 'package:flutter/material.dart';
import '../models/cart.dart';
import 'customer_info_screen.dart';

class CartScreen extends StatefulWidget {
  final Cart cart;

  CartScreen({required this.cart});

  @override
  _CartScreenState createState() => _CartScreenState();
}

class _CartScreenState extends State<CartScreen> {
  double getTotalPrice() {
    double total = 0;
    if (widget.cart.items != null) {
      for (var item in widget.cart.items!) {
        total += item.price * item.quantity;
      }
    }
    return total;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Giỏ hàng'),
      ),
      body: Stack(
        children: [
          ListView.builder(
            itemCount: widget.cart.items?.length ?? 0,
            itemBuilder: (context, index) {
              final item = widget.cart.items![index];
              return ListTile(
                leading: CircleAvatar(
                  backgroundImage: NetworkImage(item.imageUrl),
                ),
                title: Text(item.productName),
                subtitle: Text('Giá: ${item.price.toString()} VND'),
                trailing: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Column(
                      children: [
                        Text('Số lượng:'),
                        Expanded(
                          child: Row(
                            children: [
                              Container(
                                width: 30,
                                height: 30,
                                alignment: Alignment.center,
                                child: IconButton(
                                  icon: Icon(Icons.remove),
                                  iconSize: 24,
                                  padding: EdgeInsets.zero,
                                  onPressed: () {
                                    setState(() {
                                      if (item.quantity > 1) {
                                        item.quantity--;
                                      } else {
                                        widget.cart.removeProduct(item.productName);
                                      }
                                    });
                                  },
                                ),
                              ),
                              const SizedBox(width: 2),
                              Text('${item.quantity}'),
                              const SizedBox(width: 2),
                              Container(
                                width: 30,
                                height: 30,
                                alignment: Alignment.center,
                                child: IconButton(
                                  icon: Icon(Icons.add),
                                  iconSize: 24,
                                  padding: EdgeInsets.zero,
                                  onPressed: () {
                                    setState(() {
                                      item.quantity++;
                                    });
                                  },
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                    IconButton(
                      icon: Icon(Icons.remove_shopping_cart),
                      onPressed: () {
                        setState(() {
                          widget.cart.removeProduct(item.productName);
                        });
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(content: Text('Đã xóa ${item.productName} khỏi giỏ hàng!')),
                        );
                      },
                    ),
                  ],
                ),
              );
            },
          ),
          Align(
            alignment: Alignment.bottomRight,
            child: Container(
              padding: EdgeInsets.all(16.0),
              margin: EdgeInsets.all(16.0),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(8),
                boxShadow: [
                  BoxShadow(
                    color: Colors.grey.withOpacity(0.5),
                    spreadRadius: 2,
                    blurRadius: 5,
                    offset: Offset(0, 3),
                  ),
                ],
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Text(
                    'Tổng tiền: ${getTotalPrice().toString()} VND',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  SizedBox(height: 8),
                  ElevatedButton(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => CustomerInfoForm(cart: widget.cart),
                        ),
                      );
                    },
                    child: Text('Thanh toán'),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}