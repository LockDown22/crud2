// ignore_for_file: unused_element

import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Firebase Firestore',
      home: HomePage(),
    );
  }
}

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
// text fields' controllers
  final TextEditingController _hotenController = TextEditingController();
  final TextEditingController _gioitinhController = TextEditingController();
  final TextEditingController _dienthoaiController = TextEditingController();
  final TextEditingController _diachiController = TextEditingController();
  final TextEditingController _mansController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();

  final CollectionReference _employee =
      FirebaseFirestore.instance.collection('nhansu');

  Future<void> _create([DocumentSnapshot? documentSnapshot]) async {

    await showModalBottomSheet(
        isScrollControlled: true,
        context: context,
        builder: (BuildContext ctx) {
          return Padding(
            padding: EdgeInsets.only(
                top: 20,
                left: 20,
                right: 20,
                bottom: MediaQuery.of(ctx).viewInsets.bottom + 20),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                TextField(
                  controller: _mansController,
                  decoration: const InputDecoration(labelText: 'Mã Ns'),
                ),
                TextField(
                  controller: _hotenController,
                  decoration: const InputDecoration(labelText: 'Name'),
                ),
                TextField(
                  controller: _gioitinhController,
                  decoration: const InputDecoration(labelText: 'Gioi Tinh'),
                ),
                TextField(
                  controller: _diachiController,
                  decoration: const InputDecoration(labelText: 'Dia Chi'),
                ),
                TextField(
                  controller: _emailController,
                  decoration: const InputDecoration(labelText: 'Email'),
                ),
                TextField(
                  keyboardType:
                  const TextInputType.numberWithOptions(),
                  controller: _dienthoaiController,
                  decoration: const InputDecoration(
                    labelText: 'Sdt',
                  ),
                ),
                const SizedBox(
                  height: 20,
                ),
                ElevatedButton(
                  child: const Text('Them NS'),
                  onPressed: () async {
                    final String mans = _mansController.text;
                    final String name = _hotenController.text;
                    final String gioitinh = _gioitinhController.text;
                    final String diachi = _diachiController.text;
                    final String email = _emailController.text;
                    
                    final int? sdt =
                    int.tryParse(_dienthoaiController.text);
                    if (sdt != null) {
                        await _employee.add({"hoten": name,"diachi":diachi,"gioitinh": gioitinh,"email":email,"mans":mans ,"dienthoai": sdt});

                      _mansController.text = '';
                      _hotenController.text = '';
                      _gioitinhController.text = '';
                      _diachiController.text = '';
                      _emailController.text = '';
                      _dienthoaiController.text = '';
                        Navigator.of(context).pop();
                    }
                  },
                )
              ],
            ),
          );

        });
  }
  Future<void> _update([DocumentSnapshot? documentSnapshot]) async {
    if (documentSnapshot != null) {

      _mansController.text = documentSnapshot['mans'];
      _hotenController.text = documentSnapshot['hoten'];
      _gioitinhController.text = documentSnapshot['gioitinh'];
      _diachiController.text = documentSnapshot['diachi'];
      _emailController.text = documentSnapshot['email'];
  
      _dienthoaiController.text = documentSnapshot['dienthoai'].toString();
    }

    await showModalBottomSheet(
        isScrollControlled: true,
        context: context,
        builder: (BuildContext ctx) {
          return Padding(
            padding: EdgeInsets.only(
                top: 20,
                left: 20,
                right: 20,
                bottom: MediaQuery.of(ctx).viewInsets.bottom + 20),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                TextField(
                  controller: _mansController,
                  decoration: const InputDecoration(labelText: 'mans'),
                ),
                TextField(
                  controller: _hotenController,
                  decoration: const InputDecoration(labelText: 'hoten'),
                ),
                TextField(
                  controller: _gioitinhController,
                  decoration: const InputDecoration(labelText: 'gioitinh'),
                ),
                TextField(
                  controller: _diachiController,
                  decoration: const InputDecoration(labelText: 'diachi'),
                ),
                TextField(
                  controller: _emailController,
                  decoration: const InputDecoration(labelText: 'email'),
                ),
                TextField(
                  keyboardType:
                      const TextInputType.numberWithOptions(),
                  controller: _dienthoaiController,
                  decoration: const InputDecoration(
                    labelText: 'dienthoai',
                  ),
                ),
                const SizedBox(
                  height: 20,
                ),
                ElevatedButton(
                  child: const Text( 'Update'),
                  onPressed: () async {
                    final String mans = _mansController.text;
                    final String name = _hotenController.text;
                    final String gioitinh = _gioitinhController.text;
                    final String diachi = _diachiController.text;
                    final String email = _emailController.text;
                    final int? sdt =
                        int.tryParse(_dienthoaiController.text);
                    if (sdt != null) {

                        await _employee
                            .doc(documentSnapshot!.id)
                            .update({"mans": mans,"hoten": name,"gioitinh": gioitinh,"diachi": diachi,"email": email, "dienthoai": sdt});
                      _mansController.text = '';
                      _hotenController.text = '';
                      _gioitinhController.text = '';
                      _diachiController.text = '';
                      _emailController.text = '';
                      _dienthoaiController.text = '';
                        Navigator.of(context).pop();
                    }
                  },
                )
              ],
            ),
          );
        });
  }

  Future<void> _delete(String productId) async {
    await _employee.doc(productId).delete();

    ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
        content: Text('You have successfully deleted a product')));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Center(child: Text('CRUD with Firebase Firestore')),
      ),
      body: StreamBuilder(
        stream: _employee.snapshots(),
        builder: (context, AsyncSnapshot<QuerySnapshot> streamSnapshot) {
          if (streamSnapshot.hasData) {
            return ListView.builder(
              itemCount: streamSnapshot.data!.docs.length,
              itemBuilder: (context, index) {
                final DocumentSnapshot documentSnapshot =
                    streamSnapshot.data!.docs[index];
                return Card(
                  margin: const EdgeInsets.all(10),
                  child: Column(children: [

                    Text(documentSnapshot['mans']),
                    Text(documentSnapshot['hoten']),
                    Text(documentSnapshot['gioitinh']),
                    Text(documentSnapshot['diachi']),
                    Text(documentSnapshot['email']),
                    Text(documentSnapshot['dienthoai'].toString()),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                      IconButton(
                               icon: const Icon(Icons.edit),
                              onPressed: () =>
                                 _update(documentSnapshot)),
                    IconButton(
                               icon: const Icon(Icons.delete),
                               onPressed: () =>
                                   _delete(documentSnapshot.id))

                    ],)
                    
                  
                  ],
                  ),
                  // child: ListTile(
                  //   title: Text(documentSnapshot['mans']),
                  //   subtitle: Text(documentSnapshot['dienthoai'].toString()),
                  //   trailing: SizedBox(
                  //     width: 100,
                  //     child: Row(
                  //       children: [
                  //         IconButton(
                  //             icon: const Icon(Icons.edit),
                  //             onPressed: () =>
                  //                 _update(documentSnapshot)),
                  //         IconButton(
                  //             icon: const Icon(Icons.delete),
                  //             onPressed: () =>
                  //                 _delete(documentSnapshot.id)),
                  //       ],
                  //     ),
                  //   ),
                  // ),
                );
              },
            );
          }

          return const Center(
            child: CircularProgressIndicator(),
          );
        },
      ),
// Add new product
      floatingActionButton: FloatingActionButton(
        onPressed: () => _create(),
        child: const Icon(Icons.add),

      ),
        floatingActionButtonLocation: FloatingActionButtonLocation.endFloat
    );
  }
}