class Filter {
  static const tblFilter = 'filter';
  static const colId = 'id';
  static const colbyCategory = 'byCategory';
  static const colcategoryName = "categoryName";
  static const colbyVendor = "byVendor";
  static const colvendorName = "vendorName";
  static const coltype = 'ctype';
  static const collocation = 'location_id';

  late final int? id;
  late String? bycategory;
  late String? categoryname;
  late String? byvendor;
  late String? vendorname;
  late String? type;
  late String? location_id;

  Filter({
    this.id,
    this.bycategory,
    this.categoryname,
    this.byvendor,
    this.vendorname,
    this.type,
    this.location_id,
  });

  Filter.fromMap(Map<String, dynamic> map) {
    id = map[colId];
    bycategory = map[colbyCategory];
    categoryname = map[colcategoryName];
    byvendor = map[colbyVendor];
    vendorname = map[colvendorName];
    type = map[coltype];
    location_id = map[collocation];
  }

  Map<String, dynamic> toMap() {
    var map = <String, dynamic>{
      colbyCategory: bycategory,
      colcategoryName: categoryname,
      colbyVendor: byvendor,
      colvendorName: vendorname,
      coltype: type,
      collocation:location_id
    };
    map[colId] = id;
    return map;
  }
}
