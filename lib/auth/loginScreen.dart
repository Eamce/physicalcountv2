import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:physicalcountv2/db/sqfLite_dbHelper.dart';
import 'package:physicalcountv2/db/models/logsModel.dart';
import 'package:physicalcountv2/screens/admin/adminDashboardScreen.dart';
import 'package:physicalcountv2/screens/user/userDashboardScreen.dart';
import 'package:physicalcountv2/values/assets.dart';
import 'package:physicalcountv2/values/globalVariables.dart';
import 'package:physicalcountv2/widget/instantMsgModal.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({Key? key}) : super(key: key);

  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  late FocusNode myFocusNodeEmpNo;
  late FocusNode myFocusNodeEmpPin;

  final empnoController = TextEditingController();
  final emppinController = TextEditingController();

  bool btnEnabled = false;

  late SqfliteDBHelper _sqfliteDBHelper;
  Logs _log = Logs();
  DateFormat dateFormat = DateFormat("yyyy-MM-dd");
  DateFormat timeFormat = DateFormat("hh:mm:ss aaa");

  bool obscureENumber = true;
  bool obscureEPin = true;

  @override
  void initState() {
    _sqfliteDBHelper = SqfliteDBHelper.instance;
    if (mounted) setState(() {});
    emppinController.text="480080767534";
    empnoController.text="01000042637";
    myFocusNodeEmpNo = FocusNode();
    myFocusNodeEmpPin = FocusNode();
    myFocusNodeEmpNo.requestFocus();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async => false,
      child: Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
          backgroundColor: Colors.transparent,
          titleSpacing: 0.0,
          elevation: 0.0,
        ),
        body: Padding(
          padding: const EdgeInsets.all(10.0),
          child: SafeArea(
            child: SingleChildScrollView(
              child: Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Center(
                      child: Image.asset(Assets.pc, width: 300),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: TextField(
                      obscureText: obscureENumber,
                      focusNode: myFocusNodeEmpNo,
                      cursorColor: Colors.black,
                      style: TextStyle(color: Colors.black, fontSize: 25),
                      controller: empnoController,
                      keyboardType: TextInputType.number,
                      decoration: InputDecoration(
                        enabledBorder: UnderlineInputBorder(
                          borderSide: BorderSide(color: Colors.black),
                        ),
                        focusedBorder: UnderlineInputBorder(
                          borderSide: BorderSide(color: Colors.black),
                        ),
                        prefixIcon: Icon(
                          CupertinoIcons.person_alt_circle,
                          color: Colors.black,
                        ),
                        hintStyle: TextStyle(color: Colors.grey[400]),
                        hintText: 'Employee Number',
                        suffixIcon: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: <Widget>[
                            empnoController.text.isNotEmpty
                                ? IconButton(
                                    onPressed: () {
                                      if (mounted)
                                        setState(() {
                                          empnoController.clear();
                                          btnEnabled = false;
                                        });
                                    },
                                    icon: Icon(
                                      CupertinoIcons.xmark_circle_fill,
                                      color: Colors.red,
                                    ),
                                  )
                                : SizedBox(),
                            IconButton(
                              icon: !obscureENumber
                                  ? Icon(CupertinoIcons.eye_fill,
                                      color: Colors.blueGrey[900])
                                  : Icon(CupertinoIcons.eye_slash_fill,
                                      color: Colors.blueGrey[900]),
                              onPressed: () {
                                obscureENumber = !obscureENumber;
                                if (mounted) setState(() {});
                              },
                            ),
                          ],
                        ),
                      ),
                      onChanged: (value) {
                        if (mounted)
                          setState(() {
                            empnoController.text.isNotEmpty &&
                                    emppinController.text.isNotEmpty
                                ? btnEnabled = true
                                : btnEnabled = false;
                          });
                      },
                      onSubmitted: (value) {
                        myFocusNodeEmpPin.requestFocus();
                        onPressLogin();
                      },
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: TextField(
                      obscureText: obscureEPin,
                      focusNode: myFocusNodeEmpPin,
                      cursorColor: Colors.black,
                      style: TextStyle(color: Colors.black, fontSize: 25),
                      controller: emppinController,

                      keyboardType: TextInputType.number,
                      decoration: InputDecoration(
                        enabledBorder: UnderlineInputBorder(
                          borderSide: BorderSide(color: Colors.black),
                        ),
                        focusedBorder: UnderlineInputBorder(
                          borderSide: BorderSide(color: Colors.black),
                        ),
                        prefixIcon: Icon(
                          CupertinoIcons.lock_circle,
                          color: Colors.black,
                        ),
                        hintStyle: TextStyle(color: Colors.grey[400]),
                        hintText: 'Employee Pin',
                        suffixIcon: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: <Widget>[
                            emppinController.text.isNotEmpty
                                ? IconButton(
                                    onPressed: () {
                                      if (mounted)
                                        setState(() {
                                          emppinController.clear();
                                          btnEnabled = false;
                                        });
                                    },
                                    icon: Icon(
                                      CupertinoIcons.xmark_circle_fill,
                                      color: Colors.red,
                                    ),
                                  )
                                : SizedBox(),
                            IconButton(
                              icon: !obscureEPin
                                  ? Icon(CupertinoIcons.eye_fill,
                                      color: Colors.blueGrey[900])
                                  : Icon(CupertinoIcons.eye_slash_fill,
                                      color: Colors.blueGrey[900]),
                              onPressed: () {
                                obscureEPin = !obscureEPin;
                                if (mounted) setState(() {});
                              },
                            ),
                          ],
                        ),
                      ),
                      onChanged: (value) {
                        if (mounted)
                          setState(() {
                            empnoController.text.isNotEmpty &&
                                    emppinController.text.isNotEmpty
                                ? btnEnabled = true
                                : btnEnabled = false;
                          });
                      },
                      onSubmitted: (value) => onPressLogin(),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(
                      top: 8.0,
                      right: 8.0,
                      left: 8.0,
                    ),
                    child: MaterialButton(
                      minWidth: MediaQuery.of(context).size.width,
                      height: MediaQuery.of(context).size.height / 15,
                      elevation: 0.0,
                      child: Text(
                        "Log In",
                        style: TextStyle(
                           color: btnEnabled ? Colors.white : Colors.grey[400],

                            fontSize: 25),
                      ),
                      color: btnEnabled ? Colors.blue : Colors.grey[300],
                      onPressed: () async {
                        await onPressLogin();
                      },
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  onPressLogin() async {
    if (btnEnabled) {
      if (empnoController.text.trim() == "1001" &&
          emppinController.text.trim() == "1001") {
        //logs
        _log.date = dateFormat.format(DateTime.now());
        _log.time = timeFormat.format(DateTime.now());
        _log.device =
            "${GlobalVariables.deviceInfo}(${GlobalVariables.readdeviceInfo})";
        _log.user = "ADMIN";
        _log.empid = "ADMIN";
        _log.details = "[LOGIN][Admin Login]";
        await _sqfliteDBHelper.insertLog(_log);

        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => AdminDashboardScreen()),
        );
      } else {
        var ls = await _sqfliteDBHelper.selectUserWhere(
            empnoController.text.trim(), emppinController.text.trim());
        var rs = await _sqfliteDBHelper.fetchUsersWhere("id != 0");
        print(rs);
        if (ls.length > 0) {
          var filter = await _sqfliteDBHelper.selectFilterWhere();
          print(filter);
          GlobalVariables.byCategory =
              filter[0]['byCategory'] == 'True' ? true : false;
          GlobalVariables.categories = filter[0]['categoryName'];
          GlobalVariables.byVendor =
              filter[0]['byVendor'] == 'True' ? true : false;
          GlobalVariables.vendors = filter[0]['vendorName'];
          GlobalVariables.countType = filter[0]['ctype'];
          GlobalVariables.enableExpiry = false;

          GlobalVariables.prevBarCode = "FUnknown";
          GlobalVariables.prevItemCode = "Unknown";
          GlobalVariables.prevItemDesc = "Unknown";
          GlobalVariables.prevItemUOM = "Unknown";
          GlobalVariables.prevQty = "Unknown";
          GlobalVariables.prevDTCreated = "Unknown";

          GlobalVariables.logEmpNo = empnoController.text.trim();
          GlobalVariables.logFullName = ls[0]['name'];

          _log.date = dateFormat.format(DateTime.now());
          _log.time = timeFormat.format(DateTime.now());
          _log.device =
              "${GlobalVariables.deviceInfo}(${GlobalVariables.readdeviceInfo})";
          _log.user = "USER";
          _log.empid = GlobalVariables.logEmpNo;
          _log.details = "[LOGIN][User Login]";
          await _sqfliteDBHelper.insertLog(_log);

          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => UserDashboardScreen()),
          );
        } else {
          instantMsgModal(
              context,
              Icon(
                CupertinoIcons.exclamationmark_circle,
                color: Colors.red,
                size: 40,
              ),
              Text("Invalid Credentials."));
        }
      }
    }
  }
}
