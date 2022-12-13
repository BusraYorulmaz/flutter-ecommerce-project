import 'package:animated_splash_screen/animated_splash_screen.dart';
import 'package:eticaret_project/constants/constant.dart';
import 'package:eticaret_project/pages/userPages/userLoginRegister.dart';
import 'package:flutter/material.dart';
import '../adminPages/admin_login.dart';
import 'package:page_transition/page_transition.dart';

class SplashScreenWidget extends StatefulWidget {
  const SplashScreenWidget({Key? key}) : super(key: key);

  @override
  State<SplashScreenWidget> createState() => _SplashScreenWidgetState();
}

class _SplashScreenWidgetState extends State<SplashScreenWidget> {
  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;
    return Scaffold(
      body: Stack(
        children: [
          _backgroundImageAssets(size),
          Column(
            children: [
              Padding(
                padding: const EdgeInsets.all(18.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    const SizedBox(height: 40),
                    _skipButton(TextConstants().skipButtonText, context),
                    const SizedBox(height: 40),
                    _splashTitleText(),
                    const SizedBox(height: 10),
                    _splashSubTitleText(size),
                  ],
                ),
              ),
              _bottomContainer(size, context)
            ],
          ),
        ],
      ),
    );
  }

  Text _splashTitleText() {
    return Text(
      TextConstants().splashTitleText,
      style: const TextStyle(color: Colors.deepPurpleAccent, fontSize: 60),
    );
  }

  Image _backgroundImageAssets(Size size) {
    return Image.asset(
      AssetPathConstant().loginAssethPath,
      height: size.height,
      width: size.width,
      fit: BoxFit.cover, //ekranın tamamına sığsın
    );
  }

  _bottomContainer(Size size, BuildContext context) {
    return Expanded(
      child: Align(
        alignment: Alignment.bottomCenter,
        child: Container(
          width: size.width,
          height: size.height * 0.40,
          decoration: const BoxDecoration(
            color: Colors.deepPurpleAccent,
            borderRadius: BorderRadius.only(
              topLeft: Radius.circular(50),
              topRight: Radius.circular(50),
            ),
          ),
          child: Column(
            children: [
              const SizedBox(height: 50),
              _userLoginButton(size, context),
              const SizedBox(height: 10),
              _adminLoginButton(size, context),
            ],
          ),
        ),
      ),
    );
  }

  Widget _userLoginButton(Size size, BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.pushAndRemoveUntil(
            context,
            MaterialPageRoute(builder: (_) => const WidgetUserAndRegister()),
            (route) => false);
      },
      child: const Card(
        elevation: 50,
        color: Colors.white,
        child: SizedBox(
          height: 60,
          width: 250,
          child: Center(
            child: Text(
              TextConstants.userlogin,
              style: TextStyle(color: Colors.black, fontSize: 18),
            ),
          ),
        ),
      ),
    );
  }

  Widget _adminLoginButton(Size size, BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.pushAndRemoveUntil(
            context,
            MaterialPageRoute(builder: (_) => const AdminUserPages()),
            (route) => false);
      },
      child: const Card(
        elevation: 50,
        color: Colors.white,
        child: SizedBox(
          height: 60,
          width: 250,
          child: Center(
            child: Text(
              TextConstants.adminlogin,
              style: TextStyle(color: Colors.black, fontSize: 18),
            ),
          ),
        ),
      ),
    );
  }

  Align _skipButton(String text, BuildContext context) {
    return Align(
      alignment: Alignment.bottomRight,
      child: GestureDetector(
        onTap: () {
          openInformationPopup();
        },
        child: Container(
          padding: const EdgeInsets.all(14),
          decoration: BoxDecoration(
            border: Border.all(color: Colors.black),
            borderRadius: BorderRadius.circular(16),
          ),
          child: Text(
            text,
            style: TextStyle(color: Colors.black, fontSize: 18),
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
                      Navigator.pop(context);
                      // Navigator.pushAndRemoveUntil(
                      //     context,
                      //     MaterialPageRoute(builder: (_) =>   SplashScreenWidget()),
                      //     (route) => false);
                    },
                    child: Text('OKEY')),
              ],
            )),
      );

  _splashSubTitleText(Size size) {
    return Container(
      constraints: BoxConstraints(maxWidth: size.width * 0.9),
      child: const Text(
        TextConstants.splashSubtitleText,
        style: TextStyle(color: Colors.black, fontSize: 26),
      ),
    );
  }
}

/*//ilk uygulama açıldığıda 2 sn gösterilecek ekran
class FirstScreen extends StatelessWidget {
  const FirstScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return AnimatedSplashScreen(
      splash: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Image.asset(
                       
            AssetPathConstant().splashAssethPath,
            fit: BoxFit.cover,
          ),
          const Text(
            'E commerce',
            style: TextStyle(
                fontSize: 30, fontWeight: FontWeight.bold, color: Colors.white),
          )
        ],
      ),
      backgroundColor: Colors.blue.shade100,
      nextScreen: const SplashScreenWidget(),
      splashIconSize: 150,
      duration: 3000,
      //splashTransition: SplashTransition.sizeTransition, //splash içeriğin hangi yönden geleceği
      //pageTransitionType: PageTransitionType.bottomToTop, //ana sayfa ne taraftan kayacağı
      //animationDuration: const Duration(seconds: 2),
    );
  }
}
*/