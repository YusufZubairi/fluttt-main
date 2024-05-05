// ignore: file_names
// ignore_for_file: use_build_context_synchronously

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:pharmaco/Pages/ProductPage.dart';
import 'package:pharmaco/Pages/homepage.dart';
import 'package:pharmaco/Pages/login.dart';

class Dashboardpage extends StatefulWidget {
  const Dashboardpage({super.key});

  @override
  State<Dashboardpage> createState() => _DashboardpageState();
}

class _DashboardpageState extends State<Dashboardpage> {
  final searchController = TextEditingController();
  String name = "";
  String currentPage = 'Search';
  int currentIndex = 1;

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
          color: currentPage == title ? Colors.blueAccent : Colors.black,
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
        backgroundColor: const Color.fromARGB(255, 212, 227, 241),
        appBar: AppBar(
          backgroundColor: Colors.blueAccent[200],
          title: const Text('Dashboard'),
          actions: [
            IconButton(
              onPressed: () => signUserOut(context),
              icon: const Icon(Icons.logout),
            )
          ],
        ),
        drawer: Drawer(
            child: Container(
          color: Colors.blue[100],
          child: ListView(
            children: [
              const DrawerHeader(
                  child: Center(
                child: Text(
                  'Nav',
                  style: TextStyle(fontSize: 25),
                ),
              )),
              buildDrawerItem('Home', Icons.home_filled, Home()),
              buildDrawerItem('Search', Icons.search, const Dashboardpage()),
            ],
          ),
        )),
        body: Center(
          child: Column(
            children: [
              const SizedBox(height: 100),
              Container(
                margin: const EdgeInsets.all(15.0),
                decoration: BoxDecoration(
                  boxShadow: [
                    BoxShadow(
                      offset: const Offset(12, 26),
                      blurRadius: 50,
                      spreadRadius: 0,
                      color: Colors.grey.withOpacity(.1),
                    ),
                  ],
                ),
                child: TextField(
                  controller: searchController,
                  onChanged: (value) {
                    setState(() {
                      name = value;
                    });
                  },
                  decoration: const InputDecoration(
                    prefixIcon: Icon(
                      Icons.search,
                      color: Color(0xff4338CA),
                    ),
                    filled: true,
                    fillColor: Colors.white,
                    hintText: 'Search',
                    hintStyle: TextStyle(color: Colors.grey),
                    contentPadding:
                        EdgeInsets.symmetric(vertical: 10.0, horizontal: 20.0),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.all(Radius.circular(15.0)),
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderSide: BorderSide(color: Colors.white, width: 1.0),
                      borderRadius: BorderRadius.all(Radius.circular(15.0)),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderSide: BorderSide(color: Colors.white, width: 2.0),
                      borderRadius: BorderRadius.all(Radius.circular(15.0)),
                    ),
                  ),
                ),
              ),
              StreamBuilder<QuerySnapshot>(
                stream: FirebaseFirestore.instance
                    .collection('Recommendation')
                    .where('name',
                        isGreaterThanOrEqualTo:
                            name != null && name.isNotEmpty ? name : '\0')
                    .where('name',
                        isLessThanOrEqualTo: name != null && name.isNotEmpty
                            ? '$name\uf8ff'
                            : '\0')
                    .limit(3)
                    .snapshots(),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const Center(child: CircularProgressIndicator());
                  }

                  return ListView.builder(
                    shrinkWrap: true,
                    itemCount: snapshot.data?.docs.length ?? 0,
                    itemBuilder: (context, index) {
                      var data = snapshot.data?.docs[index].data()
                          as Map<String, dynamic>;
                      return GestureDetector(
                        onTap: () {
                          // Navigate to the unique page for this search result
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => ProductPage(
                                name: data['name'],
                                netPrice: data['Net_Price'],
                                actionClass: data['Action Class'],
                                chemicalClass: data['Chemical Class'],
                                habitForming: data['Habit Forming'],
                                therapeuticClass: data['Therapeutic Class'],
                                id: data['id'],
                                sideEffects: List<String>.generate(
                                    40, (index) => data['sideEffect$index']),
                                substitutes: List<String>.generate(
                                    5, (index) => data['substitute$index']),
                                uses: List<String>.generate(
                                    5, (index) => data['use$index']),
                              ),
                            ),
                          );
                        },
                        child: Container(
                          decoration: BoxDecoration(
                            boxShadow: [
                              BoxShadow(
                                color: Colors.grey.withOpacity(0.5),
                                spreadRadius: 2,
                                blurRadius: 5,
                                offset: const Offset(0, 3),
                              ),
                            ],
                            border: Border.all(
                              color: Colors.grey,
                              width: 1,
                            ),
                            borderRadius: BorderRadius.circular(10),
                          ),
                          margin: const EdgeInsets.all(8),
                          child: ListTile(
                            title: Text(
                              'Name: ${data['name']}',
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              style: const TextStyle(
                                color: Colors.black,
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            subtitle: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  'Rs. ${data['Net_Price'] ?? '0'}',
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                  style: const TextStyle(
                                    color: Colors.black,
                                    fontSize: 16,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      );
                    },
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
