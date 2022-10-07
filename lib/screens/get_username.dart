import 'package:datetime/screens/home.dart';
import 'package:datetime/utils/utils.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:form_field_validator/form_field_validator.dart';

class GetUserName extends StatefulWidget {
  @override
  _GetUserNameState createState() => _GetUserNameState();
}

class _GetUserNameState extends State<GetUserName> {
  final TextEditingController userNameController = TextEditingController();
  final userNameKey = GlobalKey<FormState>();

  String userName;
  bool isLoading = false;

  @override
  void setState(fn) {
    if (mounted) {
      super.setState(fn);
    }
  }

  @override
  void initState() {
    super.initState();
    isLoading = true;
    print('from form');
    getUserName().then((value) => setState(() {
          userName = value;
          isLoading = false;
        }));
  }

  @override
  Widget build(BuildContext context) {
    SizeConfig().init(context);
    return Scaffold(
      resizeToAvoidBottomInset: true,
      body: SafeArea(
        child: Padding(
          padding:
              EdgeInsets.symmetric(horizontal: SizeConfig.shortside * 0.10),
          child: Column(
            children: [
              if (isLoading)
                Expanded(
                    child: Center(
                  child: CupertinoActivityIndicator(),
                ))
              else
                Expanded(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        "Your Name",
                        style: TextStyle(fontSize: SizeConfig.longside / 20),
                      ),
                      SizedBox(height: SizeConfig.longside / 80),
                      Container(
                        child: Form(
                          key: userNameKey,
                          child: TextFormField(
                            cursorRadius: Radius.circular(50),
                            cursorColor: Colors.white,
                            decoration: InputDecoration(
                              errorStyle: TextStyle(
                                color: Colors.white,
                              ),
                            ),
                            controller: userNameController,
                            autovalidateMode:
                                AutovalidateMode.onUserInteraction,
                            autofocus: true,
                            textAlign: TextAlign.center,
                            validator: MultiValidator([
                              RequiredValidator(errorText: 'Required'),
                            ]),
                            onEditingComplete: () {
                              if (userNameKey.currentState.validate()) {
                                WidgetsBinding
                                    .instance.focusManager.primaryFocus
                                    ?.unfocus();
                                setUserNamePreference(userNameController.text);
                                Get.to(() =>
                                    Home(userName: userNameController.text));
                                Get.snackbar(
                                  userNameController.text,
                                  "Good Name",
                                  duration: Duration(milliseconds: 800),
                                );
                              }
                            },
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }

  setUserNamePreference(String userName) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setString('userName', userName);
  }
}

Future<String> getUserName() async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  return prefs.getString('userName');
}
