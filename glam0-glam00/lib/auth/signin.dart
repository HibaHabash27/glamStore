import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:glam0/blocks/auth_block.dart';
import 'package:glam0/models/user.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SignIn extends StatefulWidget {
  @override
  _SignInState createState() => _SignInState();
}


class _SignInState extends State<SignIn> {
  final _formKey = GlobalKey<FormState>();
  final UserCredential userCredential = UserCredential(email: '', password: '');


  @override
  Widget build(BuildContext context) {
    return Center(
        child: Form(
          key: _formKey,
          child: SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.only(left: 15.0, right: 15.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Padding(
                    padding: const EdgeInsets.only(bottom: 12.0),
                    child: TextFormField(
                      keyboardType: TextInputType.emailAddress,
                      validator: (value) {
                        if (value!.isEmpty) {
                          return 'Please Enter Email or Username';
                        }
                        return null;
                      },
                      onSaved: (value) {
                        setState(() {
                          userCredential.email = value!;
                        });
                      },
                      decoration: InputDecoration(
                        hintText: 'Enter Username Or Email',
                        labelText: 'Email',
                      ),
                    ),
                  ),
                  TextFormField(
                    validator: (value) {
                      if (value!.isEmpty) {
                        return 'Please Enter Password';
                      }
                      return null;
                    },
                    onSaved: (value) {
                      setState(() {
                        userCredential.password = value!;
                      });
                    },
                    decoration: InputDecoration(
                      hintText: 'Enter Password',
                      labelText: 'Password',
                    ),
                    obscureText: true,
                  ),
                  Padding(
                    padding: const EdgeInsets.only(top: 25.0),
                    child: SizedBox(
                      width: 150,
                      height: 50,
                      child: Consumer<AuthBlock>(
                        builder:
                            (BuildContext context, AuthBlock auth, Widget? child) {
                          return RaisedButton(
                            color: Color(0xffDB3022),
                            textColor: Colors.white,
                            child: auth.loading && auth.loadingType == 'login' ? CircularProgressIndicator(
                              valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                            ) : Text('Sign In'),
                            onPressed: () {
                              // Validate form
                              if (_formKey.currentState!.validate() && !auth.loading) {
                                // Update values
                                _formKey.currentState!.save();
                                // Hit Api
                                setState(() {
                                    auth.login(userCredential);
                                });

                                if(auth.a=="failed" || auth.a=="not exist") {
                                  Navigator.pushNamed(context, '/auth');
                                }
                                else {
                                  Navigator.pushNamed(context, '/settings');
                                }

                              }
                            },
                          );
                        },
                      ),
                    ),
                  )
                ],
              ),
            ),
          ),
        ),
    );
  }
}
