import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:http/http.dart' as http;
import 'dart:convert' as convert;
import 'Model/Currency.dart'; //Import the right-fold and left-fold library of the app
import 'package:intl/intl.dart';
void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
//////////////////////////////////////////////START Code of left fold and right fold app
      localizationsDelegates: [
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      supportedLocales: [
        Locale('fa'), // farsi
      ],
////////////////////////////////////////////END Code of left fold and right fold app

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
      //Remove the debug label in the corner of the app by falsely placing the following piece of code

      home: Home(),
    );
  }
}

////////////////////////////////////////////// START The main part of the app
class Home extends StatefulWidget {
  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  List<Currency> currency = [];//We call the currency model here
//////////////////////////////////////////////START create API & Get API
  Future getApi(BuildContext cntx) async {//Because we use async, we must use the word future and use the word await to receive
    var url = "http://sasansafari.com/flutter/api.php?access_key=flutter123456";
   var value=await http.get(Uri.parse(url));
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
////////////////////////////////////////////////// End process API
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getApi(context);
  }
  @override
  Widget build(BuildContext context) {
    //Using context, we can access the parents of the upper branches
    //getApi(context);
    return Scaffold(
      backgroundColor: Color.fromARGB(255, 243, 243, 243),
      //The color of the main body of our app (except the header) is determined

      ////////////////////////////////////////////////START APP BAR
      appBar: AppBar(
        backgroundColor: Colors.white,
        actions: [
          SizedBox(
            width: 9,
          ),
          //The distance between the right photo and the corner of the app

          Image.asset("assets/images/icon.png"),

          SizedBox(
            width: 9,
          ),
          //The distance between the right image and the opposite text

          Text(
            "قیمت به روز سکه و ارز",
            style: Theme
                .of(context)
                .textTheme
                .headlineLarge,
          ),

          Expanded(
            //With the extended method, the complete images are separated from each other in the direction we give them and each is directed to the left and rightmost corners.
              child: Align(
                  alignment: Alignment.centerLeft,
                  child: Image.asset("assets/images/menu.png"))),

          SizedBox(
            width: 9,
          )
          //The distance between the menu image and the left corner of the app
        ],
      ),
      //Writing the header and upper part of the app
      ///////////////////////////////////////////////END APP BAR

      /////////////////////////////////START BODY APP
      body: Padding(
        padding: const EdgeInsets.all(14.0),
        child: Column(
          children: [
            ///////////////////////////////////START Text and photo at the bottom of the app bar header
            Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Image.asset("assets/images/752675.png"),
                SizedBox(
                  width: 8,
                ),
                Text("نرخ ارز آزاد چیست؟ ",
                    style: Theme
                        .of(context)
                        .textTheme
                        .headlineLarge),
              ],
            ),
            ///////////////////////////////////START Text and photo at the bottom of the app bar header

            /////////////////////////////////////////////////Create an application description section
            SizedBox(
              height: 7,
            ),
            Text(
                " نرخ ارزها در معاملات نقدی و رایج روزانه است معاملات نقدی معاملاتی هستند که خریدار و فروشنده به محض انجام معامله، ارز و ریال را با هم تبادل می نمایند.",
                style: Theme
                    .of(context)
                    .textTheme
                    .bodyMedium),
            /////////////////////////////////////////////////////////////Create an application description section

            SizedBox(
              height: 20,
            ),
            //Giving space between the description and the currency description box

            //////////////////////////////////////////////////START Implementation of the gray color space of currency specifications
            Container(
              width: double.infinity,
              height: 40,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.all(Radius.circular(1000)),
                color: Color.fromARGB(255, 130, 130, 130),
              ),
              //Styling the container box (adding color, rounding the corners, etc.) with decoration
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  Text("نام آزاد ارز",
                      style: Theme
                          .of(context)
                          .textTheme
                          .headlineLarge),
                  Text("قیمت",
                      style: Theme
                          .of(context)
                          .textTheme
                          .headlineLarge),
                  Text("تغییر",
                      style: Theme
                          .of(context)
                          .textTheme
                          .headlineLarge),
                ],
              ),
            ),
            //////////////////////////////////////////////////END Implementation of the gray color space of currency specifications

            ///////////////////////////////////////////////////START List and location of currencies
            Container(
                width: double.infinity,
                height: MediaQuery.of(context).size.height/2,
                child: currency.isEmpty//If the list is empty, it displays a loading icon, otherwise, if the list has a value, it displays the list
                    ? Center(child: CircularProgressIndicator())
                    :
                 ListView.separated(
                  //By using ListView.separated, we have a scrollable list that includes other values such as ads and... between the main values ​​of our list.
                  physics: BouncingScrollPhysics(),
                  //In this section, we define the physics of scrolling the list like the iOS operating system
                  itemCount: currency.length,
                  itemBuilder: (BuildContext context, int position) {
                    //In ListView.separated two values of BuildContext context, int position must be defined
                    //In the first return, the list of wishes is shown, and in the second return, our advertisements
                    return Padding(
                      padding: const EdgeInsets.fromLTRB(0, 9, 0, 0),
                      child: MyItem(position, currency),
                    );
                  },
                  separatorBuilder: (BuildContext context, int index) {
                    if (index % 9 == 0) {
                      //After every 9 main fields, 1 advertisement field is returned
                      return Padding(
                        padding: const EdgeInsets.fromLTRB(0, 9, 0, 0),
                        child: Add(),
                      );
                    } else {
                      //Otherwise, create a distance lighter than the box size
                      return SizedBox.shrink();
                    }
                  },
                )),
            ////////////////////////////////////////////////////////////END List and location of currencies

            //////////////////////////////////////////////////////////////START Create button background area
            SizedBox(
              height: 11,
            ),
            Container(
              width: double.infinity,
              height: MediaQuery.of(context).size.height/15,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(1000),
                color: Colors.white70,
              ),
              //////////////////////////////////////////////////////////////END Create button background area

              //////////////////////////////////////////////////////////////START Button refresh
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  SizedBox(
                    height:  MediaQuery.of(context).size.height/16,
                    child: TextButton.icon(
                        style: ButtonStyle(
                            backgroundColor: MaterialStateProperty.all(
                                Color.fromARGB(255, 205, 193, 255)),
                            shape: MaterialStateProperty.all<
                                RoundedRectangleBorder>(
                                RoundedRectangleBorder(
                                    borderRadius:
                                    BorderRadius.circular(1000)))),
                        //With this anonymous function, if the update button is clicked, the list is cleared and the new values are received from the api again and displayed.
                        onPressed: () {
                          setState(() {
                            currency.clear();
                          });
                          getApi(context);
                        },
                        //We use the snack bar value to get a message after pressing the button
                        icon: Icon(
                          CupertinoIcons.refresh_bold,
                          color: Colors.black,
                        ),
                        label: Padding(
                          padding: const EdgeInsets.fromLTRB(8, 0, 0, 0),
                          child: Text(
                            "بروزرسانی",
                            style: Theme
                                .of(context)
                                .textTheme
                                .headlineLarge,
                          ),
                        )),
                  ),
                  Text(
                    "  آخرین بروزرسانی ${_getTime()} ",
                    style: Theme
                        .of(context)
                        .textTheme
                        .headlineLarge,
                  ),
                  SizedBox(
                    width: 2,
                  ),
                ],
              ),

              //////////////////////////////////////////////////////////////END Button refresh
            )
          ],
        ),
      ),
    );
  }
/////////////////////////////////////////////////////start get and view time update
  String _getTime() {
    DateTime now = DateTime.now();
    return DateFormat('kk:mm:ss').format(now);

  }
}
/////////////////////////////////////////////////////end get and view time update



/////////////////////////////////////////////  END The main part of the app

//////////////////////////////////////////////////////START Create SnackBar
void _ShowSnackBar(BuildContext context, String msg) {
  ScaffoldMessenger.of(context).showSnackBar(SnackBar(
    content: Text(msg),
    backgroundColor: Colors.green,
  ));
}
//////////////////////////////////////////////////////END Create SnackBar

////////////////////////////////////////////// START Making a currency value box
class MyItem extends StatelessWidget {
  //In this space, we determine the details of our currency values such as price, name and change amount
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
            style: Theme
                .of(context)
                .textTheme
                .headlineLarge,
          ),
          Text(
            getPersianNumber(currency[position].price!),
            style: Theme
                .of(context)
                .textTheme
                .headlineLarge,
          ),
          Text(
            getPersianNumber(currency[position].changes!),
            style: TextStyle(
              fontSize: 20,
                fontWeight: FontWeight.w700,
                fontFamily: 'arialbd',
                color: currency[position].status == "n"//If the change value is n or negative, show the text color in red, otherwise show the color in green
                    ? Colors.red
                    : Colors.green),

          ),
        ],
      ),
    );
  }
}
////////////////////////////////////////////// END Making a currency value box

////////////////////////////////////////////// START Making a currency Adds box
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
            style: Theme
                .of(context)
                .textTheme
                .headlineLarge,
          ),
        ],
      ),
    );
  }
}
////////////////////////////////////////////// END Making a currency Adds box

/////////////////////////////////////////////////START replace number en as fa
String getPersianNumber(String number){
  const en = ['0', '1', '2', '3', '4', '5', '6', '7', '8', '9'];
  const fa = ['۰', '۱', '۲', '۳', '۴', '۵', '۶', '۷', '۸', '۹'];
  en.forEach((element){
    number = number.replaceAll(element, fa[en.indexOf(element)]);
  });
return number;
}
/////////////////////////////////////////////////END replace number en as fa

