import 'package:flutter/material.dart';
import 'package:notex/src/screens/folder_screen/body.dart';
import 'package:notex/src/screens/home_screen/body.dart';
import 'package:notex/src/screens/profile_screen/body.dart';
import 'package:notex/src/ui/components/custom_Appbar.dart';

class Mainpages extends StatefulWidget {
  const Mainpages({super.key});

  @override
  State<Mainpages> createState() => _MainpagesState();
}

class _MainpagesState extends State<Mainpages> {
  int _currentIndex = 0;

  final List<Widget> _pages = [
    HomeScreen(),
    FolderScreen(),
    ProfileScreen(),
  ];

  void onTabTapped(int index) {
    setState(() {
      _currentIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(

      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(kToolbarHeight),
        child: CustomAppBar(),
      ),

      body: _pages[_currentIndex],

      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentIndex,
        onTap: onTabTapped,
        items: [
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.search),
            label: 'Search',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person),
            label: 'Profile',
          ),
        ],
      ),
    );
  }
}
