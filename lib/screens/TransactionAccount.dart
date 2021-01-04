import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class TransactionAccount extends StatefulWidget {
  @override
  _TransactionAccountState createState() => _TransactionAccountState();
}

enum SingingCharacter { DEBIT, CREDIT }

class _TransactionAccountState extends State<TransactionAccount> {
  TextEditingController _controller;

  SingingCharacter _character = SingingCharacter.DEBIT;

  void initState() {
    super.initState();
    _controller = TextEditingController();
  }

  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Transaction Account'),
      ),
      body: Container(
        alignment: Alignment.center,
        child: Column(children: <Widget>[
          SizedBox(
            height: 26,
          ),
          Container(
            width: double.infinity,
            margin: EdgeInsets.all(16),
            child: TextField(
              decoration: InputDecoration(
                border: OutlineInputBorder(),
                labelText: 'Amount',
              ),
              controller: _controller,
            ),
          ),
          SizedBox(
            height: 26,
          ),
          ListTile(
            title: const Text(
              'DEBIT',
              style: TextStyle(color: Colors.red),
            ),
            leading: Radio(
              value: SingingCharacter.DEBIT,
              groupValue: _character,
              activeColor: Colors.red,
              onChanged: (SingingCharacter value) {
                setState(() {
                  _character = value;
                });
              },
            ),
            trailing: Icon(
              Icons.remove,
              color: Colors.red,
            ),
          ),
          ListTile(
            title: const Text(
              'CREDIT',
              style: TextStyle(color: Colors.green),
            ),
            leading: Radio(
              value: SingingCharacter.CREDIT,
              groupValue: _character,
              onChanged: (SingingCharacter value) {
                setState(() {
                  _character = value;
                });
              },
              activeColor: Colors.green,
            ),
            trailing: Icon(
              Icons.add,
              color: Colors.green,
            ),
          ),
          SizedBox(
            height: 26,
          ),
          Container(
            child: new ButtonBar(
              mainAxisSize: MainAxisSize
                  .min, // this will take space as minimum as posible(to center)
              children: <Widget>[
                new RaisedButton(
                  padding: EdgeInsets.all(20),
                  child: new Text('BACK'),
                  onPressed: () => Navigator.pop(context),
                ),
                new RaisedButton(
                  padding: EdgeInsets.all(20),
                  child: new Text('SUBMIT'),
                  onPressed: () => {
                    if (_controller.text.trim() == "")
                      {_showSnackBar(context, "Amount cannot be empty")}
                    else if (_character == SingingCharacter.CREDIT)
                      {
                        creditToAccount(int.parse(_controller.text), context),
                      }
                    else
                      {
                        debitToAccount(int.parse(_controller.text), context),
                      }
                  },
                  color: Colors.blue,
                ),
              ],
            ),
          )
        ]),
      ),
    );
  }
}

creditToAccount(int value, BuildContext context) {
  FirebaseFirestore.instance
      .collection('sdew021')
      .doc('${DateTime.now().year}${DateTime.now().month}')
      .set({
        'accountCredit': FieldValue.arrayUnion([value])
      },
        SetOptions(merge: true),)
      .then((x) => {
            print("Credited"),
            showDialog<void>(
              context: context,
              builder: (BuildContext context) {
                return AlertDialog(
                  title: const Text('Thanks!'),
                  content: Text('You credited "$value" to account.'),
                  actions: <Widget>[
                    FlatButton(
                      onPressed: () {
                        Navigator.pop(context);
                        Navigator.pop(context);
                      },
                      child: const Text('OK'),
                    ),
                  ],
                );
              },
            ),
          })
      .catchError((error) => print("Failed to credit: $error"));
}

debitToAccount(int value, BuildContext context) {
  FirebaseFirestore.instance
      .collection('sdew021')
      .doc('${DateTime.now().year}${DateTime.now().month}')
      .set({
        'accountDebit': FieldValue.arrayUnion([value])
      },
        SetOptions(merge: true),)
      .then((x) => {
            print("Debited"),
            showDialog<void>(
              context: context,
              builder: (BuildContext context) {
                return AlertDialog(
                  title: const Text('Thanks!'),
                  content: Text('You debited "$value" to account.'),
                  actions: <Widget>[
                    FlatButton(
                      onPressed: () {
                        Navigator.pop(context);
                        Navigator.pop(context);
                      },
                      child: const Text('OK'),
                    ),
                  ],
                );
              },
            ),
          })
      .catchError((error) => print("Failed to debit: $error"));
}

void _showSnackBar(BuildContext context, String message) {
  ScaffoldMessenger.of(context).showSnackBar(SnackBar(
    content: Text(message),
    duration: const Duration(milliseconds: 1000),
  ));
}
