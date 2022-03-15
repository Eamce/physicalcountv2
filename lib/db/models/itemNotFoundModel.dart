class ItemNotFound {
  static const tblItemNotFound = 'itemnotfound';
  static const colId = 'id';
  static const colBarcode = 'barcode';
  static const colUom = 'uom';
  static const colQty = 'qty';
  static const colLocation = 'location';
  static const colExported = 'exported';
  static const colDTCreated = 'datetimecreated';

  late final int? id;
  late String? barcode;
  late String? uom;
  late String? qty;
  late String? location;
  late String? exported;
  late String? dateTimeCreated;

  ItemNotFound({
    this.id,
    this.barcode,
    this.uom,
    this.qty,
    this.location,
    this.exported,
    this.dateTimeCreated,
  });

  ItemNotFound.fromMap(Map<String, dynamic> map) {
    id = map[colId];
    barcode = map[colBarcode];
    uom = map[colUom];
    qty = map[colQty];
    location = map[colLocation];
    exported = map[colExported];
    dateTimeCreated = map[colDTCreated];
  }

  Map<String, dynamic> toMap() {
    var map = <String, dynamic>{
      colBarcode: barcode,
      colUom: uom,
      colQty: qty,
      colLocation: location,
      colExported: exported,
      colDTCreated: dateTimeCreated,
    };
    map[colId] = id;
    return map;
  }
}
