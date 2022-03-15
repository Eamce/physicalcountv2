import 'dart:async';
import 'dart:io';
import 'package:device_info/device_info.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:physicalcountv2/auth/loginScreen.dart';
import 'package:physicalcountv2/values/assets.dart';
import 'package:physicalcountv2/values/globalVariables.dart';

void main() {
  runApp(PhysicalCount());
}

class PhysicalCount extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
    ]);
    return MaterialApp(
      title: 'Physical Count',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: Splash(),
    );
  }
}

class Splash extends StatefulWidget {
  const Splash({Key? key}) : super(key: key);

  @override
  _SplashState createState() => _SplashState();
}

class _SplashState extends State<Splash> {
  String deviceName = '';
  String deviceVersion = '';
  String identifier = '';

  void initState() {
    GlobalVariables.bodyContext = context;
    Timer(Duration(seconds: 2), () {
      _deviceDetails();
      gotoLogin();
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.white,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Center(
              child: Image.asset(
                Assets.pc,
                width: 300,
              ),
            ),
          ),
          Center(
            child: CircularProgressIndicator(
              backgroundColor: Colors.blue,
              valueColor: new AlwaysStoppedAnimation<Color>(Colors.red),
            ),
          ),
        ],
      ),
    );
  }

  Future gotoLogin() async {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => LoginScreen()),
    );
    // var res = await checkIfConnectedToNetwork();
    // if (res == 'error') {
    //   Navigator.push(
    //     context,
    //     MaterialPageRoute(builder: (context) => ErrorScreen()),
    //   );
    // } else if (res == 'errornet') {
    //   Navigator.push(
    //     context,
    //     MaterialPageRoute(builder: (context) => NointernetScreen()),
    //   );
    // } else {
    //   Navigator.push(
    //     context,
    //     MaterialPageRoute(builder: (context) => LoginScreen()),
    //   );
    // }
  }

  Future<void> _deviceDetails() async {
    final DeviceInfoPlugin deviceInfoPlugin = new DeviceInfoPlugin();
    try {
      if (Platform.isAndroid) {
        var build = await deviceInfoPlugin.androidInfo;
        deviceName = build.model;
        identifier = build.androidId;
        GlobalVariables.deviceInfo = "$deviceName $identifier";
        GlobalVariables.readdeviceInfo = "${build.brand} ${build.device}";
        //UUID for Android
      } else if (Platform.isIOS) {
        var data = await deviceInfoPlugin.iosInfo;
        deviceName = data.name;
        identifier = data.identifierForVendor;
        GlobalVariables.deviceInfo = "$deviceName $identifier";
        GlobalVariables.readdeviceInfo = "${data.utsname.machine}";
        //UUID for iOS
      }
    } on PlatformException {
      print('Failed to get platform version');
    }
  }
}
