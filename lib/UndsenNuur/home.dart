import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class MoneyControlApp extends StatelessWidget {
  final String userId;

  MoneyControlApp({required this.userId});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Money Control',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: MainPage(userId: userId),
    );
  }
}

class MainPage extends StatefulWidget {
  final String userId;

  MainPage({required this.userId});

  @override
  _MainPageState createState() => _MainPageState(userId: userId);
}

class _MainPageState extends State<MainPage> {
  int _selectedIndex = 0;
  final String userId;
  late List<Widget> _widgetOptions;

  _MainPageState({required this.userId});

  @override
  void initState() {
    super.initState();
    _widgetOptions = <Widget>[
      HomePage(userId: userId),
      TransactionsPage(),
      ProfilePage(userId: userId), // Pass userId here
    ];
  }

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Money Control'),
      ),
      body: _widgetOptions.elementAt(_selectedIndex),
      bottomNavigationBar: BottomNavigationBar(
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.list),
            label: 'Transactions',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person),
            label: 'Profile',
          ),
        ],
        currentIndex: _selectedIndex,
        selectedItemColor: Colors.blue,
        onTap: _onItemTapped,
      ),
    );
  }
}

class HomePage extends StatefulWidget {
  final String userId;

  HomePage({required this.userId});

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  TextEditingController _amountController = TextEditingController();
  String _transactionType = 'income';

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Text(
            'Account Balance',
            style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
          ),
          SizedBox(height: 8),
          StreamBuilder<QuerySnapshot>(
            stream: FirebaseFirestore.instance.collection('transactions').snapshots(),
            builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
              if (snapshot.hasError) {
                return Text('Error: ${snapshot.error}');
              }

              if (snapshot.connectionState == ConnectionState.waiting) {
                return CircularProgressIndicator();
              }

              double totalBalance = 0;

              snapshot.data!.docs.forEach((DocumentSnapshot document) {
                Map<String, dynamic> data = document.data() as Map<String, dynamic>;
                totalBalance += data['amount'];
              });

              return Text(
                '\$$totalBalance',
                style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: totalBalance >= 0 ? Colors.green : Colors.red),
              );
            },
          ),
          SizedBox(height: 24),
          Text(
            'Recent Transactions',
            style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
          ),
          SizedBox(height: 8),
          Expanded(
            child: StreamBuilder<QuerySnapshot>(
              stream: FirebaseFirestore.instance.collection('transactions').snapshots(),
              builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
                if (snapshot.hasError) {
                  return Text('Error: ${snapshot.error}');
                }

                if (snapshot.connectionState == ConnectionState.waiting) {
                  return CircularProgressIndicator();
                }

                return ListView(
                  children: snapshot.data!.docs.map((DocumentSnapshot document) {
                    Map<String, dynamic> data = document.data() as Map<String, dynamic>;
                    return ListTile(
                      leading: Icon(
                        data['type'] == 'income' ? Icons.arrow_upward : Icons.arrow_downward,
                        color: data['type'] == 'income' ? Colors.green : Colors.red,
                      ),
                      title: Text(data['description'] ?? ''),
                      subtitle: Text(data['timestamp'] != null ? data['timestamp'].toDate().toString() : ''),
                      trailing: Text(
                        '${data['type'] == 'income' ? '+' : '-'} \$${data['amount'].toStringAsFixed(2)}',
                        style: TextStyle(color: data['type'] == 'income' ? Colors.green : Colors.red),
                      ),
                    );
                  }).toList(),
                );
              },
            ),
          ),
          SizedBox(height: 24),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              DropdownButton<String>(
                value: _transactionType,
                onChanged: (String? newValue) {
                  setState(() {
                    _transactionType = newValue!;
                  });
                },
                items: <String>['income', 'expenditure'].map<DropdownMenuItem<String>>((String value) {
                  return DropdownMenuItem<String>(
                    value: value,
                    child: Text(value == 'income' ? 'Add Income' : 'Add Expenditure'),
                  );
                }).toList(),
              ),
              SizedBox(width: 20),
              SizedBox(
                width: 120,
                child: TextField(
                  controller: _amountController,
                  keyboardType: TextInputType.numberWithOptions(decimal: true),
                  decoration: InputDecoration(
                    labelText: 'Amount',
                  ),
                ),
              ),
              SizedBox(width: 20),
              ElevatedButton(
                onPressed: () => _addTransaction(context),
                child: Text('Add'),
              ),
            ],
          ),
        ],
      ),
    );
  }

  void _addTransaction(BuildContext context) async {
    if (_amountController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text('Please enter an amount'),
      ));
      return;
    }

    final FirebaseFirestore _firestore = FirebaseFirestore.instance;
    final CollectionReference transactions = _firestore.collection('transactions');

    double amount = double.parse(_amountController.text);
    await transactions.add({
      'userId': widget.userId,
      'type': _transactionType,
      'amount': _transactionType == 'income' ? amount : -amount,
      'timestamp': Timestamp.now(),
    });

    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
      content: Text('Transaction added successfully'),
    ));

    _amountController.clear();
  }

  @override
  void dispose() {
    _amountController.dispose();
    super.dispose();
  }
}




class TransactionsPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Center(
      child: Text(
        'Transactions Page',
        style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
      ),
    );
  }
}

class ProfilePage extends StatelessWidget {
  final String userId;

  ProfilePage({required this.userId});

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<DocumentSnapshot>(
      future: FirebaseFirestore.instance.collection('User').doc(userId).get(),
      builder: (BuildContext context, AsyncSnapshot<DocumentSnapshot> snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return CircularProgressIndicator(); // Show loading indicator while fetching data
        }
        if (snapshot.hasError) {
          return Text('Error: ${snapshot.error}');
        }
        if (!snapshot.hasData || !snapshot.data!.exists) {
          return Text('User not found'); // Handle case where user data is not available
        }
        var userData = snapshot.data!.data() as Map<String, dynamic>; // Get user data
        return Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                'Profile Page',
                style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 20),
              Text('Name: ${userData['Овог']} ${userData['Нэр']}'),
              Text('Утас: ${userData['Утас']}'),
              // Add more user information here
            ],
          ),
        );
      },
    );
  }
}
