import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class WalletScreen extends StatelessWidget {
  final String documentId = "${DateTime.now().year}${DateTime.now().month}";
  final String month = DateFormat.MMMM().format(DateTime.now());

  @override
  Widget build(BuildContext context) {
    CollectionReference users =
        FirebaseFirestore.instance.collection('sdew021');
    return FutureBuilder<DocumentSnapshot>(
      future: users.doc(documentId).get(),
      builder:
          (BuildContext context, AsyncSnapshot<DocumentSnapshot> snapshot) {
        if (snapshot.hasError) {
          return Text("Something went wrong");
        }

        if (snapshot.connectionState == ConnectionState.done) {
          Map<String, dynamic> data = snapshot.data.data();
          return Container(
            color: Colors.blue,
            child: Column(
              children: [
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Card(
                    elevation: 5,
                    child: ListTile(
                      leading: Icon(
                        Icons.calendar_today,
                        color: Colors.blue,
                      ),
                      title: Text("${DateTime.now().year}-$month",
                          style: TextStyle(fontWeight: FontWeight.bold)),
                      trailing: Text("WALLET TRANSACTIONS",
                          style: TextStyle(fontWeight: FontWeight.bold)),
                    ),
                  ),
                ),
                Row(
                  children: <Widget>[
                    Expanded(
                      child: Column(
                        children: <Widget>[
                          for (var i in data['walletCredit'])
                            Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Card(
                                color: Colors.green[400],
                                elevation: 5,
                                child: ListTile(
                                  leading: Icon(
                                    Icons.remove,
                                    color: Colors.white,
                                  ),
                                  title: Text(
                                    "$i",
                                    style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        color: Colors.white),
                                  ),
                                  trailing: Text(
                                    "message",
                                    style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        color: Colors.white),
                                  ),
                                ),
                              ),
                            ),
                        ],
                      ),
                    ),
                    Expanded(
                      child: Column(
                        children: <Widget>[
                          for (var i in data['walletDebit'])
                            Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Card(
                                color: Colors.red[400],
                                elevation: 5,
                                child: ListTile(
                                  leading: Icon(
                                    Icons.remove,
                                    color: Colors.white,
                                  ),
                                  title: Text(
                                    "$i",
                                    style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        color: Colors.white),
                                  ),
                                  trailing: Text(
                                    "message",
                                    style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        color: Colors.white),
                                  ),
                                ),
                              ),
                            ),
                        ],
                      ),
                    ),
                  ],
                ),
              ],
            ),
          );
        }

        return Text("loading");
      },
    );
  }
}
