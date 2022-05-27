import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:physicalcountv2/db/models/itemNotFoundModel.dart';
import 'package:physicalcountv2/db/models/logsModel.dart';
import 'package:physicalcountv2/db/sqfLite_dbHelper.dart';
import 'package:physicalcountv2/values/globalVariables.dart';
import 'package:physicalcountv2/widget/customLogicalModal.dart';
import 'package:physicalcountv2/widget/instantMsgModal.dart';
import 'package:physicalcountv2/widget/saveNotFoundItemModal.dart';
import 'package:physicalcountv2/widget/scanAuditModal.dart';
import 'package:physicalcountv2/widget/updateNotFoundItemModal.dart';

class ItemNotFoundScanScreen extends StatefulWidget {
  const ItemNotFoundScanScreen({Key? key}) : super(key: key);

  @override
  _ItemNotFoundScanScreenState createState() => _ItemNotFoundScanScreenState();
}

class _ItemNotFoundScanScreenState extends State<ItemNotFoundScanScreen> {
  late SqfliteDBHelper _sqfliteDBHelper;

  List units = [];
  List<ItemNotFound> itemNotFound = [];
  Logs _log = Logs();
  DateFormat dateFormat = DateFormat("yyyy-MM-dd");
  DateFormat timeFormat = DateFormat("hh:mm:ss aaa");

  bool _loading = true;

  @override
  void initState() {
    _sqfliteDBHelper = SqfliteDBHelper.instance;
    if (mounted) setState(() {});

    getUnits();

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async => false,
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.transparent,
          titleSpacing: 0.0,
          elevation: 0.0,
          leading: IconButton(
              icon: Icon(Icons.close, color: Colors.red),
              onPressed: () => Navigator.of(context).pop()),
          title: Row(
            children: [
              Flexible(
                child: Material(
                  type: MaterialType.transparency,
                  child: Text(
                    "List of not found item on this location",
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
          actions: [
            IconButton(
              icon: Icon(CupertinoIcons.plus),
              color: Colors.red,
              onPressed: () async {
                await saveNotFoundItemModal(context, _sqfliteDBHelper, units);
                _refreshItemList();
              },
            ),
          ],
        ),
        body: Column(
          children: [
            _loading
                ? loading()
                : itemNotFound.length > 0
                    ? Expanded(
                        child: Scrollbar(
                          child: ListView.builder(
                            itemCount: itemNotFound.length,
                            itemBuilder: (context, index) {
                              return Padding(
                                padding: const EdgeInsets.only(
                                    left: 20.0, right: 20.0),
                                child: Container(
                                  width: MediaQuery.of(context).size.width,
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      RichText(
                                        text: TextSpan(
                                          children: [
                                            TextSpan(
                                                text: "Datetime Scanned: ",
                                                style: TextStyle(
                                                    fontSize: 15,
                                                    color: Colors.blue,
                                                    fontWeight:
                                                        FontWeight.bold)),
                                            TextSpan(
                                                text:
                                                    "${itemNotFound[index].dateTimeCreated!}",
                                                style: TextStyle(
                                                    fontSize: 15,
                                                    color: Colors.black))
                                          ],
                                        ),
                                      ),
                                      RichText(
                                        text: TextSpan(
                                          children: [
                                            TextSpan(
                                                text: "${itemNotFound[index].description}: ",
                                                style: TextStyle(
                                                    fontSize: 15,
                                                    color: Colors.blue,
                                                    fontWeight:
                                                        FontWeight.bold)),
                                            TextSpan(
                                                text:
                                                    "${itemNotFound[index].barcode}",
                                                style: TextStyle(
                                                    fontSize: 15,
                                                    color: Colors.black))
                                          ],
                                        ),
                                      ),
                                      RichText(
                                        text: TextSpan(
                                          children: [
                                            TextSpan(
                                                text: "Unit of Measure: ",
                                                style: TextStyle(
                                                    fontSize: 15,
                                                    color: Colors.blue,
                                                    fontWeight:
                                                        FontWeight.bold)),
                                            TextSpan(
                                                text:
                                                    "${itemNotFound[index].uom}",
                                                style: TextStyle(
                                                    fontSize: 15,
                                                    color: Colors.black))
                                          ],
                                        ),
                                      ),
                                      RichText(
                                        text: TextSpan(
                                          children: [
                                            TextSpan(
                                                text: "Quantity: ",
                                                style: TextStyle(
                                                    fontSize: 15,
                                                    color: Colors.blue,
                                                    fontWeight:
                                                        FontWeight.bold)),
                                            TextSpan(
                                                text:
                                                    "${itemNotFound[index].qty}",
                                                style: TextStyle(
                                                    fontSize: 15,
                                                    color: Colors.black))
                                          ],
                                        ),
                                      ),
                                      Row(
                                        children: [
                                          Spacer(),
                                          Padding(
                                            padding: const EdgeInsets.only(
                                                right: 8.0),
                                            child: ElevatedButton(
                                              style: ElevatedButton.styleFrom(
                                                  primary: Colors.yellow[700]),
                                              child: Row(
                                                children: [
                                                  Icon(CupertinoIcons.pencil),
                                                  Text("Edit"),
                                                ],
                                              ),
                                              onPressed: () async {
                                                if (itemNotFound[index]
                                                        .exported !=
                                                    'EXPORTED') {
                                                  customLogicalModal(
                                                    context,
                                                    Text("Are you sure you want to edit this item?"),
                                                    () => Navigator.pop(context),
                                                    () async {
                                                      Navigator.pop(context);
                                                      await updateNotFoundItemModal(
                                                        context,
                                                        _sqfliteDBHelper,
                                                        "[LOGIN][Audit scan ID to update scanned item quantity.]",
                                                        itemNotFound[index].id!.toString(),
                                                        itemNotFound[index].barcode!,
                                                        itemNotFound[index].uom!,
                                                        itemNotFound[index].qty!,
                                                        units,
                                                      );
                                                      _refreshItemList();
                                                    },
                                                  );
                                                } else {
                                                  instantMsgModal(
                                                      context,
                                                      Icon(
                                                        CupertinoIcons
                                                            .exclamationmark_circle,
                                                        color: Colors.red,
                                                        size: 40,
                                                      ),
                                                      Text(
                                                          "This item is already synced, you cannot edit synced item."));
                                                }
                                              },
                                            ),
                                          ),
                                          Padding(
                                            padding: const EdgeInsets.only(
                                                right: 8.0),
                                            child: ElevatedButton(
                                              style: ElevatedButton.styleFrom(
                                                 primary: Colors.red),
                                              child: Row(
                                                children: [
                                                  Icon(CupertinoIcons.trash),
                                                  Text("Delete"),
                                                ],
                                              ),
                                              onPressed: () async {
                                                if (itemNotFound[index]
                                                        .exported !=
                                                    'EXPORTED') {
                                                  customLogicalModal(
                                                    context,
                                                    Text(
                                                        "Are you sure you want to delete this item?"),
                                                    () =>
                                                        Navigator.pop(context),
                                                    () async {
                                                      Navigator.pop(context);
                                                      var dtls =
                                                          "[LOGIN][Audit scan ID to delete not found item.]";
                                                      GlobalVariables
                                                              .isAuditLogged =
                                                          false;
                                                      await scanAuditModal(
                                                          context,
                                                          _sqfliteDBHelper,
                                                          dtls);
                                                      if (GlobalVariables
                                                              .isAuditLogged ==
                                                          true) {
                                                        //delte code here
                                                        delete(
                                                            itemNotFound[index]
                                                                .id!,
                                                            index);
                                                      }
                                                    },
                                                  );
                                                } else {
                                                  instantMsgModal(
                                                      context,
                                                      Icon(
                                                        CupertinoIcons
                                                            .exclamationmark_circle,
                                                        color: Colors.red,
                                                        size: 40,
                                                      ),
                                                      Text("This item is already synced, you cannot remove synced item."));
                                                }
                                              },
                                            ),
                                          ),
                                        ],
                                      ),
                                      Row(
                                        children: [
                                          Spacer(),
                                          Icon(
                                            itemNotFound[index].exported == 'EXPORTED' ? CupertinoIcons.checkmark_alt_circle_fill
                                                : CupertinoIcons.info_circle_fill,
                                            color:
                                                itemNotFound[index].exported ==
                                                        'EXPORTED'
                                                    ? Colors.green
                                                    : Colors.red,
                                          ),
                                          Text(
                                              itemNotFound[index].exported ==
                                                      'EXPORTED'
                                                  ? "Synced to Server Database"
                                                  : "Not synced to Server Database",
                                              style: TextStyle(
                                                   fontSize: 15,
                                                  color: Colors.black))
                                        ],
                                      ),
                                      SizedBox(height: 5),
                                      Divider(),
                                    ],
                                  ),
                                ),
                              );
                            },
                          ),
                        ),
                      )
                    : Center(
                        child: Column(
                          children: [
                            Icon(
                              CupertinoIcons.doc,
                              size: 100,
                              color: Colors.grey,
                            ),
                            Text(
                              "Oops...It's empty in here!",
                              style:
                                  TextStyle(fontSize: 25, color: Colors.grey),
                            )
                          ],
                        ),
                      ),
          ],
        ),
      ),
    );
  }
  Widget loading() {
    return Expanded(
      child: Column(
        children: [
          Spacer(),
          Center(child: CircularProgressIndicator()),
          Spacer(),
        ],
      ),
    );
  }

  getUnits() async {
    units = await _sqfliteDBHelper.selectUnitsAll();
    List<ItemNotFound> x = await _sqfliteDBHelper.fetchItemNotFoundWhere(
        "location = '${GlobalVariables.currentLocationID}'");
    itemNotFound = x;
    _loading = false;
    if (mounted) setState(() {});
  }

  _refreshItemList() async {
    List<ItemNotFound> x = await _sqfliteDBHelper.fetchItemNotFoundWhere(
        "location = '${GlobalVariables.currentLocationID}' AND exported != 'EXPORTED'");
    itemNotFound = x;
    if (mounted) setState(() {});
  }

  delete(int id, int index) async {
    await _sqfliteDBHelper.deleteItemNotFound(id);
    _refreshItemList();
    //logs
    _log.date = dateFormat.format(DateTime.now());
    _log.time = timeFormat.format(DateTime.now());
    _log.device =
        "${GlobalVariables.deviceInfo}(${GlobalVariables.readdeviceInfo})";
    _log.user = "USER";
    _log.empid = GlobalVariables.logEmpNo;
    _log.details =
        "[DELETE][Delete item (barcode: ${itemNotFound[index].barcode} unit: ${itemNotFound[index].uom} qty: ${itemNotFound[index].qty})]";
    await _sqfliteDBHelper.insertLog(_log);
  }
}
