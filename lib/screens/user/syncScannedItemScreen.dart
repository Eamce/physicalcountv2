import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:physicalcountv2/db/models/itemCountModel.dart';
import 'package:physicalcountv2/db/models/itemNotFoundModel.dart';
import 'package:physicalcountv2/db/models/logsModel.dart';
import 'package:physicalcountv2/db/sqfLite_dbHelper.dart';
import 'package:physicalcountv2/services/api.dart';
import 'package:physicalcountv2/values/globalVariables.dart';
import 'package:physicalcountv2/widget/instantMsgModal.dart';
import 'package:syncfusion_flutter_signaturepad/signaturepad.dart';
import 'dart:ui' as ui;

class SyncScannedItemScreen extends StatefulWidget {
  const SyncScannedItemScreen({Key? key}) : super(key: key);

  @override
  _SyncScannedItemScreenState createState() => _SyncScannedItemScreenState();
}

class _SyncScannedItemScreenState extends State<SyncScannedItemScreen> {
  final GlobalKey<SfSignaturePadState> signatureUserGlobalKey = GlobalKey();
  final GlobalKey<SfSignaturePadState> signatureAuditGlobalKey = GlobalKey();

  late SqfliteDBHelper _sqfliteDBHelper;
  List _myAudit = [];
  List _items = [];
  List _nfitems = [];
  String _auditor = "";
  bool checkingNetwork = false;

  Logs _log = Logs();
  DateFormat dateFormat = DateFormat("yyyy-MM-dd");
  DateFormat timeFormat = DateFormat("hh:mm:ss aaa");

  @override
  void initState() {
    _sqfliteDBHelper = SqfliteDBHelper.instance;
    if (mounted) setState(() {});

    _getMyAudit();

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    // print(GlobalVariables.saveAuditSignature);
    return WillPopScope(
      onWillPop: () async => false,
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.transparent,
          titleSpacing: 0.0,
          elevation: 0.0,
          leading: IconButton(
            icon: Icon(Icons.close, color: Colors.red),
            onPressed: () => Navigator.of(context).pop(),
          ),
          title: Row(
            children: [
              Flexible(
                child: Material(
                  type: MaterialType.transparency,
                  child: Text(
                    "Sync Count Data to Server Database",
                    maxLines: 2,
                    style: TextStyle(
                        fontSize: 20,
                        color: Colors.blue,
                        fontWeight: FontWeight.bold),
                  ),
                ),
              ),
            ],
          ),
        ),
        body: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            checkingNetwork ? LinearProgressIndicator() : SizedBox(),
            Spacer(),
            Center(
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text(
                  "Note: Make sure to review all the item before syncing. You cannot edit or delete all synced item.",
                  style: TextStyle(
                      fontWeight: FontWeight.bold, fontStyle: FontStyle.italic),
                  textAlign: TextAlign.center,
                ),
              ),
            ),
            MaterialButton(
              color: Colors.green,
              child: Padding(
                padding: const EdgeInsets.all(15.0),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(
                      CupertinoIcons.tray_arrow_up_fill,
                      size: 25,
                      color: Colors.white,
                    ),
                    Text(
                      " Start to sync",
                      style: TextStyle(color: Colors.white, fontSize: 25),
                    ),
                  ],
                ),
              ),
              onPressed: () async {
                final dataUser = await signatureUserGlobalKey.currentState!
                    .toImage(pixelRatio: 3.0);
                final bytesUser =
                    await dataUser.toByteData(format: ui.ImageByteFormat.png);
                final dataAudit = await signatureAuditGlobalKey.currentState!
                    .toImage(pixelRatio: 3.0);
                final bytesAudit =
                    await dataAudit.toByteData(format: ui.ImageByteFormat.png);
                print(signatureAuditGlobalKey.currentState!.toPathList());
                // if (bytesUser!.buffer.lengthInBytes == 6864 ||
                //     bytesAudit!.buffer.lengthInBytes == 6864) {
                if (signatureUserGlobalKey.currentState!.toPathList().length ==
                        0 ||
                    signatureAuditGlobalKey.currentState!.toPathList().length ==
                        0) {
                  instantMsgModal(
                      context,
                      Icon(
                        CupertinoIcons.exclamationmark_circle,
                        color: Colors.red,
                        size: 40,
                      ),
                      Text(
                          "User signature and Auditor signature are required to signed before syncing."));
                } else {
                  continueSync(base64Encode(bytesUser!.buffer.asUint8List()),
                      base64Encode(bytesAudit!.buffer.asUint8List()));
                }
              },
            ),
            Spacer(),
            Divider(),
            Row(
              children: [
                Text(
                  "  User Signature",
                  style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold),
                ),
                TextButton(
                    onPressed: () {
                      signatureUserGlobalKey.currentState!.clear();
                    },
                    child: Text("Clear"))
              ],
            ),
            Padding(
                padding: EdgeInsets.only(right: 8, left: 8),
                child: Container(
                    child: SfSignaturePad(
                      key: signatureUserGlobalKey,
                      backgroundColor: Colors.white,
                      strokeColor: Colors.black,
                      minimumStrokeWidth: 3.0,
                      maximumStrokeWidth: 6.0,
                      // minimumStrokeWidth: 1.0,
                      // maximumStrokeWidth: 4.0,
                    ),
                    decoration:
                        BoxDecoration(border: Border.all(color: Colors.grey)))),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  "${GlobalVariables.logFullName.toUpperCase()}",
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                ),
              ],
            ),
            Divider(),
            Row(
              children: [
                Text(
                  "  Auditor Signature",
                  style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold),
                ),
                TextButton(
                  onPressed: () {
                    signatureAuditGlobalKey.currentState!.clear();
                  },
                  child: Text("Clear"),
                ),
                // TextButton(
                //   onPressed: () async {
                //     signatureAuditGlobalKey.currentState!.clear();
                //     SharedPreferences prefss =
                //         await SharedPreferences.getInstance();

                //     final dataAudit = await signatureAuditGlobalKey
                //         .currentState!
                //         .toImage(pixelRatio: 3.0);
                //     final bytesAudit = await dataAudit.toByteData(
                //         format: ui.ImageByteFormat.png);

                //     prefss.setString('saveAuditSignature',
                //         base64Encode(bytesAudit!.buffer.asUint8List()));
                //   },
                //   child: Text("Save"),
                // ),
              ],
            ),
            Padding(
                padding: EdgeInsets.only(right: 8, left: 8),
                child: Container(
                    child: SfSignaturePad(
                        key: signatureAuditGlobalKey,
                        backgroundColor: Colors.white,
                        strokeColor: Colors.black,
                        minimumStrokeWidth: 3.0,
                        maximumStrokeWidth: 6.0),
                    decoration:
                        BoxDecoration(border: Border.all(color: Colors.grey)))),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  "$_auditor",
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                ),
              ],
            ),
            Spacer(),
          ],
        ),
      ),
    );
  }

  _getMyAudit() async {
    _myAudit = [];
    _auditor = "";
    _myAudit = await _sqfliteDBHelper
        .findAuditByLocationId(GlobalVariables.currentLocationID);
    if (_myAudit.length > 0) {
      _auditor = _myAudit[0]['name'].toString().toUpperCase();
    }
    if (mounted) setState(() {});
  }

  continueSync(String bytesUser, String bytesAudit) async {
    print(GlobalVariables.currentLocationID);
    checkingNetwork = true;
    if (mounted) setState(() {});

    var res = await checkIfConnectedToNetwork();
    // checkingNetwork = false;
    // if (mounted) setState(() {});

    if (res == 'error') {
      checkingNetwork = false;
      if (mounted) setState(() {});
      instantMsgModal(
          context,
          Icon(
            CupertinoIcons.exclamationmark_circle,
            color: Colors.red,
            size: 40,
          ),
          Text("${GlobalVariables.httpError}"));
    } else if (res == 'errornet') {
      checkingNetwork = false;
      if (mounted) setState(() {});
      instantMsgModal(
          context,
          Icon(
            CupertinoIcons.exclamationmark_circle,
            color: Colors.red,
            size: 40,
          ),
          Text("${GlobalVariables.httpError}"));
    } else {
      await _getCountedItems();
      await _getCountedNfItems();
      //NF ITEMS//
      if (_nfitems.length > 0) {
        var res = await syncNfItem(_nfitems,bytesUser,bytesAudit);
        await _sqfliteDBHelper.updateItemNotFoundByLocation(
            GlobalVariables.currentLocationID, "exported = 'EXPORTED'");
        if (res == true) {
          _log.date = dateFormat.format(DateTime.now());
          _log.time = timeFormat.format(DateTime.now());
          _log.device =
              "${GlobalVariables.deviceInfo}(${GlobalVariables.readdeviceInfo})";
          _log.user = "USER";
          _log.empid = GlobalVariables.logEmpNo;
          _log.details =
              "[SYNCED][USER Synced Not Found Item on Location ID: ${GlobalVariables.currentLocationID}]";
          await _sqfliteDBHelper.insertLog(_log);
        }
      }
      //COUNT
      if (_items.length > 0) {
        var res = await syncItem(_items, bytesUser, bytesAudit);
        await _sqfliteDBHelper.updateItemCountByLocation(
            GlobalVariables.currentLocationID, "exported = 'EXPORTED'");
        if (res == true) {
          _log.date = dateFormat.format(DateTime.now());
          _log.time = timeFormat.format(DateTime.now());
          _log.device =
              "${GlobalVariables.deviceInfo}(${GlobalVariables.readdeviceInfo})";
          _log.user = "USER";
          _log.empid = GlobalVariables.logEmpNo;
          _log.details =
              "[SYNCED][USER Synced Count Item on Location ID: ${GlobalVariables.currentLocationID}]";
          await _sqfliteDBHelper.insertLog(_log);
          checkingNetwork = false;
          if (mounted) setState(() {
            Navigator.pop(context);
          });
          instantMsgModal(
              context,
              Icon(
                CupertinoIcons.checkmark_alt_circle,
                color: Colors.green,
                size: 40,
              ),
              Text("Data successfully synced."));

        } else {
          checkingNetwork = false;
          if (mounted) setState(() {});
          instantMsgModal(
              context,
              Icon(
                CupertinoIcons.exclamationmark_circle,
                color: Colors.red,
                size: 40,
              ),
              Text("Something went wrong.")
          );
        }
      } else {
        checkingNetwork = false;
        if (mounted) setState(() {
          Navigator.pop(context);
        });
        instantMsgModal(
            context,
            Icon(
              CupertinoIcons.exclamationmark_circle,
              color: Colors.red,
              size: 40,
            ),
            Text("No data to sync."));
      }
    }
  }
  _getCountedItems() async {
    _items = await _sqfliteDBHelper.selectItemCountRawQuery(
        "SELECT itemcode,barcode,description,uom, qty, business_unit, department, section, rack_desc, datetimecreated, datetimesaved, expiry, location_id, conqty FROM ${ItemCount.tblItemCount} WHERE location_id = '${GlobalVariables.currentLocationID}' AND exported != 'EXPORTED'");
  }
  _getCountedNfItems() async {
    _nfitems = await _sqfliteDBHelper.selectItemNotFoundRawQuery(
        "SELECT barcode,uom, qty,location, datetimecreated,business_unit,department,section,empno,rack_desc,description FROM ${ItemNotFound.tblItemNotFound} WHERE location = '${GlobalVariables.currentLocationID}' AND exported != 'EXPORTED'");
  }
}
