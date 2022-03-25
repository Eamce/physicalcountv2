import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'package:physicalcountv2/services/server_url.dart';
import "package:http/http.dart" as http;
import 'package:physicalcountv2/values/globalVariables.dart';
import 'package:retry/retry.dart';

Future checkIfConnectedToNetwork() async {
  try {
   // var url = Uri.parse(ServerUrl.urlCI + "mapi/getItemMasterfileCount");
   //  final response = await http.get(url).timeout(const Duration(seconds: 20));
   //  if (response.statusCode == 00) {
   //    return 'success';
   //  } else if (response.statusCode >= 400 || response.statusCode <= 499) {
   //    GlobalVariables.httpError =
   //        "Error: Client issued a malformed or illegal request.";
   //    return 'error';
   //  } else if (response.statusCode >= 500 || response.statusCode <= 599) {
   //    GlobalVariables.httpError = "Error: Internal server error.";
   //    return 'error';
   //  }
  } on TimeoutException {
    GlobalVariables.httpError =
        "Connection timed out. Please check internet connection or proxy server configurations.";
    return 'errornet';
  } on SocketException {
    GlobalVariables.httpError =
        "Connection timed out. Please check internet connection or proxy server configurations.";
    return 'errornet';
  } on HttpException {
    GlobalVariables.httpError =
        "Error: An HTTP error eccured. Please try again later.";
    return 'error';
  } on FormatException {
    GlobalVariables.httpError =
        "Error: Format exception error occured. Please try again later.";
    return 'error';
  }
}

Future getUserMasterfile() async {
  var url = Uri.parse(ServerUrl.urlCI + "mapi/getUserMasterfile");
  final response = await retry(
      () => http.post(url, headers: {"Accept": "Application/json"}, body: {}));
  var convertedDataToJson = jsonDecode(response.body);
  return convertedDataToJson;
}

Future getAuditMasterfile() async {
  var url = Uri.parse(ServerUrl.urlCI + "mapi/getAuditMasterifle");
  final response = await retry(
      () => http.post(url, headers: {"Accept": "Application/json"}, body: {}));
  var convertedDataToJson = jsonDecode(response.body);
  return convertedDataToJson;
}

Future getLocationMasterfile() async {
  var url = Uri.parse(ServerUrl.urlCI + "mapi/getLocationMasterfile");
  final response = await retry(
      () => http.post(url, headers: {"Accept": "Application/json"}, body: {}));
  var convertedDataToJson = jsonDecode(response.body);
  return convertedDataToJson;
}

Future getItemMasterfileCount() async {
  var url = Uri.parse(ServerUrl.urlCI + "mapi/getItemMasterfileCount");
  final response = await retry(
      () => http.post(url, headers: {"Accept": "Application/json"}, body: {}));
  var convertedDataToJson = jsonDecode(response.body);
  return convertedDataToJson;
}

Future getUnit(String haveFilter, String filters) async {
  var url = Uri.parse(ServerUrl.urlCI + "mapi/getUnit");
  final response = await retry(() => http.post(url, headers: {
        "Accept": "Application/json"
      }, body: {
        'haveFilter': haveFilter,
        'filters': filters,
      }));
  var convertedDataToJson = jsonDecode(response.body);
  print('convertedDataToJson $convertedDataToJson');
  return convertedDataToJson;
}

Future getItemMasterfileOffset(String offset) async {
  var url = Uri.parse(ServerUrl.urlCI + "mapi/getItemMasterfileOffset");
  final response = await retry(() => http.post(url, headers: {
        "Accept": "Application/json"
      }, body: {
        'offset': offset,
      }));
  var convertedDataToJson = jsonDecode(response.body);
  return convertedDataToJson;
}

Future getFilteredItemMasterfile() async {
  var url = Uri.parse(ServerUrl.urlCI + "mapi/getFilteredItemMasterfile");
  final response = await retry(
      () => http.post(url, headers: {"Accept": "Application/json"}, body: {}));
  var convertedDataToJson = jsonDecode(response.body);
  return convertedDataToJson;
}

Future syncItem(
    List items, String usersignature, String auditorsignature) async {
  var url = Uri.parse(ServerUrl.urlCI + "mapi/insertCountDataList");
  final response = await retry(() => http.post(url, headers: {
        "Accept": "Application/json"
      }, body: {
        'items': json.encode(items),
        'empno': GlobalVariables.logEmpNo,
        'user_signature': usersignature,
        'audit_signature': auditorsignature,
        'locationid': GlobalVariables.currentLocationID,
      }));
  var convertedDataToJson = jsonDecode(response.body);
  return convertedDataToJson;
}

Future syncNfItem(List nfItems, String userSignature, String auditSignature) async {
  var url = Uri.parse(ServerUrl.urlCI + "mapi/""insertNFItemList");
  final response = await retry(() => http.post(url, headers: {
        "Accept": "Application/json"
      }, body: {
        'nfitems': json.encode(nfItems),
        'user_signature': userSignature,
        'audit_signature': auditSignature,
      }));
  var convertedDataToJson = jsonDecode(response.body);
  return convertedDataToJson;
}

Future getAllUsers() async {
  var url = Uri.parse(ServerUrl.urlCI + "mapi/getAllUsers");
  final response = await retry(
      () => http.post(url, headers: {"Accept": "Application/json"}, body: {}));
  var convertedDataToJson = jsonDecode(response.body);
  return convertedDataToJson;
}

Future updateSignature(
    String locationid, String userSig, String auditSig) async {
  var url = Uri.parse(ServerUrl.urlCI + "mapi/updateSignature");
  final response = await retry(() => http.post(url, headers: {
        "Accept": "Application/json"
      }, body: {
        'location_id': locationid,
        'user_sig': userSig,
        'audit_sig': auditSig,
      }));
  var convertedDataToJson = jsonDecode(response.body);
  return convertedDataToJson;
}
