import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:linktify/backers.dart';

class StartupPage extends StatefulWidget {
  final String startupId;

  const StartupPage({super.key, required this.startupId});

  @override
  State<StartupPage> createState() => _StartupPageState();
}

class _StartupPageState extends State<StartupPage> {
  late Future<DocumentSnapshot<Map<String, dynamic>>> _startupFuture;

  @override
  void initState() {
    super.initState();
    _startupFuture =
        getStartupById(widget.startupId); // Fetch data on initState
  }

  void reloadStartupData() async {
    setState(() {
      _startupFuture = getStartupById(widget.startupId);
    });
  }

  Future<DocumentSnapshot<Map<String, dynamic>>> getStartupById(
      String id) async {
    // Get a reference to the startups collection
    final CollectionReference startups =
        FirebaseFirestore.instance.collection('startups');

    // Try fetching the document with the specified ID
    try {
      final docSnapshot = await startups.doc(id).get();
      return docSnapshot as DocumentSnapshot<Map<String, dynamic>>;
    } catch (error) {
      return Future.error(error); // Re-throw or handle the error appropriately
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Image(
          image: AssetImage('assets/Linktify Logo alt.png'),
          height: 30,
        ),
      ),
      body: SingleChildScrollView(
        child: Center(
          child: FutureBuilder<DocumentSnapshot<Map<String, dynamic>>>(
            future: _startupFuture,
            builder: (context, snapshot) {
              if (snapshot.hasError) {
                return Text('Error: ${snapshot.error}');
              }

              if (snapshot.connectionState == ConnectionState.waiting) {
                return const CircularProgressIndicator();
              }

              return _buildStartupDetails(
                  snapshot.data!.data()!); // Access data
            },
          ),
        ),
      ),
    );
  }

  Widget _buildStartupDetails(Map<String, dynamic> startupData) {
    bool isStartupVerified = startupData['verified'];
    bool isStartupRecommended = startupData['recommended'];
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Align(
            alignment: Alignment.center,
            child: Text(startupData['title'],
                style: const TextStyle(
                  fontSize: 20.0,
                  fontWeight: FontWeight.bold,
                )),
          ),

          const Padding(
            padding: EdgeInsets.fromLTRB(20.0, 20.0, 0, 0),
            child: Text('Owner',
                style: TextStyle(
                  fontSize: 20.0,
                  fontWeight: FontWeight.bold,
                )),
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(20.0, 0, 20.0, 20.0),
            child: Container(
              decoration: BoxDecoration(
                color: Colors.white, // Customize the background color
                borderRadius: BorderRadius.circular(
                    10.0), // Set the desired border radius
                border: Border.all(
                  color: Colors.grey
                      .withOpacity(0.2), // Match border color to shadow
                  width: 1.0, // Set the border width
                ),
              ),
              child: Padding(
                padding: const EdgeInsets.all(20.0),
                child: Column(
                  children: [
                    _dataRow('name', startupData['owner']['name']),
                    _dataRow('email', startupData['owner']['email']),
                    _dataRow('prfession', startupData['owner']['profeesion']),
                  ],
                ),
              ),
            ),
          ),
          _dataColumn('startup idea', startupData['shortDisc']),
          _dataColumn('startup discription', startupData['disc']),
          _dataColumn('Goal', startupData['goal'].toString()),
          _dataColumn('funded', startupData['funded'].toString()),

          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _dataColumn('verifcation', ''),
              const Spacer(),
              Switch(
                value:
                    isStartupVerified, // Replace with your boolean variable for verification state
                onChanged: (value) async {
                  final docRef = FirebaseFirestore.instance
                      .collection('startups')
                      .doc(widget.startupId);

                  try {
                    await docRef.update({'verified': value});
                    getStartupById(widget.startupId);
                    reloadStartupData();
                    // Verification successful (optional: show a success message)
                  } catch (error) {
                    // Handle errors appropriately (e.g., display an error message to the user)
                  }
                },
                activeColor: Colors.blue,
              )
            ],
          ),
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _dataColumn('recommended', ''),
              const Spacer(),
              Switch(
                value:
                    isStartupRecommended, // Replace with your boolean variable for verification state
                onChanged: (value) async {
                  final docRef = FirebaseFirestore.instance
                      .collection('startups')
                      .doc(widget.startupId);

                  try {
                    await docRef.update({'recommended': value});
                    getStartupById(widget.startupId);
                    reloadStartupData();
                    // Verification successful (optional: show a success message)
                  } catch (error) {
                    // Handle errors appropriately (e.g., display an error message to the user)
                  }
                },
                activeColor: Colors.blue,
              ),
            ],
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(20.0, 10.0, 0, 0),
            child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.blue, // Set background color
                  foregroundColor: Colors.white, // Set text color
                  textStyle: const TextStyle(fontSize: 18.0), // Set text style
                  shape: RoundedRectangleBorder(
                      borderRadius:
                          BorderRadius.circular(10.0)), // Set border shape

                  padding:
                      const EdgeInsets.fromLTRB(20.0, 5, 20, 5), // Set padding
                  tapTargetSize: MaterialTapTargetSize
                      .shrinkWrap, // Optional: adjust tap area
                ),
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) =>
                          Backers(backers: startupData['backers']),
                    ),
                  );
                },
                child: const Text('backers')),
          ),

          // ... Other widgets for details
        ],
      ),
    );
  }

  Row _dataRow(title, startupData) {
    return Row(
      children: [
        Text('$title :',
            style: const TextStyle(
              fontWeight: FontWeight.bold,
            )),
        const SizedBox(width: 10.0),
        Text(startupData)
      ],
    );
  }

  Column _dataColumn(title, startupData) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.fromLTRB(20.0, 20.0, 0, 0),
          child: Text(title,
              style: const TextStyle(
                fontSize: 20.0,
                fontWeight: FontWeight.bold,
              )),
        ),
        // Or other Alignment values
        Padding(
          padding: const EdgeInsets.fromLTRB(20.0, 0, 0, 0),
          child: Text(startupData),
        ),
      ],
    );
  }
}

class SwitchExample extends StatefulWidget {
  const SwitchExample({super.key});

  @override
  State<SwitchExample> createState() => _SwitchExampleState();
}

class _SwitchExampleState extends State<SwitchExample> {
  bool light = true;

  @override
  Widget build(BuildContext context) {
    return Switch(
      // This bool value toggles the switch.
      value: light,
      activeColor: Colors.red,
      onChanged: (bool value) {
        // This is called when the user toggles the switch.
        setState(() {
          light = value;
        });
      },
    );
  }
}
