import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:pharmaco/Pages/Pharma.dart';
import 'package:pharmaco/Pages/PharmaDash.dart';
import 'package:pharmaco/Pages/login.dart';
import 'package:pharmaco/components/splash_screen.dart';
import 'package:provider/provider.dart';
import 'package:timezone/data/latest_all.dart' as tz;
import 'Provider.dart'; // Assuming Provider.dart contains your alarmprovider class
import 'Add_Alarm.dart'; // Assuming Add_Alarm.dart contains your AddAlarm widget

class PharmaSet extends StatefulWidget {
  const PharmaSet({Key? key}) : super(key: key);

  @override
  State<PharmaSet> createState() => _PharmaSetState();
}

class _PharmaSetState extends State<PharmaSet> {
  bool notifyPatient = false;
  User? user = FirebaseAuth.instance.currentUser;

  void signUserOut(BuildContext context) async {
    try {
      await FirebaseAuth.instance.signOut();
      Navigator.of(context).pushReplacement(MaterialPageRoute(
        builder: (context) => const login(), // Assuming Login.dart contains your login page
      ));
    } catch (e) {
      print('Error signing out: $e');
    }
  }

  String? getPharmacyName(String? userEmail) {
    if (userEmail == null) {
      return null;
    }

    List<String> pharmacies = [
      'BasicPharma',
      'MedRevive',
      'QuantumMeds',
      'TariqMedical',
      'VitalBlend',
    ];

    String lowercaseEmail = userEmail.toLowerCase();

    for (String pharmacy in pharmacies) {
      if (lowercaseEmail.contains(pharmacy.toLowerCase())) {
        return pharmacy;
      }
    }
    return null;
  }

  @override
  Widget build(BuildContext context) {
    tz.initializeTimeZones();
    return ChangeNotifierProvider(
      create: (context) => alarmprovider(),
      child: Scaffold(
        drawer: Drawer(
          elevation: 4,
          child: Container(
            color: const Color(0xFF075e54),
            child: Column(
              children: <Widget>[
                UserAccountsDrawerHeader(
                  accountName: Text(
                    getPharmacyName(user?.email) ?? '',
                    style: const TextStyle(color: Colors.white),
                  ),
                  accountEmail: Text(
                    user?.email ?? '',
                    style: const TextStyle(color: Colors.white),
                  ),
                  currentAccountPicture: const CircleAvatar(
                    backgroundColor: Colors.white,
                    child: Icon(
                      Icons.person,
                      color: Color(0xFF075e54),
                    ),
                  ),
                  decoration: const BoxDecoration(
                    color: Color(0xFF075e54),
                  ),
                ),
                ListTile(
                  leading: const Icon(Icons.home, color: Colors.grey),
                  title: const Text(
                    'Home',
                    style: TextStyle(color: Colors.grey),
                  ),
                  onTap: () => Navigator.of(context).push(MaterialPageRoute(
                    builder: (context) => const splash(nextScreen: PharmacistHome()), // Assuming PharmacistHome.dart contains your home page
                  )),
                ),
                ListTile(
                  leading: const Icon(Icons.dashboard_rounded, color: Colors.grey),
                  title: const Text(
                    'Dashboard',
                    style: TextStyle(color: Colors.grey),
                  ),
                  onTap: () {
                    Navigator.of(context).push(MaterialPageRoute(
                      builder: (context) => const PharmaDash(), // Assuming PharmaDash.dart contains your dashboard page
                    ));
                  },
                ),
                ListTile(
                  leading: const Icon(Icons.settings, color: Colors.white),
                  title: const Text(
                    'Settings',
                    style: TextStyle(color: Colors.white),
                  ),
                  onTap: () {},
                ),
                const Divider(color: Colors.white),
                ListTile(
                  leading: const Icon(Icons.logout, color: Colors.grey),
                  title: const Text(
                    'Logout',
                    style: TextStyle(color: Colors.grey),
                  ),
                  onTap: () => signUserOut(context),
                ),
              ],
            ),
          ),
        ),
        body: Container(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 30),
              const Text(
                'Pharmacist Settings',
                style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 16.0),
              SwitchListTile(
                title: const Text('Notify Patient'),
                value: notifyPatient,
                onChanged: (value) {
                  setState(() {
                    notifyPatient = value;
                    if (notifyPatient) {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => const AddAlarm()),
                      );
                    }
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
                onTap: () {},
              ),
            ],
          ),
        ),
      ),
    );
  }
}
