import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:physicalcountv2/db/sqfLite_dbHelper.dart';
import 'package:physicalcountv2/values/bodySize.dart';
import 'package:physicalcountv2/values/globalVariables.dart';
import 'package:physicalcountv2/widget/scanAuditModal.dart';

import 'instantMsgModal.dart';

updateItemModal(
    BuildContext context,
    SqfliteDBHelper db,
    String details,
    String id,
    String desc,
    String barcode,
    String itemcode,
    String uom,
    String expiry,
    String qty) {
  final qtyController = TextEditingController();
  qtyController.text = qty;
  late FocusNode myFocusNodeQty;
  myFocusNodeQty = FocusNode();
  myFocusNodeQty.requestFocus();

  DateTime selectedDate = DateTime.parse(expiry);
  int int_qty =int.parse(qty);
  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: selectedDate,
      firstDate: DateTime(2015, 8),
      lastDate: DateTime(2101),
    );
    if (picked != selectedDate) selectedDate = picked!;
  }

  return showModalBottomSheet(
    isScrollControlled: true,
    context: context,
    backgroundColor: Colors.transparent,
    builder: (context) {
      return StatefulBuilder(
        builder: (BuildContext context, StateSetter setModalState) {
          return Container(
            height: BodySize.hghth / 1.8,
            decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.only(
                    topRight: Radius.circular(10),
                    topLeft: Radius.circular(10))),
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Flexible(
                        child: Text(
                          desc,
                          style: TextStyle(fontSize: 25),
                          overflow: TextOverflow.ellipsis,
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
                                fontSize: 25,
                                color: Colors.blue,
                                fontWeight: FontWeight.bold)),
                        TextSpan(
                            text: "$barcode",
                            style: TextStyle(fontSize: 25, color: Colors.black))
                      ],
                    ),
                  ),
                  RichText(
                    text: TextSpan(
                      children: [
                        TextSpan(
                            text: "Itemcode: ",
                            style: TextStyle(
                                fontSize: 25,
                                color: Colors.blue,
                                fontWeight: FontWeight.bold)),
                        TextSpan(
                            text: "$itemcode",
                            style: TextStyle(fontSize: 25, color: Colors.black))
                      ],
                    ),
                  ),
                  RichText(
                    text: TextSpan(
                      children: [
                        TextSpan(
                            text: "Unit of Measure: ",
                            style: TextStyle(
                                fontSize: 25,
                                color: Colors.blue,
                                fontWeight: FontWeight.bold)),
                        TextSpan(
                            text: "$uom",
                            style: TextStyle(fontSize: 25, color: Colors.black))
                      ],
                    ),
                  ),
                  GlobalVariables.countType != 'ANNUAL'
                      ? Row(
                          children: [
                            RichText(
                              text: TextSpan(
                                children: [
                                  TextSpan(
                                      text: "Expiry Date: ",
                                      style: TextStyle(
                                          fontSize: 25,
                                          color: Colors.blue,
                                          fontWeight: FontWeight.bold)),
                                ],
                              ),
                            ),
                            Container(
                              width: MediaQuery.of(context).size.width / 3,
                              child: ElevatedButton(
                                style: ElevatedButton.styleFrom(
                                    primary: Colors.blue),
                                onPressed: () async {
                                  _selectDate(context);
                                  setModalState(() {});
                                },
                                child: Text(
                                  "${DateFormat('MMMM dd, yyyy').format(selectedDate)}",
                                  style: TextStyle(color: Colors.white),
                                ),
                              ),
                            ),
                          ],
                        )
                      : SizedBox(),
                  Row(
                    children: [
                      RichText(
                        text: TextSpan(
                          children: [
                            TextSpan(
                                text: "Quantity: ",
                                style: TextStyle(
                                    fontSize: 25,
                                    color: Colors.blue,
                                    fontWeight: FontWeight.bold)),
                          ],
                        ),
                      ),
                      Container(
                        width: BodySize.wdth / 3,
                        child: TextFormField(
                          controller: qtyController,
                          focusNode: myFocusNodeQty,
                          keyboardType: TextInputType.number,
                          style: TextStyle(fontSize: 50),
                          decoration: InputDecoration(
                            contentPadding:
                                EdgeInsets.all(8.0), //here your padding
                            border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(3)),
                          ),
                          onChanged: (value) {
                            if(int_qty<int.parse(value)){
                              instantMsgModal(
                                  context,
                                  Icon(
                                    CupertinoIcons.exclamationmark_circle,
                                    color: Colors.red,
                                    size: 40,
                                  ),
                                  Text("ERROR!"));
                              qtyController.text=qty;
                            }
                          },
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(left: 8.0),
                        child: ElevatedButton(
                          style:
                              ElevatedButton.styleFrom(primary: Colors.green),
                          child: Row(
                            children: [
                              Icon(CupertinoIcons.arrow_right_square_fill),
                              Padding(
                                padding: const EdgeInsets.only(
                                    top: 17.0, bottom: 17.0),
                                child: Text("Update",
                                    style: TextStyle(fontSize: 25)),
                              )
                            ],
                          ),
                          onPressed: () async {
                            GlobalVariables.isAuditLogged = false;
                            if (GlobalVariables.isAuditLogged == false && qtyController.text.isEmpty) {
                              instantMsgModal(
                                  context,
                                  Icon(
                                    CupertinoIcons.exclamationmark_circle,
                                    color: Colors.red,
                                    size: 40,
                                  ),
                                  Text("ERROR! Please input quantity!"));
                            }else{
                               await scanAuditModal(context, db, details);
                            }
                          if (GlobalVariables.isAuditLogged == true && qtyController.text.isNotEmpty) {
                            await db.updateItemCountWhere(int.parse(id),
                                "qty = '${qtyController.text.trim()}', expiry = '$selectedDate'");
                            Navigator.pop(context);
                          }
                          }
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          );
        },
      );
    },
  );
}
