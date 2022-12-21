import 'dart:convert';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:eticaret_project/pages/adminPages/admin_login.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:snippet_coder_utils/FormHelper.dart';

class AdminHomePage extends StatefulWidget {
  const AdminHomePage({Key? key}) : super(key: key);

  @override
  State<AdminHomePage> createState() => _AdminHomePageState();
}

class _AdminHomePageState extends State<AdminHomePage> {
  FirebaseFirestore _firestore = FirebaseFirestore.instance;

  TextEditingController urunName = TextEditingController();
  TextEditingController urunKategori = TextEditingController();
  TextEditingController bodySize = TextEditingController();
  TextEditingController shoeSize = TextEditingController();

  final List<String> bodyShoeSize = ['bodysec'.tr, 'shoesec'.tr];
  final List<String> shoeSized = [
    '35',
    '36',
    '37',
    '38',
    '39',
    '40',
    '41',
    '42',
    '43',
    '44'
  ];
  final List<String> bodySized = [
    'XSmall',
    'Small',
    'Medium',
    'Large',
    'XLarge',
    'XX Large'
  ];

  String? selectedBodyorShoe;
  String? selectedSize;
  List<String> size = [];

  @override
  Widget build(BuildContext context) {
    var collection = _firestore.collection('urun');
    Stream<QuerySnapshot> docSnapShot = collection.snapshots();

    ekleAdd(
      String urunName,
      String selectedBodyorShoe,
      String bodySselectedSizeize,
    ) async {
      Map<String, dynamic> _eklenecekVeri = <String, dynamic>{};
      _eklenecekVeri['isim'] = urunName;
      _eklenecekVeri['kategori'] = selectedBodyorShoe;
      _eklenecekVeri['size1'] = selectedSize;

      await _firestore.collection('urun').doc(urunName).set(_eklenecekVeri);
      createPopup();
    }

    guncelleme(
      String urunName,
      String selectedBodyorShoe,
      String selectedSize,
    ) async {
      await _firestore.collection('urun').doc(urunName).update({
        'isim': urunName,
        'kategori': selectedBodyorShoe,
        'size1': selectedSize
      });
      guncellePopup();
    }

    veriSil(String urunName, String urunKategori, String bodySize,
        String shoeSize) async {
      await _firestore.collection('urun').doc(urunName).delete();
      silPopup();
    }

    return Scaffold(
      drawer: NavigationDrawer(), //navbar yandan açılır menu
      appBar: AppBar(
        title: Text("adminPanel".tr),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: TextField(
                controller: urunName,
                decoration: InputDecoration(hintText: "urunName".tr),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: DropdownButton<String>(
                isExpanded: true,
                value: selectedBodyorShoe,
                items: bodyShoeSize.map((e) {
                  return DropdownMenuItem<String>(
                    value: e,
                    child: Text('$e'),
                  );
                }).toList(),
                onChanged: (val) {
                  selectedSize = null;
                  size = val == 'bodysec'.tr ? bodySized : shoeSized;
                  setState(() {
                    selectedBodyorShoe = val;
                    print("Seçim: $val");
                  });
                },
              ),
            ),

            //province
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: DropdownButton<String>(
                isExpanded: true,
                value: selectedSize,
                items: size.map((e) {
                  return DropdownMenuItem<String>(
                    value: e,
                    child: Text('$e'),
                  );
                }).toList(),
                onChanged: (valSize) {
                  setState(() {
                    selectedSize = valSize;
                    print("Size: $valSize");
                  });
                },
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(20.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  ElevatedButton(
                    onPressed: () {
                      ekleAdd(urunName.text, selectedBodyorShoe.toString(),
                          selectedSize.toString());
                    },
                    child: Text("create".tr),
                    style: ElevatedButton.styleFrom(
                      primary: Colors.grey.shade300,
                      onPrimary: Colors.deepPurple,
                      shadowColor: Colors.deepPurple,
                      elevation: 5,
                    ),
                  ),
                  ElevatedButton(
                    onPressed: () {
                      guncelleme(urunName.text, selectedBodyorShoe.toString(),
                          selectedSize.toString());
                    },
                    child: Text("update".tr),
                    style: ElevatedButton.styleFrom(
                      primary: Colors.grey.shade300,
                      onPrimary: Colors.deepPurple,
                      shadowColor: Colors.deepPurple,
                      elevation: 5,
                    ),
                  ),
                  ElevatedButton(
                    onPressed: () {
                      veriSil(urunName.text, urunKategori.text, bodySize.text,
                          shoeSize.text);
                    },
                    child: Text("delete".tr),
                    style: ElevatedButton.styleFrom(
                      primary: Colors.grey.shade300,
                      onPrimary: Colors.deepPurple,
                      shadowColor: Colors.deepPurple,
                      elevation: 5,
                    ),
                  ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Container(
                  child: Column(
                children: [
                  Text('veriler'.tr, style: TextStyle(fontSize: 24)),
                  //veriler stream ile anlık olarak izlenerek ekrana yansıtılıyor.
                  StreamBuilder<QuerySnapshot<Object?>>(
                      stream: _firestore.collection('urun').snapshots(),
                      builder: (BuildContext context,
                          AsyncSnapshot<QuerySnapshot> snapshot) {
                        if (!snapshot.hasData) {
                          return const Center(
                            child: CircularProgressIndicator(),
                          );
                        }
                        return ListView(
                          physics: const NeverScrollableScrollPhysics(),
                          scrollDirection: Axis.vertical,
                          shrinkWrap: true,
                          children: snapshot.data!.docs.map((document) {
                            return Card(
                              child: ListTile(
                                title: Text("urunName".tr + document['isim'],
                                    style: const TextStyle(fontSize: 16)),
                                subtitle: Row(
                                  mainAxisSize: MainAxisSize.max,
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text(
                                      "kategori".tr + document['kategori'],
                                      style: const TextStyle(fontSize: 13),
                                    ),

                                    //Text("Size" + document['size'],style: const TextStyle(fontSize: 13),),
                                    //     Text("Size" + document['size']),

                                    Text(
                                      "size".tr + document['size1'],
                                      style: const TextStyle(fontSize: 13),
                                    ),
                                    // Text(
                                    //   "shoeSize".tr + document['shoe'],
                                    //   style: const TextStyle(fontSize: 13),
                                    // ),
                                  ],
                                ),
                              ),
                            );
                          }).toList(),
                        );
                        // return Text("sd");
                      }),
                ],
              )),
            ),
          ],
        ),
      ),
    );
  }

  createPopup() => showDialog(
      context: context,
      builder: ((context) => SimpleDialog(
            title: Text('product_added'.tr, textAlign: TextAlign.center),
            children: <Widget>[
              TextButton(
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  child: Text('okey'.tr)),
            ],
          )));
  guncellePopup() => showDialog(
      context: context,
      builder: ((context) => SimpleDialog(
            title: Text('product_updated'.tr, textAlign: TextAlign.center),
            children: <Widget>[
              TextButton(
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  child: Text('okey'.tr)),
            ],
          )));
  silPopup() => showDialog(
      context: context,
      builder: ((context) => SimpleDialog(
            title: Text('product_deleted'.tr, textAlign: TextAlign.center),
            children: <Widget>[
              TextButton(
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  child: Text('okey'.tr)),
            ],
          )));
}

//NAVBAR yandan açılır menü
class NavigationDrawer extends StatelessWidget {
  const NavigationDrawer({super.key});

  @override
  Widget build(BuildContext context) => Drawer(
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: <Widget>[buildHeader(context), buildMenuItems(context)],
          ),
        ),
      );

  Widget buildHeader(BuildContext context) => Material(
        color: Colors.deepPurple,
        child: Container(
          padding: EdgeInsets.only(
            top: MediaQuery.of(context).padding.top,
            bottom: 24,
          ),
          child: Column(
            children: const [
              CircleAvatar(
                radius: 52,
                backgroundImage: NetworkImage(
                  //resimler ve buradaki bilgiler veri tabanından çekilecek şuan tasarım yapıldı
                  'https://www.wpdurum.com/uploads/thumbs/anime-kiz-profil-resimleri-1.jpg',
                ),
              ),
              SizedBox(
                height: 12,
              ),
              Text(
                'Büşra Yorulmaz',
                style: TextStyle(fontSize: 28, color: Colors.amber),
              ),
              Text(
                'busrayorulmaz42@gmail.com',
                style: TextStyle(fontSize: 16, color: Colors.amberAccent),
              ),
            ],
          ),
        ),
      );

  Widget buildMenuItems(BuildContext context) => Container(
        padding: const EdgeInsets.all(24),
        child: Wrap(
          runSpacing: 16, //vertical sapcing
          children: [
            ListTile(
              leading: Icon(Icons.home_outlined),
              title: Text('home'.tr),
              onTap: () {
                Navigator.of(context).pushReplacement(MaterialPageRoute(
                  builder: (context) => const AdminHomePage(),
                ));
              },
            ),
            const Divider(
              color: Colors.black54,
            ),
            ListTile(
              leading: Icon(Icons.admin_panel_settings_outlined),
              title: Text('admin'.tr),
              onTap: () {},
            ),
            ListTile(
              leading: Icon(Icons.arrow_back_sharp),
              title: Text('exit'.tr),
              onTap: () {
                Navigator.of(context).pushReplacement(MaterialPageRoute(
                  builder: (context) => const AdminUserPages(),
                ));
              },
            ),
          ],
        ),
      );
}
