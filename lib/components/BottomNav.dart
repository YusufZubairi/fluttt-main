import 'package:curved_navigation_bar/curved_navigation_bar.dart';
import 'package:flutter/material.dart';
import 'package:pharmaco/Pages/Dashboard.dart';
import 'package:pharmaco/Pages/Settings.dart';
import 'package:pharmaco/Pages/homepage.dart';

class BottomNav extends StatefulWidget {
  const BottomNav({super.key});

  @override
  State<BottomNav> createState() => _BottomNavState();
}

class _BottomNavState extends State<BottomNav> {
  int currentIndex = 0;

  late Widget currentpage;
  late List<Widget> pages;
  late Home homepage;
  late Dashboardpage dashboard;
  late Settings setting;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    homepage = Home();
    dashboard = const Dashboardpage();
    setting = const Settings();
    pages = [homepage, dashboard, setting];
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      bottomNavigationBar: CurvedNavigationBar(
        height: 65,
        backgroundColor: const Color.fromARGB(255, 212, 227, 241),
        color: const Color.fromARGB(255, 22, 40, 99),
        animationDuration: const Duration(milliseconds: 500),
        onTap: (int index) {
          setState(() {
            currentIndex = index;
          });
        },
        items: const [
        Icon(
          Icons.home_outlined,
          color: Colors.white,
        ),
        Icon(
          Icons.search,
          color: Colors.white,
        ),
        Icon(
          Icons.person_outlined,
          color: Colors.white,
        ),

      ]),
      body: pages[currentIndex],
    );
  }
}
