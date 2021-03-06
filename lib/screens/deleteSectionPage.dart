import 'package:fast_turtle_v2/dbHelper/delData.dart';
import 'package:fast_turtle_v2/models/hospitalModel.dart';
import 'package:fast_turtle_v2/models/sectionModel.dart';
import 'package:fast_turtle_v2/screens/showHospitals.dart';
import 'package:fast_turtle_v2/screens/showSections.dart';
import 'package:flutter/material.dart';

class DeleteSection extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return DeleteSectionState();
  }
}

class DeleteSectionState extends State {
  Hospital hastane = Hospital();
  Section section = Section();
  bool hastaneSecildiMi = false;
  bool bolumSecildiMi = false;
  String textMessage = " ";
  double goruntu = 0.0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.blueAccent,
      appBar: AppBar(
        title: Text(
          "Section Deletion Screen",
          style: TextStyle(fontSize: 25.0, fontWeight: FontWeight.bold),
        ),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: <Widget>[
            Container(
              padding: EdgeInsets.only(top: 40.0, left: 20.0, right: 20.0),
              child: Form(
                child: Column(
                  children: <Widget>[
                    SizedBox(
                      height: 10.0,
                    ),
                    Container(
                      child: Text(
                        "WARNING!",
                        style: TextStyle(
                            fontSize: 50.0,
                            fontWeight: FontWeight.bold,
                            color: Colors.redAccent),
                      ),
                    ),
                    Container(
                      child: Text(
                        "When you delete a department, you will also delete the doctors working in that department and the appointments of those doctors.",
                        style: TextStyle(
                            fontWeight: FontWeight.bold, fontSize: 20.0),
                      ),
                    ),
                    SizedBox(
                      height: 13.0,
                    ),
                    RaisedButton(
                      child: Text("Click to Choose Hospital"),
                      onPressed: () {
                        bolumSecildiMi = false;
                        hospitalNavigator(BuildHospitalList());
                      },
                    ),
                    SizedBox(
                      height: 16.0,
                    ),
                    showSelectedHospital(hastaneSecildiMi),
                    SizedBox(
                      height: 16.0,
                    ),
                    RaisedButton(
                      child: Text("Click to Choose Section"),
                      onPressed: () {
                        if (hastaneSecildiMi) {
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
                      height: 16.0,
                    ),
                    _silButonu()
                  ],
                ),
              ),
            )
          ],
        ),
      ),
    );
  }

  void alrtHospital(BuildContext context, String message) {
    var alertDoctor = AlertDialog(
      title: Text("Warning!"),
      content: Text(message),
    );

    showDialog(
        context: context,
        builder: (BuildContext context) {
          return alertDoctor;
        });
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

  void sectionNavigator(dynamic page) async {
    section = await Navigator.push(
        context, MaterialPageRoute(builder: (context) => page));

    if (section == null) {
      bolumSecildiMi = false;
    } else {
      bolumSecildiMi = true;
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
              "Selected Hospital: ",
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
              "Selected Section: ",
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

  _silButonu() {
    return RaisedButton(
      child: Text(
        "Delete Selected Section",
        textDirection: TextDirection.ltr,
        style: TextStyle(fontSize: 20.0),
      ),
      onPressed: () {
        if (hastaneSecildiMi && bolumSecildiMi) {
          alrtBolumSil(context);
        } else {
          alrtHospital(context, "There is missing information");
        }
      },
    );
  }

  void alrtBolumSil(BuildContext context) {
    var alrtRandevu = AlertDialog(
      title: Text(
        "Along with the department, all doctors and appointments registered in the department will also be deleted. Do you want to continue?",
        style: TextStyle(fontSize: 20.0, fontWeight: FontWeight.bold),
      ),
      actions: <Widget>[
        FlatButton(
          child: Text("No"),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        SizedBox(
          width: 5.0,
        ),
        FlatButton(
          child: Text(
            "Yeah",
            textAlign: TextAlign.center,
          ),
          onPressed: () {
            DelService().deleteSectionBySectionId(section, section.reference);
            Navigator.pop(context);
            Navigator.pop(context, true);
          },
        )
      ],
    );

    showDialog(
        context: context,
        builder: (BuildContext context) {
          return alrtRandevu;
        });
  }
}
