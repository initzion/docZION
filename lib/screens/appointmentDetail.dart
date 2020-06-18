import 'package:flutter/material.dart';

class AppointmentDetail extends StatefulWidget {
  @override
  _AppointmentDetailState createState() => _AppointmentDetailState();
}

class _AppointmentDetailState extends State<AppointmentDetail> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Appointment Detail"),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: <Widget>[
            // this page for future plan
          ],
        ),
      ),
    );
  }


}
