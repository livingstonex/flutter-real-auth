import 'package:flutter/material.dart';
import 'package:realauth/home_page.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'api_service.dart';


void main() => runApp( new MaterialApp(
  debugShowCheckedModeBanner: false,
  home: LoginPage(),
));

String userId;
class Urls {
  static const BASE_API_URL = "https://jsonplaceholder.typicode.com";
}

//============================== LOGIN PAGE ===================================================================================================================

class LoginPage extends StatefulWidget {
  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {

  bool _isLoading = false;
  TextEditingController emailController = new TextEditingController();
  TextEditingController usernameController = new TextEditingController();

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      body: Center(
        child: Form(
          autovalidate: true,
          child: ListView(
            padding: EdgeInsets.only(left: 24.0, right: 24.0),
            shrinkWrap: true,
            children: <Widget>[

              SizedBox(height: 48.0,),
              TextFormField(
                controller: emailController,
                keyboardType: TextInputType.emailAddress,
                validator: (input) => input.isEmpty ? "*Required" : null,
                autovalidate: false,
                autofocus: false,
                decoration: InputDecoration(
                    hintText: "Email",
                    hasFloatingPlaceholder: true,
                    contentPadding: EdgeInsets.fromLTRB(20.0, 16.0, 20.0, 16.0),
                    border: OutlineInputBorder(borderRadius: BorderRadius.circular(32.0))
                ),
              ),
              SizedBox(height: 8.0,),
              TextFormField(
                controller: usernameController,
                autovalidate: false,
                validator: (input) => input.isEmpty ? "*Required" : null,
                autofocus: false,
                obscureText: false,

                decoration: InputDecoration(
                    hintText: 'Username',
                    contentPadding: EdgeInsets.fromLTRB(20.0, 16.0, 20.0, 16.0),
                    border: OutlineInputBorder(borderRadius: BorderRadius.circular(32.0))
                ),
              ),
              SizedBox(height: 24.0,),
              Padding(
                padding: EdgeInsets.symmetric(vertical: 16.0),
                child: Material(
                  color: Colors.lightBlueAccent,
                  elevation: 5.0,
                  borderRadius: BorderRadius.circular(48.0),
                  shadowColor: Colors.lightBlueAccent.shade100,
                  child: MaterialButton(
                    minWidth: 200.0,
                    height: 42.0,
                    onPressed: () async{
                      if((emailController.text != "") && (usernameController.text != "")) {
                        setState(() {
                          _isLoading = true;
                        });

                        final users = await ApiService.getUserList();

                        setState(() {
                          _isLoading = false;
                        });

                        if (users == null) {
                          showDialog(
                              context: context,
                              builder: (context){
                                return AlertDialog(
                                  title: Text("Interrnet Error"),
                                  content: Text("Check yuor Internet Connection"),
                                  actions: <Widget>[
                                    FlatButton(
                                      child: Text("Ok"),
                                      onPressed: (){
                                        Navigator.pop(context);
                                      },
                                    )
                                  ],
                                );
                              }
                          );
                        } else {
                          final user = users.where(
                                  (u) => u['email'] == emailController.text && u['username'] == usernameController.text
                                    ).first;
                          final userWithEmailandPassExists = user != null;
                          if (userWithEmailandPassExists) {
                                 userId = user['id'].toString();

                                 // save email in shared preferences
                                 String clientEmail = user['email'];
                                 final storage = await SharedPreferences.getInstance();
                                 storage.setString('U_email', clientEmail);


                            Navigator.push(context,
                                MaterialPageRoute(
                                    builder: (context) => HomePage()));
                          } else {
                            showDialog(
                                context: context,
                                builder: (context){
                                  return AlertDialog(
                                    title: Text("Incorrect Details"),
                                    content: Text("Either Email or Username is wrong"),
                                    actions: <Widget>[ 
                                      FlatButton(
                                        child: Text("Ok"),
                                        onPressed: (){
                                          Navigator.pop(context);
                                        },
                                      )
                                    ],
                                  );
                                }
                            );

                            setState(() {
                              _isLoading = false;
                            });

                          }
                        }
                      } else{
                        showDialog(
                          context: context,
                          builder: (context){
                            return AlertDialog(
                              title: Text("Error"),
                              content: Text("Enter your Details"),
                              actions: <Widget>[
                                  FlatButton(
                                      child: Text("Ok"),
                                      onPressed: (){
                                        Navigator.pop(context);
                                      },
                                  )
                              ],
                            );
                          }
                        );
                      }
                    },
                    child: Text(_isLoading ? "Login in..." : "Login", style: TextStyle(color: Colors.white),),
                  ),
                ),
              ),
              SizedBox(height: 10.0,),
              FlatButton(
                child: Text("Forgot Password", style: TextStyle(color: Colors.black54,),),
                onPressed: (){
                },
              ),
            ],
          ),
        ),
      ),
    );
  }


}


//=============================================================== REGISTER PAGE ===============================================================================

