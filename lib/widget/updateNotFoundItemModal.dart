import 'package:dropdown_search/dropdown_search.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:physicalcountv2/db/sqfLite_dbHelper.dart';
import 'package:physicalcountv2/values/bodySize.dart';
import 'package:physicalcountv2/values/globalVariables.dart';
import 'package:physicalcountv2/widget/instantMsgModal.dart';
import 'package:physicalcountv2/widget/scanAuditModal.dart';

updateNotFoundItemModal(
    BuildContext context,
    SqfliteDBHelper db,
    String details,
    String id,
    String barcode,
    String uom,
    String qty,
    List units) {
  late FocusNode myFocusNodeQty;
  myFocusNodeQty = FocusNode();

  final qtyController = TextEditingController();
  // ItemNotFound _itemNotFound = ItemNotFound();

  var _uom = units;
  String _selectedUom = uom;
  qtyController.text = qty;
  final validCharacters = RegExp(r'^[0-9]+$');
  var _uomm = [];
  units.forEach((element) {
    _uomm.add(element['uom']);
  });

  return showModalBottomSheet(
    isScrollControlled: true,
    context: context,
    backgroundColor: Colors.transparent,
    builder: (context) {
      return StatefulBuilder(
        builder: (BuildContext context, StateSetter setModalState) {
          return Container(
            height: BodySize.hghth / 1.2,
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
                  Padding(
                    padding: const EdgeInsets.only(left: 20.0, right: 20.0),
                    child: RichText(
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
                              style:
                                  TextStyle(fontSize: 25, color: Colors.black))
                        ],
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(left: 20.0, right: 20.0),
                    child: Text("Unit of Measure",
                        style: TextStyle(
                            fontSize: 25,
                            color: Colors.blue,
                            fontWeight: FontWeight.bold)),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(
                        left: 20.0, right: 20.0, bottom: 10.0),
                    child: DropdownSearch<dynamic>(
                      items: _uomm,
                      showSearchBox: true,
                      selectedItem: _selectedUom,
                      dropdownSearchDecoration: InputDecoration(
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(5.0),
                        ),
                      ),
                      onChanged: (val) {
                        _selectedUom = val.toString();
                        setModalState(() {});
                      },
                    ),
                  ),
                  // Padding(
                  //   padding: const EdgeInsets.only(
                  //       left: 20.0, right: 20.0, bottom: 10.0),
                  //   child: Container(
                  //     width: BodySize.wdth / 2,
                  //     child: FormField<String>(
                  //       builder: (FormFieldState<String> state) {
                  //         return InputDecorator(
                  //           decoration: InputDecoration(
                  //               focusedBorder: UnderlineInputBorder(
                  //                 borderSide:
                  //                     BorderSide(color: Colors.blueGrey),
                  //               ),
                  //               errorStyle: TextStyle(
                  //                   color: Colors.redAccent, fontSize: 25.0),
                  //               hintText: 'Please select unit',
                  //               border: OutlineInputBorder(
                  //                   borderRadius: BorderRadius.circular(5.0))),
                  //           isEmpty: _selectedUom == '',
                  //           child: DropdownButtonHideUnderline(
                  //             child: DropdownButton<String>(
                  //               value: _selectedUom,
                  //               isDense: true,
                  //               isExpanded: true,
                  //               onChanged: (newValue) {
                  //                 _selectedUom = newValue.toString();
                  //                 state.didChange(newValue);
                  //                 setModalState(() {});
                  //               },
                  //               items: _uom.map((value) {
                  //                 return DropdownMenuItem<String>(
                  //                   value: value['uom'],
                  //                   child: Text(
                  //                     value['uom'],
                  //                     style: TextStyle(fontSize: 25.0),
                  //                   ),
                  //                 );
                  //               }).toList(),
                  //             ),
                  //           ),
                  //         );
                  //       },
                  //     ),
                  //   ),
                  // ),
                  Padding(
                    padding: const EdgeInsets.only(left: 20.0, right: 20.0),
                    child: Text("Quantity",
                        style: TextStyle(
                            fontSize: 25,
                            color: Colors.blue,
                            fontWeight: FontWeight.bold)),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(
                        left: 20.0, right: 20.0, bottom: 10.0),
                    child: Container(
                      width: BodySize.wdth / 2,
                      child: TextFormField(
                        autofocus: true,
                        focusNode: myFocusNodeQty,
                        style: TextStyle(fontSize: 50),
                        controller: qtyController,
                        keyboardType: TextInputType.number,
                        decoration: InputDecoration(
                          contentPadding:
                              EdgeInsets.all(8.0), //here your padding
                          border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(3)),
                        ),
                        onFieldSubmitted: (value) {
                          qtyController.clear();
                        },
                        onChanged: (value) {
                          if(value.characters.first=='0' || validCharacters.hasMatch(value)==false){
                            qtyController.clear();
                          }
                          if (qtyController.text.isNotEmpty) {
                            setModalState(() {});
                          } else {
                            setModalState(() {});
                          }
                        },
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(
                        left: 20.0, right: 20.0, top: 8, bottom: 8.0),
                    child: MaterialButton(
                      height: MediaQuery.of(context).size.height / 15,
                      minWidth: MediaQuery.of(context).size.width,
                      color: Colors.green,
                      child: Text("UPDATE",
                          style: TextStyle(color: Colors.white, fontSize: 25)),
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
                        if (GlobalVariables.isAuditLogged != false && qtyController.text.isNotEmpty){
                          await db.updateItemNotFoundWhere(int.parse(id),
                              'uom = "${_selectedUom.trim()}", qty = "${qtyController.text.trim()}"');
                          Navigator.pop(context);
                        }
                      },
                    ),
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
