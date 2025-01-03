import 'package:flutter/material.dart';
import '../services/user_service.dart'; // Sử dụng service trực tiếp
import '../models/user.dart';

class CustomerProfileScreen extends StatefulWidget {
  @override
  _CustomerProfileScreenState createState() => _CustomerProfileScreenState();
}

class _CustomerProfileScreenState extends State<CustomerProfileScreen> {
  User? _user;
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    _fetchUserProfile();
  }

  Future<void> _fetchUserProfile() async {
    setState(() => _isLoading = true);
    try {
      _user = await UserService.getUserProfile();
    } catch (e) {
      print('Error fetching user profile: $e');
    } finally {
      setState(() => _isLoading = false);
    }
  }

  Future<void> _logout() async {
    setState(() => _isLoading = true);
    try {
      // Xóa token hoặc thực hiện đăng xuất
      Navigator.pushReplacementNamed(context, '/login');
    } catch (e) {
      print('Error logging out: $e');
    } finally {
      setState(() => _isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Profile')),
      body: _isLoading
          ? Center(child: CircularProgressIndicator())
          : Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Name: ${_user?.name}', style: TextStyle(fontSize: 18)),
            Text('Email: ${_user?.email}', style: TextStyle(fontSize: 18)),
            Text('Phone: ${_user?.phoneNumber}', style: TextStyle(fontSize: 18)),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: _isLoading ? null : _logout,
              child: _isLoading ? CircularProgressIndicator() : Text('Logout'),
            ),
          ],
        ),
      ),
    );
  }
}