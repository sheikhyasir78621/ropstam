import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:ropstam/global/constants.dart';
import 'package:ropstam/global/utils.dart';
import 'package:ropstam/screens/home_screen.dart';
import 'package:ropstam/state/app_state.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:toast/toast.dart';

class LoginScreen extends StatelessWidget {
  final DataUtil dataUtil = DataUtil();
  LoginScreen({Key? key}) : super(key: key);

  final _formKey = GlobalKey<FormState>();
  TextEditingController userNameController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();

  @override
  Widget build(BuildContext context) {
    ToastContext().init(context);
    AppState provider = Provider.of<AppState>(context);

    return Scaffold(
      key: _scaffoldKey,
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.transparent,
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            SizedBox(
              height: MediaQuery.of(context).size.height * 0.09,
            ),
            Center(
              child: SizedBox(
                width: MediaQuery.of(context).size.width / 2,
                child: const Text(
                  'Hello Again!',
                  style: TextStyle(
                    fontSize: 28,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
            const SizedBox(
              height: 10,
            ),
            Center(
              child: SizedBox(
                width: MediaQuery.of(context).size.width / 2,
                child: const Text(
                  'Chance to get your life better',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ),
            const SizedBox(
              height: 20,
            ),
            Form(
              key: _formKey,
              child: Column(
                children: [
                  Container(
                    margin: const EdgeInsets.symmetric(horizontal: 20),
                    padding: const EdgeInsets.symmetric(horizontal: 10),
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(12),
                        color: Colors.white,
                        boxShadow: const [
                          BoxShadow(blurRadius: 2, color: kGrey)
                        ]),
                    child: TextFormField(
                      keyboardType: TextInputType.emailAddress,
                      controller: userNameController,
                      decoration: const InputDecoration(
                        labelText: 'Enter email',
                        hintText: 'Enter your email',
                        border: InputBorder.none,
                      ),
                      validator: (value) {
                        if (value!.isEmpty) {
                          return "Please enter email";
                        }
                        return null;
                      },
                    ),
                  ),
                  const SizedBox(
                    height: 16,
                  ),
                  Container(
                    margin: const EdgeInsets.symmetric(horizontal: 20),
                    padding: const EdgeInsets.symmetric(horizontal: 10),
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(12),
                        color: kWhite,
                        boxShadow: const [
                          BoxShadow(blurRadius: 2, color: kGrey)
                        ]),
                    child: TextFormField(
                      keyboardType: TextInputType.text,
                      controller: passwordController,
                      obscureText: provider
                          .passwordVisible, //This will obscure text dynamically
                      decoration: InputDecoration(
                        labelText: 'Enter password',
                        hintText: 'Enter your password',
                        border: InputBorder.none,
                        suffixIcon: IconButton(
                          icon: Icon(
                              provider.passwordVisible
                                  ? Icons.visibility_off
                                  : Icons.visibility,
                              color: Theme.of(context).primaryColorDark),
                          onPressed: () {
                            provider.updatePasswordVisibility();
                          },
                        ),
                      ),
                      validator: (value) {
                        if (value!.isEmpty) {
                          return "Please Enter Password";
                        }
                        return null;
                      },
                    ),
                  ),
                ],
              ),
            ),
            const Align(
              alignment: FractionalOffset.bottomRight,
              child: Padding(
                padding: EdgeInsets.only(right: 22, top: 10),
                child: Text(
                  'Recovery password',
                  style: TextStyle(color: kGrey, fontSize: 14),
                ),
              ),
            ),
            const SizedBox(
              height: 30,
            ),
            GestureDetector(
              onTap: () async {
                if (_formKey.currentState!.validate()) {
                  provider.updateLoginScreenLoading(true);
                  final jsonData = await dataUtil.Login(
                    userNameController.text.toString(),
                    passwordController.text.toString(),
                  );
                  provider.updateLoginScreenLoading(false);

                  if (jsonData['meta']['message'] == 'Successfull') {
                    token = jsonData['data']['access_token'];

                    SharedPreferences preferences =
                        await SharedPreferences.getInstance();
                    preferences.setString('token', token.toString());
                    preferences.setInt(
                        'userId', jsonData['data']['user']['id']);

                    preferences.setString(
                        'username', jsonData['data']['user']['username']);
                    preferences.setString(
                        'name', jsonData['data']['user']['name']);

                    preferences.setString(
                        'email', jsonData['data']['user']['email']);

                    preferences.setString(
                        'mobile', jsonData['data']['user']['mobile']);

                    preferences.setString(
                        'image', jsonData['data']['user']['image']);

                    // ignore: use_build_context_synchronously
                    Navigator.pushReplacement(context,
                        MaterialPageRoute(builder: (context) => HomeScreen()));
                  } else if (jsonData['message'] ==
                      "Page Not Found. If error persists, contact info@website.com") {
                    // ignore: use_build_context_synchronously
                    ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                        content: Text(
                      'Invalid username or password',
                    )));
                  } else {
                    // ignore: use_build_context_synchronously
                    ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                        content: Text(
                      'Server error',
                    )));
                  }
                }
              },
              child: Container(
                height: 54,
                alignment: Alignment.center,
                width: MediaQuery.of(context).size.width / 1.15,
                decoration: BoxDecoration(
                    color: kGreen,
                    borderRadius: BorderRadius.circular(12),
                    boxShadow: const [
                      BoxShadow(
                        blurRadius: 2,
                        color: kGrey,
                      )
                    ]),
                child: provider.loginScreenLoading
                    ? const CircularProgressIndicator(
                        backgroundColor: kWhite,
                      )
                    : const Text(
                        'Login',
                        style: TextStyle(color: kWhite, fontSize: 18),
                      ),
              ),
            ),
            const SizedBox(
              height: 20,
            ),
            const Align(
              alignment: FractionalOffset.center,
              child: Padding(
                padding: EdgeInsets.only(right: 22, top: 10),
                child: Text(
                  'or continue with',
                  style: TextStyle(color: kGrey, fontSize: 14),
                ),
              ),
            ),
            const SizedBox(
              height: 20,
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                      height: 56,
                      width: 56,
                      decoration: BoxDecoration(
                        color: kLightGreen,
                        //   boxShadow: [BoxShadow(blurRadius: 3, color: kGrey)],
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(color: kWhite, width: 3),
                      ),
                      alignment: Alignment.center,
                      padding: const EdgeInsets.all(14),
                      child: Image.asset('assets/icons/google.png')),
                  const SizedBox(
                    width: 20,
                  ),
                  Container(
                      height: 56,
                      width: 56,
                      decoration: BoxDecoration(
                        color: kLightGreen,
                        //   boxShadow: [BoxShadow(blurRadius: 3, color: kGrey)],
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(color: kWhite, width: 3),
                      ),
                      alignment: Alignment.center,
                      padding: const EdgeInsets.all(14),
                      child: Image.asset('assets/icons/apple-logo.png')),
                  const SizedBox(
                    width: 20,
                  ),
                  Container(
                      height: 56,
                      width: 56,
                      decoration: BoxDecoration(
                        color: kLightGreen,
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(color: kWhite, width: 3),
                      ),
                      alignment: Alignment.center,
                      padding: const EdgeInsets.all(14),
                      child: Image.asset('assets/icons/facebook.png',
                          color: Colors.blue))
                ],
              ),
            ),
            const SizedBox(
              height: 40,
            ),
            RichText(
              text: const TextSpan(
                  text: "Not a member? ",
                  style: TextStyle(fontSize: 14, color: Colors.black),
                  children: [
                    TextSpan(
                      text: 'Register now',
                      style: TextStyle(
                          fontWeight: FontWeight.w600,
                          fontSize: 14,
                          color: kGreen),
                    )
                  ]),
            ),
          ],
        ),
      ),
    );
  }
}
