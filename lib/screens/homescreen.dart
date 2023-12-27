import 'package:comrade_app/pages/addpost.dart';
import 'package:comrade_app/screens/signin_screen.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final firestore = FirebaseFirestore.instance.collection("data").snapshots();
  final auth = FirebaseAuth.instance;
  late User? user = auth.currentUser;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: Drawer(
          child: ListView(
        children: [
          DrawerHeader(
            decoration: BoxDecoration(
              color: Theme.of(context).primaryColor,
            ),
            child: Text(
              user!.email.toString(),
              style: const TextStyle(color: Colors.white, fontSize: 18),
            ),
          ),
          ListTile(
            onTap: () {
              Navigator.pop(context);
              auth.signOut();
              Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => const SignInScreen()));
            },
            leading: const Icon(Icons.logout_rounded),
            title: const Text(
              "Logout",
              style: TextStyle(fontSize: 20),
            ),
          ),
          const Divider()
        ],
      )),
      floatingActionButton: FloatingActionButton(
          onPressed: () {
            Navigator.push(context,
                MaterialPageRoute(builder: (context) => const AddPost()));
          },
          backgroundColor:
              Theme.of(context).floatingActionButtonTheme.backgroundColor,
          child: const Icon(Icons.add_photo_alternate_outlined, size: 35)),
      appBar: AppBar(
        title: const Text(
          "Home Screen",
        ),
      ),
      body: Column(verticalDirection: VerticalDirection.down, children: [
        //StreamBuilder //FirebaseAnimatedList

        StreamBuilder<QuerySnapshot>(
            stream: firestore,
            builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
              if (snapshot.hasData) {
                return Expanded(
                    child: ListView.builder(
                  shrinkWrap: true,
                  reverse: true,
                  itemCount: snapshot.data?.docs.length,
                  itemBuilder: (context, index) {
                    return Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 8.0),
                      child: Card(
                        color: Theme.of(context).cardColor,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const SizedBox(
                              height: 10,
                            ),
                            Padding(
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 5.0),
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(
                                    snapshot.data!.docs[index]['email'],
                                    style: const TextStyle(
                                        fontSize: 15,
                                        fontWeight: FontWeight.bold),
                                  ),
                                  Row(
                                    children: [
                                      Text(
                                        snapshot.data!.docs[index]['postDate'],
                                        style: const TextStyle(
                                            fontSize: 15,
                                            fontWeight: FontWeight.bold),
                                      ),
                                      const SizedBox(
                                        width: 20,
                                      ),
                                      Text(
                                        snapshot.data!.docs[index]['postTime'],
                                        style: const TextStyle(
                                            fontSize: 15,
                                            fontWeight: FontWeight.bold),
                                      ),
                                      const SizedBox(
                                        width: 10,
                                      ),
                                    ],
                                  )
                                ],
                              ),
                            ),
                            const SizedBox(
                              height: 7,
                            ),
                            Image.network(
                              snapshot.data!.docs[index]['image'],
                              height: 400,
                              width: 400,
                            ),
                            const SizedBox(
                              height: 10,
                            ),
                            Padding(
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 15.0),
                              child: Text(
                                snapshot.data!.docs[index]['message']
                                    .toString(),
                                style: const TextStyle(fontSize: 16),
                              ),
                            ),
                            const SizedBox(
                              height: 10,
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                ));
              } else if (snapshot.connectionState == ConnectionState.waiting) {
                return Center(
                  child: CircularProgressIndicator(
                    color: Theme.of(context).primaryColor,
                  ),
                );
              } else if (!snapshot.hasData) {
                return const Center(
                    child: Text(
                  "No Posts Yet!",
                  style: TextStyle(fontSize: 25),
                ));
              } else {
                return const Center(
                    child: Text(
                  "No Posts Yet!",
                  style: TextStyle(fontSize: 25),
                ));
              }
            }),
      ]),
    );
  }
}
