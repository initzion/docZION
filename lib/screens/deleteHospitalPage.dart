import 'package:fast_turtle_v2/dbHelper/delData.dart';
import 'package:fast_turtle_v2/models/hospitalModel.dart';
import 'package:fast_turtle_v2/screens/showHospitals.dart';
import 'package:flutter/material.dart';

class DeleteHospital extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return DeleteHospitalState();
  }
}

class DeleteHospitalState extends State {
  Hospital hastane = Hospital();
  bool hastaneSecildiMi = false;
  double goruntu = 0.0;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.blueAccent,
      appBar: AppBar(
        title: Text(
          "Hospital Deletion Screen",
          style: TextStyle(fontSize: 25.0, fontWeight: FontWeight.bold),
        ),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: <Widget>[
            Container(
              padding: EdgeInsets.only(top: 40.0, left: 20.0, right: 15.0),
              child: Form(
                child: Column(
                  children: <Widget>[
                    SizedBox(
                      height: 1.0,
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
                        "When you delete a hospital, you will also delete all the departments, doctors and active appointments of that hospital.",
                        style: TextStyle(
                            fontWeight: FontWeight.bold, fontSize: 20.0),
                      ),
                    ),
                    SizedBox(
                      height: 50.0,
                    ),
                    RaisedButton(
                      child: Text("Click to Choose Hospital"),
                      onPressed: () {
                        hospitalNavigator(BuildHospitalList());
                      },
                    ),
                    SizedBox(height: 13.0),
                    Container(
                      child: showSelectedHospital(hastaneSecildiMi),
                    ),
                    SizedBox(
                      height: 30.0,
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

  _silButonu() {
    return RaisedButton(
      child: Text(
        "Delete Selected Hospital",
        textDirection: TextDirection.ltr,
        style: TextStyle(fontSize: 20.0),
      ),
      onPressed: () {
        if (hastaneSecildiMi) {
          alrtHastaneSil(context);
        } else {
          alrtHospital(context, "There is missing data");
        }
      },
    );
  }

  void alrtHastaneSil(BuildContext context) {
    var alrtRandevu = AlertDialog(
      title: Text(
        " Together with the hospital, all departments registered in the hospital, department doctors and doctor appointments will also be deleted. Do you want to continue?",
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
            "Evet",
            textAlign: TextAlign.center,
          ),
          onPressed: () {
            DelService().deleteHospitalById(hastane);
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
