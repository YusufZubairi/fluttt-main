// ignore_for_file: use_build_context_synchronously, file_names

import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:pharmaco/Pages/Pharma.dart';
import 'package:pharmaco/Pages/PharmaSet.dart';
import 'package:pharmaco/components/splash_screen.dart';
import 'package:pharmaco/objects/pharmacyData.dart';
import 'package:pharmaco/Pages/login.dart';

class PharmaDash extends StatefulWidget {
  const PharmaDash({super.key});

  @override
  State<PharmaDash> createState() => _PharmaDashState();
}

class _PharmaDashState extends State<PharmaDash> {
  @override
  void initState() {
    super.initState();
  }

  final searchController = TextEditingController();
  String name = "";
  final MyData _obj = MyData();
  String currentPage = 'View';
  final User user = FirebaseAuth.instance.currentUser!;
  int count = 0;

  String getBranchFromEmail(String? email) {
    String username = email!.split('@').first;

    for (int i = 0; i < username.length; i++) {
      if (username.codeUnitAt(i) >= 48 && username.codeUnitAt(i) <= 57) {
        return 'Branch${username[i]}';
      }
    }

    return 'Branch1';
  }

  // ignore: non_constant_identifier_names
  void EditMedBox(Map<String, dynamic> medicine) {
    GlobalKey<FormState> formKey = GlobalKey<FormState>();

    TextEditingController medicineIdController =
        TextEditingController(text: '${medicine['medId']}');
    TextEditingController brandNameController =
        TextEditingController(text: '${medicine['Brand Name']}');
    TextEditingController companyNameController =
        TextEditingController(text: '${medicine['companyName']}');
    TextEditingController formulationController =
        TextEditingController(text: '${medicine['Formulation']}');
    TextEditingController mrpController =
        TextEditingController(text: '${medicine['Market Price']}');
    TextEditingController packSizeController =
        TextEditingController(text: '${medicine['Pack Size']}');
    TextEditingController registrationNumberController =
        TextEditingController(text: '${medicine['regNo']}');

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Edit Medicine'),
        content: SingleChildScrollView(
          child: Form(
            key: formKey,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                TextFormField(
                  controller: medicineIdController,
                  readOnly: true,
                  decoration:
                      const InputDecoration(labelText: 'Read Only Medicine ID'),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
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
                      return 'Registration Number cannot be empty';
                    }
                    if (int.tryParse(value) == null) {
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
                _obj.updateMedicine(
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
                ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                    content: Text(
                  "Medicine ${medicine['Brand Name']} Successfully Edited!",
                  style: const TextStyle(fontSize: 19.0),
                )));
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

  String? getPharmacyName(String? userEmail) {
    if (userEmail == null) {
      return null; // or handle the case when userEmail is null
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
    // If no match is found, you can return null or handle it accordingly.
    return null;
  }

  late List<Map<String, dynamic>> medicinesList = [];

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

  ListTile buildDrawerItem(String title, IconData icon, Widget destination) {
    return ListTile(
      leading: Icon(icon),
      title: Text(
        title,
        style: TextStyle(
          fontSize: 23,
          color: currentPage == title ? Colors.pinkAccent[200] : Colors.black,
        ),
      ),
      onTap: () {
        Navigator.of(context)
            .push(MaterialPageRoute(builder: (context) => destination));

        // Update the current active page
        setState(() {
          currentPage = title;
        });
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        debugShowCheckedModeBanner: false,
        home: Scaffold(
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
          floatingActionButton: FloatingActionButton(
            onPressed: (openMedBox),
            backgroundColor: const Color.fromARGB(255, 241, 97, 145),
            child: const Icon(Icons.add),
          ),
          drawer: Drawer(
            elevation: 4,
            child: Container(
              color:
                  const Color(0xFF075e54), // Darker greenish-blue drawer color
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
                      color: Color(
                          0xFF075e54), // Darker greenish-blue header color
                    ),
                  ),
                  ListTile(
                    leading: const Icon(Icons.home, color: Colors.grey),
                    title: const Text(
                      'Home',
                      style: TextStyle(color: Colors.grey),
                    ),
                    onTap: () => {
                      Navigator.of(context).push(MaterialPageRoute(
                          builder: (context) =>
                              const splash(nextScreen: PharmacistHome())))
                    },
                  ),
                  ListTile(
                    leading: const Icon(Icons.dashboard_rounded,
                        color: Colors.white),
                    title: const Text(
                      'Dashboard',
                      style: TextStyle(color: Colors.white),
                    ),
                    onTap: () {},
                  ),
                  ListTile(
                    leading: const Icon(Icons.settings, color: Colors.grey),
                    title: const Text(
                      'Settings',
                      style: TextStyle(color: Colors.grey),
                    ),
                    onTap: () {
                      Navigator.of(context).push(MaterialPageRoute(
                          builder: (context) => const PharmaSet()));
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
          body: SingleChildScrollView(
            child: Column(children: [
              SizedBox(
                height: 100,
                child: Text(
                  "${getPharmacyName(user.email)} Database",
                  style: const TextStyle(
                    fontSize: 45,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              StreamBuilder<List<Map<String, dynamic>>>(
                stream: (_obj.parseData()),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const CircularProgressIndicator();
                  } else if (snapshot.hasError) {
                    return Text('Error: ${snapshot.error}');
                  } else {
                    List<Map<String, dynamic>> medicinesList =
                        snapshot.data ?? [];

                    if (medicinesList.isNotEmpty) {
                      return SingleChildScrollView(
                        child: DataTable(
                          columnSpacing: 10,
                          horizontalMargin: 10,
                          sortColumnIndex: 0,
                          sortAscending: true,
                          columns: const [
                            DataColumn(
                              label: Text('Medicine ID'),
                            ),
                            DataColumn(
                              label: Text('Brand Name'),
                            ),
                            DataColumn(
                              label: Text('Market Price'),
                            ),
                            DataColumn(
                              label: Text('Actions'),
                            ),
                          ],
                          rows: medicinesList.map((medicine) {
                            return DataRow(
                              cells: [
                                DataCell(
                                  Text('${medicine['medId']}'),
                                ),
                                DataCell(
                                  Text('${medicine['Brand Name']}'),
                                ),
                                DataCell(
                                  Text('${medicine['Market Price']}'),
                                ),
                                DataCell(
                                  Row(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      IconButton(
                                        onPressed: () => {EditMedBox(medicine)},
                                        icon: const Icon(Icons.edit_outlined),
                                        color: Colors.orangeAccent,
                                      ),
                                      IconButton(
                                        onPressed: () {
                                          AwesomeDialog(
                                              context: context,
                                              dialogType: DialogType.warning,
                                              animType: AnimType.topSlide,
                                              showCloseIcon: true,
                                              title:
                                                  "Delete ${medicine['Brand Name']}?",
                                              desc:
                                                  'Are you sure you wish to proceed?',
                                              btnCancelOnPress: () {},
                                              btnOkOnPress: () => {
                                                    _obj.deleteMedicine(
                                                        medicine['medId'])
                                                  }).show();
                                        },
                                        icon: const Icon(Icons.delete_outline),
                                        color: Colors.red,
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            );
                          }).toList(),
                        ),
                      );
                    } else {
                      return const Text('Pharmacy data does not exist');
                    }
                  }
                },
              ),
            ]),
          ),
        ));
  }
}
