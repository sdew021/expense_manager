import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:expense_manager/screens/AccountScreen.dart';
import 'package:expense_manager/screens/SummaryScreen.dart';
import 'package:expense_manager/screens/TransactionAccount.dart';
import 'package:expense_manager/screens/TransactionWallet.dart';
import 'package:expense_manager/screens/WalletScreen.dart';
import 'package:fab_circular_menu/fab_circular_menu.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  static const String _title = 'Expense Manager';

  final Future<FirebaseApp> _initialization = Firebase.initializeApp();
  // @override
  // Widget build(BuildContext context) {
  //   return MaterialApp(
  //     title: _title,
  //     home: MyStatefulWidget(),
  //   );
  // }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      // Initialize FlutterFire:
      future: _initialization,
      builder: (context, snapshot) {
        // Check for errors
        if (snapshot.hasError) {
          return SomethingWentWrong();
        }

        // Once complete, show your application
        if (snapshot.connectionState == ConnectionState.done) {
          return MaterialApp(
            title: _title,
            home: MyStatefulWidget(),
          );
        }

        // Otherwise, show something whilst waiting for initialization to complete
        return Loading();
      },
    );
  }
}

class SomethingWentWrong extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Container(
        child: Text("Error!! Something Went Wrong"),
      ),
    );
  }
}

class Loading extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Container(
        child: Text("Loading!!!"),
      ),
    );
  }
}

/// This is the stateful widget that the main application instantiates.
class MyStatefulWidget extends StatefulWidget {
  MyStatefulWidget({Key key}) : super(key: key);

  @override
  _MyStatefulWidgetState createState() => _MyStatefulWidgetState();
}

/// This is the private State class that goes with MyStatefulWidget.
class _MyStatefulWidgetState extends State<MyStatefulWidget> {
  PageController _pageController;
  int _selectedIndex = 0;
  int _pageIndex = 0;

  final GlobalKey<FabCircularMenuState> fabKey = GlobalKey();

  List<Widget> tabPages = [
    SummaryScreen(),
    AccountScreen(),
    WalletScreen(),
  ];

  void onPageChanged(int page) {
    setState(() {
      _selectedIndex = page;
      this._pageIndex = page;
    });
  }

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
    this._pageController.animateToPage(index,
        duration: const Duration(milliseconds: 500), curve: Curves.easeInOut);
  }

  @override
  void initState() {
    super.initState();
    _pageController = PageController(initialPage: _pageIndex);
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final primaryColor = Theme.of(context).primaryColor;
    return Scaffold(
      appBar: AppBar(
        title: const Text('Expense Manager'),
      ),
      body: Container(
        child: PageView(
          children: tabPages,
          onPageChanged: onPageChanged,
          controller: _pageController,
        ),
      ),
      floatingActionButton: Builder(
        builder: (context) => FabCircularMenu(
          key: fabKey,
          // Cannot be `Alignment.center`
          alignment: Alignment.bottomRight,
          ringColor: Colors.white.withAlpha(25),
          ringDiameter: 300.0,
          ringWidth: 80.0,
          fabSize: 64.0,
          fabElevation: 8.0,
          fabIconBorder: CircleBorder(),
          // Also can use specific color based on wether
          // the menu is open or not:
          // fabOpenColor: Colors.white
          // fabCloseColor: Colors.white
          // These properties take precedence over fabColor
          fabColor: Colors.white,
          fabOpenIcon: Icon(Icons.add, color: primaryColor),
          fabCloseIcon: Icon(Icons.close, color: primaryColor),
          fabMargin: const EdgeInsets.all(16.0),
          animationDuration: const Duration(milliseconds: 500),
          animationCurve: Curves.easeInOutCirc,
          onDisplayChange: (isOpen) async {
            //_showSnackBar(context, "The menu is ${isOpen ? "open" : "closed"}");
            if (fabKey.currentState.isOpen) {
              await Future.delayed(Duration(seconds: 2));
              fabKey.currentState.close();
            }
          },
          children: <Widget>[
            RawMaterialButton(
              onPressed: () {
                //_showSnackBar(context, "You pressed 1");
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => TransactionAccount()));
              },
              shape: CircleBorder(),
              padding: const EdgeInsets.all(24.0),
              child: Icon(Icons.credit_card_rounded, color: Colors.white),
            ),
            RawMaterialButton(
              onPressed: () {
                //_showSnackBar(context, "You pressed 2");
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => TransactionWallet()));
              },
              shape: CircleBorder(),
              padding: const EdgeInsets.all(24.0),
              child: Icon(Icons.account_balance_wallet_rounded,
                  color: Colors.white),
            ),
            RawMaterialButton(
              onPressed: () {
                // _showSnackBar(context, "You pressed close.");
                updateAccounts(context);
              },
              shape: CircleBorder(),
              padding: const EdgeInsets.all(24.0),
              child: Icon(Icons.update, color: Colors.white),
            )
          ],
        ),
      ),
      bottomNavigationBar: BottomNavigationBar(
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.person),
            label: 'Summary',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.credit_card),
            label: 'Account',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.account_balance_wallet),
            label: 'Wallet',
          ),
        ],
        currentIndex: _selectedIndex,
        selectedItemColor: Colors.amber[800],
        onTap: _onItemTapped,
      ),
    );
  }

  // void _showSnackBar(BuildContext context, String message) {
  //   ScaffoldMessenger.of(context).showSnackBar(SnackBar(
  //     content: Text(message),
  //     duration: const Duration(milliseconds: 1000),
  //   ));
  // }
}

void updateAccounts(BuildContext context) {
  FirebaseFirestore.instance
      .collection('sdew021')
      .doc('${DateTime.now().year}${DateTime.now().month}')
      .set(
        {'accountBalance': 0},
        SetOptions(merge: true),
      )
      .then((x) => {
            print("Init"),
            showDialog<void>(
              context: context,
              builder: (BuildContext context) {
                return AlertDialog(
                  title: const Text('Thanks!'),
                  content: Text('Account Initialized'),
                  actions: <Widget>[
                    FlatButton(
                      onPressed: () {
                        Navigator.pop(context);
                        // Navigator.pop(context);
                      },
                      child: const Text('OK'),
                    ),
                  ],
                );
              },
            ),
          })
      .catchError((error) => print("Failed to init: $error"));

  FirebaseFirestore.instance
      .collection('sdew021')
      .doc('${DateTime.now().year}${DateTime.now().month}')
      .set(
        {'walletBalance': 0},
        SetOptions(merge: true),
      )
      .then((x) => {
            print("Init"),
            showDialog<void>(
              context: context,
              builder: (BuildContext context) {
                return AlertDialog(
                  title: const Text('Thanks!'),
                  content: Text('Wallet Initialized'),
                  actions: <Widget>[
                    FlatButton(
                      onPressed: () {
                        Navigator.pop(context);
                        // Navigator.pop(context);
                      },
                      child: const Text('OK'),
                    ),
                  ],
                );
              },
            ),
          })
      .catchError((error) => print("Failed to init: $error"));
}
