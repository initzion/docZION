import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fast_turtle_v2/dbHelper/addData.dart';
import 'package:fast_turtle_v2/dbHelper/searchData.dart';
import 'package:fast_turtle_v2/models/adminModel.dart';
import 'package:fast_turtle_v2/models/doktorModel.dart';
import 'package:fast_turtle_v2/models/hospitalModel.dart';
import 'package:fast_turtle_v2/models/sectionModel.dart';
import 'package:fast_turtle_v2/models/userModel.dart';
import 'package:fast_turtle_v2/screens/showAppoTimesForAdmin.dart';
import 'package:fast_turtle_v2/screens/showHospitals.dart';
import 'package:fast_turtle_v2/screens/showSections.dart';
import 'package:flutter/material.dart';

import 'showDoctors.dart';

class OpenAppointment extends StatefulWidget {
  final Admin admin;
  OpenAppointment(this.admin);
  @override
  OpenAppointmentState createState() => OpenAppointmentState(admin);
}

class OpenAppointmentState extends State<OpenAppointment> {
  Admin _admin;
  OpenAppointmentState(this._admin);
  bool hastaneSecildiMi = false;
  bool bolumSecildiMi = false;
  bool doktorSecildiMi = false;
  bool tarihSecildiMi = false;
  bool appointmentControl1;
  bool appointmentControl2;

  double drGoruntu = 0.0;
  double goruntu = 0.0;

  Hospital hastane = Hospital();
  Section section = Section();
  Doktor doktor = Doktor();
  User kullanici = User();

  String textMessage = " ";

  var randevuTarihi;
  var raisedButtonText = "Click and Select";

  var saatTarihBirlesim;

  double goruntuSaat = 0.0;

  @override
  Widget build(BuildContext context) {
    setState(() {
      Firestore.instance
          .collection('tblAdmin')
          .getDocuments()
          .then((QuerySnapshot docs) {
        _admin.reference = docs.documents[0].reference;
      });
    });
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "Open Doctor Appointment",
          style: TextStyle(fontSize: 25.0, fontWeight: FontWeight.bold),
        ),
      ),
      body: Column(
        children: <Widget>[
          Container(
            padding: EdgeInsets.only(top: 20.0, left: 9.0, right: 9.0),
            child: Form(
              child: Column(
                children: <Widget>[
                  RaisedButton(
                    child: Text("Click to Choose Hospital"),
                    onPressed: () {
                      bolumSecildiMi = false;
                      doktorSecildiMi = false;
                      tarihSecildiMi = false;
                      hospitalNavigator(BuildHospitalList());
                    },
                  ),
                  SizedBox(height: 13.0),
                  showSelectedHospital(hastaneSecildiMi),
                  SizedBox(
                    height: 30.0,
                  ),
                  RaisedButton(
                    child: Text("Click to Choose Section"),
                    onPressed: () {
                      if (hastaneSecildiMi) {
                        doktorSecildiMi = false;
                        drGoruntu = 0.0;
                        tarihSecildiMi = false;
                        sectionNavigator(BuildSectionList(hastane));
                      } else {
                        alrtHospital(
                            context, "You cannot choose a department without choosing a hospital");
                      }
                    },
                  ),
                  SizedBox(
                    height: 16.0,
                  ),
                  _showSelectedSection(bolumSecildiMi),
                  SizedBox(
                    height: 30.0,
                  ),
                  RaisedButton(
                    child: Text("Click to Choose a Doctor"),
                    onPressed: () {
                      if (hastaneSecildiMi && bolumSecildiMi) {
                        doctorNavigator(BuildDoctorList(section, hastane));
                      } else {
                        alrtHospital(context,
                            "You cannot choose a doctor without choosing a hospital or department");
                      }
                    },
                  ),
                  SizedBox(
                    height: 16.0,
                  ),
                  showSelectedDoctor(doktorSecildiMi),
                  SizedBox(
                    height: 25.0,
                  ),
                  dateOfAppointment(),
                  SizedBox(
                    height: 16.0,
                  ),
                  RaisedButton(
                    child: Text("Click to Select Trading Time"),
                    onPressed: () {
                      if (randevuTarihi != null &&
                          hastaneSecildiMi &&
                          bolumSecildiMi &&
                          doktorSecildiMi) {
                        basicNavigator(AppointmentTimesForAdmin(
                            randevuTarihi.toString(), doktor, _admin));
                        tarihSecildiMi = true;
                      } else {
                        alrtHospital(context,
                            "Time selection cannot be made until the above selections are completed.");
                      }
                    },
                  ),
                  SizedBox(
                    height: 16.0,
                  ),
                  showSelectedDate(tarihSecildiMi),
                  SizedBox(
                    height: 16.0,
                  ),
                  _buildDoneButton()
                ],
              ),
            ),
          )
        ],
      ),
    );
  }

  void hospitalNavigator(dynamic page) async {
    hastane = await Navigator.push(
        context, MaterialPageRoute(builder: (context) => page));

    if (hastane == null) {
      hastaneSecildiMi = false;
    } else {
      hastaneSecildiMi = true;
    }
  }

  showSelectedHospital(bool secildiMi) {
    String textMessage = " ";
    if (secildiMi) {
      setState(() {
        textMessage = this.hastane.hastaneAdi.toString();
      });
      goruntu = 1.0;
    } else {
      goruntu = 0.0;
    }

    return Container(
        decoration: BoxDecoration(),
        child: Row(
          children: <Widget>[
            Text(
              "Selected Hospital : ",
              style: TextStyle(fontSize: 16.0, fontWeight: FontWeight.bold),
            ),
            Opacity(
                opacity: goruntu,
                child: Container(
                  alignment: Alignment.center,
                  child: Text(
                    textMessage,
                    style:
                        TextStyle(fontSize: 16.0, fontWeight: FontWeight.bold),
                  ),
                ))
          ],
        ));
  }

  void alrtHospital(BuildContext context, String message) {
    var alertDoctor = AlertDialog(
      title: Text(
        "Warning!",
        style: TextStyle(fontWeight: FontWeight.bold),
      ),
      content: Text(message),
    );

    showDialog(
        context: context,
        builder: (BuildContext context) {
          return alertDoctor;
        });
  }

  void sectionNavigator(dynamic page) async {
    section = await Navigator.push(
        context, MaterialPageRoute(builder: (context) => page));

    if (section == null) {
      bolumSecildiMi = false;
    } else {
      bolumSecildiMi = true;
    }
  }

  _showSelectedSection(bool secildiMi) {
    double goruntu = 0.0;

    if (secildiMi) {
      setState(() {
        textMessage = this.section.bolumAdi.toString();
      });
      goruntu = 1.0;
    } else {
      goruntu = 0.0;
    }

    return Container(
        decoration: BoxDecoration(),
        child: Row(
          children: <Widget>[
            Text(
              "Selected Section : ",
              style: TextStyle(fontSize: 16.0, fontWeight: FontWeight.bold),
            ),
            Opacity(
                opacity: goruntu,
                child: Container(
                    alignment: Alignment.center,
                    child: _buildTextMessage(textMessage)))
          ],
        ));
  }

  _buildTextMessage(String gelenText) {
    return Text(
      textMessage,
      style: TextStyle(fontSize: 16.0, fontWeight: FontWeight.bold),
    );
  }

  void doctorNavigator(dynamic page) async {
    doktor = await Navigator.push(
        context, MaterialPageRoute(builder: (context) => page));

    if (doktor == null) {
      doktorSecildiMi = false;
    } else {
      doktorSecildiMi = true;
    }
  }

  showSelectedDoctor(bool secildiMih) {
    String textMessage = " ";
    if (secildiMih) {
      setState(() {
        textMessage = this.doktor.adi.toString() + " " + this.doktor.soyadi;
      });
      drGoruntu = 1.0;
    } else {
      drGoruntu = 0.0;
    }

    return Container(
        decoration: BoxDecoration(),
        child: Row(
          children: <Widget>[
            Text(
              "Selected Doctor : ",
              style: TextStyle(fontSize: 16.0, fontWeight: FontWeight.bold),
            ),
            Opacity(
                opacity: goruntu,
                child: Container(
                  alignment: Alignment.center,
                  child: Text(
                    textMessage,
                    style:
                        TextStyle(fontSize: 16.0, fontWeight: FontWeight.bold),
                  ),
                ))
          ],
        ));
  }

  Future<Null> _selectDate(BuildContext context) async {
    final DateTime picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now().add(Duration(days: 1)),
      firstDate: DateTime.now(),
      lastDate: DateTime(2021),
    );
    randevuTarihi = picked;
    saatTarihBirlesim = null;
    tarihSecildiMi = false;
  }

  Widget dateOfAppointment() {
    return Container(
      padding: EdgeInsets.only(top: 5.0),
      child: Row(
        children: <Widget>[
          Text(
            "Transaction date: ",
            style: TextStyle(fontSize: 19.0),
          ),
          RaisedButton(
            child: Text(raisedButtonText),
            onPressed: () {
              _selectDate(context).then((result) => setState(() {
                    if (randevuTarihi == null) {
                      raisedButtonText = "Click and Select";
                      tarihSecildiMi = false;
                    } else {
                      raisedButtonText =
                          randevuTarihi.toString().substring(0, 10);
                    }
                  }));
            },
          )
        ],
      ),
    );
  }

  showSelectedDate(bool tarihSecildiMi) {
    String textMessage = " ";
    if (tarihSecildiMi) {
      setState(() {
        textMessage = saatTarihBirlesim.toString();
      });
      goruntuSaat = 1.0;
    } else {
      goruntuSaat = 0.0;
    }

    return Container(
        decoration: BoxDecoration(),
        child: Row(
          children: <Widget>[
            Text(
              "Transaction Date and Time : ",
              style: TextStyle(fontSize: 16.0, fontWeight: FontWeight.bold),
            ),
            Opacity(
                opacity: goruntuSaat,
                child: Container(
                  alignment: Alignment.center,
                  child: Text(
                    textMessage,
                    style:
                        TextStyle(fontSize: 16.0, fontWeight: FontWeight.bold),
                  ),
                ))
          ],
        ));
  }

  void basicNavigator(dynamic page) async {
    saatTarihBirlesim = await Navigator.push(
        context, MaterialPageRoute(builder: (context) => page));
  }

  void alrtAppointment(BuildContext context) {
    var alertAppointment = AlertDialog(
        contentPadding: const EdgeInsets.fromLTRB(5.0, 50.0, 5.0, 50.0),
        title: Text(
          "Transaction Summary",
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        content: Container(
          padding: EdgeInsets.only(bottom: 50.0),
          child: Column(
            children: <Widget>[
              showSelectedHospital(hastaneSecildiMi),
              _showSelectedSection(bolumSecildiMi),
              showSelectedDoctor(doktorSecildiMi),
              showSelectedDate(tarihSecildiMi),
              SizedBox(
                height: 13.0,
              ),
              Container(
                child: FlatButton(
                  child: Text(
                    "OK",
                    style:
                        TextStyle(fontSize: 20.0, fontWeight: FontWeight.bold),
                  ),
                  onPressed: () {
                    Navigator.pop(context);
                    Navigator.pop(context, true);
                    AddService().addDoctorAppointment(doktor);
                    AddService().closeDoctorAppointment(_admin);
                  },
                ),
              ),
            ],
          ),
        ));

    showDialog(
        context: context,
        builder: (BuildContext context) {
          return alertAppointment;
        });
  }

  _buildDoneButton() {
    return Container(
      child: RaisedButton(
        child: Text("Complete"),
        onPressed: () {
          if (hastaneSecildiMi &&
              bolumSecildiMi &&
              doktorSecildiMi &&
              tarihSecildiMi &&
              saatTarihBirlesim != null) {
            SearchService()
                .searchDoctorById(doktor.kimlikNo)
                .then((QuerySnapshot docs) {
              Doktor temp = Doktor.fromMap(docs.documents[0].data);
              if (temp.randevular.contains(saatTarihBirlesim)) {
                doktor.randevular.remove(saatTarihBirlesim);
                _admin.kapatilanSaatler.remove(saatTarihBirlesim);
                alrtAppointment(context);
              } else {
                alrtHospital(context, "This session is full");
              }
            });
          } else {
            alrtHospital(context, "There is missing information");
          }
        },
      ),
    );
  }
}
