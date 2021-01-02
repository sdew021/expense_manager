import 'package:flutter/material.dart';

class TransactionWallet extends StatefulWidget {
  @override
  _TransactionWalletState createState() => _TransactionWalletState();
}

enum SingingCharacter { DEBIT, CREDIT }

class _TransactionWalletState extends State<TransactionWallet> {
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
        title: const Text('Transaction Wallet'),
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
                      {
                        _showSnackBar(context,"Amount cannot be empty")
                      }
                    else if (_character == SingingCharacter.CREDIT)
                      {
                        showDialog<void>(
                          context: context,
                          builder: (BuildContext context) {
                            return AlertDialog(
                              title: const Text('Thanks!'),
                              content: Text(
                                  'You credited "${_controller.text}" to wallet.'),
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
                      }
                    else
                      {
                        showDialog<void>(
                          context: context,
                          builder: (BuildContext context) {
                            return AlertDialog(
                              title: const Text('Thanks!'),
                              content: Text(
                                  'You debited "${_controller.text}" to wallet.'),
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

void _showSnackBar(BuildContext context, String message) {
  ScaffoldMessenger.of(context).showSnackBar(SnackBar(
    content: Text(message),
    duration: const Duration(milliseconds: 1000),
  ));
}

//TO MAKE USE WHEN SUBMITTED
// onSubmitted: (String value) async {
//               await showDialog<void>(
//                 context: context,
//                 builder: (BuildContext context) {
//                   return AlertDialog(
//                     title: const Text('Thanks!'),
//                     content: Text('You typed "$value".'),
//                     actions: <Widget>[
//                       FlatButton(
//                         onPressed: () {
//                           Navigator.pop(context);
//                         },
//                         child: const Text('OK'),
//                       ),
//                     ],
//                   );
//                 },
//               );
//             },
