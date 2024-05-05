import 'package:curved_navigation_bar/curved_navigation_bar.dart';
import 'package:flutter/material.dart';
import 'package:pharmaco/Pages/Pharma.dart';
import 'package:pharmaco/Pages/PharmaDash.dart';
import 'package:pharmaco/Pages/PharmaSet.dart';

class PharmaNav extends StatefulWidget {
  const PharmaNav({super.key});

  @override
  State<PharmaNav> createState() => _PharmaNavState();
}

class _PharmaNavState extends State<PharmaNav> {
  int currentIndex = 0;

  late Widget currentpage;
  late List<Widget> pages;
  late PharmacistHome homepage;
  late PharmaDash dashboard;
  late PharmaSet setting;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    homepage = const PharmacistHome();
    dashboard = const PharmaDash();
    setting = const PharmaSet();
    pages = [homepage, dashboard, setting];
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      bottomNavigationBar: CurvedNavigationBar(
        height: 65,
        backgroundColor: Colors.transparent,
        color: const Color.fromARGB(255, 228, 90, 193),
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
