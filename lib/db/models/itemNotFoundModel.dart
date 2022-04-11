class ItemNotFound {
  static const tblItemNotFound = 'itemnotfound';
  static const colId = 'id';
  static const colBarcode = 'barcode';
  static const colUom = 'uom';
  static const colQty = 'qty';
  static const colLocation = 'location';
  static const colExported = 'exported';
  static const colDTCreated = 'datetimecreated';
  static const colBu='business_unit';
  static const coldept='department';
  static const colsection='section';
  static const colempno='empno';
  static const colrack='rack_desc';

  late final int? id;
  late String? barcode;
  late String? uom;
  late String? qty;
  late String? location;
  late String? exported;
  late String? dateTimeCreated;
  late String? businessUnit;
  late String? department;
  late String? section;
  late String? empno;
  late String? rack_desc;

  ItemNotFound({
    this.id,
    this.barcode,
    this.uom,
    this.qty,
    this.location,
    this.exported,
    this.dateTimeCreated,
    this.businessUnit,
    this.department,
    this.section,
    this.empno,
    this.rack_desc
  });

  ItemNotFound.fromMap(Map<String, dynamic> map) {
    id              = map[colId];
    barcode         = map[colBarcode];
    uom             = map[colUom];
    qty             = map[colQty];
    location        = map[colLocation];
    exported        = map[colExported];
    dateTimeCreated = map[colDTCreated];
    businessUnit    =map[colBu];
    department      =map[coldept];
    section         =map[colsection];
    empno           =map[colempno];
    rack_desc       =map[colrack];
  }
  Map<String, dynamic> toMap() {
    var map = <String, dynamic>{
      colBarcode    : barcode,
      colUom        : uom,
      colQty        : qty,
      colLocation   : location,
      colExported   : exported,
      colDTCreated  : dateTimeCreated,
      colBu         : businessUnit,
      coldept       : department,
      colsection    : section,
      colempno      : empno,
      colrack       : rack_desc
    };
    map[colId] = id;
    return map;
  }
}
