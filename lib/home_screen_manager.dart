import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:tricycleapp/screens/home_screen.dart';
import 'package:tricycleapp/screens/me_screen.dart';
import 'package:tricycleapp/screens/request_tricycle_sreen.dart';
import 'package:tricycleapp/screens/trip_history_screen.dart';

class HomeScreenManager extends StatefulWidget {
  static const screenName = '/homescreencontroller';

  @override
  _HomeScreenManagerState createState() => _HomeScreenManagerState();
}

class _HomeScreenManagerState extends State<HomeScreenManager> {
  List<Widget> _pages = [
    HomeScreen(),
    RequestTricycleSreen(),
    TripHistoryScreen(),
    MeScreen(),
  ];

  int _pageIndex = 0;

  void _selectPage(int index) {
    setState(() {
      _pageIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _pages[_pageIndex],
      bottomNavigationBar: BottomNavigationBar(
        backgroundColor: Colors.red,
        unselectedItemColor: Colors.black54,
        unselectedLabelStyle: TextStyle(color: Colors.black54),
        selectedItemColor: Colors.white,
        selectedLabelStyle: TextStyle(color: Colors.grey[350], fontSize: 10),
        type: BottomNavigationBarType.shifting,
        currentIndex: _pageIndex,
        onTap: _selectPage,
        items: [
          bottomNavigator(Icons.home, 'Home'),
          bottomNavigator(Icons.location_on, 'Request'),
          bottomNavigator(Icons.history, 'Trips'),
          bottomNavigator(Icons.account_circle, 'Me'),
          // BottomNavigationBarItem(
          //   backgroundColor: Colors.red[800],
          //   icon: Icon(Icons.home),
          //   label: 'HOME',
          // ),
          // BottomNavigationBarItem(
          //   backgroundColor: Colors.red[800],
          //   icon: Icon(Icons.location_on),
          //   label: 'REQUEST',
          // ),
          // BottomNavigationBarItem(
          //   backgroundColor: Colors.red[800],
          //   icon: Icon(Icons.history),
          //   label: 'TRIPS',
          // ),
          // BottomNavigationBarItem(
          //   backgroundColor: Colors.red[800],
          //   icon: Icon(Icons.account_circle),
          //   label: 'ME',
          // ),
        ],
      ),
    );
  }

  BottomNavigationBarItem bottomNavigator(IconData icon, String label) {
    return BottomNavigationBarItem(
      backgroundColor: Colors.red[800],
      icon: Icon(icon),
      label: label,
    );
  }
}
