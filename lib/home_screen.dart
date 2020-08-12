import 'package:flutter/material.dart';
import 'period.dart';

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  List<Period> _periods = [
    Period(date: DateTime.now()),
    Period(date: DateTime.now()),
    Period(date: DateTime.now())
  ];

  DateTime _datePicked = DateTime.now();

  @override
  Widget build(BuildContext context) {
    InputDecoration textFieldDecoration = InputDecoration(
      filled: true,
      fillColor: Colors.white,
      hintText: '2017-04-10',
      enabledBorder: OutlineInputBorder(
        borderSide: BorderSide(
          color: Colors.red,
        ),
      ),
      border:
          OutlineInputBorder(borderSide: BorderSide(color: Colors.redAccent)),
      suffixIcon: Icon(
        Icons.date_range,
        color: Colors.red,
      ),
    );
    Widget textFieldDatePicker = TextField(
      showCursor: true,
      readOnly: true,
      decoration: textFieldDecoration,
      onTap: () {
        showDatePicker(
                context: context,
                initialDate: DateTime.now(),
                firstDate: DateTime(2020),
                lastDate: DateTime.now())
            .then((date) {
          print("Then");
          setState(() {
            _datePicked = date;
            print(_datePicked);
          });
        });
      },
      controller: TextEditingController()
        ..text = (_datePicked == null
            ? ''
            : _datePicked
                .toString()
                .substring(0, _datePicked.toString().indexOf(' '))),
    );

    Widget periodTemplate(Period period) {
      return Card(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Row(
            children: <Widget>[
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: <Widget>[
                    Text(
                        "Date: ${period.date.toString().substring(0, period.date.toString().indexOf(' '))}"),
                    SizedBox(height: 8.0),
                    Text(
                      "Duration: ${period.duration}",
                      style: TextStyle(
                        color: Colors.grey,
                      ),
                    ),
                  ],
                ),
              ),
              IconButton(
                onPressed: () {},
                icon: Icon(Icons.delete),
                color: Colors.red,
              )
            ],
          ),
        ),
      );
    }

    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          children: <Widget>[
            Padding(
              padding: const EdgeInsets.all(4.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  Expanded(child: textFieldDatePicker),
                  SizedBox(width: 8.0),
                  ButtonTheme(
                    minWidth: 36.0,
                    height: 56.0,
                    child: RaisedButton(
                      child: Icon(
                        Icons.add,
                        color: Colors.white,
                      ),
                      onPressed: () {
                        
                      },
                      color: Colors.red,
                    ),
                  ),
                ],
              ),
            ),
            Column(
              children:
                  _periods.map((period) => periodTemplate(period)).toList(),
            ),
          ],
        ),
      ),
    );
  }
}
