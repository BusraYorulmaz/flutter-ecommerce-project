import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:eticaret_project/pages/adminPages/admin_login.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';

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

  @override
  Widget build(BuildContext context) {
    var collection = _firestore.collection('urun');
    Stream<QuerySnapshot> docSnapShot = collection.snapshots();

    ekleAdd(String urunName, String urunKategori, String bodySize,
        String shoeSize) async {
      Map<String, dynamic> _eklenecekVeri = <String, dynamic>{};
      _eklenecekVeri['isim'] = urunName;
      _eklenecekVeri['kategori'] = urunKategori;
      _eklenecekVeri['body'] = bodySize;
      _eklenecekVeri['shoe'] = shoeSize;

      await _firestore.collection('urun').doc(urunName).set(_eklenecekVeri);

      createPopup();
    }

    guncelleme(String urunName, String urunKategori, String bodySize,
        String shoeSize) async {
      await _firestore.collection('urun').doc(urunName).update({
        'isim': urunName,
        'kategori': urunKategori,
        'body': bodySize,
        'shoe': shoeSize
      });
      guncellePopup();
    }

    veriSil(String urunName, String urunKategori, String bodySize,
        String shoeSize) async {
      await _firestore.collection('urun').doc(urunName).delete();
      silPopup();
    }

    queryingData() async {
      var _userRef = _firestore.collection('urun');
      var _sonuc = await _userRef.where('body', whereIn: ['38', '40']).get();

      for (var urun in _sonuc.docs) {
        debugPrint(urun.data().toString());
      }
    }

    return Scaffold(
      drawer: NavigationDrawer(), //navbar yandan açılır menu
      appBar: AppBar(
        title: const Text("Admin Panel"),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: TextField(
                controller: urunName,
                decoration: const InputDecoration(hintText: "Urun Name"),
              ),
            ),
            // Padding(
            //   padding: const EdgeInsets.all(16.0),
            //   child: TextField(
            //     controller: urunKategori,
            //     decoration: const InputDecoration(hintText: "Urun kategori"),
            //   ),
            // ),stream: _firestore.collection('urun').doc('kategori').snapshots(),

     
   


            Padding(
              padding: const EdgeInsets.all(16.0),
              child: TextField(
                controller: bodySize,
                decoration: const InputDecoration(hintText: "Urun body size"),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: TextField(
                controller: shoeSize,
                decoration: const InputDecoration(hintText: "Urun shoe size"),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(20.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  ElevatedButton(
                    onPressed: () {
                      ekleAdd(urunName.text, urunKategori.text, bodySize.text,
                          shoeSize.text);
                    },
                    child: Text("Create"),
                    style: ElevatedButton.styleFrom(
                      primary: Colors.green,
                      onPrimary: Colors.white,
                      shadowColor: Colors.deepPurple,
                      elevation: 5,
                    ),
                  ),
                  ElevatedButton(
                    onPressed: () {
                      guncelleme(urunName.text, urunKategori.text,
                          bodySize.text, shoeSize.text);
                    },
                    child: Text("Update"),
                    style: ElevatedButton.styleFrom(
                      primary: Colors.orange,
                      onPrimary: Colors.white,
                      shadowColor: Colors.deepPurple,
                      elevation: 5,
                    ),
                  ),
                  ElevatedButton(
                    onPressed: () {
                      veriSil(urunName.text, urunKategori.text, bodySize.text,
                          shoeSize.text);
                    },
                    child: Text("Delete"),
                    style: ElevatedButton.styleFrom(
                      primary: Colors.red,
                      onPrimary: Colors.white,
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
                  const Text('VERİLER', style: TextStyle(fontSize: 24)),
                  //veriler stream ile anlık olarak izlenerek ekrana yazdırılıyor
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
                                title: Text("İsim: " + document['isim'],
                                    style: const TextStyle(fontSize: 16)),
                                subtitle: Row(
                                  mainAxisSize: MainAxisSize.max,
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text(
                                      "Kategori: " + document['kategori'],
                                      style: const TextStyle(fontSize: 13),
                                    ),
                                    Text(
                                      " Body: " + document['body'],
                                      style: const TextStyle(fontSize: 13),
                                    ),
                                    Text(
                                      " Shoe: " + document['shoe'],
                                      style: const TextStyle(fontSize: 13),
                                    ),
                                  ],
                                ),
                              ),
                            );
                          }).toList(),
                        );
                        // return Text("sd");
                      }),

                  Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: const Text('Kategoriler',
                        style: TextStyle(fontSize: 24)),
                  ),

                  ElevatedButton(
                    onPressed: () => queryingData(),
                    child: Text("sorgu"),
                    style: ElevatedButton.styleFrom(primary: Colors.red),
                  ),
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
            title: const Text('Ürün Eklendi', textAlign: TextAlign.center),
            children: <Widget>[
              TextButton(
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  child: const Text('OKEY')),
            ],
          )));
  guncellePopup() => showDialog(
      context: context,
      builder: ((context) => SimpleDialog(
            title: const Text('Ürün Güncellendi', textAlign: TextAlign.center),
            children: <Widget>[
              TextButton(
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  child: const Text('OKEY')),
            ],
          )));
  silPopup() => showDialog(
      context: context,
      builder: ((context) => SimpleDialog(
            title: const Text('Ürün Silindi', textAlign: TextAlign.center),
            children: <Widget>[
              TextButton(
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  child: const Text('OKEY')),
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
              title: Text('home'),
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
              title: Text('Admin'),
              onTap: () {},
            ),
            ListTile(
              leading: Icon(Icons.workspaces_outlined),
              title: Text('Workflow'),
              onTap: () {},
            ),
            ListTile(
              leading: Icon(Icons.arrow_back_sharp),
              title: Text('Exit'),
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
