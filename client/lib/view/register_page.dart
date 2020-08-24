import 'package:flutter/material.dart';
import 'package:ktg_client/controller/user_requests.dart';
import 'package:flutter/rendering.dart';
import 'package:ktg_client/view/home_page.dart';
import 'package:ktg_client/view/login_page.dart';
import 'package:ktg_client/main.dart';

class RegisterPage extends StatefulWidget {
  const RegisterPage({
    Key key,
  }) : super(key: key);

  @override
  RegisterPageState createState() => RegisterPageState();
}

class RegisterPageState extends State<RegisterPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.blue[50],
      appBar: AppBar(
        title: const Text('User Register'),
        backgroundColor: Colors.blue,
      ),
      body: Stack(
        fit: StackFit.expand,
        children: <Widget>[
          Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[MyCustomForm()],
          )
        ],
      ),
    );
  }
}

// Create a Form widget.
class MyCustomForm extends StatefulWidget {
  @override
  MyCustomFormState createState() {
    return MyCustomFormState();
  }
}

// Create a corresponding State class.
// This class holds data related to the form.
class MyCustomFormState extends State<MyCustomForm> {
  // Create a global key that uniquely identifies the Form widget
  // and allows validation of the form.
  //
  // Note: This is a GlobalKey<FormState>,
  // not a GlobalKey<MyCustomFormState>.
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController nameController = TextEditingController();
  final TextEditingController usernameController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

  int statusCode;
  int statusCodeLogin;

  @override
  Widget build(BuildContext context) {
    // Build a Form widget using the _formKey created above.
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
                  controller: nameController,
                  decoration: InputDecoration(
                    filled: true,
                    fillColor: Colors.white,
                    hintText: 'Enter Name',
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
                  validator: (String value) {
                    if (value.isEmpty) {
                      return 'Please enter your name';
                    }
                    return null;
                  }),
              const SizedBox(height: 8.0),
              TextFormField(
                  controller: usernameController,
                  decoration: InputDecoration(
                    filled: true,
                    fillColor: Colors.white,
                    hintText: 'Enter Username',
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
                  validator: (String value) {
                    if (value.isEmpty) {
                      return 'Please enter your username';
                    }
                    return null;
                  }),
              const SizedBox(height: 8.0),
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
                    const String p =
                        '[a-zA-Z0-9\+\.\_\%\-\+]{1,256}\\@[a-zA-Z0-9][a-zA-Z0-9\\-]{0,64}(\\.[a-zA-Z0-9][a-zA-Z0-9\\-]{0,25})+';
                    final RegExp regExp = RegExp(p);

                    if (regExp.hasMatch(value)) {
                      return null;
                    }

                    return 'Please insert a valid email';
                  }),
              const SizedBox(height: 20.0),
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
                  validator: (String password) {
                    if (password.isEmpty) {
                      return 'Please enter a password';
                    }
                    if (password.length < 7) {
                      return 'Passwords should have at least 7 characters';
                    }
                    return null;
                  }),
              const SizedBox(height: 8.0),
              TextFormField(
                  decoration: InputDecoration(
                    filled: true,
                    fillColor: Colors.white,
                    hintText: 'Confirm Password',
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
                    if (value.isEmpty) {
                      return 'Please make sure you typed the same password';
                    }
                    if (value != passwordController.text) {
                      return 'Passwords are not the same';
                    }
                    return null;
                  }),
              const Padding(
                padding: EdgeInsets.only(top: 20.0),
              ),
              MaterialButton(
                color: Colors.blue,
                textColor: Colors.white,
                child: const Text('Confirm'),
                onPressed: () async {
                  if (_formKey.currentState.validate()) {
                    statusCode = await UserRequests().signUp(
                        emailController.text,
                        nameController.text,
                        usernameController.text,
                        passwordController.text);
                    print('StatusCode: ');
                    print(statusCode);

                    if (statusCode == 201) {
                      statusCodeLogin = await UserRequests()
                          .login(emailController.text, passwordController.text);
                      if (statusCodeLogin == 200) {
                        currentSession.userRequests.email =
                            emailController.text;
                        Navigator.of(context).push(MaterialPageRoute<void>(
                            builder: (BuildContext context) {
                          return HomePage();
                        }));
                      } else {
                        Navigator.of(context).push(MaterialPageRoute<void>(
                            builder: (BuildContext context) {
                          return const LoginPage();
                        }));
                      }
                    } else {
                      Scaffold.of(context).showSnackBar(const SnackBar(
                        content: Text(
                            "Can't register. Are you connected to the internet?"),
                      ));
                    }
                  }
                },
              ),
            ],
          ),
        ),
      ),
    );
  }

  @override
  void dispose() {
    // Clean up the controller when the widget is disposed.
    emailController.dispose();
    usernameController.dispose();
    nameController.dispose();
    passwordController.dispose();
    super.dispose();
  }
}
