import 'package:flutter/material.dart';

class Backers extends StatefulWidget {
  final backers;
  const Backers({super.key, this.backers});

  @override
  State<Backers> createState() => _BackersState();
}

class _BackersState extends State<Backers> {
  final List<String> _items = ['Item 1', 'Item 2', 'Item 3'];
  Future<void> _refreshData() async {
    // Simulate fetching new data with a delay
    setState(() {
      _items.insert(0, 'New Item');
    });
  }

  @override
  Widget build(BuildContext context) {
    return RefreshIndicator(
      onRefresh: () => _refreshData(),
      child: MaterialApp(
        home: Scaffold(
          appBar: AppBar(
            title: const Text('Backers'),
          ),
          body: ListView.builder(
            itemCount: widget.backers.length,
            itemBuilder: (context, index) {
              final backerData = widget.backers[index];
              return Card(
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    children: [
                      Text(
                        'Name: ${backerData['backer']['name']}',
                        style: const TextStyle(fontWeight: FontWeight.bold),
                      ),
                      Text('Email: ${backerData['backer']['email']}'),
                      Text('Amount: ${backerData['amount']}DZD',
                          style: const TextStyle(fontSize: 18.0)),
                    ],
                  ),
                ),
              );
            },
          ),
        ),
      ),
    );
  }
}
