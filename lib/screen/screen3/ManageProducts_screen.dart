import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart'; // Thêm import này
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';
import 'product_provider.dart';

class ManageProductsScreen extends StatefulWidget {
  @override
  _ManageProductsScreenState createState() => _ManageProductsScreenState();
}

class _ManageProductsScreenState extends State<ManageProductsScreen> {
  final _formKey = GlobalKey<FormState>();
  String? productName, productCode, category, manufacturer;
  double? price;
  File? productImage;

  Future<void> pickImage() async {
    final pickedFile = await ImagePicker().pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      setState(() {
        productImage = File(pickedFile.path);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final productProvider = Provider.of<ProductProvider>(context);

    return Scaffold(
      appBar: AppBar(
        title: Text('Manage Products'),
      ),
      body: Column(
        children: [
          Expanded(
            child: ListView.builder(
              itemCount: productProvider.products.length,
              itemBuilder: (context, index) {
                final product = productProvider.products[index];
                return ListTile(
                  leading: product['image'] != null
                      ? kIsWeb // Kiểm tra nếu là web
                      ? Image.network(product['image'].path) // Sử dụng Image.network cho web
                      : Image.file(product['image'], width: 50, height: 50, fit: BoxFit.cover) // Sử dụng Image.file cho các nền tảng khác
                      : Icon(Icons.image),
                  title: Text(product['name'] ?? ''),
                  subtitle: Text(product['code'] ?? ''),
                  trailing: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      IconButton(
                        icon: Icon(Icons.edit),
                        onPressed: () => editProduct(context, productProvider, index),
                      ),
                      IconButton(
                        icon: Icon(Icons.delete),
                        onPressed: () => productProvider.deleteProduct(index),
                      ),
                    ],
                  ),
                );
              },
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: ElevatedButton(
              onPressed: () {
                showDialog(
                  context: context,
                  builder: (_) => AlertDialog(
                    title: Text('Add Product'),
                    content: buildProductForm(() {
                      if (_formKey.currentState!.validate()) {
                        _formKey.currentState!.save();
                        productProvider.addProduct({
                          'name': productName,
                          'code': productCode,
                          'price': price,
                          'category': category,
                          'manufacturer': manufacturer,
                          'image': productImage,
                        });
                        Navigator.pop(context);
                      }
                    }),
                  ),
                );
              },
              child: Text('Add Product'),
            ),
          ),
        ],
      ),
    );
  }

  void editProduct(BuildContext context, ProductProvider productProvider, int index) {
    final product = productProvider.products[index];
    setState(() {
      productName = product['name'];
      productCode = product['code'];
      price = product['price'];
      category = product['category'];
      manufacturer = product['manufacturer'];
      productImage = product['image'];
    });

    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: Text('Edit Product'),
        content: buildProductForm(() {
          if (_formKey.currentState!.validate()) {
            _formKey.currentState!.save();
            productProvider.editProduct(index, {
              'name': productName,
              'code': productCode,
              'price': price,
              'category': category,
              'manufacturer': manufacturer,
              'image': productImage,
            });
            Navigator.pop(context);
          }
        }),
      ),
    );
  }

  Widget buildProductForm(VoidCallback onSave) {
    return Form(
      key: _formKey,
      child: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextFormField(
              initialValue: productName,
              decoration: InputDecoration(labelText: 'Product Name'),
              onSaved: (value) => productName = value,
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Required field';
                }
                return null;
              },
            ),
            TextFormField(
              initialValue: productCode,
              decoration: InputDecoration(labelText: 'Product Code'),
              onSaved: (value) => productCode = value,
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Required field';
                }
                return null;
              },
            ),
            TextFormField(
              initialValue: price?.toString(),
              decoration: InputDecoration(labelText: 'Price'),
              keyboardType: TextInputType.number,
              onSaved: (value) => price = double.tryParse(value ?? ''),
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Required field';
                }
                return null;
              },
            ),
            TextFormField(
              initialValue: category,
              decoration: InputDecoration(labelText: 'Category'),
              onSaved: (value) => category = value,
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Required field';
                }
                return null;
              },
            ),
            TextFormField(
              initialValue: manufacturer,
              decoration: InputDecoration(labelText: 'Manufacturer'),
              onSaved: (value) => manufacturer = value,
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Required field';
                }
                return null;
              },
            ),
            SizedBox(height: 10),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(productImage == null ? 'No image selected' : 'Image selected'),
                ElevatedButton(
                  onPressed: pickImage,
                  child: Text('Browse'),
                ),
              ],
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: onSave,
              child: Text('Save'),
            ),
          ],
        ),
      ),
    );
  }
}