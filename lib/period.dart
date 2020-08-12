import 'package:flutter/material.dart';
import 'package:age/age.dart';

class Period {
  DateTime date;
  int duration;

  Period({this.date});

  void calculateDuration(Period p2) {
    DateTime tempDate = DateTime(date.year, p2.date.month, p2.date.day);
    DateTime nextBirthdayDate = tempDate.isBefore(date)
        ? Age.add(date: tempDate, duration: AgeDuration(years: 1))
        : tempDate;
    AgeDuration nextBirthdayDuration =
    Age.dateDifference(fromDate: date, toDate: nextBirthdayDate);

    duration = (nextBirthdayDuration.years * 360) + (nextBirthdayDuration.months * 30) + (nextBirthdayDuration.days);
  }
}