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
  static const coldescription = 'description';
  static const colitemcode = 'itemcode';

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
  late String? description;
  late String? itemcode;

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
    this.rack_desc,
    this.description,
    this.itemcode
  });

  ItemNotFound.fromMap(Map<String, dynamic> map) {
    id              = map[colId];
    barcode         = map[colBarcode];
    uom             = map[colUom];
    qty             = map[colQty];
    location        = map[colLocation];
    exported        = map[colExported];
    dateTimeCreated = map[colDTCreated];
    businessUnit    = map[colBu];
    department      = map[coldept];
    section         = map[colsection];
    empno           = map[colempno];
    rack_desc       = map[colrack];
    description     = map[coldescription];
    itemcode     = map[colitemcode];
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
      colrack       : rack_desc,
      coldescription    : description,
      colitemcode    : itemcode
    };
    map[colId] = id;
    return map;
  }
}
