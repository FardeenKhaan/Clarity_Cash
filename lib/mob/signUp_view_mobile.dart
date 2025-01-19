import 'package:clarity_cash/mob/login_view_mobile.dart';
import 'package:clarity_cash/view_model.dart';
import 'package:clarity_cash/web/login_view_web.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

class SignupViewMobile extends HookConsumerWidget {
  const SignupViewMobile({super.key});

  Widget build(BuildContext context, WidgetRef ref) {
    TextEditingController _nameField = useTextEditingController();
    TextEditingController _emailField = useTextEditingController();
    TextEditingController _passwordField = useTextEditingController();
    final double deviceheight = MediaQuery.of(context).size.height;
    final double deviceWidth = MediaQuery.of(context).size.width;
    final viewModelProvider = ref.watch(viewModel);
    return SafeArea(
      child: Scaffold(
          body: Column(
        children: [
          Expanded(
              child: Container(
            decoration: BoxDecoration(
                image: DecorationImage(
                    image: AssetImage(
                      'assets/clarity.png',
                    ),
                    fit: BoxFit.cover)),
            child: Center(
              child: Container(
                margin: EdgeInsets.only(top: deviceheight * 0.4),
                height: deviceheight * 0.6,
                width: deviceWidth * 0.7,
                decoration: BoxDecoration(
                    border: Border.all(color: Colors.blueGrey, width: 4),
                    color: Colors.black87,
                    borderRadius: BorderRadius.all(Radius.circular(20))),
                child: SingleChildScrollView(
                  child: Padding(
                    padding:
                        EdgeInsets.symmetric(horizontal: deviceWidth * 0.03),
                    child: Column(
                      spacing: 10,
                      children: [
                        Text('Welcome!!',
                            style: GoogleFonts.acme(
                              textStyle: TextStyle(
                                  color: Colors.white,
                                  fontSize: deviceheight * 0.05),
                            )),
                        Text('Please SignUP to continue',
                            style: GoogleFonts.acme(
                              textStyle: TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.w700,
                                  fontSize: deviceheight * 0.025),
                            )),
                        SizedBox(
                          height: MediaQuery.of(context).size.height * 0.01,
                        ),
                        TextFormField(
                          controller: _nameField,
                          keyboardType: TextInputType.number,
                          decoration: InputDecoration(
                            hintText: 'Name',
                            border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(10)),
                            enabledBorder: OutlineInputBorder(
                                borderSide: BorderSide(color: Colors.white),
                                borderRadius:
                                    BorderRadius.all(Radius.circular(10))),
                            focusedErrorBorder: OutlineInputBorder(
                                borderRadius:
                                    BorderRadius.all(Radius.circular(10))),
                            prefixIcon: Icon(Icons.person),
                          ),
                        ),
                        TextFormField(
                          controller: _emailField,
                          keyboardType: TextInputType.number,
                          decoration: InputDecoration(
                            hintText: 'Email',
                            border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(10)),
                            enabledBorder: OutlineInputBorder(
                                borderSide: BorderSide(color: Colors.white),
                                borderRadius:
                                    BorderRadius.all(Radius.circular(10))),
                            focusedErrorBorder: OutlineInputBorder(
                                borderRadius:
                                    BorderRadius.all(Radius.circular(10))),
                            prefixIcon: Icon(Icons.mail),
                          ),
                        ),
                        TextFormField(
                          controller: _passwordField,
                          keyboardType: TextInputType.emailAddress,
                          obscureText: viewModelProvider.isObscure,
                          decoration: InputDecoration(
                            hintText: 'Password',
                            border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(10)),
                            enabledBorder: OutlineInputBorder(
                                borderSide: BorderSide(color: Colors.white),
                                borderRadius:
                                    BorderRadius.all(Radius.circular(10))),
                            focusedErrorBorder: OutlineInputBorder(
                                borderRadius:
                                    BorderRadius.all(Radius.circular(10))),
                            prefixIcon: IconButton(
                                onPressed: () {
                                  viewModelProvider.toggleObscure();
                                },
                                icon: Icon(viewModelProvider.isObscure
                                    ? Icons.visibility
                                    : Icons.visibility_off)),
                          ),
                        ),
                        SizedBox(
                          height: deviceheight * 0.01,
                        ),
                        Container(
                          height: deviceheight * 0.06,
                          width: deviceWidth * 0.15,
                          decoration: BoxDecoration(
                              color: Colors.blueGrey,
                              borderRadius: BorderRadius.circular(15)),
                          child: MaterialButton(
                            onPressed: () async {
                              final result = await viewModelProvider
                                  .createUserWithEmailAndPassowrd(
                                      context,
                                      _emailField.text.toString(),
                                      _passwordField.text.toString());
                            },
                            child: Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Text('SignUp'),
                            ),
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(5.0)),
                            color: Colors.blueGrey,
                          ),
                        ),
                        Row(
                          mainAxisSize: MainAxisSize.max,
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text('Already have an account?',
                                style: GoogleFonts.acme(
                                  textStyle: TextStyle(
                                      color: Colors.white,
                                      fontWeight: FontWeight.w200,
                                      fontSize: deviceheight * 0.016),
                                )),
                            SizedBox(
                              width: 2,
                            ),
                            GestureDetector(
                              onTap: () {
                                Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) =>
                                            LoginViewMobile()));
                              },
                              child: Text('Login',
                                  style: GoogleFonts.acme(
                                    textStyle: TextStyle(
                                        color: Colors.white,
                                        fontWeight: FontWeight.w200,
                                        fontSize: deviceheight * 0.016),
                                  )),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ))
        ],
      )),
    );
  }
}
