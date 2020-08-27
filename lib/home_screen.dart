import 'package:flutter/material.dart';
import 'period.dart';
import 'period_card.dart';
import 'database_helpers.dart';

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  List<Period> _periods = [];
  bool dataFetched = false;
  DateTime _datePicked = DateTime.now();

  @override
  Widget build(BuildContext context) {
    if (dataFetched == false) {
      _read();
      dataFetched = true;
    }

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
                        setState(() {
                          print("HAMZA");
                          Period period = Period(_datePicked);
                          _periods.insert(0, period);
                          updateAfterAddition();
                          _save(period);
                        });
                      },
                      color: Colors.red,
                    ),
                  ),
                ],
              ),
            ),
            Column(
              children: _periods
                  .map((period) => PeriodCard(
                        period: period,
                        delete: () {
                          setState(() {
                            updateAfterDeletion(_periods.indexOf(period));
                            _delete(period);
                          });
                        },
                      ))
                  .toList(),
            ),
          ],
        ),
      ),
    );
  }

  void updateAfterAddition() {
    if (hasMoreThanOneItem()) {
      _updatePeriod(1);
    }
  }

  bool isFirstIndex(int periodIndex) {
    return (periodIndex == 0);
  }

  bool isLastIndex(int periodIndex) {
    return (periodIndex == (_periods.length));
  }

  bool hasMoreThanOneItem() {
    return (_periods.length > 1);
  }

  void updateAfterDeletion(int periodIndex) {
    _periods.remove(_periods.remove(_periods[periodIndex]));
    print(isFirstIndex(periodIndex));
    print(periodIndex);
    if (isFirstIndex(periodIndex)) {
      if (_periods.isNotEmpty) {
        _periods[0].duration = null;
        _updateDatabaseRow(_periods[0]);
        if (hasMoreThanOneItem()) {
          _updatePeriod(1);
        }
      }
    } else if (isLastIndex(periodIndex)) {
      print("Nothing to update");
    } else {
      _updatePeriod(periodIndex);
    }
  }

  _updatePeriod(int periodIndex) {
    _periods[periodIndex].calculateDuration(_periods[periodIndex - 1]);
    _updateDatabaseRow(_periods[periodIndex]);
  }

  _save(Period period) async {
    DatabaseHelper helper = DatabaseHelper.instance;
    int id = await helper.insert(period);
    period.id = id;
    print("Inserted Period ID: $id");
  }

  _read() async {
    DatabaseHelper helper = DatabaseHelper.instance;
    List<Period> periods = await helper.queryPeriods();
    if (periods.length == 0) {
      print('Empty');
    } else {
      setState(() {
        periods.forEach((period) {
          _periods.insert(0, period);
          print("Period Date:" + period.date.toString());
        });
      });
      print('All Periods added: ');
    }
    return true;
  }

  _delete(Period period) async {
    DatabaseHelper helper = DatabaseHelper.instance;
    int id = await helper.delete(period.id);
    print("Deleted Period ID: $id");
  }

  _updateDatabaseRow(Period period) async {
    DatabaseHelper helper = DatabaseHelper.instance;
    int id = await helper.update(period);
    print("Updated Period ID: $id");
  }
}
