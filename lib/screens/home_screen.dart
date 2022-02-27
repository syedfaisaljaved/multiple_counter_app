import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:counter_app/firestore/FireStoreUtils.dart';
import 'package:counter_app/screens/counterOne.dart';
import 'package:counter_app/screens/counterThree.dart';
import 'package:counter_app/screens/counterTwo.dart';
import 'package:flutter/material.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  late List<BottomNavigationBarItem> navBarScreens;
  late List<Widget> _screens;
  late StreamController<int> _pageController;
  int index = 0;

  @override
  void initState() {
    navBarScreens = [
      const BottomNavigationBarItem(
          icon: Icon(
            Icons.timer,
            color: Colors.grey,
          ),
          label: "Counter 1",
          tooltip: "Counter 1",
          activeIcon: Icon(
            Icons.timer,
            color: Colors.blue,
          )),
      const BottomNavigationBarItem(
          icon: Icon(
            Icons.timer,
            color: Colors.grey,
          ),
          label: "Counter 2",
          tooltip: "Counter 2",
          activeIcon: Icon(
            Icons.timer,
            color: Colors.blue,
          )),
      const BottomNavigationBarItem(
          icon: Icon(
            Icons.timer,
            color: Colors.grey,
          ),
          label: "Counter 3",
          tooltip: "Counter 3",
          activeIcon: Icon(
            Icons.timer,
            color: Colors.blue,
          )),
    ];

    _pageController = StreamController<int>.broadcast();

    super.initState();
  }

  @override
  void dispose() {
    _pageController.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Counter App"),
        actions: [
          MaterialButton(
            onPressed: () async {
              /// reset counter
              (await FireStoreUtils.instance.userDeviceRef).update({
                "counter1": 0,
                "counter2": 0,
                "counter3": 0,
              });
            },
            child: const Text(
              "Reset All",
              style: TextStyle(
                fontSize: 14,
                color: Colors.white,
              ),
            ),
          ),
        ],
      ),
      body: FutureBuilder<Stream<DocumentSnapshot<Object?>>>(
        future: getUserDeviceRef(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.done) {
            _screens = [
              CounterOne(
                stream: snapshot.data,
              ),
              CounterTwo(
                stream: snapshot.data,
              ),
              CounterThree(
                stream: snapshot.data,
              )
            ];
            return Center(child: _screens[index]);
          } else {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }
        },
      ),
      bottomNavigationBar: BottomNavigationBar(
        items: navBarScreens,
        currentIndex: index,
        onTap: (index) {
          setState(() {
            this.index = index;
          });
        },
      ),
    );
  }

  Future<Stream<DocumentSnapshot<Object?>>> getUserDeviceRef() async {
    DocumentReference documentReference =
        await FireStoreUtils.instance.userDeviceRef;
    return documentReference.snapshots();
  }
}
