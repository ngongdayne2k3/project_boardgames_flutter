import 'package:flutter/material.dart';
import 'package:project_boardgames_flutter/screen/screen3/customer_detail_screen.dart';
import 'package:provider/provider.dart';
import 'auth_provider.dart';
import 'package:project_boardgames_flutter/models/user.dart';
import 'package:project_boardgames_flutter/models/role.dart';

class ManageCustomersScreen extends StatelessWidget {
  final TextEditingController searchController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    final authProvider = Provider.of<AuthProvider>(context);
    final customers = authProvider.users.where((u) => u.role == Role.customer).toList();

    return Scaffold(
      appBar: AppBar(
        title: Text('Manage Customers'),
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: TextField(
              controller: searchController,
              decoration: InputDecoration(
                labelText: 'Search by Customer ID',
                suffixIcon: IconButton(
                  icon: Icon(Icons.search),
                  onPressed: () {
                    // Tìm kiếm khách hàng dựa trên ID
                  },
                ),
              ),
            ),
          ),
          Expanded(
            child: ListView.builder(
              itemCount: customers.length,
              itemBuilder: (context, index) {
                final customer = customers[index];
                return ListTile(
                  title: Text(customer.name ?? 'Unknown'),
                  subtitle: Text('ID: ${customer.id}'),
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => CustomerDetailScreen(customer: customer),
                      ),
                    );
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}