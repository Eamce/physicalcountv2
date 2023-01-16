  import 'package:flutter/material.dart';

class GlobalVariables {
  static late BuildContext bodyContext;
  static String httpError           = '';
  static String deviceInfo          = "";
  static String readdeviceInfo      = "";
  static String logEmpNo            = "";
  static String logFullName         = "";
  static String logAuditName        ="";
  static String prevBarCode         = "";
  static String prevItemCode        = "";
  static String prevItemDesc        = "";
  static String prevItemUOM         = "";
  static String prevExpiry          = "";
  static String prevQty             = "";
  static String prevDTCreated       = "";
  static bool byVendor              = false;
  static String vendors             = "";
  static bool byCategory            = false;
  static String categories          = "";
  static String countType           = "";
  static bool enableExpiry          = false;
  static String currentLocationID   = "";
  static String currentBusinessUnit = "";
  static String currentDepartment   = "";
  static String currentSection      = "";
  static String currentRackDesc     = "";
  static bool isAuditLogged         = false;
  static String saveAuditSignature  = '';
  static String searchItemBarcode   = '';
  static String editedQuantity      = '';
  static int editCount              = 0;
}
