import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:intl/intl.dart';

class Transaction {
  final String type;
  final double amount;
  final DateTime date;
  Transaction(this.type, this.amount, this.date);
}
class TransactionPage extends StatefulWidget {
  const TransactionPage({Key? key}) : super(key: key);
  @override
  State<TransactionPage> createState() => _TransactionPageState();
}
class _TransactionPageState extends State<TransactionPage> {
  final List<Transaction> transactions = [];
  String selectedType = 'Боловсрол';
  void deleteTransaction(int index) {
    setState(() {
      transactions.removeAt(index);
    });
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "Хийгдэх Гүйлгээнүүд",
          style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
        ),
        actions: [
          IconButton(
            icon: Icon(Icons.add),
            onPressed: () => _dialogBuilder(context),
          )
        ],
      ),
      body: Container(child: PastTransactionsList(transactions, deleteTransaction)),
    );
  }
  Future<void> _dialogBuilder(BuildContext context) async {
    final TextEditingController amountController = TextEditingController();
    DateTime selectedDate = DateTime.now();
    return showDialog<void>(
      context: context,
      builder: (BuildContext context) {
        return StatefulBuilder(
          builder: (BuildContext context, StateSetter setState) {
            return AlertDialog(
              title: Text('Нэмэх'),
              content: SingleChildScrollView(
                child: ListBody(
                  children: <Widget>[
                    Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(13),
                        color:
                            Color.fromARGB(255, 48, 45, 206).withOpacity(0.1),
                      ),
                      child: DropdownButton<String>(
                        value: selectedType,
                        onChanged: (String? newValue) {
                          setState(() {
                            selectedType = newValue!;
                          });
                        },
                        items: <String>[
                          'Боловсрол',
                          'Ресторан',
                          'Хөгжим',
                          'Кино',
                          'Үнэт эдлэл',
                          'Аялал/Зугаалга',
                          'Гоо сайхан'
                        ].map<DropdownMenuItem<String>>((String value) {
                          return DropdownMenuItem<String>(
                            value: value,
                            child: Row(
                              children: <Widget>[
                                _getIconForType(value),
                                SizedBox(width: 8),
                                Text(value),
                              ],
                            ),
                          );
                        }).toList(),
                      ),
                    ),
                    SizedBox(height: 20),
                    TextField(
                      controller: amountController,
                      decoration: InputDecoration(
                        labelText: 'Үнэ',
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(18),
                          borderSide: BorderSide.none,
                        ),
                        fillColor:
                            Color.fromARGB(255, 48, 45, 206).withOpacity(0.1),
                        filled: true,
                        prefixIcon: const Icon(Icons.money),
                      ),
                      keyboardType: TextInputType.number,
                    ),
                    SizedBox(height: 20),
                    ElevatedButton(
                      onPressed: () async {
                        final DateTime? picked = await showDatePicker(
                          context: context,
                          initialDate: selectedDate,
                          firstDate: DateTime.now(),
                          lastDate: DateTime(2101),
                        );
                        if (picked != null && picked != selectedDate)
                          setState(() {
                            selectedDate = picked;
                          });
                      },
                      child: Text(DateFormat.yMd().format(selectedDate)),
                    ),
                  ],
                ),
              ),
              actions: <Widget>[
                TextButton(
                  child: const Text('Цуцлах'),
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                ),
                TextButton(
                  child: const Text('Нэмэх'),
                  onPressed: () {
                    final double amount =
                        double.tryParse(amountController.text) ?? 0.0;
                    if (amount > 0) {
                      this.setState(() {
                        transactions.add(Transaction(selectedType, amount, selectedDate));
                      });
                    }
                    Navigator.of(context).pop();
                  },
                ),
              ],
            );
          },
        );
      },
    );
  }
  Widget _getIconForType(String type) {
    switch (type) {
      case 'Боловсрол':
        return Icon(Icons.school,color: Colors.orange,);
      case 'Ресторан':
        return Icon(Icons.restaurant,color: Colors.green,);
      case 'Хөгжим':
        return Icon(Icons.music_note,color: Colors.pink,);
      case 'Кино':
        return Icon(Icons.movie,color: Colors.black,);
      case 'Үнэт эдлэл':
        return Icon(Icons.diamond,color: Colors.blue,);
      case 'Аялал/Зугаалга':
        return Icon(Icons.beach_access,color: Colors.yellow,);
      case 'Гоо сайхан':
        return Icon(Icons.spa,color: Colors.purple,);
      default:
        return Icon(Icons.category);
    }
  }
}
class PastTransactionsList extends StatelessWidget {
  final List<Transaction> transactions;
  final Function deleteTransaction;
  const PastTransactionsList(this.transactions, this.deleteTransaction);
  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      padding: EdgeInsets.zero,
      shrinkWrap: false,
      scrollDirection: Axis.vertical,
      itemCount: transactions.length,
      itemBuilder: (context, int index) {
        final transaction = transactions[index];
        return Card(
          elevation: 5,
          margin: EdgeInsets.symmetric(vertical: 8, horizontal: 5),
          child: ListTile(
            shape: RoundedRectangleBorder(
              side: const BorderSide(color: Colors.greenAccent, width: 0.25),
              borderRadius: BorderRadius.circular(10),
            ),
            title: Row(
              children: <Widget>[
                _getIconForType(transaction.type),
                SizedBox(width: 8),
                Text(transaction.type, style: TextStyle(color: Colors.black)),
              ],
            ),
            subtitle: Row(
              children: <Widget>[
                Text('€', style: TextStyle(color: Colors.black)),
                Text(transaction.amount.toString()),
              ],
            ),
            trailing: Row(
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                IconButton(
                  icon: Icon(Icons.delete),
                  onPressed: () => deleteTransaction(index),
                ),
                Text(DateFormat.MMMMEEEEd().format(transaction.date)),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _getIconForType(String type) {
    switch (type) {
      case 'Боловсрол':
        return Icon(Icons.school,color: Colors.orange,size: 50,);
      case 'Ресторан':
        return Icon(Icons.restaurant,color: Colors.green,size: 50,);
      case 'Хөгжим':
        return Icon(Icons.music_note,color: Colors.pink,size: 50,);
      case 'Кино':
        return Icon(Icons.movie,color: Colors.black,size: 50,);
      case 'Үнэт эдлэл':
        return Icon(Icons.diamond,color: Colors.blue,size: 50,);
      case 'Аялал/Зугаалга':
        return Icon(Icons.beach_access,color: Colors.yellow,size: 50,);
      case 'Гоо сайхан':
        return Icon(Icons.spa,color: Colors.purple,size: 50,);
      default:
        return Icon(Icons.category);
    }
  }
}
