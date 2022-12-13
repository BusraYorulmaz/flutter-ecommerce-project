import'package:eticaret_project/main.dart';
import 'package:eticaret_project/pages/splashPages/splash_screen.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

//user page ve register page in olduğu ana sayfa 
class WidgetUserAndRegister extends StatefulWidget {
  const WidgetUserAndRegister({Key? key}) : super(key: key);

  @override
  State<WidgetUserAndRegister> createState() => _WidgetUserAndRegisterState();
}

class _WidgetUserAndRegisterState extends State<WidgetUserAndRegister> {
  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: SafeArea(
        child: Scaffold(
          body: NestedScrollView(
            headerSliverBuilder: (context, innerBoxIsScrolled) {
              return [
                SliverAppBar(
                  leading: Builder(builder: (BuildContext context) {
                    return IconButton(
                      //appbar ikon ve yönlendirme
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => const SplashScreenWidget(),
                          ),
                        );
                      },
                      icon: const Icon(Icons.arrow_back),
                    );
                  }),

                  //kaydırılabilir appbar
                  title: const Text('USER PAGE'),
                  expandedHeight: 50,
                  pinned: true,
                ),
                const SliverToBoxAdapter(
                  child: TabBar(
                    labelColor: Colors.pink,
                    unselectedLabelColor: Colors.black,
                    indicatorColor: Colors.pink,
                    tabs: [
                      Tab(
                        icon: Icon(Icons.account_circle_rounded),
                        text: 'Login',
                      ),
                      Tab(
                        icon: Icon(Icons.add_box_sharp),
                        text: 'Register',
                      ),
                    ],
                  ),
                ),
              ];
            },
            body: const TabBarView(
                children: [UserLoginPage(), RegisterUserPage()]),
          ),
        ),
      ),
    );
  }
}


//Kullanıcı girişi 
class UserLoginPage extends StatefulWidget {
  const UserLoginPage({Key? key}) : super(key: key);

  @override
  State<UserLoginPage> createState() => _UserLoginPageState();
}

class _UserLoginPageState extends State<UserLoginPage> {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  // final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  bool sifre_gozukme = true;

//giriş yap fonksiyonu
  Future<User?> signIn(String email, String password) async {
    try {
      var user = await _auth.signInWithEmailAndPassword(
          email: email, password: password);
      openInformationPopup();
      debugPrint(user.toString() + " email ve şife doğru ");
    } catch (e) {
      debugPrint(e.toString() + " email yada şifre hatali");
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => MyApp(),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: Center(
          child: SingleChildScrollView(
            child: Padding(
              padding: EdgeInsets.all(40.0),
              child: Form(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Text(
                      'USER LOGIN',
                      style: TextStyle(color: Colors.deepPurple, fontSize: 32),
                    ),
                    const SizedBox(height: 15),
                    TextFormField(
                      controller: _emailController, //email kontrolü
                      cursorColor: Colors.pink,
                      keyboardType: TextInputType.emailAddress,
                      decoration: const InputDecoration(
                        prefixIcon: Icon(Icons.email),
                        border: OutlineInputBorder(),
                        labelText: 'E posta',
                      ),
                    ),
                    const SizedBox(height: 15),
                    Row(
                      children: [
                        Expanded(
                          child: TextFormField(
                            obscureText: sifre_gozukme, //şifeyi gizli tutma
                            controller: _passwordController, //şifre kontrolü
                            cursorColor: Colors.pink,
                            decoration: const InputDecoration(
                              prefixIcon: Icon(Icons.key),
                              border: OutlineInputBorder(),
                              
                              labelText: 'Password',
                            ),
                            
                          ),
                        ),
                        IconButton(
                          onPressed: () {
                            setState(() {
                              sifre_gozukme =!sifre_gozukme;
                            });
                          },
                          icon: Icon(
                            sifre_gozukme?Icons.remove_red_eye : Icons.close),
                        ),
                      ],
                    ),
                    const SizedBox(height: 15),
                    ElevatedButton(
                      child: const Text('ENTER',style: TextStyle(fontSize: 16),),
                      onPressed: () {
                        signIn(_emailController.text, _passwordController.text)
                            .then((value) {});
                      },
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  openInformationPopup() => showDialog(
        context: context,
        builder: ((context) => SimpleDialog(
              title: const Text(
                'YOUR INFORMATION',
                textAlign: TextAlign.center,
              ),
              children: <Widget>[
                const TextField(
                  decoration: InputDecoration(
                      hintText: 'Body Size', icon: Icon(Icons.boy_rounded)),
                ),
                const TextField(
                  decoration: InputDecoration(
                      hintText: 'Shoe Size', icon: Icon(Icons.snowshoeing)),
                ),
                TextButton(
                    onPressed: () {
                      Navigator.pushAndRemoveUntil(
                          context,
                          MaterialPageRoute(builder: (_) => const LogAutUser()),
                          (route) => false);
                    },
                    child: Text('OKEY')),
              ],
            )),
      );
}


//kullacı kayıt regiter 
class RegisterUserPage extends StatefulWidget {
  const RegisterUserPage({Key? key}) : super(key: key);

  @override
  State<RegisterUserPage> createState() => _RegisterUserPageState();
}

class _RegisterUserPageState extends State<RegisterUserPage> {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  bool sifre_gozukme = true;

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: Center(
          child: SingleChildScrollView(
            child: Padding(
              padding: EdgeInsets.all(50.0),
              child: Form(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      'REGISTER ',
                      style: TextStyle(color: Colors.deepPurple, fontSize: 32),
                    ),
                    const SizedBox(height: 15),
                    TextFormField(
                      controller: _emailController,
                      cursorColor: Colors.pink,
                      keyboardType: TextInputType.emailAddress,
                      decoration: InputDecoration(
                        prefixIcon: Icon(Icons.email),
                        border: OutlineInputBorder(),
                        labelText: 'E posta',
                      ),
                    ),
                    const SizedBox(height: 15),
                    Row(
                      children: [
                        Expanded(
                          child: TextFormField(
                            obscureText: sifre_gozukme,
                            controller: _passwordController,
                            cursorColor: Colors.pink,
                            decoration: InputDecoration(
                              prefixIcon: Icon(Icons.key),
                              border: OutlineInputBorder(),
                              labelText: 'Password',
                            ),
                          ),
                        ),
                         IconButton(
                          onPressed: () {
                            setState(() {
                              sifre_gozukme =!sifre_gozukme;
                            });
                          },
                          icon: Icon(
                            sifre_gozukme?Icons.remove_red_eye : Icons.close),
                        ),
                      ],
                    ),
                    SizedBox(height: 15),
                    ElevatedButton(
                      onPressed: () {
                        userRegister(
                                _emailController.text, _passwordController.text)
                            .then((value) {});
                      },
                      child: Text('SIGN IN',style: TextStyle(fontSize: 16),),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Future<User?> userRegister(String email, String password) async {
 
    try {
      var _userCredential = await _auth.createUserWithEmailAndPassword(
          email: email, password: password);

      //cloud firestore ye veri ekleme
      await _firestore
          .collection("Person")
          .doc(_userCredential.user!.uid)
          .set({'email': email});
      //+ return _userCredential.user;

      debugPrint(_userCredential.toString() + "kayit olma başarılı");
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => WidgetUserAndRegister(),
        ),
      );
    } catch (e) {
      debugPrint(e.toString() + " kayit olma basarisiz");
      warningPopup();
    }
  }

  void warningPopup() => showDialog(
        context: context,
        builder: ((context) => SimpleDialog(
              title: const Text(
                'WARNING',
                style: TextStyle(color: Colors.red),
                textAlign: TextAlign.center,
              ),
              children: <Widget>[
                const Text(
                  'Email address is already in use by another account.\n Try again with another email address.',
                  textAlign: TextAlign.center,
                ),
                TextButton(
                    onPressed: () {
                      Navigator.pop(context);
                    },
                    child: const Text(
                      'OKEY',
                      style: TextStyle(color: Colors.red),
                    )),
              ],
            )),
      );
}


//OTURUM SONLANDIRMA
class LogAutUser extends StatefulWidget {
  const LogAutUser({Key? key}) : super(key: key);

  @override
  State<LogAutUser> createState() => _LogAutUserState();
}

class _LogAutUserState extends State<LogAutUser> {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: Center(
          child: Padding(
            padding: const EdgeInsets.all(100.0),
            child: Column(
              children: [
                ElevatedButton(
                  onPressed: () {
                    //
                    signOutUser();
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (_) => SplashScreenWidget()));
                  },
                  child: const Text('SIGNOUT'),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
  void signOutUser() async {
    await _auth.signOut();
  }
}


