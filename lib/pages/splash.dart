import 'package:flutter/material.dart';
import 'package:notex/pages/homePage/body.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Onboarding Example',
      theme: ThemeData(
        primarySwatch: Colors.teal,
      ),
      home: OnboardingScreen(),
    );
  }
}

class OnboardingScreen extends StatefulWidget {
  @override
  _OnboardingScreenState createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen> {
  final PageController _pageController = PageController();
  int _currentPage = 0;

  List<OnboardingPage> pages = [
    OnboardingPage(
      title: 'Seamless ordering experience.',
      description: 'No stress, buy and go!',
      image: 'assets/aa.png',
    ),
    OnboardingPage(
      title: 'Quick Delivery right to your doorstep.',
      description: 'Wherever that is, we\'ll deliver sharp, sharp!',
      image: 'assets/aa.png',
    ),
    OnboardingPage(
      title: 'Quick Delivery right to your doorstep.',
      description: 'Wherever that is, we\'ll deliver sharp, sharp!',
      image: 'assets/aa.png',
    ),
  ];

  void _onSkip() {
    _pageController.animateToPage(
      pages.length,
      duration: Duration(milliseconds: 300),
      curve: Curves.easeInOut,
    );
  }

  void _onNext() {
    if (_currentPage < pages.length - 1) {
      _pageController.nextPage(
        duration: Duration(milliseconds: 300),
        curve: Curves.easeInOut,
      );
    } else {
      _onSkip();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          PageView.builder(
            controller: _pageController,
            itemCount: pages.length,
            onPageChanged: (int page) {
              setState(() {
                _currentPage = page;
              });
            },
            itemBuilder: (context, index) {
              return buildPage(pages[index]);
            },
          ),
          Positioned(
            bottom: 80,
            left: 0,
            right: 0,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: List.generate(
                pages.length,
                (index) => buildDot(index),
              ),
            ),
          ),
          if (_currentPage == pages.length - 1)
            Positioned(
              bottom: 20,
              left: 20,
              right: 20,
              child: ElevatedButton(
                child: Text('البدء'),
                style: ElevatedButton.styleFrom(
                  padding: EdgeInsets.symmetric(vertical: 15),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
                onPressed:(){
                  Navigator.pushReplacementNamed(context, '/login');
                } ,
              ),
            )
          else ...[
            Positioned(
              bottom: 20,
              left: 20,
              child: TextButton(
                child: Text('Skip'),
                onPressed: _onSkip,
              ),
            ),
            Positioned(
              bottom: 20,
              right: 20,
              child: ElevatedButton(
                child: Icon(Icons.arrow_forward),
                onPressed: _onNext,
              ),
            ),
          ],
        ],
      ),
    );
  }

  Widget buildDot(int index) {
    return Container(
      height: 10,
      width: 10,
      margin: EdgeInsets.only(right: 5),
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: _currentPage == index ? Colors.teal : Colors.grey,
      ),
    );
  }

  Widget buildPage(OnboardingPage page) {
    return Padding(
      padding: EdgeInsets.all(40),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Image.asset(page.image, height: 300),
          SizedBox(height: 40),
          Text(
            page.title,
            style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            textAlign: TextAlign.center,
          ),
          SizedBox(height: 20),
          Text(
            page.description,
            style: TextStyle(fontSize: 16),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }
}

class OnboardingPage {
  final String title;
  final String description;
  final String image;

  OnboardingPage({
    required this.title,
    required this.description,
    required this.image,
  });
}
