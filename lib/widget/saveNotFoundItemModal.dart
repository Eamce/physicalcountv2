import 'package:dropdown_search/dropdown_search.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:physicalcountv2/db/models/itemNotFoundModel.dart';
import 'package:physicalcountv2/db/sqfLite_dbHelper.dart';
import 'package:physicalcountv2/values/bodySize.dart';
import 'package:physicalcountv2/values/globalVariables.dart';
import 'package:physicalcountv2/widget/scanAuditModal.dart';

saveNotFoundItemModal(BuildContext context, SqfliteDBHelper db, List units) {
  late FocusNode myFocusNodeBarcode;
  late FocusNode myFocusNodeQty;

  myFocusNodeBarcode = FocusNode();
  myFocusNodeQty = FocusNode();

  final barcodeController = TextEditingController();
  final qtyController = TextEditingController();

  bool btnSaveEnabled = false;

  ItemNotFound _itemNotFound = ItemNotFound();

  // var _uom = ["MALE", "FEMALE"];
  var _uom = units;
  var _uomm = [];
  units.forEach((element) {
    _uomm.add(element['uom']);
  });
  String _selectedUom = _uom[0]['uom'];

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
                    child: Text("Barcode",
                        style: TextStyle(
                            fontSize: 25,
                            color: Colors.blue,
                            fontWeight: FontWeight.bold)),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(
                        left: 20.0, right: 20.0, bottom: 10.0),
                    child: TextFormField(
                      autofocus: true,
                      focusNode: myFocusNodeBarcode,
                      style: TextStyle(fontSize: 50),
                      textAlign: TextAlign.center,
                      controller: barcodeController,
                      keyboardType: TextInputType.number,
                      decoration: InputDecoration(
                        contentPadding: EdgeInsets.all(8.0), //here your padding
                        border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(3)),
                      ),
                      onFieldSubmitted: (value) {
                        myFocusNodeQty.requestFocus();
                      },
                      onChanged: (value) {
                        if (barcodeController.text.isNotEmpty &&
                            qtyController.text.isNotEmpty) {
                          btnSaveEnabled = true;
                          setModalState(() {});
                        } else {
                          btnSaveEnabled = false;
                          setModalState(() {});
                        }
                      },
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
                          //
                        },
                        onChanged: (value) {
                          if (barcodeController.text.isNotEmpty &&
                              qtyController.text.isNotEmpty) {
                            btnSaveEnabled = true;
                            setModalState(() {});
                          } else {
                            btnSaveEnabled = false;
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
                      color: btnSaveEnabled ? Colors.green : Colors.grey[300],
                      child: Text("SAVE",
                          style: TextStyle(color: Colors.white, fontSize: 25)),
                      onPressed: () async {
                        if (btnSaveEnabled == true) {
                          var dtls = "[LOGIN][Audit scan ID to save item.";
                          GlobalVariables.isAuditLogged = false;
                          await scanAuditModal(context, db, dtls);
                          if (GlobalVariables.isAuditLogged == true) {
                            DateFormat dateFormat1 =
                                DateFormat("yyyy-MM-dd hh:mm:ss aaa");
                            String dt = dateFormat1.format(DateTime.now());

                            _itemNotFound.barcode =
                                barcodeController.text.trim();
                            _itemNotFound.uom = _selectedUom.trim();
                            _itemNotFound.qty = qtyController.text.trim();
                            _itemNotFound.location =
                                GlobalVariables.currentLocationID;
                            _itemNotFound.exported = 'false';
                            _itemNotFound.dateTimeCreated = dt;
                            await db.insertItemNotFound(_itemNotFound);

                            myFocusNodeBarcode.requestFocus();
                            barcodeController.clear();
                            qtyController.clear();

                            btnSaveEnabled = false;
                            setModalState(() {});

                            var rs = await db.selectItemNotFoundWhere(
                                GlobalVariables.currentLocationID);
                            print(rs);
                          }
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
