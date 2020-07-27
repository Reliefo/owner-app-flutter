import 'package:date_format/date_format.dart';
import 'package:flutter/material.dart';
import 'package:ownerapp/Home/barGraph.dart';
import 'package:ownerapp/Home/salesDetails.dart';
import 'package:ownerapp/constants.dart';
import 'package:ownerapp/data.dart';

class HomeScreen extends StatefulWidget {
  HomeScreen({
    @required this.orderHistory,
  });

  final List<RestaurantOrderHistory> orderHistory;
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  DateTime now = new DateTime.now();

//  List<RestaurantOrderHistory> orderHistory;

  List<RestaurantOrderHistory> currentDayHistory,
      currentWeekHistory,
      lastWeekHistory,
      currentMonthHistory,
      lastMonthHistory,
      customPeriodHistory;

  Map<String, int> currentDaySales,
      currentWeekSales,
      lastWeekSales,
      currentMonthSales,
      lastMonthSales,
      customPeriodSales;
  List<Map<String, int>> recentSales = []; //today's sales at index 0

  DateTime fromDate;
  DateTime uptoDate;

  calculateCurrentDaySales() {
    DateTime startTime;
    DateTime endTime;

    // start date-time morning 9 am
    startTime = DateTime(now.year, now.month, now.day, 9);

// end date-time next day(midnight) 3 am
    endTime = DateTime(now.year, now.month, now.day + 1, 3);

//    print("current Day Sales");
//    print(startTime);
//    print(endTime);
    setState(() {
      currentDaySales = calculateSales(startTime, endTime);

      currentDayHistory = getRestaurantOrderHistory(startTime, endTime);
    });
  }

  calculateRecentSales() {
    recentSales.clear();
    print("resent dateslll");
    for (var i = 0; i < 8; ++i) {
      DateTime startTime = DateTime(now.year, now.month, now.day - i, 9);
      DateTime endTime = DateTime(now.year, now.month, now.day + 1 - i, 3);
//
//      print("resent dates");
//
//      print(startTime);
//      print(endTime);

      Map<String, int> value = calculateSales(startTime, endTime);
      setState(() {
        recentSales.add(value);
      });
    }
  }

  calculateCurrentWeekSales() {
    DateTime startTime;
    DateTime endTime;

    startTime = DateTime(now.year, now.month, now.day - now.weekday + 1, 9);
    endTime = DateTime.now();
//    print("currentWeekSales");
//    print(startTime);
//    print(endTime);

    setState(() {
      currentWeekSales = calculateSales(startTime, endTime);
      currentWeekHistory = getRestaurantOrderHistory(startTime, endTime);
    });
  }

  calculateLastWeekSales() {
    DateTime startTime;
    DateTime endTime;

    startTime = DateTime(now.year, now.month, now.day - now.weekday - 6, 9);
    endTime = DateTime(startTime.year, startTime.month, startTime.day + 7, 3);
//    print("LastWeekSales");
//    print(startTime);
//    print(endTime);

    setState(() {
      lastWeekSales = calculateSales(startTime, endTime);
      lastWeekHistory = getRestaurantOrderHistory(startTime, endTime);
    });
  }

  calculateCurrentMonthSales() {
    DateTime startTime;
    DateTime endTime;

    startTime = DateTime(now.year, now.month, 1, 9);
    endTime = DateTime(
      now.year,
      now.month,
      now.day,
      now.hour,
      now.minute,
    );
//    print("currentMonthSales");
//    print(startTime);
//    print(endTime);

    setState(() {
      currentMonthSales = calculateSales(startTime, endTime);
      currentMonthHistory = getRestaurantOrderHistory(startTime, endTime);
    });
  }

  calculateLastMonthSales() {
    DateTime startTime;
    DateTime endTime;

    startTime = DateTime(now.year, now.month - 1, 1, 9);
    endTime = DateTime(now.year, now.month, 1, 3);
//    print("lastMonthSales");
//    print(startTime);
//    print(endTime);
    setState(() {
      lastMonthSales = calculateSales(startTime, endTime);
      lastMonthHistory = getRestaurantOrderHistory(startTime, endTime);
    });
  }

  Map<String, int> calculateSales(DateTime startTime, DateTime endTime) {
    double preTaxAmount = 0;
    double totalTax = 0;
    double totalAmount = 0;

    widget.orderHistory?.forEach((order) {
//      print("hereeee");
      if (order.timeStamp.isAfter(startTime) &&
          order.timeStamp.isBefore(endTime)) {
        preTaxAmount += order.bill.preTaxAmount;
//        print("coming");
        totalTax += order.bill.totalTax;
//        print("coming1");
        totalAmount += order.bill.totalAmount;
      }
    });
//    print("total sales");
//    print(totalAmount);
    return {
      "preTaxAmount": preTaxAmount.round(),
      "totalTax": totalTax.round(),
      "totalAmount": totalAmount.round()
    };
  }

  List<RestaurantOrderHistory> getRestaurantOrderHistory(
      DateTime startTime, DateTime endTime) {
    List<RestaurantOrderHistory> sortedOrderHistory = [];
    widget.orderHistory?.forEach((order) {
      if (order.timeStamp.isAfter(startTime) &&
          order.timeStamp.isBefore(endTime)) {
        sortedOrderHistory.add(order);
      }
    });

    return sortedOrderHistory;
  }

  calculateAllSales() {
    calculateCurrentDaySales();
    calculateRecentSales();
    calculateCurrentWeekSales();
    calculateLastWeekSales();
    calculateCurrentMonthSales();
    calculateLastMonthSales();
  }

  Widget customPeriodLayout() {
    if (fromDate == null || uptoDate == null) {
      return Container(
        child: Text("Select Start and End Dates to get Sales."),
      );
    } else if (fromDate.isAfter(uptoDate)) {
      return Container(
        child: Text("Start date is greater than end date.!"),
      );
    } else if (fromDate.isBefore(uptoDate)) {
      setState(() {
        customPeriodSales = calculateSales(fromDate, uptoDate);
        customPeriodHistory = getRestaurantOrderHistory(fromDate, uptoDate);
      });

      return SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Container(
              padding: EdgeInsets.symmetric(
                horizontal: 10,
                vertical: 8,
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Text(
                    "Pre-Tax Amount : ",
                    style: kSubTitleStyle,
                  ),
                  Text(
                    "₹ ${customPeriodSales["preTaxAmount"]}",
                    style: kHeaderStyleSmall,
                  ),
                ],
              ),
            ),
            Container(
              padding: EdgeInsets.symmetric(
                horizontal: 10,
                vertical: 8,
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Text(
                    "Total Sales: ",
                    style: kSubTitleStyle,
                  ),
                  Text(
                    "₹ ${customPeriodSales["totalAmount"]}",
                    style: kDashBoardLargeStyle,
                  ),
                ],
              ),
            ),
            RaisedButton(
              child: Text("View Details"),
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => SalesDetails(
                      salesHistory: customPeriodHistory,
                    ),
                  ),
                );
              },
            ),
          ],
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    calculateAllSales();

    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          title: Text("Dashboard"),
          backgroundColor: kThemeColor,
        ),
        body: Container(
          color: Color(0xffF5F7FB),
          child: ListView(
            children: <Widget>[
              RawMaterialButton(
                child: DisplaySales(
                  title: "Today's Sales",
                  value: currentDaySales,
                ),
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => SalesDetails(
                        salesHistory: currentDayHistory,
                      ),
                    ),
                  );
                },
              ),
              Row(
                children: <Widget>[
                  Expanded(
                    child: RawMaterialButton(
                      child: DisplaySales(
                        title: "This Week",
                        value: currentWeekSales,
                      ),
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => SalesDetails(
                              salesHistory: currentWeekHistory,
                            ),
                          ),
                        );
                      },
                    ),
                  ),
                  ////////////////
                  Expanded(
                    child: RawMaterialButton(
                      child: DisplaySales(
                        title: "Last Week",
                        value: lastWeekSales,
                      ),
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => SalesDetails(
                              salesHistory: lastWeekHistory,
                            ),
                          ),
                        );
                      },
                    ),
                  ),
                ],
              ),
              Row(
                children: <Widget>[
                  Expanded(
                    child: RawMaterialButton(
                      child: DisplaySales(
                        title: "This Month",
                        value: currentMonthSales,
                      ),
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => SalesDetails(
                              salesHistory: currentMonthHistory,
                            ),
                          ),
                        );
                      },
                    ),
                  ),
                  Expanded(
                    child: RawMaterialButton(
                      child: DisplaySales(
                        title: "Last Month",
                        value: lastMonthSales,
                      ),
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => SalesDetails(
                              salesHistory: lastMonthHistory,
                            ),
                          ),
                        );
                      },
                    ),
                  ),
                ],
              ),
              BarGraph(
                recentSales: recentSales,
              ),
              Container(
                margin: EdgeInsets.all(10),
                color: Colors.white,
                child: Column(
                  children: <Widget>[
                    Container(
                      padding: EdgeInsets.symmetric(vertical: 10),
                      child: Text(
                        "Custom Period",
                        style: kHeaderStyleSmall,
                      ),
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        GestureDetector(
                          child: Container(
                            color: Colors.white,
                            padding: EdgeInsets.symmetric(
                                vertical: 10, horizontal: 10),
                            child: Row(
                              children: <Widget>[
                                Text(
                                  fromDate != null
                                      ? "From : ${formatDate(fromDate, [
                                          yyyy,
                                          '/',
                                          mm,
                                          '/',
                                          dd
                                        ])} "
                                      : "From : Select Date",
                                  style: kTitleStyle,
                                ),
                                SizedBox(width: 16),
                                Icon(Icons.calendar_today),
                              ],
                            ),
                          ),
                          onTap: () {
                            showDatePicker(
                              context: context,
                              initialDate:
                                  DateTime(now.year, now.month, now.day - 1),
                              firstDate: DateTime(2020),
                              lastDate: DateTime(now.year, now.month, now.day),
                            ).then((date) {
                              setState(() {
                                fromDate = DateTime(
                                    date.year, date.month, date.day, 9);
                              });
                            });
                          },
                        ),
                        GestureDetector(
                          child: Container(
                            color: Colors.white,
                            padding: EdgeInsets.symmetric(
                                vertical: 10, horizontal: 10),
                            child: Row(
                              children: <Widget>[
                                Text(
                                  uptoDate != null
                                      ? "To : ${formatDate(uptoDate, [
                                          yyyy,
                                          '/',
                                          mm,
                                          '/',
                                          dd
                                        ])} "
                                      : "To : Select Date",
                                  style: kTitleStyle,
                                ),
                                SizedBox(width: 16),
                                Icon(Icons.calendar_today),
                              ],
                            ),
                          ),
                          onTap: () {
                            showDatePicker(
                              context: context,
                              initialDate: DateTime.now(),
                              firstDate: DateTime(2020),
                              lastDate: DateTime.now(),
                            ).then((date) {
                              setState(() {
                                uptoDate = DateTime(
                                    date.year, date.month, date.day, 3);
                              });
                            });
                          },
                        ),
                      ],
                    ),
                    customPeriodLayout(),
                    SizedBox(
                      height: MediaQuery.of(context).size.height * 0.2,
                    )
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class DisplaySales extends StatelessWidget {
  final String title;
  final Map<String, int> value;
  const DisplaySales({
    @required this.title,
    @required this.value,
    Key key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.all(4),
      padding: EdgeInsets.all(10),
      color: Colors.white,
      child: Center(
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Container(
                padding: EdgeInsets.symmetric(
                  horizontal: 10,
                  vertical: 8,
                ),
                child: Text(
                  title,
                  style: kHeaderStyleSmall,
                ),
              ),
              Container(
                padding: EdgeInsets.symmetric(
                  horizontal: 10,
                  vertical: 8,
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    Text(
                      "Pre-Tax Amount : ",
                      style: kSubTitleStyle,
                    ),
                    Text(
                      "₹ ${value["preTaxAmount"]}",
                      style: kHeaderStyleSmall,
                    ),
                  ],
                ),
              ),
//            Container(
//              padding: EdgeInsets.symmetric(
//                horizontal: 16,
//                vertical: 8,
//              ),
//              child: Row(
//                mainAxisAlignment: MainAxisAlignment.center,
//                children: <Widget>[
//                  Text(
//                    "Tax : ",
//                  ),
//                  Text(
//                    "₹ ${value["totalTax"]}",
//                  ),
//                ],
//              ),
//            ),
              Container(
                padding: EdgeInsets.symmetric(
                  horizontal: 10,
                  vertical: 8,
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    Text(
                      "Total Sales: ",
                      style: kSubTitleStyle,
                    ),
                    Text(
                      "₹ ${value["totalAmount"]}",
                      style: kDashBoardLargeStyle,
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
