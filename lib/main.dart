import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:bezier_chart/bezier_chart.dart';
import 'package:shake/shake.dart';
import 'package:flutter_coffee_count/model/caffeineModel.dart';
import 'package:flutter_coffee_count/databases/database_helper.dart';


void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {

  @override
  State<StatefulWidget> createState() {
    return _MyHomePageState();
  }
}

class _MyHomePageState extends State<MyHomePage> {

  @override
  void initState() {
    super.initState();
    ShakeDetector.autoStart(onPhoneShake: () {
      _incrementCounter();
    });
  }

  int _counter = 0;
  final int caffeinePerCoffee = 70;
  int caffeineAmount = 0;

  DatabaseHelper databaseHelper = DatabaseHelper();
  List<CaffeineModel> caffeineValuesList;

  Color green = Colors.lightGreen;
  Color blue = Colors.lightBlueAccent;
  Color red = Colors.red;
  Color orange = Colors.amberAccent;
  Color buttonMinus1 = Colors.lightBlueAccent;
  Color buttonMinus2 = Colors.amberAccent;

  final date1 = DateTime.now();
  final date2 = DateTime.now().subtract(Duration(days: 30));

  int _incrementCounter() {
    setState(() {
      _counter++;
      caffeineAmount += caffeinePerCoffee;
      return _counter;
    });
  }

  int _decrementCounter() {
    setState(() {
      _counter--;
      caffeineAmount -= caffeinePerCoffee;
      return _counter;
    });
  }

  int _resetCounter() {
    setState(() {
      caffeineAmount = 0;
      _counter = 0;
      return _counter;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Container(
          decoration: BoxDecoration(
              gradient: LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: _counter < 6 ? [green, blue] : [red, orange])),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: <Widget>[
              new Container(
                //color: Colors.brown,
                child: Center(
                  child: Column(
                    children: <Widget>[
                      new Container(
                        margin: EdgeInsets.only(bottom: 30),
                        decoration: new BoxDecoration(
                          
                            // color: Colors.white,
                            border: Border.all(
                              color: Colors.white,
                              width: 1,
                            ),
                            borderRadius: new BorderRadius.only(
                                topLeft: const Radius.circular(20.0),
                                topRight: const Radius.circular(20.0),
                                bottomRight: const Radius.circular(20.0),
                                bottomLeft: const Radius.circular(20.0))),
                        child: Padding(
                          padding: const EdgeInsets.all(30.0),
                          
                          child: Text(
                            'Coffee counter',
                            style: new TextStyle(
                              fontSize: 30.0,
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                            ),
                            textAlign: TextAlign.center,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              new Padding(
                padding: const EdgeInsets.only(bottom: 10.0, top: 0),
                child: Text(
                  'Total coffees today:',
                  style: new TextStyle(fontSize: 22.0, color: Colors.white),
                  textAlign: TextAlign.center,
                ),
              ),
              new Text(
                '$_counter',
                style: new TextStyle(fontSize: 60.0, color: Colors.white),
                textAlign: TextAlign.center,
              ),
              new Text(
                'Caffeine amount: ' + '$caffeineAmount' ' mg',
                style: new TextStyle(fontSize: 18.0, color: Colors.white),
                textAlign: TextAlign.center,
              ),
              new Padding(
                padding: EdgeInsets.only(top: 5.0),
                child: Text(
                  'Safe amount per day: 400 mg',
                  style: new TextStyle(
                    fontSize: 15.0,
                    color: Colors.brown,
                  ),
                  textAlign: TextAlign.center,
                ),
              ),
              new Center(
              child: Container(
              color: Colors.transparent,
              height: MediaQuery.of(context).size.height / 6,
              width: MediaQuery.of(context).size.width,
              child: BezierChart(
                fromDate: date2,
                bezierChartScale: BezierChartScale.WEEKLY,
                toDate: date1,
                selectedDate: date1,
                series: [
                  BezierLine(
                    label: _counter > 1 ? "Coffees" : "Coffee",
                    onMissingValue: (dateTime) {
                      if (dateTime.day.isEven) {
                        return 0.0;
                      }
                      return 0.0;
                    },
                    data: [
                      DataPoint<DateTime>(value: _counter.toDouble(), xAxis: date1),
                    ],
                  ),
                ],
                config: BezierChartConfig(
                  verticalIndicatorStrokeWidth: 3.0,
                  verticalIndicatorColor: Colors.black26,
                  showVerticalIndicator: true,
                  verticalIndicatorFixedPosition: false,
                  backgroundColor: Colors.transparent,
                  footerHeight: 50.0,
                ),
              ),
            ),
              ),
              new Padding(
                padding: EdgeInsets.only(top: 30.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    new SizedBox(
                      width: 80.0,
                      height: 80.0,
                      child: FloatingActionButton(
                        onPressed: () => [_incrementCounter()], 
                        tooltip: 'Increment',
                        backgroundColor: Colors.lime[900],
                        child: Icon(Icons.add),
                      ),
                    ),
                    new FlatButton(
                        onPressed: _resetCounter,
                        // color: Colors.lightGreen,
                        child: new Text(
                          'Reset counter',
                          style: TextStyle(color: Colors.white),
                        )),
                    new FloatingActionButton(
                      onPressed: _decrementCounter,
                      child: new Icon(
                        const IconData(0xe15b, fontFamily: 'MaterialIcons'),
                      ),
                      backgroundColor: _counter < 6 ? buttonMinus1 : buttonMinus2,
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
