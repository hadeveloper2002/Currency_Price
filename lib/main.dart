import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:http/http.dart' as http;
import 'dart:convert' as convert;
import 'Model/Currency.dart';
import 'package:intl/intl.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      localizationsDelegates: [
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      supportedLocales: [
        Locale('fa'),
      ],
      theme: ThemeData(
          fontFamily: 'arial',
          textTheme: TextTheme(
            headlineLarge: TextStyle(
              fontFamily: 'arialbd',
              fontSize: 20,
              fontWeight: FontWeight.w700,
            ),
            bodyMedium: TextStyle(
              fontFamily: 'arial',
              fontSize: 16,
              fontWeight: FontWeight.w300,
            ),
          )),
      debugShowCheckedModeBanner: false,
      home: Home(),
    );
  }
}

class Home extends StatefulWidget {
  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  List<Currency> currency = [];

  Future getApi(BuildContext cntx) async {
    var url = "http://sasansafari.com/flutter/api.php?access_key=flutter123456";
    var value = await http.get(Uri.parse(url));
    if (currency.isEmpty) {
      if (value.statusCode == 200) {
        _ShowSnackBar(context, "دیتا ها با موفقیت لود شدند");
        List jsonList = convert.jsonDecode(value.body);
        if (jsonList.length > 0) {
          for (int i = 0; i < jsonList.length; i++) {
            setState(() {
              currency.add(Currency(
                id: jsonList[i]["id"],
                title: jsonList[i]["title"],
                price: jsonList[i]["price"],
                changes: jsonList[i]["changes"],
                status: jsonList[i]["status"],
              ));
            });
          }
        }
      }
    }
  }

  @override
  void initState() {
    super.initState();
    getApi(context);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color.fromARGB(255, 243, 243, 243),
      appBar: AppBar(
        backgroundColor: Colors.white,
        actions: [
          SizedBox(width: 9),
          Image.asset("assets/images/icon.png"),
          SizedBox(width: 9),
          Text(
            "قیمت به روز سکه و ارز",
            style: Theme.of(context).textTheme.headlineLarge,
          ),
          Expanded(
              child: Align(
                  alignment: Alignment.centerLeft,
                  child: Image.asset("assets/images/menu.png"))),
          SizedBox(width: 9),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(14.0),
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Image.asset("assets/images/752675.png"),
                SizedBox(width: 8),
                Text("نرخ ارز آزاد چیست؟ ",
                    style: Theme.of(context).textTheme.headlineLarge),
              ],
            ),
            SizedBox(height: 7),
            Text(
                " نرخ ارزها در معاملات نقدی و رایج روزانه است معاملات نقدی معاملاتی هستند که خریدار و فروشنده به محض انجام معامله، ارز و ریال را با هم تبادل می نمایند.",
                style: Theme.of(context).textTheme.bodyMedium),
            SizedBox(height: 20),
            Container(
              width: double.infinity,
              height: 40,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.all(Radius.circular(1000)),
                color: Color.fromARGB(255, 130, 130, 130),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  Text("نام آزاد ارز",
                      style: Theme.of(context).textTheme.headlineLarge),
                  Text("قیمت",
                      style: Theme.of(context).textTheme.headlineLarge),
                  Text("تغییر",
                      style: Theme.of(context).textTheme.headlineLarge),
                ],
              ),
            ),
            Container(
                width: double.infinity,
                height: MediaQuery.of(context).size.height / 2,
                child: currency.isEmpty
                    ? Center(child: CircularProgressIndicator())
                    : ListView.separated(
                        physics: BouncingScrollPhysics(),
                        itemCount: currency.length,
                        itemBuilder: (BuildContext context, int position) {
                          return Padding(
                            padding: const EdgeInsets.fromLTRB(0, 9, 0, 0),
                            child: MyItem(position, currency),
                          );
                        },
                        separatorBuilder: (BuildContext context, int index) {
                          if (index % 9 == 0) {
                            return Padding(
                              padding: const EdgeInsets.fromLTRB(0, 9, 0, 0),
                              child: Add(),
                            );
                          } else {
                            return SizedBox.shrink();
                          }
                        },
                      )),
            SizedBox(height: 11),
            Container(
              width: double.infinity,
              height: MediaQuery.of(context).size.height / 15,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(1000),
                color: Colors.white70,
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  SizedBox(
                    height: MediaQuery.of(context).size.height / 16,
                    child: TextButton.icon(
                        style: ButtonStyle(
                            backgroundColor: MaterialStateProperty.all(
                                Color.fromARGB(255, 205, 193, 255)),
                            shape: MaterialStateProperty.all<
                                    RoundedRectangleBorder>(
                                RoundedRectangleBorder(
                                    borderRadius:
                                        BorderRadius.circular(1000)))),
                        onPressed: () {
                          setState(() {
                            currency.clear();
                          });
                          getApi(context);
                        },
                        icon: Icon(
                          CupertinoIcons.refresh_bold,
                          color: Colors.black,
                        ),
                        label: Padding(
                          padding: const EdgeInsets.fromLTRB(8, 0, 0, 0),
                          child: Text(
                            "بروزرسانی",
                            style: Theme.of(context).textTheme.headlineLarge,
                          ),
                        )),
                  ),
                  Text(
                    "  آخرین بروزرسانی ${_getTime()} ",
                    style: Theme.of(context).textTheme.headlineLarge,
                  ),
                  SizedBox(width: 2),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }

  String _getTime() {
    DateTime now = DateTime.now();
    return DateFormat('kk:mm:ss').format(now);
  }
}

void _ShowSnackBar(BuildContext context, String msg) {
  ScaffoldMessenger.of(context).showSnackBar(SnackBar(
    content: Text(msg),
    backgroundColor: Colors.green,
  ));
}

class MyItem extends StatelessWidget {
  int position;
  List<Currency> currency;

  MyItem(this.position, this.currency);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      height: 60,
      decoration: BoxDecoration(boxShadow: <BoxShadow>[
        BoxShadow(blurRadius: 1.0, color: Colors.grey)
      ], color: Colors.white, borderRadius: BorderRadius.circular(1000)),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          Text(
            currency[position].title!,
            style: Theme.of(context).textTheme.headlineLarge,
          ),
          Text(
            getPersianNumber(currency[position].price!),
            style: Theme.of(context).textTheme.headlineLarge,
          ),
          Text(
            getPersianNumber(currency[position].changes!),
            style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.w700,
                fontFamily: 'arialbd',
                color: currency[position].status == "n"
                    ? Colors.red
                    : Colors.green),
          ),
        ],
      ),
    );
  }
}

class Add extends StatelessWidget {
  const Add({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      height: 60,
      decoration: BoxDecoration(boxShadow: <BoxShadow>[
        BoxShadow(blurRadius: 1.0, color: Colors.grey)
      ], color: Colors.blue, borderRadius: BorderRadius.circular(1000)),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          Text(
            "Adds",
            style: Theme.of(context).textTheme.headlineLarge,
          ),
        ],
      ),
    );
  }
}

String getPersianNumber(String number) {
  const en = ['0', '1', '2', '3', '4', '5', '6', '7', '8', '9'];
  const fa = ['۰', '۱', '۲', '۳', '۴', '۵', '۶', '۷', '۸', '۹'];
  en.forEach((element) {
    number = number.replaceAll(element, fa[en.indexOf(element)]);
  });
  return number;
}
