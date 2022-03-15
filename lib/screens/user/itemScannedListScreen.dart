import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:physicalcountv2/db/models/itemCountModel.dart';
import 'package:physicalcountv2/db/models/logsModel.dart';
import 'package:physicalcountv2/db/sqfLite_dbHelper.dart';
import 'package:physicalcountv2/values/globalVariables.dart';
import 'package:physicalcountv2/widget/customLogicalModal.dart';
import 'package:physicalcountv2/widget/instantMsgModal.dart';
import 'package:physicalcountv2/widget/scanAuditModal.dart';
import 'package:physicalcountv2/widget/updateItemModal.dart';

class ItemScannedListScreen extends StatefulWidget {
  const ItemScannedListScreen({Key? key}) : super(key: key);

  @override
  _ItemScannedListScreenState createState() => _ItemScannedListScreenState();
}

class _ItemScannedListScreenState extends State<ItemScannedListScreen> {
  late SqfliteDBHelper _sqfliteDBHelper;
  Logs _log = Logs();
  List<ItemCount> _items = [];
  List _notSynced = [];
  List _notSynced2 = [];
  List _items2 = [];
  List _synced = [];
  final _textController = TextEditingController();
  DateFormat dateFormat = DateFormat("yyyy-MM-dd");
  DateFormat timeFormat = DateFormat("hh:mm:ss aaa");
  bool listStat = false;
  bool _loading = true;

  @override
  void initState() {
    _sqfliteDBHelper = SqfliteDBHelper.instance;
    if (mounted) setState(() {});
    _refreshItemList();
    super.initState();
  }

  Future onSearched(text) async {
    listStat = true;
    List itemSearched = await _sqfliteDBHelper.itemSearched(text);
    _items2=itemSearched;
    print('SEARCH ITEMSS: $itemSearched');
    if (itemSearched.isEmpty) {
      showDialog(
        barrierDismissible: false,
        context: context,
        builder: (BuildContext context) {
          return CupertinoAlertDialog(
            title: new Text("Item not found!"),
            actions: <Widget>[
              new FlatButton(
                child: new Text("Close"),
                onPressed: () {
                  _refreshItemList();
                  Navigator.of(context).pop();
                },
              ),
            ],
          );
        },
      );
    } else {
      setState(() {
        _notSynced2 = itemSearched;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async => false,
      child: Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
          title: RichText(
            text: TextSpan(
              children: [
                TextSpan(
                    text: "List of Scanned Item: ",
                    style: TextStyle(
                        color: Colors.blue,
                        fontSize: 19,
                        fontWeight: FontWeight.bold)),
                TextSpan(
                    text: "[Total: ${_items.length}] ",
                    style: TextStyle(
                        color: Colors.black,
                        fontSize: 19,
                        fontWeight: FontWeight.bold)),
                TextSpan(
                    text: "[Synced: ${_synced.length}] ",
                    style: TextStyle(
                        color: Colors.green,
                        fontSize: 19,
                        fontWeight: FontWeight.bold)),
                TextSpan(
                    text: "[Not Synced: ${_notSynced.length}] ",
                    style: TextStyle(
                        color: Colors.red,
                        fontSize: 19,
                        fontWeight: FontWeight.bold)),
                WidgetSpan(
                    child: SizedBox.fromSize(
                  size: Size(25, 22),
                  child: IconButton(
                    icon: new Icon(Icons.search, color: Colors.black),
                    padding: EdgeInsets.only(left: 0),
                    onPressed: () {
                      _refreshItemList();
                      showDialog(
                        barrierDismissible: false,
                        context: context,
                        builder: (BuildContext context) {
                          // return object of type Dialog
                          return CupertinoAlertDialog(
                            title: new Text("Search item"),
                            content: new CupertinoTextField(
                              onSubmitted: (value){
                                onSearched(value);
                                Navigator.of(context).pop();
                              },
                              keyboardType: TextInputType.number,
                              controller: _textController,
                              autofocus: true,
                              //  onChanged: _onSearched,
                            ),
                            actions: <Widget>[
                              new FlatButton(
                                child: new Text("Search"),
                                onPressed: () {
                                  onSearched(_textController.text.trim());
                                  print("SEARCHED ITEM: "+_textController.text.trim());
                                  _textController.clear();
                                  Navigator.of(context).pop();
                                },
                              ),
                              new FlatButton(
                                child: new Text("Close"),
                                onPressed: () {
                                  _refreshItemList();
                                  Navigator.of(context).pop();
                                },
                              ),
                            ],
                          );
                        },
                      );
                    },
                  ),
                ))
              ],
            ),
          ),
          backgroundColor: Colors.transparent,
          titleSpacing: 0.0,
          elevation: 0.0,
          leading: IconButton(
            icon: Icon(Icons.close, color: Colors.red),
            onPressed: () => Navigator.of(context).pop(),
          ),
        ),
        body: Column(
          children: [
            _loading
                ? loading()
                : _notSynced.length > 0
                    ? Expanded(
                        child: Scrollbar(
//==============================================================================================================================
 //<-------------------------------------SEARCH LISTVIEW FOR SCANNED ITEMS----------------------------------------------------------------->
//================================================================================================================================
                          child: listStat == true
                              ? ListView.builder(
                                  itemCount: _notSynced2.length,
                                  itemBuilder: (context, index) {
                                    return Padding(
                                      padding: const EdgeInsets.only(
                                          left: 20.0, right: 20.0),
                                      child: Container(
                                        width:
                                            MediaQuery.of(context).size.width,
                                        child: Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            RichText(
                                              text: TextSpan(
                                                children: [
                                                  TextSpan(
                                                      text: "Datetime Scanned: ",
                                                      style: TextStyle(fontSize: 15,
                                                          color: Colors.blue,
                                                          fontWeight: FontWeight.bold)),
                                                  TextSpan(
                                                      text: _items2[index]['datetimecreated'],
                                                      style: TextStyle(fontSize: 15,
                                                          color: Colors.black))
                                                ],
                                              ),
                                            ),
                                            RichText(
                                              text: TextSpan(
                                                children: [
                                                  TextSpan(
                                                      text: "Datetime Saved: ",
                                                      style: TextStyle(fontSize: 15,
                                                          color: Colors.blue,
                                                          fontWeight: FontWeight.bold)),
                                                  TextSpan(
                                                      text: _items2[index]['datetimesaved'],
                                                      style: TextStyle(fontSize: 15,
                                                          color: Colors.black))
                                                ],
                                              ),
                                            ),
                                            Row(
                                              children: [
                                                Flexible(
                                                  child: Text(_items2[index]['description'],
                                                    style: TextStyle(fontSize: 25),
                                                    // maxLines: 1,
                                                    overflow: TextOverflow.ellipsis,
                                                  ),
                                                ),
                                              ],
                                            ),
                                            RichText(
                                              text: TextSpan(
                                                children: [
                                                  TextSpan(text: "Barcode: ",
                                                      style: TextStyle(
                                                          fontSize: 15,
                                                          color: Colors.blue,
                                                          fontWeight:
                                                              FontWeight.bold)),
                                                  TextSpan(
                                                      text: _items2[index]['barcode'],
                                                      style: TextStyle(
                                                          fontSize: 15,
                                                          color: Colors.black))
                                                ],
                                              ),
                                            ),
                                            RichText(
                                              text: TextSpan(
                                                children: [
                                                  TextSpan(text: "Itemcode: ",
                                                      style: TextStyle(
                                                          fontSize: 15,
                                                          color: Colors.blue,
                                                          fontWeight:
                                                              FontWeight.bold)),
                                                  TextSpan(
                                                      text: _items2[index]['itemcode'],
                                                      style: TextStyle(
                                                          fontSize: 15,
                                                          color: Colors.black))
                                                ],
                                              ),
                                            ),
                                            RichText(
                                              text: TextSpan(
                                                children: [
                                                  TextSpan(text: "Unit of Measure: ",
                                                      style: TextStyle(
                                                          fontSize: 15,
                                                          color: Colors.blue,
                                                          fontWeight:
                                                              FontWeight.bold)),
                                                  TextSpan(
                                                      text: _items2[index]['uom'],
                                                      style: TextStyle(
                                                          fontSize: 15,
                                                          color: Colors.black))
                                                ],
                                              ),
                                            ),
                                            GlobalVariables.countType != 'ANNUAL' && GlobalVariables.enableExpiry ==
                                                        true
                                                ? RichText(
                                                    text: TextSpan(
                                                      children: [
                                                        TextSpan(
                                                            text: "Expiry Date: ",
                                                            style: TextStyle(fontSize: 15,
                                                                color: Colors.blue,
                                                                fontWeight: FontWeight.bold)),
                                                        TextSpan(
                                                            text: "${DateFormat('MMMM dd, yyyy').format(DateTime.parse(_items2[index]['expiry']))}",
                                                            style: TextStyle(
                                                                fontSize: 15,
                                                                color: Colors.black))
                                                      ],
                                                    ),
                                                  )
                                                : SizedBox(),
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
                                                      text: _items2[index]['qty'],
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
                                                  padding:
                                                      const EdgeInsets.only(
                                                          right: 8.0),
                                                  child: ElevatedButton(
                                                    style: ElevatedButton.styleFrom(
                                                            primary: Colors
                                                                .yellow[700]),
                                                    child: Row(
                                                      children: [
                                                        Icon(CupertinoIcons
                                                            .pencil),
                                                        Text("Edit"),
                                                      ],
                                                    ),
                                                    onPressed: () async {
                                                      if (_items2[index]['exported']!= 'EXPORTED') {
                                                        customLogicalModal(
                                                          context,
                                                          Text(
                                                              "Are you sure you want to edit this item?"),
                                                          () => Navigator.pop(
                                                              context),
                                                          () async {
                                                            Navigator.pop(
                                                                context);

                                                            await updateItemModal(
                                                              context,
                                                              _sqfliteDBHelper,
                                                              "[LOGIN][Audit scan ID to update scanned item quantity.]",
                                                              _items2[index]['id'].toString(),
                                                              _items2[index]['description'].toString(),
                                                              _items2[index]['barcode'].toString(),
                                                              _items2[index]['itemcode'].toString(),
                                                              _items2[index]['uom'].toString(),
                                                              _items2[index]['expiry'].toString(),
                                                              _items2[index]['qty'].toString(),
                                                            );
                                                            _refreshItemList();
                                                          },
                                                        );
                                                      } else {
                                                        instantMsgModal(
                                                            context,
                                                            Icon(
                                                              CupertinoIcons.exclamationmark_circle,
                                                              color: Colors.red,
                                                              size: 40,
                                                            ),
                                                            Text("This item is already synced, you cannot edit synced item."));
                                                      }
                                                    },
                                                  ),
                                                ),
                                                Padding(
                                                  padding:
                                                      const EdgeInsets.only(
                                                          right: 8.0),
                                                  child: ElevatedButton(
                                                    style: ElevatedButton.styleFrom(primary: Colors.red),
                                                    child: Row(
                                                      children: [
                                                        Icon(CupertinoIcons.trash),
                                                        Text("Delete"),
                                                      ],
                                                    ),
                                                    onPressed: () async {
                                                      if ( _items2[index]['exported'].toString()!= 'EXPORTED') {
                                                        customLogicalModal(
                                                          context,
                                                          Text("Are you sure you want to delete this item?"),
                                                          () => Navigator.pop(context),
                                                          () async {
                                                            Navigator.pop(context);
                                                            var dtls = "[LOGIN][Audit scan ID to delete scanned item.]";
                                                            GlobalVariables.isAuditLogged = false;
                                                            await scanAuditModal(context, _sqfliteDBHelper, dtls);
                                                            if (GlobalVariables.isAuditLogged == true) {
                                                              //delte code here
                                                              delete( _items2[index]['id'],index);
                                                            }
                                                          },
                                                        );
                                                      } else {
                                                        instantMsgModal(context,
                                                            Icon(CupertinoIcons.exclamationmark_circle,
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
                                                Icon(_items2[index]['exported'].toString() == 'EXPORTED'
                                                      ? CupertinoIcons.checkmark_alt_circle_fill
                                                      : CupertinoIcons.info_circle_fill,
                                                  color: _items2[index]['exported'].toString() == 'EXPORTED'
                                                          ? Colors.green
                                                          : Colors.red,
                                                ),
                                                Text( _items2[index]['exported'].toString() == 'EXPORTED'
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
                                )
//================================================================================================================================//
//<------------------------------------LISTVIEW FOR SCANNED ITEMS--------------------------------------------------------------------------------->
//=================================================================================================================================//
                              : ListView.builder(
                                  itemCount: _items.length,
                                  itemBuilder: (context, index) {
                                    return Padding(
                                      padding: const EdgeInsets.only(
                                          left: 20.0, right: 20.0),
                                      child: Container(
                                        width:
                                            MediaQuery.of(context).size.width,
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
                                                      text: "${_items[index].dateTimeCreated!}",
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
                                                      text: "Datetime Saved: ",
                                                      style: TextStyle(
                                                          fontSize: 15,
                                                          color: Colors.blue,
                                                          fontWeight:
                                                              FontWeight.bold)),
                                                  TextSpan(
                                                      text: "${_items[index].dateTimeSaved!}",
                                                      style: TextStyle(
                                                          fontSize: 15,
                                                          color: Colors.black))
                                                ],
                                              ),
                                            ),
                                            Row(
                                              children: [
                                                Flexible(
                                                  child: Text(
                                                    _items[index].description!,
                                                    style:
                                                        TextStyle(fontSize: 25),
                                                    // maxLines: 1,
                                                    overflow:
                                                        TextOverflow.ellipsis,
                                                  ),
                                                ),
                                              ],
                                            ),
                                            RichText(
                                              text: TextSpan(
                                                children: [
                                                  TextSpan(
                                                      text: "Barcode: ",
                                                      style: TextStyle(
                                                          fontSize: 15,
                                                          color: Colors.blue,
                                                          fontWeight:
                                                              FontWeight.bold)),
                                                  TextSpan(
                                                      text: "${_items[index].barcode!}",
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
                                                      text: "Itemcode: ",
                                                      style: TextStyle(
                                                          fontSize: 15,
                                                          color: Colors.blue,
                                                          fontWeight:
                                                              FontWeight.bold)),
                                                  TextSpan(
                                                      text: "${_items[index].itemcode!}",
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
                                                      text: "${_items[index].uom!}",
                                                      style: TextStyle(
                                                          fontSize: 15,
                                                          color: Colors.black))
                                                ],
                                              ),
                                            ),
                                            GlobalVariables.countType != 'ANNUAL' && GlobalVariables.enableExpiry == true
                                                ? RichText(
                                                    text: TextSpan(
                                                      children: [
                                                        TextSpan(
                                                            text: "Expiry Date: ",
                                                            style: TextStyle(
                                                                fontSize: 15,
                                                                color: Colors.blue,
                                                                fontWeight: FontWeight.bold)),
                                                        TextSpan(
                                                            text: "${DateFormat('MMMM dd, yyyy').format(DateTime.parse(_items[index].expiry!))}",
                                                            style: TextStyle(fontSize: 15,
                                                                color: Colors.black))
                                                      ],
                                                    ),
                                                  )
                                                : SizedBox(),
                                            RichText(
                                              text: TextSpan(
                                                children: [
                                                  TextSpan(
                                                      text: "Quantity: ",
                                                      style: TextStyle(
                                                          fontSize: 15,
                                                          color: Colors.blue,
                                                          fontWeight: FontWeight.bold)),
                                                  TextSpan(
                                                      text: "${_items[index].qty!}",
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
                                                    style: ElevatedButton
                                                        .styleFrom(primary: Colors.yellow[700]),
                                                    child: Row(
                                                      children: [
                                                        Icon(CupertinoIcons.pencil),
                                                        Text("Edit"),
                                                      ],
                                                    ),
                                                    onPressed: () async {
                                                      if (_items[index].exported != 'EXPORTED') {
                                                        customLogicalModal(
                                                          context,
                                                          Text("Are you sure you want to edit this item?"),
                                                          () => Navigator.pop(context),
                                                          () async {
                                                            Navigator.pop(context);
                                                            await updateItemModal(
                                                              context,
                                                              _sqfliteDBHelper,
                                                              "[LOGIN][Audit scan ID to update scanned item quantity.]",
                                                              _items[index].id!.toString(),
                                                              _items[index].description!,
                                                              _items[index].barcode!,
                                                              _items[index].itemcode!,
                                                              _items[index].uom!,
                                                              _items[index].expiry!,
                                                              _items[index].qty!,
                                                            );
                                                            _refreshItemList();
                                                          },
                                                        );
                                                      } else {
                                                        instantMsgModal(
                                                            context,
                                                            Icon(CupertinoIcons.exclamationmark_circle,
                                                              color: Colors.red,
                                                              size: 40,
                                                            ),
                                                            Text("This item is already synced, you cannot edit synced item."));
                                                      }
                                                    },
                                                  ),
                                                ),
                                                Padding(
                                                  padding:
                                                      const EdgeInsets.only(
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
                                                      if (_items[index].exported != 'EXPORTED') {
                                                        customLogicalModal(context,
                                                          Text("Are you sure you want to delete this item?"),
                                                          () => Navigator.pop(context), () async {
                                                          Navigator.pop(context);
                                                            var dtls = "[LOGIN][Audit scan ID to delete scanned item.]";
                                                            GlobalVariables.isAuditLogged = false;
                                                            await scanAuditModal(context, _sqfliteDBHelper, dtls);
                                                            if (GlobalVariables.isAuditLogged == true) {
                                                              //delte code here
                                                              delete(_items[index].id!, index);
                                                            }
                                                          },
                                                        );
                                                      } else {
                                                        instantMsgModal(
                                                            context,
                                                            Icon(
                                                              CupertinoIcons.exclamationmark_circle,
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
                                                  _items[index].exported == 'EXPORTED'
                                                      ? CupertinoIcons.checkmark_alt_circle_fill
                                                      : CupertinoIcons.info_circle_fill,
                                                  color:
                                                  _items[index].exported == 'EXPORTED'
                                                          ? Colors.green
                                                          : Colors.red,
                                                ),
                                                Text(
                                                    _items[index].exported ==
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
                            Text("Oops...It's empty in here!",
                              style: TextStyle(fontSize: 25, color: Colors.grey),
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

  _refreshItemList() async {
    List<ItemCount> x = await _sqfliteDBHelper.fetchItemCountWhere(
        "empno = '${GlobalVariables.logEmpNo}' AND business_unit = '${GlobalVariables.currentBusinessUnit}' AND department = '${GlobalVariables.currentDepartment}' AND section  = '${GlobalVariables.currentSection}' AND rack_desc  = '${GlobalVariables.currentRackDesc}'");
    _items = x;
    _notSynced = [];
    _synced = [];
    _notSynced = _items.where((element) => element.exported == '').toList();
    _synced = _items.where((element) => element.exported == 'EXPORTED').toList();
    _loading = false;
    listStat = false;
    if (mounted) setState(() {});
  }

  delete(int id, int index) async {
    await _sqfliteDBHelper.deleteItemCountWhere(id);
    _refreshItemList();

    //logs
    _log.date = dateFormat.format(DateTime.now());
    _log.time = timeFormat.format(DateTime.now());
    _log.device =
        "${GlobalVariables.deviceInfo}(${GlobalVariables.readdeviceInfo})";
    _log.user = "USER";
    _log.empid = GlobalVariables.logEmpNo;
    _log.details =
        "[DELETE][Delete item (barcode: ${_items[index].barcode} description: ${_items[index].description})]";
    await _sqfliteDBHelper.insertLog(_log);
  }
}
