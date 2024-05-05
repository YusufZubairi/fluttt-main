import 'package:flutter/material.dart';
import 'package:pharmaco/Services/auth_services.dart';

class Settings extends StatefulWidget {
  const Settings({super.key});

  @override
  State<Settings> createState() => _SettingsState();
}

class _SettingsState extends State<Settings> {
  bool notifyPharmacist = false;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Patient Settings',
            style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 16.0),
          SwitchListTile(
            title: const Text('Notify Pharmacist'),
            value: notifyPharmacist,
            onChanged: (value) {
              setState(() {
                notifyPharmacist = value;
              });
            },
          ),
          const SizedBox(height: 16.0),
          ListTile(
            title: const Text('Change Password'),
            onTap: () {
              // Navigate to the change password screen
            },
          ),
          const SizedBox(height: 16.0),
          ListTile(
            title: const Text('Logout'),
            onTap: () {
              AuthService().signUserOut(context);
            },
          ),
        ],
      ),
    );
  }
}