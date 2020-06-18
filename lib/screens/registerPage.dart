import 'package:fast_turtle_v2/dbHelper/addData.dart';
import 'package:fast_turtle_v2/models/userModel.dart';
import 'package:flutter/material.dart';
import 'package:fast_turtle_v2/mixins/validation_mixin.dart';

class RegisterPage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return RegisterPageState();
  }
}

class RegisterPageState extends State with ValidationMixin {
  final registerFormKey = GlobalKey<FormState>();
  final user = User();

  var genders = ["Female", "Male"];
  String selectedGenders = "Female";
  var dogumTarihi;
  var raisedButtonText = "Female ve Male";

  Future<Null> _selectDate(BuildContext context) async {
    final DateTime picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(1920),
      lastDate: DateTime.now(),
    );
    dogumTarihi = picked;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text("New Member Registration"),
        ),
        body: SingleChildScrollView(
          child: Container(
              padding: EdgeInsets.only(top: 30.0, left: 10.0, right: 10.0),
              child: Form(
                key: registerFormKey,
                child: Column(
                  children: <Widget>[
                    kimlikNoField(),
                    sifreField(),
                    firstNameField(),
                    lastNameField(),
                    placeofBirthField(),
                    genderChoose(),
                    dateOfBirth(),
                    submitButton()
                  ],
                ),
              )),
        ));
  }

  static void alrtDone(BuildContext context) {
    var alertDialog = AlertDialog(
      title: Text("Registration Successful"),
      content: Text("You can login"),
    );

    showDialog(
        context: context,
        builder: (BuildContext context) {
          return alertDialog;
        });
  }

  static void alrtFail(BuildContext context) {
    var alertDialog = AlertDialog(
      title: Text("Login Failed"),
      content: Text("You entered incorrect or missing information"),
    );

    showDialog(
        context: context,
        builder: (BuildContext context) {
          return alertDialog;
        });
  }

  void basicPop(BuildContext context, bool result) {
    Navigator.pop(context, result);
  }

  Widget kimlikNoField() {
    return TextFormField(
      decoration: InputDecoration(labelText: "T. C. Identification number:"),
      validator: validateTCNo,
      onSaved: (String value) {
        user.kimlikNo = value;
      },
    );
  }

  Widget sifreField() {
    return TextFormField(
      decoration: InputDecoration(labelText: "Password:"),
      onSaved: (String value) {
        user.sifre = value;
      },
    );
  }

  Widget firstNameField() {
    return TextFormField(
      decoration: InputDecoration(labelText: "Ad"),
      validator: validateFirstName,
      onSaved: (String value) {
        user.adi = value;
      },
    );
  }

  Widget lastNameField() {
    return TextFormField(
      decoration: InputDecoration(labelText: "Surname"),
      validator: validateLastName,
      onSaved: (String value) {
        user.soyadi = value;
      },
    );
  }

  Widget placeofBirthField() {
    return TextFormField(
      decoration: InputDecoration(labelText: "Place of Birth"),
      onSaved: (String value) {
        user.dogumYeri = value;
      },
    );
  }

  Widget genderChoose() {
    return Container(
        padding: EdgeInsets.only(top: 13.0),
        child: Row(
          children: <Widget>[
            Container(
              padding: EdgeInsets.only(right: 25.0),
              child: Text(
                "Gender: ",
                style: TextStyle(fontSize: 19.0),
              ),
            ),
            DropdownButton<String>(
              items: genders.map((String cinsiyetler) {
                return DropdownMenuItem<String>(
                  value: cinsiyetler,
                  child: Text(cinsiyetler),
                );
              }).toList(),
              value: selectedGenders,
              onChanged: (String tiklanan) {
                setState(() {
                  if (tiklanan == null) {
                    this.selectedGenders = "Woman";
                  } else {
                    this.selectedGenders = tiklanan;
                  }
                  user.cinsiyet = selectedGenders;
                });
              },
            ),
          ],
        ));
  }

  Widget dateOfBirth() {
    return Container(
      padding: EdgeInsets.only(top: 5.0),
      child: Row(
        children: <Widget>[
          Text(
            "Date of Birth: ",
            style: TextStyle(fontSize: 19.0),
          ),
          RaisedButton(
            child: Text(raisedButtonText),
            onPressed: () {
              _selectDate(context).then((result) => setState(() {
                    raisedButtonText = dogumTarihi.toString().substring(0, 10);
                    user.dogumTarihi = dogumTarihi.toString().substring(0, 10);
                  }));
            },
          )
        ],
      ),
    );
  }

  Widget submitButton() {
    return Container(
      padding: EdgeInsets.only(top: 45.0),
      child: RaisedButton(
        child: Text(
          "Complete",
          textDirection: TextDirection.ltr,
          style: TextStyle(fontSize: 20.0),
        ),
        onPressed: () {
          if (registerFormKey.currentState.validate()) {
            registerFormKey.currentState.save();
            basicPop(context, true);
            AddService().saveUser(user);
          }
          //  else {
          //   alrtFail(context);
          // }
        },
      ),
    );
  }
}
