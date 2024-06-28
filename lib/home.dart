import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:linktify/startupPage.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    CollectionReference startups =
        FirebaseFirestore.instance.collection('startups');

    return StreamBuilder<QuerySnapshot>(
      stream: startups.snapshots(), // Get a stream of all documents
      builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
        if (snapshot.hasError) {
          return Scaffold(
            appBar: AppBar(
              title: const Image(
                image: AssetImage('assets/Linktify Logo alt.png'),
                height: 30,
              ),
            ),
            body: const Text('Something went wrong'),
          );
        }

        if (snapshot.connectionState == ConnectionState.waiting) {
          return Scaffold(
            appBar: AppBar(
              title: const Image(
                image: AssetImage('assets/Linktify Logo alt.png'),
                height: 30,
              ),
            ),
            body: const Text('Loading'),
          );
        }

        if (snapshot.hasData) {
          if (snapshot.data!.docs.isEmpty) {
            return Scaffold(
              appBar: AppBar(
                title: const Image(
                  image: AssetImage('assets/Linktify Logo alt.png'),
                  height: 30,
                ),
              ),
              body: const Text('No documents found'),
            );
          }

          return MaterialApp(
            home: Scaffold(
              appBar: AppBar(
                title: const Image(
                  image: AssetImage('assets/Linktify Logo alt.png'),
                  height: 30,
                ),
              ),
              body: ListView.builder(
                itemCount: snapshot.data!.docs.length,
                itemBuilder: (context, index) {
                  DocumentSnapshot document = snapshot.data!.docs[index];

                  // Check if document data exists before accessing it
                  if (document.data() == null) {
                    return const ListTile(
                      title: Text('Document has no data'),
                    );
                  }

                  Map<String, dynamic> data =
                      document.data()! as Map<String, dynamic>;
                  return Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: GestureDetector(
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => StartupPage(startupId: document.id),
                          ),
                        );
                      },
                      child: Container(
                        decoration: BoxDecoration(
                          color: Colors.white, // Customize the background color
                          boxShadow: [
                            BoxShadow(
                              color: Colors.grey.withOpacity(
                                  0.2), // Set a light gray shadow color with low opacity
                              blurRadius:
                                  5.0, // Adjust blurRadius for a softer shadow
                              spreadRadius:
                                  0.0, // Set spreadRadius to 0 to avoid extending the shadow
                              offset: Offset(2.0,
                                  2.0), // Adjust offset for shadow direction (optional)
                            )
                          ],
                          borderRadius: BorderRadius.circular(
                              10.0), // Set the desired border radius
                          border: Border.all(
                            color: Colors.grey.withOpacity(
                                0.2), // Match border color to shadow
                            width: 1.0, // Set the border width
                          ),
                        ),
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Row(
                            children: [
                              Image.network(
                                data['logo'],
                                height: 50,
                              ),
                              SizedBox(width: 10.0),
                              Text(
                                data['title']?.toString() ?? 'No name',
                                style: TextStyle(fontWeight: FontWeight.bold),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  );
                },
              ),
            ),
          );
        }

        // Handle initial null state from Stream (optional)
        return Scaffold(
          appBar: AppBar(
            title: const Image(
              image: AssetImage('assets/Linktify Logo alt.png'),
              height: 30,
            ),
          ),
          body: const Text('Waiting for data...'),
        );
      },
    );
  }
}
