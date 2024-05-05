// ignore: file_names
// ignore_for_file: use_build_context_synchronously

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
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
        body: SingleChildScrollView(
          child: Column(
            children: [
              const SizedBox(height: 100),
              
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
                    .snapshots(),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const Center(child: CircularProgressIndicator());
                  }

                  return ListView.builder(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    itemCount: snapshot.data?.docs.length ?? 0,
                    itemBuilder: (context, index) {
                      var data = snapshot.data?.docs[index].data()
                          as Map<String, dynamic>;
                      return Container(
                        decoration: BoxDecoration(
                          boxShadow: [
                            BoxShadow(
                              color: Colors.grey.withOpacity(0.5),
                              spreadRadius: 2,
                              blurRadius: 5,
                              offset:const Offset(0, 3),
                            ),
                          ],
                          border: Border.all(
                            color: Colors.grey,
                            width: 1,
                          ),
                          borderRadius: BorderRadius.circular(10),
                        ),
                        margin:const EdgeInsets.all(8),
                        child: ListTile(
                          title: Text(
                            'Name: ${data['name'] }',
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
                                'Substitute 1: ${data['substitute0'] ?? ''}',
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                                style: const TextStyle(
                                  color: Colors.black,
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              Text(
                                'Substitute 2: ${data['substitute1'] ?? ''}',
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                                style: const TextStyle(
                                  color: Colors.black,
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              Text(
                                'Substitute 3: ${data['substitute2'] ?? ''}',
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                                style: const TextStyle(
                                  color: Colors.black,
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              Text(
                                'Usage: ${data['use0'] ?? ''}',
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
