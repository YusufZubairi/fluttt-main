import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:pharmaco/Pages/PharmaDash.dart';
import 'package:pharmaco/Pages/Settings.dart';
import 'package:pharmaco/Pages/login.dart';
import 'package:pharmaco/components/PharmaNav.dart';
import 'package:pharmaco/components/splash_screen.dart';
import 'package:pharmaco/objects/pharmacyData.dart';

class PharmacistHome extends StatefulWidget {
  const PharmacistHome({
    super.key,
  }); // Constructor with splashScreenPath parameter
  @override
  State<PharmacistHome> createState() => _PharmacistHomeState();
}

class _PharmacistHomeState extends State<PharmacistHome> {
  final MyData _obj = MyData();

  bool isCardTapped1 = false;
  bool isCardTapped2 = false;
  bool isCardTapped3 = false;
  bool isCardTapped4 = false;
  final User user = FirebaseAuth.instance.currentUser!;
  String currentPage = 'Home';

  void signUserOut(BuildContext context) async {
    try {
      await FirebaseAuth.instance.signOut();
      Navigator.of(context).pushReplacement(MaterialPageRoute(
        builder: (context) => const login(),
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

  void openMedBox() {
    GlobalKey<FormState> formKey = GlobalKey<FormState>();
    TextEditingController medicineIdController = TextEditingController();
    TextEditingController brandNameController = TextEditingController();
    TextEditingController companyNameController = TextEditingController();
    TextEditingController formulationController = TextEditingController();
    TextEditingController mrpController = TextEditingController();
    TextEditingController packSizeController = TextEditingController();
    TextEditingController registrationNumberController =
        TextEditingController();

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Create Medicine'),
        content: SingleChildScrollView(
          child: Form(
            key: formKey,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                TextFormField(
                  controller: medicineIdController,
                  decoration: const InputDecoration(labelText: 'Medicine ID'),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      const SnackBar(
                        content: Row(
                          children: [
                            Icon(Icons.error_outline),
                            SizedBox(width: 20),
                            Expanded(child: Text('Medicine ID cannot be empty'))
                          ],
                        ),
                      );
                      return 'Medicine ID cannot be empty';
                    }
                    return null;
                  },
                ),
                TextFormField(
                  controller: brandNameController,
                  decoration: const InputDecoration(labelText: 'Brand Name'),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      const SnackBar(
                        content: Row(
                          children: [
                            Icon(Icons.error_outline),
                            SizedBox(width: 20),
                            Expanded(child: Text('Brand Name cannot be empty'))
                          ],
                        ),
                      );
                      return 'Brand Name cannot be empty';
                    }
                    return null;
                  },
                ),
                TextFormField(
                  controller: companyNameController,
                  decoration: const InputDecoration(labelText: 'Company Name'),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      const SnackBar(
                        content: Row(
                          children: [
                            Icon(Icons.error_outline),
                            SizedBox(width: 20),
                            Expanded(
                                child: Text('Company Name cannot be empty'))
                          ],
                        ),
                      );
                      return 'Company Name cannot be empty';
                    }
                    return null;
                  },
                ),
                TextFormField(
                  controller: formulationController,
                  decoration: const InputDecoration(labelText: 'Formulation'),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      const SnackBar(
                        content: Row(
                          children: [
                            Icon(Icons.error_outline),
                            SizedBox(width: 20),
                            Expanded(child: Text('Formulation cannot be empty'))
                          ],
                        ),
                      );
                      return 'Formulation cannot be empty';
                    }
                    return null;
                  },
                ),
                TextFormField(
                  controller: mrpController,
                  decoration: const InputDecoration(labelText: 'Market Rate'),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      const SnackBar(
                        content: Row(
                          children: [
                            Icon(Icons.error_outline),
                            SizedBox(width: 20),
                            Expanded(
                                child:
                                    Text('Market Rate Price cannot be empty'))
                          ],
                        ),
                      );
                      return 'Market Rate Price cannot be empty';
                    }
                    return null;
                  },
                ),
                TextFormField(
                  controller: packSizeController,
                  decoration: const InputDecoration(labelText: 'Pack Size'),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      const SnackBar(
                        content: Row(
                          children: [
                            Icon(Icons.error_outline),
                            SizedBox(width: 20),
                            Expanded(child: Text('Packet Size cannot be empty'))
                          ],
                        ),
                      );
                      return 'Packet Size cannot be empty';
                    }
                    return null;
                  },
                ),
                TextFormField(
                  controller: registrationNumberController,
                  decoration:
                      const InputDecoration(labelText: 'Registration Number'),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      const SnackBar(
                        content: Row(
                          children: [
                            Icon(Icons.error_outline),
                            SizedBox(width: 20),
                            Expanded(
                                child:
                                    Text('Registration Number cannot be empty'))
                          ],
                        ),
                      );
                    }
                    if (int.tryParse(value!) == null) {
                      return 'Registration Number must be a number';
                    }
                    return null;
                  },
                ),
              ],
            ),
          ),
        ),
        actions: <Widget>[
          TextButton(
            onPressed: () {
              Navigator.pop(context);
            },
            style: ButtonStyle(
              foregroundColor: MaterialStateProperty.all<Color>(Colors.red),
            ),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () {
              if (formKey.currentState!.validate()) {
                _obj.addMedicine(
                    medicineIdController.text,
                    brandNameController.text,
                    companyNameController.text,
                    formulationController.text,
                    mrpController.text,
                    packSizeController.text,
                    registrationNumberController.text);

                medicineIdController.clear();
                brandNameController.clear();
                companyNameController.clear();
                formulationController.clear();
                mrpController.clear();
                packSizeController.clear();
                registrationNumberController.clear();

                Navigator.pop(context);
              }
            },
            style: ButtonStyle(
              backgroundColor:
                  MaterialStateProperty.all<Color>(Colors.blue.shade200),
            ),
            child: const Text('Save'),
          ),
        ],
      ),
    );
  }

  String create(String s) {
    int atIndex = s.indexOf('@');

    if (atIndex != -1) {
      String substringBeforeAt = s.substring(0, atIndex);
      String stringWithoutNumbers =
          substringBeforeAt.replaceAll(RegExp(r'\d'), '');
      return stringWithoutNumbers;
    }

    return s;
  }

  Widget _buildAnimatedCard(
    BuildContext context,
    IconData icon,
    String label,
    Color color,
    Color borderColor,
    bool isTapped,
    VoidCallback onTap,
  ) {
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(16.0),
          border: Border.all(
            color: isTapped ? borderColor : Colors.transparent,
            width: 2.0,
          ),
          boxShadow: [
            BoxShadow(
              color: isTapped ? Colors.transparent : color.withOpacity(0.5),
              spreadRadius: 5,
              blurRadius: 7,
              offset: const Offset(0, 3), // changes position of shadow
            ),
          ],
        ),
        child: Card(
          elevation: isTapped ? 0 : 4,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16.0),
          ),
          color: color,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                icon,
                size: 64,
                color: Colors.white,
              ),
              const SizedBox(height: 16),
              Text(
                label,
                style: const TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                ),
                textAlign: TextAlign.center,
              ),
            ],
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 243, 213, 223),
      appBar: AppBar(
        backgroundColor: const Color.fromARGB(255, 241, 97, 145),
        title: const Text('Pharmacist Dashboard'),
        actions: [
          IconButton(
            onPressed: () => signUserOut(context),
            icon: const Icon(Icons.logout),
          )
        ],
      ),
      drawer: Drawer(
        elevation: 4,
        child: Container(
          color: const Color(0xFF075e54), // Darker greenish-blue drawer color
          child: Column(
            children: <Widget>[
              UserAccountsDrawerHeader(
                accountName: Text(
                  getPharmacyName(user.email)!,
                  style: const TextStyle(color: Colors.white),
                ),
                accountEmail: Text(
                  user.email!,
                  style: const TextStyle(color: Colors.white),
                ),
                currentAccountPicture: const CircleAvatar(
                  backgroundColor: Colors.white,
                  child: Icon(
                    Icons.person,
                    color: Color(0xFF075e54), // Darker greenish-blue color
                  ),
                ),
                decoration: const BoxDecoration(
                  color: Color(0xFF075e54), // Darker greenish-blue header color
                ),
              ),
              ListTile(
                leading: const Icon(Icons.home, color: Colors.white),
                title: const Text(
                  'Home',
                  style: TextStyle(color: Colors.white),
                ),
                onTap: () => {},
              ),
              ListTile(
                leading:
                    const Icon(Icons.dashboard_rounded, color: Colors.grey),
                title: const Text(
                  'Dashboard',
                  style: TextStyle(color: Colors.grey),
                ),
                onTap: () {
                  Navigator.of(context).push(MaterialPageRoute(
                      builder: (context) =>
                          const splash(nextScreen: PharmaDash())));
                },
              ),
              ListTile(
                leading: const Icon(Icons.settings, color: Colors.grey),
                title: const Text(
                  'Settings',
                  style: TextStyle(color: Colors.grey),
                ),
                onTap: () {
                  Navigator.of(context).push(MaterialPageRoute(
                      builder: (context) => const Settings()));
                },
              ),
              const Divider(
                color: Colors.white,
              ),
              ListTile(
                leading: const Icon(Icons.logout, color: Colors.grey),
                title: const Text(
                  'Logout',
                  style: TextStyle(color: Colors.grey),
                ),
                onTap: () => {signUserOut(context)},
              ),
            ],
          ),
        ),
      ),
      body: GridView.count(
        crossAxisCount: 2,
        padding: const EdgeInsets.all(16.0),
        mainAxisSpacing: 16.0,
        crossAxisSpacing: 16.0,
        children: [
          _buildAnimatedCard(
            context,
            Icons.medical_services,
            'Add Medicines',
            const Color(0xFF008080), // Dark greenish-blue color
            Colors.greenAccent, // Border color
            isCardTapped1,
            () {
              openMedBox();
              setState(() {
                isCardTapped1 = !isCardTapped1;
              });
            },
          ),
          _buildAnimatedCard(
            context,
            Icons.view_agenda_outlined,
            'View Medicines',
            const Color(0xFF008080), // Dark greenish-blue color
            Colors.greenAccent, // Border color
            isCardTapped2,
            () {
              Navigator.of(context).push(MaterialPageRoute(
                  builder: (context) =>
                      const splash(nextScreen: PharmaNav())));
              setState(() {
                isCardTapped2 = !isCardTapped2;
              });
            },
          ),
          _buildAnimatedCard(
            context,
            Icons.info_outline,
            'Edit Info',
            const Color(0xFF008080), // Dark greenish-blue color
            Colors.greenAccent, // Border color
            isCardTapped3,
            () {
              setState(() {
                isCardTapped3 = !isCardTapped3;
              });
            },
          ),
          _buildAnimatedCard(
            context,
            Icons.help_center_outlined,
            'Help',
            const Color(0xFF008080), // Dark greenish-blue color
            Colors.greenAccent, // Border color
            isCardTapped4,
            () {
              setState(() {
                isCardTapped4 = !isCardTapped4;
              });
            },
          ),
        ],
      ),
    );
  }
}
