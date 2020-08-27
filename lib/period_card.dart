import 'package:flutter/material.dart';
import 'period.dart';

class PeriodCard extends StatefulWidget {
  final Period period;
  final Function delete;

  PeriodCard({this.period, this.delete});

  @override
  _PeriodCardState createState() => _PeriodCardState();
}

class _PeriodCardState extends State<PeriodCard> {
  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Row(
          children: <Widget>[
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: <Widget>[
                  Row(
                    children: <Widget>[
                      Text("Date: "),
                      Text(
                        Period.dateToString(widget.period.date),
                        style: TextStyle(
                          color: Colors.grey,
                        ),
                      )
                    ],
                  ),
                  SizedBox(height: 8.0),
                  Row(
                    children: <Widget>[
                      Text("Duration: "),
                      Text(
                        formatDuration(widget.period.duration),
                        style: TextStyle(
                          color: Colors.grey,
                        ),
                      )
                    ],
                  ),
                ],
              ),
            ),
            IconButton(
              onPressed: widget.delete,
              icon: Icon(Icons.delete),
              color: Colors.red,
            )
          ],
        ),
      ),
    );
  }



  String formatDuration(int duration) {
    return (duration == null ? "Waiting for next period" : "$duration");
  }
}
