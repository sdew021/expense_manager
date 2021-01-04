import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class SummaryScreen extends StatelessWidget {
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
                      title: Text(
                          "${DateTime.now().year}-$month",
                          style: TextStyle(fontWeight: FontWeight.bold)),
                      trailing: Text("BALANCES",
                          style: TextStyle(fontWeight: FontWeight.bold)),
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Card(
                    elevation: 5,
                    child: ListTile(
                      leading: Icon(
                        Icons.account_balance_wallet_rounded,
                        color: Colors.blue,
                      ),
                      title: Text("${data['walletBalance']}",
                          style: TextStyle(fontWeight: FontWeight.bold)),
                      trailing: Text("WALLET",
                          style: TextStyle(fontWeight: FontWeight.bold)),
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Card(
                    elevation: 10,
                    child: ListTile(
                      leading: Icon(
                        Icons.credit_card_rounded,
                        color: Colors.blue,
                      ),
                      title: Text("${data['accountBalance']}",
                          style: TextStyle(fontWeight: FontWeight.bold)),
                      trailing: Text("ACCOUNT",
                          style: TextStyle(fontWeight: FontWeight.bold)),
                    ),
                  ),
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
