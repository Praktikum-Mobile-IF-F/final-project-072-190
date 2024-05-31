import 'dart:convert';

import 'package:final_project/models/user.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  late String _email = '';
  User? currentUser;
  bool _isEditing = false;
  final TextEditingController _addressController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _loadUser();
  }

  Future<void> _loadUser() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? userJson = prefs.getString('user');
    if (userJson != null) {
      setState(() {
        _email = json.decode(userJson)['email'];
      });

      final userBox = await Hive.openBox<User>('userBox');
      User? currentUser = userBox.values.firstWhere((user) => user.email == _email);
      if (currentUser != null) {
        setState(() {
          this.currentUser = currentUser;
          _addressController.text = currentUser.address ?? '';
        });
      }
    }
  }

  Future<void> _signOut(BuildContext context) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setBool('isLoggedIn', false);
    await prefs.remove('user');
    context.go('/signin');
  }

  Future<void> _saveProfile() async {
    if (currentUser != null) {
      final userBox = await Hive.openBox<User>('userBox');
      currentUser!.address = _addressController.text;
      await currentUser!.save();
      setState(() {
        _isEditing = false;
      });
    }
  }

  @override
  void dispose() {
    _addressController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Profile',
          style: TextStyle(
            fontWeight: FontWeight.bold,
          ),
        ),
        centerTitle: true,
        actions: [
          IconButton(
            icon: const Icon(
              Icons.logout,
            ),
            onPressed: () => _signOut(context),
          ),
          IconButton(
            icon: Icon(
              _isEditing ? Icons.check : Icons.edit,
            ),
            onPressed: () {
              if (_isEditing) {
                _saveProfile();
              } else {
                setState(() {
                  _isEditing = true;
                });
              }
            },
          ),
        ],
      ),
      body: _email.isEmpty
          ? const Center(
        child: CircularProgressIndicator(),
      )
          : SingleChildScrollView(
            child: Container(
                    width: double.infinity,
                    child: Column(
            children: [
              const Padding(
                padding: EdgeInsets.fromLTRB(0.0, 40.0, 0.0, 30.0),
                child: Center(
                  child: CircleAvatar(
                    radius: 80,
                    backgroundImage: AssetImage('lib/assets/images/profile.png'),
                  ),
                ),
              ),
              Text(
                _email.split('@').first,
                style: const TextStyle(
                  fontSize: 26,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 20),
              _email.isNotEmpty
                  ? Container(
                width: double.infinity,
                child: Padding(
                  padding: const EdgeInsets.symmetric(vertical: 10.0, horizontal: 30.0),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const SizedBox(height: 10),
                      const Text(
                        'Email',
                        style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
                      ),
                      Text(
                        currentUser?.email ?? 'No email available',
                        style: const TextStyle(fontSize: 20, color: Colors.black54),
                      ),
                      const SizedBox(height: 16),
                      const Text(
                        'Date of Birth',
                        style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
                      ),
                      Text(
                        currentUser?.birth ?? 'No date of birth available',
                        style: const TextStyle(fontSize: 20, color: Colors.black54),
                      ),
                      const SizedBox(height: 16),
                      const Text(
                        'Address',
                        style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
                      ),
                      _isEditing
                          ? TextField(
                        controller: _addressController,
                        decoration: const InputDecoration(
                          hintText: 'Enter address',
                        ),
                      )
                          : Text(
                        currentUser?.address ?? 'No address available',
                        style: const TextStyle(fontSize: 20, color: Colors.black54),
                      ),
                    ],
                  ),
                ),
              )
                  : const Text(
                'No user data available',
                style: TextStyle(fontSize: 18),
              ),
            ],
                    ),
                  ),
          ),
    );
  }
}
