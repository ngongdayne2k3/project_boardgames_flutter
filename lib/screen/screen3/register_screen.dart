import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'auth_provider.dart';
import 'package:project_boardgames_flutter/models/user.dart';
import 'package:project_boardgames_flutter/models/role.dart';

class RegisterScreen extends StatelessWidget {
  final TextEditingController nameController = TextEditingController();
  final TextEditingController usernameController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController phoneNumberController = TextEditingController();
  final TextEditingController addressController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    final authProvider = Provider.of<AuthProvider>(context);

    return Scaffold(
      appBar: AppBar(
        title: Text('Register'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              controller: nameController,
              decoration: InputDecoration(labelText: 'Name'),
            ),
            TextField(
              controller: usernameController,
              decoration: InputDecoration(labelText: 'Username'),
            ),
            TextField(
              controller: passwordController,
              decoration: InputDecoration(labelText: 'Password'),
              obscureText: true,
            ),
            TextField(
              controller: emailController,
              decoration: InputDecoration(labelText: 'Email'),
            ),
            TextField(
              controller: phoneNumberController,
              decoration: InputDecoration(labelText: 'Phone Number'),
            ),
            TextField(
              controller: addressController,
              decoration: InputDecoration(labelText: 'Address'),
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                // Tạo ID mới bằng cách tìm ID lớn nhất và cộng thêm 1
                int newId = authProvider.users.isEmpty
                    ? 1
                    : authProvider.users.map((u) => u.id ?? 0).reduce((max, id) => id > max ? id : max) + 1;

                User newUser = User(
                  id: newId, // Sử dụng ID mới
                  name: nameController.text,
                  username: usernameController.text,
                  password: passwordController.text,
                  email: emailController.text,
                  phoneNumber: phoneNumberController.text,
                  address: addressController.text,
                  role: Role.customer, // Mặc định là khách hàng
                );

                authProvider.addUser(newUser); // Thêm người dùng mới
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text('Registration successful')),
                );
                Navigator.pop(context);
              },
              child: Text('Register'),
            ),
          ],
        ),
      ),
    );
  }
}