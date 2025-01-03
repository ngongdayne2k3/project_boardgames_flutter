import 'package:flutter/material.dart';
import '../services/user_service.dart'; // Sử dụng service trực tiếp
import '../models/user.dart';

class UserProfileScreen extends StatefulWidget {
  @override
  _UserProfileScreenState createState() => _UserProfileScreenState();
}

class _UserProfileScreenState extends State<UserProfileScreen> {
  final TextEditingController nameController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController phoneController = TextEditingController();
  final TextEditingController addressController = TextEditingController();
  final TextEditingController imageUrlController = TextEditingController();
  bool _isLoading = false;
  User? _user;

  @override
  void initState() {
    super.initState();
    _fetchUserProfile();
  }

  Future<void> _fetchUserProfile() async {
    setState(() => _isLoading = true);
    try {
      _user = await UserService.getUserProfile();
      if (_user != null) {
        nameController.text = _user!.name;
        emailController.text = _user!.email;
        phoneController.text = _user!.phoneNumber;
        addressController.text = _user!.address;
        imageUrlController.text = _user!.profileImageUrl ?? '';
      }
    } catch (e) {
      print('Error fetching user profile: $e');
    } finally {
      setState(() => _isLoading = false);
    }
  }

  Future<void> _updateProfile() async {
    setState(() => _isLoading = true);
    try {
      User updatedUser = User(
        id: _user!.id,
        name: nameController.text,
        email: emailController.text,
        phoneNumber: phoneController.text,
        address: addressController.text,
        profileImageUrl: imageUrlController.text.isNotEmpty ? imageUrlController.text : null,
        username: _user!.username,
        password: _user!.password,
        role: _user!.role,
      );
      await UserService.updateUser(updatedUser);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Profile updated successfully')),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to update profile: $e')),
      );
    } finally {
      setState(() => _isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('User Profile')),
      body: _isLoading
          ? Center(child: CircularProgressIndicator())
          : Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            if (_user?.profileImageUrl != null)
              CircleAvatar(
                backgroundImage: NetworkImage(_user!.profileImageUrl!),
                radius: 50,
              ),
            TextField(controller: nameController, decoration: InputDecoration(labelText: 'Name')),
            TextField(controller: emailController, decoration: InputDecoration(labelText: 'Email')),
            TextField(controller: phoneController, decoration: InputDecoration(labelText: 'Phone Number')),
            TextField(controller: addressController, decoration: InputDecoration(labelText: 'Address')),
            TextField(controller: imageUrlController, decoration: InputDecoration(labelText: 'Image URL (optional)')),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: _isLoading ? null : _updateProfile,
              child: _isLoading ? CircularProgressIndicator() : Text('Update Profile'),
            ),
          ],
        ),
      ),
    );
  }
}