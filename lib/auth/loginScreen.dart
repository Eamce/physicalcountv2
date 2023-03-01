import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:physicalcountv2/db/sqfLite_dbHelper.dart';
import 'package:physicalcountv2/db/models/logsModel.dart';
import 'package:physicalcountv2/screens/admin/adminDashboardScreen.dart';
import 'package:physicalcountv2/screens/user/userDashboardScreen.dart';
import 'package:physicalcountv2/services/api.dart';
import 'package:physicalcountv2/values/assets.dart';
import 'package:physicalcountv2/values/globalVariables.dart';
import 'package:physicalcountv2/widget/instantMsgModal.dart';


class LoginScreen extends StatefulWidget {
  const LoginScreen({Key? key}) : super(key: key);

  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  List adminMasterfileData = [];
  var adminMasterfileCount = 0;
  bool downloading = true;
  bool syncBtn_click = true;
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
    downloading = false;
    syncBtn_click = false;
    if (mounted) setState(() {});
    // emppinController.text="947670329361";
    // empnoController.text="1000043388";
    // emppinController.text="105313324137";
    // empnoController.text="01000042072";

   // btnEnabled=true;
    myFocusNodeEmpNo = FocusNode();
    myFocusNodeEmpPin = FocusNode();
    myFocusNodeEmpNo.requestFocus();
    super.initState();
  }

  getAdminHere()async{
    downloading = true;
    await _sqfliteDBHelper.deleteAdminAll();
    adminMasterfileData = await getAdmin('True', 'Admin');
    await _sqfliteDBHelper.insertAdminBatch(adminMasterfileData, 0, adminMasterfileData.length);
    adminMasterfileCount = adminMasterfileCount + adminMasterfileData.length;
    _log.date = dateFormat.format(DateTime.now());
    _log.time = timeFormat.format(DateTime.now());
    _log.device = "${GlobalVariables.deviceInfo}(${GlobalVariables.readdeviceInfo})";
    _log.user = "USER";
    _log.empid = "USER";
    _log.details = "[SYNC][ADMIN Masterfile]";
    await _sqfliteDBHelper.insertLog(_log);
    downloading = false;
    print("DATA :: ${adminMasterfileData.length}");
    if(adminMasterfileData.length > 0){
      syncBtn_click = false;
      instantMsgModal(
          context,
          Icon(
            CupertinoIcons.checkmark_alt_circle,
            color: Colors.green,
            size: 40,
          ),
          Text("Admin Masterfile successfully synced."));
    }else{
      syncBtn_click = false;
      instantMsgModal(
          context,
          Icon(
            CupertinoIcons.exclamationmark_circle,
            color: Colors.red,
            size: 40,
          ),
          Text("No Data Received"));
    }
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
          leadingWidth: 8,
          title: downloading ? LinearProgressIndicator() : SizedBox(),
          actions: <Widget>[
            IconButton(
              icon: Icon(Icons.sync_outlined, color: Colors.red),
              color: Colors.white,
              onPressed: () async{
                if(!syncBtn_click){
                  syncBtn_click = true;
                  var res = await checkConnection();
                  if(res == 'connected'){
                    showDialog(
                        barrierDismissible: false,
                        context: context,
                        builder: (BuildContext context){
                          return CupertinoAlertDialog(
                            title: Text("Syncing Admin Masterfile"),
                            content: Text("Continue to Sync?"),
                            actions: <Widget>[
                              TextButton(
                                child: Text("Yes"),
                                onPressed: ()async{
                                  var res = await checkConnection();
                                  if(res == 'connected'){
                                    Navigator.of(context).pop();
                                    await getAdminHere();
                                  }else{
                                    instantMsgModal(
                                        context,
                                        Icon(
                                          CupertinoIcons.exclamationmark_circle,
                                          color: Colors.red,
                                          size: 40,
                                        ),
                                        Text("${GlobalVariables.httpError}"));
                                  }
                                },
                              ),
                              TextButton(
                                child: Text("No"),
                                onPressed: (){
                                  syncBtn_click = false;
                                  Navigator.of(context).pop();
                                },
                              ),
                            ],
                          );
                        }
                    );
                  }else{
                    syncBtn_click = false;
                    //Navigator.of(context).pop();
                    instantMsgModal(
                        context,
                        Icon(
                          CupertinoIcons.exclamationmark_circle,
                          color: Colors.red,
                          size: 40,
                        ),
                        Text("${GlobalVariables.httpError}"));
                  }
                }
              },
            ),
          ],
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
                      keyboardType: TextInputType.phone,
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
                      keyboardType: TextInputType.phone,
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

       bool  validateCredentials(value){
          RegExp _regExp = RegExp(r'^[0-9]+$');
          if(_regExp.hasMatch(value)){
            print('TRUE NI SIYA');
            print(_regExp.hasMatch(value));
            return true;
          }
          else{
            print('FALSE NI SIYA');
            return false;
          }

        }

  onPressLogin() async {
    var ls = await _sqfliteDBHelper.selectUserWhere(empnoController.text.trim(), emppinController.text.trim());
    if (btnEnabled) {
      if (empnoController.text.trim() == "1001" &&
          emppinController.text.trim() == "1001") {
        //logs
        _log.date     = dateFormat.format(DateTime.now());
        _log.time     = timeFormat.format(DateTime.now());
        _log.device   = "${GlobalVariables.deviceInfo}(${GlobalVariables.readdeviceInfo})";
        _log.user     = "ADMIN";
        _log.empid    = "ADMIN";
        _log.details  = "[LOGIN][Admin Login]";
        await _sqfliteDBHelper.insertLog(_log);
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => AdminDashboardScreen(user: "ADMIN", id: "ADMIN")),
        );
      } else {
       // var rs = await _sqfliteDBHelper.fetchUsersWhere("id != 0");
        print(ls);
        if (ls.isNotEmpty) {
          String locationId=ls[0]['location_id'];
          var filter = await _sqfliteDBHelper.selectFilterWhere(locationId);
          print('LOCATION: $locationId');
          print('FILTER: $filter');
         // print(filter[0]['byCategory']);
          GlobalVariables.byCategory    = filter[0]['byCategory'] == 'True' ? true : false;
          GlobalVariables.categories    = filter[0]['categoryName'];
          GlobalVariables.byVendor      = filter[0]['byVendor'] == 'True' ? true : false;
          GlobalVariables.vendors       = filter[0]['vendorName'];
          GlobalVariables.countType     = filter[0]['ctype'];
          GlobalVariables.currentLocationID = locationId;
          GlobalVariables.enableExpiry  = false;
          GlobalVariables.prevBarCode   = "Unknown";
          GlobalVariables.prevItemCode  = "Unknown";
          GlobalVariables.prevItemDesc  = "Unknown";
          GlobalVariables.prevItemUOM   = "Unknown";
          GlobalVariables.prevQty       = "Unknown";
          GlobalVariables.prevDTCreated = "Unknown";
          GlobalVariables.logEmpNo      = empnoController.text.trim();
          GlobalVariables.logFullName   = ls[0]['name'];
          _log.date     = dateFormat.format(DateTime.now());
          _log.time     = timeFormat.format(DateTime.now());
          _log.device   = "${GlobalVariables.deviceInfo}(${GlobalVariables.readdeviceInfo})";
          _log.user     = GlobalVariables.logFullName;
          _log.empid    = GlobalVariables.logEmpNo;
          _log.details  = "[LOGIN][Inventory Clerk]";
          await _sqfliteDBHelper.insertLog(_log);
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => UserDashboardScreen()),
          );
        }
        else {
          var ls2 = await _sqfliteDBHelper.selectAdminWhere(empnoController.text.trim(), emppinController.text.trim());
          if(ls2.isNotEmpty){
            print("ADMIN :: $ls2");
            _log.date     = dateFormat.format(DateTime.now());
            _log.time     = timeFormat.format(DateTime.now());
            _log.device   = "${GlobalVariables.deviceInfo}(${GlobalVariables.readdeviceInfo})";
            _log.user     = "${ls2[0]['emp_name']}";
            _log.empid    = "${empnoController.text}";
            _log.details  = "[LOGIN][Admin Login]";
            await _sqfliteDBHelper.insertLog(_log);
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => AdminDashboardScreen(user: "${ls2[0]['emp_name']}", id: "${empnoController.text}")),
            );
          }else{
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
}
