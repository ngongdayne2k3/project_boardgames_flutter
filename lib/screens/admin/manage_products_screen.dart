import 'package:flutter/material.dart';
import 'package:project_boardgames_flutter/models/board_game.dart';
import 'package:project_boardgames_flutter/database/database_helper.dart';

import '../../models/brand.dart';
import '../../models/category.dart';

class ManageProductsScreen extends StatefulWidget {
  @override
  _ManageProductsScreenState createState() => _ManageProductsScreenState();
}

class _ManageProductsScreenState extends State<ManageProductsScreen> {
  final DatabaseHelper _dbHelper = DatabaseHelper();
  List<BoardGame> _products = [];
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _priceController = TextEditingController();
  final _stockController = TextEditingController();
  final _descriptionController = TextEditingController();
  final _imageUrlController = TextEditingController();
  String? _selectedCategoryId;
  String? _selectedBrandId;

  List<Category> _categories = [];
  List<Brand> _brands = [];

  @override
  void initState() {
    super.initState();
    _loadProducts();
  }
  Future<void> _loadCategories() async {
    final categories = await _dbHelper.getAllCategories();
    setState(() {
      _categories = categories;
    });
  }
  Future<void> _loadBrands() async {
    final brands = await _dbHelper.getAllBrands();
    setState(() {
      _brands = brands;
    });
  }

  Future<void> _loadProducts() async {
    try {
      final products = await _dbHelper.getAllBoardGames();
      setState(() {
        _products = products;
      });
    } catch (e) {
      print('Error loading products: $e');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Có lỗi xảy ra khi tải danh sách sản phẩm: $e')),
      );
    }
  }

  Future<void> _addProduct() async {
    try{
    if (_formKey.currentState!.validate()) {
      if (_selectedCategoryId == null || _selectedBrandId == null) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Vui lòng chọn category và brand')),
        );
        return;
      }
      final newProduct = BoardGame(
        id: DateTime.now().millisecondsSinceEpoch.toString(),
        name: _nameController.text,
        category: Category(id: _selectedCategoryId!, name: ''), // Đảm bảo _selectedCategoryId không null
        brand: Brand(id: _selectedBrandId!, name: ''), // Đảm bảo _selectedBrandId không null
        price: double.parse(_priceController.text),
        stock: int.parse(_stockController.text),
        description: _descriptionController.text,
        imageUrl: _imageUrlController.text,
      );
      print('Adding product: ${newProduct.toMap()}');

      await _dbHelper.insertBoardGame(newProduct);
      _loadProducts(); // Tải lại danh sách sản phẩm sau khi thêm
      _clearForm(); // Xóa form sau khi thêm
      Navigator.of(context).pop();
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Sản phẩm đã được thêm thành công')),
      );

    }
  }catch (e) {
  // Xử lý lỗi nếu có
  print('Error adding product: $e');
  ScaffoldMessenger.of(context).showSnackBar(
  SnackBar(content: Text('Có lỗi xảy ra khi thêm sản phẩm: $e')),
  );
  }
}

  Future<void> _editProduct(BoardGame product) async {
    _nameController.text = product.name;
    _priceController.text = product.price.toString();
    _stockController.text = product.stock.toString();
    _descriptionController.text = product.description;
    _imageUrlController.text = product.imageUrl;
    _selectedCategoryId = product.category.id;
    _selectedBrandId = product.brand.id;

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text('Edit Product'),
          content: Form(
            key: _formKey,
            child: SingleChildScrollView(
              child: Column(
                children: [
                  TextFormField(
                    controller: _nameController,
                    decoration: InputDecoration(labelText: 'Name'),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter a name';
                      }
                      return null;
                    },
                  ),
                  TextFormField(
                    controller: _priceController,
                    decoration: InputDecoration(labelText: 'Price'),
                    keyboardType: TextInputType.number,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter a price';
                      }
                      return null;
                    },
                  ),
                  TextFormField(
                    controller: _stockController,
                    decoration: InputDecoration(labelText: 'Stock'),
                    keyboardType: TextInputType.number,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter stock quantity';
                      }
                      return null;
                    },
                  ),
                  TextFormField(
                    controller: _descriptionController,
                    decoration: InputDecoration(labelText: 'Description'),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter a description';
                      }
                      return null;
                    },
                  ),
                  TextFormField(
                    controller: _imageUrlController,
                    decoration: InputDecoration(labelText: 'Image URL'),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter an image URL';
                      }
                      return null;
                    },
                  ),

                  DropdownButtonFormField<String>(
                    value: _selectedCategoryId,
                    hint: Text('Select Category'),
                    items: _categories.map((category) {
                      return DropdownMenuItem(
                        value: category.id,
                        child: Text(category.name),
                      );
                    }).toList(),
                    onChanged: (value) {
                      setState(() {
                        _selectedCategoryId = value;
                      });
                    },
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please select a category';
                      }
                      return null;
                    },
                  ),
                  DropdownButtonFormField<String>(
                    value: _selectedBrandId,
                    hint: Text('Select Brand'),
                    items: _brands.map((brand) {
                      return DropdownMenuItem(
                        value: brand.id,
                        child: Text(brand.name),
                      );
                    }).toList(),
                    onChanged: (value) {
                      setState(() {
                        _selectedBrandId = value;
                      });
                    },
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please select a brand';
                      }
                      return null;
                    },
                  ),
                ],
              ),
            ),
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text('Cancel'),
            ),
            TextButton(
              onPressed: () async {
                if (_formKey.currentState!.validate()) {
                  final updatedProduct = BoardGame(
                    id: product.id,
                    name: _nameController.text,
                    category: Category(id: _selectedCategoryId!, name: ''),
                    brand: Brand(id: _selectedBrandId!, name: ''),
                    price: double.parse(_priceController.text),
                    stock: int.parse(_stockController.text),
                    description: _descriptionController.text,
                    imageUrl: _imageUrlController.text,
                  );

                  await _dbHelper.updateBoardGame(updatedProduct);
                  _loadProducts();
                  _clearForm();
                  Navigator.of(context).pop();
                }
              },
              child: Text('Save'),
            ),
          ],
        );
      },
    );
  }

  Future<void> _deleteProduct(String productId) async {
    await _dbHelper.deleteBoardGame(productId);
    _loadProducts();
  }

  void _clearForm() {
    _nameController.clear();
    _priceController.clear();
    _stockController.clear();
    _descriptionController.clear();
    _imageUrlController.clear();
    _selectedCategoryId = null;
    _selectedBrandId = null;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Manage Products'),
      ),
      body: Column(
        children: [
          Expanded(
            child: ListView.builder(
              itemCount: _products.length,
              itemBuilder: (context, index) {
                final product = _products[index];
                return ListTile(
                  title: Text(product.name),
                  subtitle: Text('\$${product.price} - Stock: ${product.stock}'),
                  trailing: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      IconButton(
                        icon: Icon(Icons.edit),
                        onPressed: () => _editProduct(product),
                      ),
                      IconButton(
                        icon: Icon(Icons.delete),
                        onPressed: () => _deleteProduct(product.id),
                      ),
                    ],
                  ),
                );
              },
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: ElevatedButton(
              onPressed: () {
                showDialog(
                  context: context,
                  builder: (context) {
                    return AlertDialog(
                      title: Text('Add Product'),
                      content: Form(
                        key: _formKey,
                        child: SingleChildScrollView(
                          child: Column(
                            children: [
                              TextFormField(
                                controller: _nameController,
                                decoration: InputDecoration(labelText: 'Name'),
                                validator: (value) {
                                  if (value == null || value.isEmpty) {
                                    return 'Please enter a name';
                                  }
                                  return null;
                                },
                              ),
                              TextFormField(
                                controller: _priceController,
                                decoration: InputDecoration(labelText: 'Price'),
                                keyboardType: TextInputType.number,
                                validator: (value) {
                                  if (value == null || value.isEmpty) {
                                    return 'Please enter a price';
                                  }
                                  return null;
                                },
                              ),
                              TextFormField(
                                controller: _stockController,
                                decoration: InputDecoration(labelText: 'Stock'),
                                keyboardType: TextInputType.number,
                                validator: (value) {
                                  if (value == null || value.isEmpty) {
                                    return 'Please enter stock quantity';
                                  }
                                  return null;
                                },
                              ),
                              TextFormField(
                                controller: _descriptionController,
                                decoration: InputDecoration(labelText: 'Description'),
                                validator: (value) {
                                  if (value == null || value.isEmpty) {
                                    return 'Please enter a description';
                                  }
                                  return null;
                                },
                              ),
                              TextFormField(
                                controller: _imageUrlController,
                                decoration: InputDecoration(labelText: 'Image URL'),
                                validator: (value) {
                                  if (value == null || value.isEmpty) {
                                    return 'Please enter an image URL';
                                  }
                                  return null;
                                },
                              ),
                              DropdownButtonFormField<String>(
                                value: _selectedCategoryId,
                                hint: Text('Select Category'),
                                items: _categories.map((category) {
                                  return DropdownMenuItem(
                                    value: category.id,
                                    child: Text(category.name),
                                  );
                                }).toList(),
                                onChanged: (value) {
                                  setState(() {
                                    _selectedCategoryId = value;
                                  });
                                },
                                validator: (value) {
                                  if (value == null || value.isEmpty) {
                                    return 'Please select a category';
                                  }
                                  return null;
                                },
                              ),
                              DropdownButtonFormField<String>(
                                value: _selectedBrandId,
                                hint: Text('Select Brand'),
                                items: _brands.map((brand) {
                                  return DropdownMenuItem(
                                    value: brand.id,
                                    child: Text(brand.name),
                                  );
                                }).toList(),
                                onChanged: (value) {
                                  setState(() {
                                    _selectedBrandId = value;
                                  });
                                },
                                validator: (value) {
                                  if (value == null || value.isEmpty) {
                                    return 'Please select a brand';
                                  }
                                  return null;
                                },
                              ),
                            ],
                          ),
                        ),
                      ),
                      actions: [
                        TextButton(
                          onPressed: () {
                            Navigator.of(context).pop();
                          },
                          child: Text('Cancel'),
                        ),
                        TextButton(
                          onPressed: _addProduct,
                          child: Text('Add'),
                        ),
                      ],
                    );
                  },
                );
              },
              child: Text('Add Product'),
            ),
          ),
        ],
      ),
    );
  }
}