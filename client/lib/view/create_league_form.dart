import 'package:flutter/material.dart';
import 'package:ktg_client/controller/api_handler.dart';
import 'package:provider/provider.dart';

class CreateLeagueForm extends StatefulWidget {
  const CreateLeagueForm();

  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    return CreateLeagueFormState();
  }
}

class CreateLeagueFormState extends State<CreateLeagueForm> {
  CreateLeagueFormState() {
    competitions = <String>['NBA', 'UEFA', 'WORLD CUP', 'LDSO'];
    visibility = 'public';
    if (competitions.isNotEmpty) currentSelectedCompetition = competitions[0];
  }

  final GlobalKey _formKey = GlobalKey<FormState>();

  String leagueName = '';
  String visibility;
  List<String> competitions;

  String currentSelectedCompetition;

  @override
  Widget build(BuildContext context) {
    // TODO: implement build

    return Form(
        key: _formKey,
        child: Container(
          width: 600,
          child: ListView(
            children: <Widget>[
              TextFormField(
                decoration: const InputDecoration(labelText: 'League Name'),
                validator: (String value) {
                  if (value.isEmpty)
                    return 'Please enter a league name';
                  else
                    return null;
                },
                onSaved: (String value) {
                  leagueName = value;
                },
              ),
              const SizedBox(height: 50),
              Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: <Widget>[
                  Column(children: <Widget>[
                    const Text('public'),
                    Radio<String>(
                        onChanged: (String value) {
                          setState(() {
                            visibility = value;
                          });
                        },
                        value: 'public',
                        groupValue: visibility)
                  ]),
                  const SizedBox(
                    width: 50,
                  ),
                  Column(children: <Widget>[
                    const Text('private'),
                    Radio<String>(
                        onChanged: (String value) {
                          setState(() {
                            visibility = value;
                          });
                        },
                        value: 'private',
                        groupValue: visibility)
                  ])
                ],
              ),
              Column(
                  mainAxisSize: MainAxisSize.min,
                  children: competitions.map((String key) {
                    return RadioListTile <String>(
                      title: Text(key),
                      onChanged: (String value) {
                        setState(() {
                          currentSelectedCompetition = value;
                          print('new new new testing radio button' +
                              value.toString());
                        });
                      },
                      value: key,
                      groupValue: currentSelectedCompetition,
                    );
                  }).toList()),
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: <Widget>[
                  RaisedButton(
                    child: const Text('create'),
                    onPressed: () {
                      final FormState form = _formKey.currentState;
                      if (form.validate()) {
                        form.save();

                        final ApiHandler apiHandler =
                            Provider.of<ApiHandler>(context, listen: false);

                        print(
                            'just to make surreeee*************************   :' +
                                currentSelectedCompetition);
                        apiHandler.createLeague(
                            leagueName, currentSelectedCompetition);

                        Navigator.of(context).pop();
                      }
                    },
                  )
                ],
              )
            ],
          ),
        ));
  }

  
}
