import 'package:flutter/material.dart';

class Mainpages extends StatelessWidget {
  const Mainpages({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(kToolbarHeight),
        child: Container(
          padding: EdgeInsets.all(20),
          color: Colors.blue,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text('Notex',
                  style: TextStyle(color: Colors.white, fontSize: 20)),
              IconButton(
                icon: Icon(Icons.person, color: Colors.white),
                onPressed: () {
                  // action
                },
              ),
            ],
          ),
        ),
      ),
      body: Stack(
        children: [
          Center(
            child: Text('Notex'),
          ),
        ],
      ),
    );
  }
}
