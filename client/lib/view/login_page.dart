import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:http/http.dart' as http;

import 'package:ktg_client/view/home_page.dart';
import 'package:ktg_client/view/register_page.dart';
import 'package:ktg_client/main.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:ktg_client/controller/user_requests.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({
    Key key,
  }) : super(key: key);

  @override
  LoginPageState createState() => LoginPageState();
}

class LoginPageState extends State<LoginPage>
    with SingleTickerProviderStateMixin {
  int statusCode;

  @override
  void initState() {
    super.initState();

    currentSession.userRequests.googleSignIn.onCurrentUserChanged
        .listen((GoogleSignInAccount account) {
      setState(() {
        currentSession.userRequests.currentUser = account;
        currentSession.userRequests.email = account.email;
      });
      if (currentSession.userRequests.currentUser != null) {
        _handleGetContact();
      }
    });
    currentSession.userRequests.googleSignIn.signInSilently();
  }

  void _handleGetContact() async {
    final http.Response response = await http.get(
      'https://people.googleapis.com/v1/people/me/connections'
      '?requestMask.includeField=person.names',
      headers: await currentSession.userRequests.currentUser.authHeaders,
    );

    if (response.statusCode != 200) {
      print('People API ${response.statusCode} response: ${response.body}');
      return;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.blue[50],
        body: Container(
            child: ListView(
          children: <Widget>[
            Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                const Image(
                  image: AssetImage('assets/KnowTheGame.png'),
                  width: 250,
                  height: 250,
                ),
                MyCustomForm(),
                googleButton()
              ],
            )
          ],
        )));
  }

  Widget googleButton() {
    return (currentSession.userRequests.currentUser != null ||
            currentSession.userRequests.cookie != null)
        ? RaisedButton(
            child: const Text("You're already signed in!"), onPressed: () {})
        : RaisedButton(
            child: const Text('Sign in with Google'),
            onPressed: currentSession.userRequests.handleSignIn,
          );
  }
}

class MyCustomForm extends StatefulWidget {
  @override
  MyCustomFormState createState() {
    return MyCustomFormState();
  }
}

class MyCustomFormState extends State<MyCustomForm> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

  int statusCode;

  @override
  Widget build(BuildContext context) {
    return Form(
        key: _formKey,
        child: Theme(
          data: ThemeData(
              brightness: Brightness.light,
              primarySwatch: Colors.blue,
              inputDecorationTheme: InputDecorationTheme(
                  labelStyle: TextStyle(color: Colors.blue, fontSize: 20.0))),
          child: Container(
            padding: const EdgeInsets.all(40.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                TextFormField(
                    controller: emailController,
                    decoration: InputDecoration(
                      filled: true,
                      fillColor: Colors.white,
                      hintText: 'Enter Email',
                      contentPadding: const EdgeInsets.only(
                          left: 14.0, bottom: 8.0, top: 8.0),
                      focusedBorder: OutlineInputBorder(
                        borderSide: BorderSide(color: Colors.white),
                        borderRadius: BorderRadius.circular(25.7),
                      ),
                      enabledBorder: UnderlineInputBorder(
                        borderSide: BorderSide(color: Colors.white),
                        borderRadius: BorderRadius.circular(25.7),
                      ),
                    ),
                    keyboardType: TextInputType.emailAddress,
                    validator: (String value) {
                      const String p = '[a-zA-Z0-9\+\.\_\%\-\+]{1,256}'
                          '\\@'
                          '[a-zA-Z0-9][a-zA-Z0-9\\-]{0,64}'
                          '('
                          '\\.'
                          '[a-zA-Z0-9][a-zA-Z0-9\\-]{0,25}'
                          ')+';
                      final RegExp regExp = RegExp(p);

                      return regExp.hasMatch(value)
                          ? null
                          : 'Please insert a valid email';
                    }),
                const SizedBox(height: 8.0),
                TextFormField(
                    controller: passwordController,
                    decoration: InputDecoration(
                      filled: true,
                      fillColor: Colors.white,
                      hintText: 'Enter Password',
                      contentPadding: const EdgeInsets.only(
                          left: 14.0, bottom: 8.0, top: 8.0),
                      focusedBorder: OutlineInputBorder(
                        borderSide: BorderSide(color: Colors.white),
                        borderRadius: BorderRadius.circular(25.7),
                      ),
                      enabledBorder: UnderlineInputBorder(
                        borderSide: BorderSide(color: Colors.white),
                        borderRadius: BorderRadius.circular(25.7),
                      ),
                    ),
                    keyboardType: TextInputType.text,
                    obscureText: true,
                    validator: (String value) {
                      return value.isEmpty
                          ? 'Please enter your password'
                          : null;
                    }),
                const Padding(
                  padding: EdgeInsets.only(top: 20.0),
                ),
                MaterialButton(
                  color: Colors.blue,
                  textColor: Colors.white,
                  child: const Text('Login'),
                  onPressed: loginHandler,
                ),
                MaterialButton(
                  color: Colors.blue,
                  textColor: Colors.white,
                  child: const Text('Sign up'),
                  onPressed: () => <void>{
                    Navigator.of(context).push(MaterialPageRoute<void>(
                        builder: (BuildContext context) {
                      return const RegisterPage();
                    }))
                  },
                ),
              ],
            ),
          ),
        ));
  }

  void loginHandler() async {
    statusCode = await UserRequests()
        .login(emailController.text, passwordController.text);

    if (_formKey.currentState.validate()) {
      if (statusCode == 200) {
        currentSession.userRequests.email = emailController.text;
        Navigator.of(context)
            .push(MaterialPageRoute<void>(builder: (BuildContext context) {
          return HomePage();
        }));
      } else
        Scaffold.of(context).showSnackBar(const SnackBar(
          content:  Text('Wrong credentials'),
        ));
    }
  }

  @override
  void dispose() {
    emailController.dispose();
    passwordController.dispose();
    super.dispose();
  }
}
