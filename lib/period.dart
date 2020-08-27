import 'package:flutter/material.dart';
import 'package:age/age.dart';

// database table and column names
final String table = 'period';
final String columnId = '_id';
final String columnDate = 'date';
final String columnDuration = 'duration';

class Period {
  int id;
  DateTime date;
  int duration;

  Period(DateTime date){
    this.date = date;
  }

  set periodId(int id) => this.id = id;
  int get periodId => this.id;

  void calculateDuration(Period p2) {
    DateTime tempDate = DateTime(date.year, p2.date.month, p2.date.day);
    DateTime nextBirthdayDate = tempDate.isBefore(date)
        ? Age.add(date: tempDate, duration: AgeDuration(years: 1))
        : tempDate;
    AgeDuration nextBirthdayDuration =
    Age.dateDifference(fromDate: date, toDate: nextBirthdayDate);

    duration = (nextBirthdayDuration.years * 360) + (nextBirthdayDuration.months * 30) + (nextBirthdayDuration.days);
  }

  Period.fromMap(Map<String, dynamic> map) {
    id = map[columnId];
    date = stringToDate(map[columnDate]);
    duration = map[columnDuration];
  }

  // convenience method to create a Map from this Word object
  Map<String, dynamic> toMap() {
    var map = <String, dynamic>{
      columnDate: dateToString(date),
      columnDuration: duration
    };
    if (id != null) {
      map[columnId] = id;
    }
    return map;
  }

  static String dateToString(DateTime date) {
    return date
        .toString()
        .substring(0, date.toString().indexOf(' '));
  }

  static DateTime stringToDate(String dateText) {
    //2020-15-30
    int year = int.parse(dateText.substring(0, dateText.indexOf('-')));
    int month = int.parse(dateText.substring(5, 7));
    int day = int.parse(dateText.substring(8, 10));
    return DateTime(year, month, day);
  }
}