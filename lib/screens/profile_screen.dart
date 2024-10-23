import 'package:flutter/material.dart';
import 'farmer_registration_screen.dart';

class ProfileScreen extends StatefulWidget {
  @override
  _ProfileScreenState createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  bool _isRegistered = false;
  bool _isFarmer = false;
  Map<String, String> _userDetails = {};

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              _buildHeader(),
              SizedBox(height: 20),
              if (!_isRegistered)
                _buildRegistrationOptions()
              else
                _buildUserProfile(),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return Container(
      padding: EdgeInsets.all(20),
      color: Colors.green,
      child: Column(
        children: [
          CircleAvatar(
            radius: 50,
            backgroundImage: AssetImage('assets/images/profile_placeholder.jpg'),
          ),
          SizedBox(height: 10),
          Text(
            'Profile',
            style: TextStyle(fontSize: 24, color: Colors.white, fontWeight: FontWeight.bold),
          ),
        ],
      ),
    );
  }

  Widget _buildRegistrationOptions() {
    return Padding(
      padding: EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          ElevatedButton(
            onPressed: () => _navigateToFarmerRegistration(),
            child: Text('Farmer Registration'),
          ),
          SizedBox(height: 10),
          ElevatedButton(
            onPressed: () {
              // TODO: Implement customer registration
            },
            child: Text('Customer Registration'),
          ),
        ],
      ),
    );
  }

  void _navigateToFarmerRegistration() async {
    final result = await Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => FarmerRegistrationScreen()),
    );
    if (result != null) {
      setState(() {
        _isRegistered = true;
        _isFarmer = true;
        _userDetails = result;
      });
    }
  }

  Widget _buildUserProfile() {
    return Padding(
      padding: EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            _isFarmer ? 'Farmer Profile' : 'Customer Profile',
            style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
          ),
          SizedBox(height: 20),
          _buildProfileItem('Name', _userDetails['name'] ?? ''),
          _buildProfileItem(_isFarmer ? 'Farm Location' : 'Address', _userDetails['location'] ?? ''),
          _buildProfileItem('Contact', _userDetails['contact'] ?? ''),
          _buildProfileItem('Email', _userDetails['email'] ?? ''),
          SizedBox(height: 20),
          ElevatedButton(
            onPressed: () {
              setState(() {
                _isRegistered = false;
                _userDetails.clear();
              });
            },
            child: Text('Log Out'),
          ),
        ],
      ),
    );
  }

  Widget _buildProfileItem(String label, String value) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 8),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 100,
            child: Text(
              '$label:',
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
          ),
          Expanded(
            child: Text(value),
          ),
        ],
      ),
    );
  }
}
