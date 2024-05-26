import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:go_router/go_router.dart';
import 'dart:convert';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({Key? key}) : super(key: key);

  @override
  State<ProfileScreen> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfileScreen> {
  late Map<String, dynamic> _userData = {};

  @override
  void initState() {
    super.initState();
    _loadUserData();
  }

  Future<void> _loadUserData() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? userDataString = prefs.getString('loggedInUserData');
    if (userDataString != null) {
      setState(() {
        _userData = json.decode(userDataString);
      });
    }
  }

  Future<void> _signOut(BuildContext context) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.remove('isLoggedIn');
    await prefs.remove('loggedInUserData');
    context.goNamed("signin");
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
        ],
      ),
      body: _userData.isEmpty
          ? const Center(
        child: CircularProgressIndicator(),
      )
          :Container(
        width: double.infinity,
        child: Column(
          children: [
            const Padding(
              padding: EdgeInsets.fromLTRB(0.0, 40.0, 0.0, 30.0),
              child: Center(
                child: CircleAvatar(
                  radius: 80,
                  // backgroundImage: AssetImage('images/profile.png'),
                ),
              ),
            ),
            Text(
              _userData['email'].split('@').first,
              style: const TextStyle(
                fontSize: 26,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 20),
            _userData.isNotEmpty
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
                      style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 20
                      ),
                    ),
                    Text(
                      _userData['email'],
                      style: const TextStyle(
                          fontSize: 20,
                          color: Colors.black54
                      ),
                    ),
                    const SizedBox(height: 16),
                    const Text(
                      'Date of Birth',
                      style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 20
                      ),
                    ),
                    Text(
                      _userData['birthDate'],
                      style: const TextStyle(
                          fontSize: 20,
                          color: Colors.black54
                      ),
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
    );
  }
}


