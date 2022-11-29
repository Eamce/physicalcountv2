import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:physicalcountv2/db/sqfLite_dbHelper.dart';
import 'package:physicalcountv2/screens/user/itemScanningScreen.dart';
import 'package:physicalcountv2/screens/user/syncScannedItemScreen.dart';
import 'package:physicalcountv2/screens/user/viewItemNotFoundScanScreen.dart';
import 'package:physicalcountv2/screens/user/viewItemScannedListScreen.dart';
import 'package:physicalcountv2/values/globalVariables.dart';
import 'package:physicalcountv2/widget/instantMsgModal.dart';
import 'package:physicalcountv2/widget/scanAuditModal.dart';

class UserAreaScreen extends StatefulWidget {
  const UserAreaScreen({Key? key}) : super(key: key);

  @override
  _UserAreaScreenState createState() => _UserAreaScreenState();
}

class _UserAreaScreenState extends State<UserAreaScreen> {
  late SqfliteDBHelper _sqfliteDBHelper;
  // Logs _log = Logs();
  // DateFormat dateFormat = DateFormat("yyyy-MM-dd");
  // DateFormat timeFormat = DateFormat("hh:mm:ss aaa");

  List _assignArea = [];
  bool checking = true;

  @override
  void initState() {
    _sqfliteDBHelper = SqfliteDBHelper.instance;
    if (mounted) setState(() {});

    _refreshUserAssignAreaList();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async => false,
      child: Scaffold(
        appBar: AppBar(
          title: Text(
            "User Area",
            style: TextStyle(color: Colors.blue),
          ),
          backgroundColor: Colors.transparent,
          titleSpacing: 0.0,
          elevation: 0.0,
          leading: IconButton(
            icon: Icon(Icons.close, color: Colors.red),
            onPressed: () => Navigator.of(context).pop(),
          ),
          actions: [
            GlobalVariables.countType != 'ANNUAL'
                ? Row(
                    children: [
                      Text(
                        "Enable Expiry Date: [${GlobalVariables.enableExpiry}]",
                        style: TextStyle(color: Colors.blue),
                      ),
                      CupertinoSwitch(
                          value: GlobalVariables.enableExpiry,
                          onChanged: (val) async {
                            var dtls =
                                "[LOGIN][Audit scan ID to change expiry date switch.";
                            GlobalVariables.isAuditLogged = false;
                            await scanAuditModal(
                                context, _sqfliteDBHelper, dtls);
                            if (GlobalVariables.isAuditLogged == true) {
                              GlobalVariables.enableExpiry = val;
                              if (mounted) setState(() {});
                            }
                          }),
                    ],
                  )
                : SizedBox(),
          ],
        ),
        body: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            checking ? LinearProgressIndicator() : SizedBox(),
            !checking
                ? Expanded(
                    child: Scrollbar(
                      child: ListView.builder(
                        itemCount: _assignArea.length,
                        itemBuilder: (context, index) {
                          var data = _assignArea;
                          return Padding(
                            padding:
                                const EdgeInsets.only(right: 8.0, left: 8.0),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.start,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  data[index]['business_unit'] +
                                      "/" +
                                      data[index]['department'] +
                                      "/" +
                                      data[index]['section'],
                                  style: TextStyle(fontSize: 20),
                                ),
                                Row(
                                  children: [
                                    Icon(
                                        data[index]['done'] == 'true'
                                            ? CupertinoIcons
                                                .checkmark_alt_circle_fill
                                            : CupertinoIcons
                                                .ellipsis_circle_fill,
                                        size: 30,
                                        color: data[index]['done'] == 'true'
                                            ? Colors.green
                                            : Colors.orange),
                                    Text(
                                      data[index]['rack_desc'],
                                      style: TextStyle(fontSize: 30),
                                    ),
                                    Spacer(),
                                  ],
                                ),
                                Row(
                                  children: [
                                    Spacer(),
                                    Padding(
                                      padding:
                                          const EdgeInsets.only(right: 8.0),
                                      child: ElevatedButton(
                                        onPressed: () async {
                                          if (data[index]['locked'] == 'false') {
                                            GlobalVariables.currentLocationID = data[index]['location_id'];
                                            GlobalVariables.currentBusinessUnit = data[index]['business_unit'];
                                            GlobalVariables.currentDepartment = data[index]['department'];
                                            GlobalVariables.currentSection = data[index]['section'];
                                            GlobalVariables.currentRackDesc = data[index]['rack_desc'];
                                            var dtls = "[LOGIN][Audit] scan ID to add item on location (${data[index]['business_unit']}/${data[index]['department']}/${data[index]['section']}/${data[index]['rack_desc']}).]";
                                            GlobalVariables.isAuditLogged = false;
                                            await scanAuditModal(context, _sqfliteDBHelper, dtls);
                                            if (GlobalVariables.isAuditLogged == true) {
                                              Navigator.push(context,
                                                MaterialPageRoute(builder: (context) =>
                                                        ItemScanningScreen()),
                                              ).then((value) {
                                                _refreshUserAssignAreaList();
                                              });
                                            }
                                          } else {
                                            instantMsgModal(
                                                context,
                                                Icon(
                                                  CupertinoIcons.exclamationmark_circle,
                                                  color: Colors.red,
                                                  size: 40,
                                                ),
                                                Text("This location is locked."));
                                          }
                                        },
                                        style: ElevatedButton.styleFrom(
                                            primary: Colors.blue),
                                        child: Row(
                                          children: [
                                            Icon(CupertinoIcons.barcode_viewfinder),
                                            Text("Start scan"),
                                          ],
                                        ),
                                      ),
                                    ),
                                    Padding(
                                      padding:
                                          const EdgeInsets.only(right: 8.0),
                                      child: ElevatedButton(
                                        onPressed: () async {
                                          GlobalVariables.currentLocationID   = data[index]['location_id'];
                                          GlobalVariables.currentBusinessUnit = data[index]['business_unit'];
                                          GlobalVariables.currentDepartment   = data[index]['department'];
                                          GlobalVariables.currentSection      = data[index]['section'];
                                          GlobalVariables.currentRackDesc     = data[index]['rack_desc'];
                                          Navigator.push(context,
                                            MaterialPageRoute(builder: (context) =>
                                                    ViewItemScannedListScreen()),
                                          );
                                        },
                                        style: ElevatedButton.styleFrom(
                                            primary: Colors.yellow[700]),
                                        child: Row(
                                          children: [
                                            Icon(CupertinoIcons.doc_plaintext),
                                            Text("View-S"),
                                          ],
                                        ),
                                      ),
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.only(right: 8.0),
                                      child: ElevatedButton(
                                        onPressed: () async {
                                          GlobalVariables.currentLocationID   = data[index]['location_id'];
                                          GlobalVariables.currentBusinessUnit = data[index]['business_unit'];
                                          GlobalVariables.currentDepartment   = data[index]['department'];
                                          GlobalVariables.currentSection      = data[index]['section'];
                                          GlobalVariables.currentRackDesc     = data[index]['rack_desc'];
                                          Navigator.push(
                                            context,
                                            MaterialPageRoute(builder: (context) => ViewItemNotFoundScanScreen()),
                                          );
                                        },
                                        style: ElevatedButton.styleFrom(
                                            primary: Colors.yellow[700]),
                                        child: Row(
                                          children: [
                                            Icon(CupertinoIcons.doc_plaintext),
                                            Text("View-NF"),
                                          ],
                                        ),
                                      ),
                                    ),
                                    Padding(
                                      padding:
                                      const EdgeInsets.only(right: 8.0),
                                      child: ElevatedButton(
                                        onPressed: () async {
                                          GlobalVariables.currentLocationID   = data[index]['location_id'];
                                          GlobalVariables.currentBusinessUnit = data[index]['business_unit'];
                                          GlobalVariables.currentDepartment   = data[index]['department'];
                                          GlobalVariables.currentSection      = data[index]['section'];
                                          GlobalVariables.currentRackDesc     = data[index]['rack_desc'];
                                          var dtls = data[index]['locked'] == 'true'
                                              ? "[LOCK][Audit Lock Rack (${data[index]['business_unit']}/${data[index]['department']}/${data[index]['section']}/${data[index]['rack_desc']})]"
                                              : "[LOCK][Audit Unlock Rack (${data[index]['business_unit']}/${data[index]['department']}/${data[index]['section']}/${data[index]['rack_desc']})]";
                                          GlobalVariables.isAuditLogged = false;
                                          await scanAuditModal(context, _sqfliteDBHelper, dtls);
                                          if (GlobalVariables.isAuditLogged == true) {
                                            data[index]['locked'].toString() ==
                                                    'true'
                                                ? _lockUnlockLocation(
                                                    index, false, false)
                                                : _lockUnlockLocation(
                                                    index, true, true);
                                          }
                                        },
                                        style: data[index]['locked'] == 'true'
                                            ? ElevatedButton.styleFrom(primary: Colors.red)
                                            : ElevatedButton.styleFrom(primary: Colors.red[200]),
                                        child: Row(
                                          children: [
                                            Icon(data[index]['locked'] == 'true'
                                                ? CupertinoIcons.lock_fill
                                                : CupertinoIcons.lock_open_fill),
                                            Text(data[index]['locked'] == 'true'
                                                ? "Locked"
                                                : "Unlock"),
                                          ],
                                        ),
                                      ),
                                    ),
                                    Padding(
                                      padding:
                                          const EdgeInsets.only(right: 8.0),
                                      child: ElevatedButton(
                                        onPressed: () async {
                                          // SharedPreferences prefss =
                                          //     await SharedPreferences
                                          //         .getInstance();
                                          // GlobalVariables.saveAuditSignature =
                                          //     prefss.getString(
                                          //             'saveAuditSignature') ??
                                          //         '';
                                          GlobalVariables.currentLocationID   = data[index]['location_id'];
                                          GlobalVariables.currentBusinessUnit = data[index]['business_unit'];
                                          GlobalVariables.currentDepartment   = data[index]['department'];
                                          GlobalVariables.currentSection      = data[index]['section'];
                                          GlobalVariables.currentRackDesc     = data[index]['rack_desc'];
                                          Navigator.push(
                                            context,
                                            MaterialPageRoute(
                                                builder: (context) =>
                                                    SyncScannedItemScreen()),
                                          );
                                        },
                                        style: ElevatedButton.styleFrom(
                                            primary: Colors.green),
                                        child: Row(
                                          children: [
                                            Icon(CupertinoIcons.arrow_2_circlepath),
                                            Text("Sync"),
                                          ],
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                                Divider(),
                              ],
                            ),
                          );
                        },
                      ),
                    ),
                  )
                : SizedBox(),
          ],
        ),
      ),
    );
  }
  Future _lockUnlockLocation(int index, bool value, bool done) async {
    var user = await _sqfliteDBHelper.selectU(GlobalVariables.logEmpNo);
    await await _sqfliteDBHelper.updateUserAssignAreaWhere(
      "locked = '" + value.toString() + "' , done = '" + done.toString() + "'",
      "emp_no = '${user[0]['emp_no']}' AND location_id = '${GlobalVariables.currentLocationID}'",
    );
    _refreshUserAssignAreaList();
  }

  _refreshUserAssignAreaList() async {
    _assignArea = [];
    _assignArea =
        await _sqfliteDBHelper.selectUserArea(GlobalVariables.logEmpNo);
    // List _loc = await _sqfliteDBHelper.selectU(GlobalVariables.logEmpNo);
    // // print(GlobalVariables.logEmpNo);
    // print(_loc);
    if (_assignArea.length > 0) {
      checking = false;
      if (mounted) setState(() {});
    } else {
      var user = int.parse(GlobalVariables.logEmpNo) * 1;
      _assignArea = await _sqfliteDBHelper.selectUserArea(user.toString());
      checking = false;
      if (mounted) setState(() {});
    }
  }
}
