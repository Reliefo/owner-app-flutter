bool debug = false;

class RestaurantOrderHistory {
  String oid;
//  List<TableOrder> tableOrder;
//  List<TableOrder> personalOrder;
  List<Map<String, String>> users;
//  List<AssistanceRequest> assistanceReq;
  DateTime timeStamp;
  String tableId;
  String table;
  Bill bill;
  String pdf;

  RestaurantOrderHistory({
    this.oid,
//    this.tableOrder,
//    this.personalOrder,
    this.users,
//    this.assistanceReq,
    this.timeStamp,
    this.tableId,
    this.table,
    this.bill,
    this.pdf,
  });

  RestaurantOrderHistory.fromJson(Map<String, dynamic> json) {
    //print("order history");
    //print(json.keys.toList());
//
    //print(json['bill_structure']);
    //print(json['timestamp']);
    //print(json['pdf']);

    if (json['_id']['\$oid'] != null) {
      oid = json['_id']['\$oid'];
    }

    if (debug) {
      //print(" oid added to RestaurantOrderHistory.!");
    }

//    if (json['table_orders'] != null) {
//      tableOrder = new List<TableOrder>();
//      json['table_orders'].forEach((v) {
//        tableOrder.add(TableOrder.fromJson(v));
//      });
//    }
//    if (debug) {
//      //print(" table order added to RestaurantOrderHistory.!");
//    }

    if (json['users'] != null) {
      users = new List<Map<String, String>>();
      json['users'].forEach((user) {
        users.add({"name": user["name"], "id": user["user_id"]});
      });
    }
    if (debug) {
      //print(" users added to RestaurantOrderHistory.!");
    }
//    if (json['assistance_reqs'] != null) {
//      assistanceReq = new List<AssistanceRequest>();
//      json['assistance_reqs'].forEach((v) {
//        assistanceReq.add(AssistanceRequest.fromJson(v));
//      });
//    }
//    if (debug) {
//      //print(" assistanceReq added to RestaurantOrderHistory.!");
//    }
    if (json['timestamp'] != null) {
      timeStamp = DateTime.parse(json['timestamp']);
    }
    if (debug) {
      //print(" timeStamp added to RestaurantOrderHistory.!");
    }
    if (json['table_id'] != null) {
      tableId = json['table_id'];
    }
    if (debug) {
      //print(" tableId added to RestaurantOrderHistory.!");
    }
    if (json['table'] != null) {
      table = json['table'];
    }
    if (debug) {
      //print(" table added to RestaurantOrderHistory.!");
    }
    if (json['bill_structure'] != null) {
      bill = Bill.fromJson(json['bill_structure']);
    }
    if (debug) {
      //print(" bill added to RestaurantOrderHistory.!");
    }
    if (json['pdf'] != null) {
      pdf = json['pdf'];
    }
    if (debug) {
      //print(" pdf added to RestaurantOrderHistory.!");
    }
  }
}

class Bill {
  double preTaxAmount;
  double totalTax;
  double totalAmount;

  Bill({
    this.preTaxAmount,
    this.totalTax,
    this.totalAmount,
  });
//  {Pre-Tax Amount: 870.0, Total Tax: 8.5, Total Amount: 943.95}
  Bill.fromJson(Map<String, dynamic> json) {
    //print(json['Pre-Tax Amount'].runtimeType);
    //print(json['Taxes'].runtimeType);
    //print(json['Total Amount'].runtimeType);

    if (json['Pre-Tax Amount'] != null) {
      if (json['Pre-Tax Amount'].runtimeType == int) {
        preTaxAmount = json['Pre-Tax Amount'].toDouble();
      } else
        preTaxAmount = json['Pre-Tax Amount'];
    }

    if (json['Taxes'] != null) {
      totalTax = json['Taxes'];
    }

    if (json['Total Amount'] != null) {
      totalAmount = json['Total Amount'];
    }
  }
}
