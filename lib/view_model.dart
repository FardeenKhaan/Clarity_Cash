import 'dart:io';
import 'dart:math';

import 'package:clarity_cash/components.dart';
import 'package:clarity_cash/mob/expense_view_mobile.dart';
import 'package:clarity_cash/web/expense_view_web.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:logger/logger.dart';
import 'package:sign_in_button/sign_in_button.dart';

final viewModel =
    ChangeNotifierProvider.autoDispose<ViewModel>((ref) => ViewModel());
final authStateProvider = StreamProvider<User?>((ref) {
  return ref.read(viewModel).authStateChange;
});

class ViewModel extends ChangeNotifier {
  final _auth = FirebaseAuth.instance;
  CollectionReference usercollection =
      FirebaseFirestore.instance.collection('users');
  // bool isSignedIn = false;
  bool isObscure = true;
  List expenseName = [];
  List expenseAmount = [];
  List incomesName = [];
  List incomeAmount = [];
  Stream<User?> get authStateChange => _auth.authStateChanges();
  // check if user is signin
  // Future<void> isLoggedIn() async {
  //   await _auth.authStateChanges().listen((User? user) {
  //     if (user == null) {
  //       isSignedIn = false;
  //     } else
  //       isSignedIn = true;
  //   });
  //   notifyListeners();
  // }

  toggleObscure() {
    isObscure = !isObscure;
    notifyListeners();
  }

  Future<void> createUserWithEmailAndPassowrd(
      BuildContext context, String email, String password) async {
    try {
      await _auth
          .createUserWithEmailAndPassword(email: email, password: password)
          .then((value) {
        Fluttertoast.showToast(
          msg: 'SignUp Successfully',
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.BOTTOM,
          backgroundColor: Colors.green,
          textColor: Colors.white,
          fontSize: 16.0,
        ); // Success message
      });
    } on FirebaseAuthException catch (e) {
      // FirebaseAuthException provides specific error codes
      String errorMessage;

      switch (e.code) {
        case 'invalid-email':
          errorMessage = "The email is invalid.";
          break;
        case 'email-already-in-use':
          errorMessage = "The email address is already in use.";
          break;
        case 'weak-password':
          errorMessage = "The password is too weak.";
          break;
        default:
          errorMessage = "An unknown error occurred: ${e.message}";
      }

      // Show AlertDialog for the error
      showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: Text('Signup Error'),
          content: Text(errorMessage),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(); // Close the dialog
              },
              child: Text('OK'),
            ),
          ],
        ),
      );
    } catch (e) {
      // Catch any other unexpected exceptions
      DialogBox(context, e.toString().replaceAll(RegExp('\\[.*?\\]'), ''));
    }
  }

  Future<void> signINWithEmailAndPassword(
      BuildContext context, String email, String password) async {
    try {
      await _auth
          .signInWithEmailAndPassword(email: email, password: password)
          .then((value) {
        Fluttertoast.showToast(
          msg: 'Login Successfully',
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.BOTTOM,
          backgroundColor: Colors.green,
          textColor: Colors.white,
          fontSize: 16.0,
        );
        // Redirect the user based on platform
        if (kIsWeb) {
          // For web, navigate to the web-specific screen
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (context) => ExpenseViewWeb()),
          );
        } else if (Platform.isAndroid || Platform.isIOS) {
          // For mobile, navigate to the mobile-specific screen
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (context) => ExpenseViewMobile()),
          );
        }
      });
    } on FirebaseAuthException catch (e) {
      String errorMessage;

      switch (e.code) {
        case 'invalid-email':
          errorMessage = "Something went wrong!!";
          break;
        case 'email-already-in-use':
          errorMessage = "The email address is already in use.";
          break;
        case 'weak-password':
          errorMessage = "The password is too weak.";
          break;
        default:
          errorMessage = "An unknown error occurred: ${e.message}";
      }

      // Show AlertDialog for the error
      showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: Text('Login Error'),
          content: Text(errorMessage),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(); // Close the dialog
              },
              child: Text('OK'),
            ),
          ],
        ),
      );
    } catch (e) {
      // Catch any other unexpected exceptions
      DialogBox(context, e.toString().replaceAll(RegExp('\\[.*?\\]'), ''));
    }
  }

  Future<void> SignInWithGoogleWeb(BuildContext context) async {
    GoogleAuthProvider googleAuthProvider = GoogleAuthProvider();
    await _auth.signInWithPopup(googleAuthProvider).onError(
        (error, StackTrace) => DialogBox(
            context, error.toString().replaceAll(RegExp('\\[.*?\\]'), '')));
    Fluttertoast.showToast(
      msg: 'Current user is not empty=${_auth.currentUser!.uid.isNotEmpty}',
      toastLength: Toast.LENGTH_SHORT,
      gravity: ToastGravity.BOTTOM,
      backgroundColor: Colors.red,
      textColor: Colors.white,
      fontSize: 16.0,
    );
  }

  Future<void> SignInWithGoogleMobile(BuildContext context) async {
    final GoogleSignInAccount? googleUser = await GoogleSignIn()
        .signIn()
        .onError((error, StackTrace) => DialogBox(
            context, error.toString().replaceAll(RegExp('\\[.*?\\]'), '')));
    final GoogleSignInAuthentication? googleAuth =
        await googleUser?.authentication;

    final credential = GoogleAuthProvider.credential(
      accessToken: googleAuth?.accessToken,
      idToken: googleAuth?.idToken,
    );

    await _auth.signInWithCredential(credential).then((value) {
      Fluttertoast.showToast(
        msg: 'Signed in with Google',
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.BOTTOM,
        backgroundColor: Colors.green,
        textColor: Colors.white,
        fontSize: 16.0,
      );
    }).onError((error, StackTrace) {
      DialogBox(context, error.toString().replaceAll(RegExp('\\[.*?\\]'), ''));
    });
  }

  Future<void> LoggedOut() async {
    try {
      await _auth.signOut();
      notifyListeners();

      // Show a toast message
      Fluttertoast.showToast(
        msg: "Logged out successfully",
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.BOTTOM,
        backgroundColor: Colors.green,
        textColor: Colors.white,
        fontSize: 16.0,
      );
    } catch (e) {
      // Handle any errors and show a toast message for failure
      Fluttertoast.showToast(
        msg: "Error logging out: ${e.toString()}",
        toastLength: Toast.LENGTH_LONG,
        gravity: ToastGravity.BOTTOM,
        backgroundColor: Colors.red,
        textColor: Colors.white,
        fontSize: 16.0,
      );
    }
  }

  Future addExpense(BuildContext context) async {
    final formkey = GlobalKey<FormState>();
    TextEditingController controllerName = TextEditingController();
    TextEditingController controllerAmount = TextEditingController();
    return await showDialog(
      context: context,
      builder: (BuildContext context) => AlertDialog(
        actionsAlignment: MainAxisAlignment.center,
        contentPadding: EdgeInsets.all(32.0),
        shape:
            RoundedRectangleBorder(borderRadius: BorderRadius.circular(10.0)),
        title: Form(
            key: formkey,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                ReusableTextbill(
                  text: 'Name',
                  containerWidth: 130.0,
                  controller: controllerName,
                  hintText: 'Name',
                  validator: (text) {
                    if (text.toString().isEmpty) {
                      return 'required';
                    }
                  },
                ),
                SizedBox(
                  width: 10.0,
                ),
                ReusableTextbill(
                  text: 'Amount',
                  containerWidth: 100.0,
                  controller: controllerAmount,
                  hintText: 'Amount',
                  digitsOnly: true,
                  validator: (text) {
                    if (text.toString().isEmpty) {
                      return 'required';
                    }
                  },
                ),
              ],
            )),
        actions: [
          MaterialButton(
            onPressed: () async {
              if (formkey.currentState!.validate()) {
                await usercollection
                    .doc(_auth.currentUser!.uid)
                    .collection('expenses')
                    .add({
                  'name': controllerName.text,
                  'amount': controllerAmount.text,
                }).then((value) {
                  Fluttertoast.showToast(
                    msg: 'Expense Added',
                    toastLength: Toast.LENGTH_SHORT,
                    gravity: ToastGravity.BOTTOM,
                    backgroundColor: Colors.green,
                    textColor: Colors.white,
                    fontSize: 16.0,
                  );
                }).onError((error, StackTrace) {
                  Fluttertoast.showToast(
                    msg: 'add expense error = $error',
                    toastLength: Toast.LENGTH_SHORT,
                    gravity: ToastGravity.BOTTOM,
                    backgroundColor: Colors.red,
                    textColor: Colors.white,
                    fontSize: 16.0,
                  );
                  return DialogBox(context, error.toString());
                });
                Navigator.pop(context);
              }
            },
            child: Text(
              'Save',
              style: GoogleFonts.openSans(color: Colors.white),
            ),
            splashColor: Colors.blueGrey,
            color: Colors.black,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10.0),
            ),
          )
        ],
      ),
    );
  }

  Future addIncome(BuildContext context) async {
    final formkey = GlobalKey<FormState>();
    final controllerName = TextEditingController();
    final controllerAmount = TextEditingController();
    return await showDialog(
      context: context,
      builder: (BuildContext context) => AlertDialog(
        actionsAlignment: MainAxisAlignment.center,
        contentPadding: EdgeInsets.all(32.0),
        shape:
            RoundedRectangleBorder(borderRadius: BorderRadius.circular(10.0)),
        title: Form(
            key: formkey,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                ReusableTextbill(
                  text: 'Name',
                  containerWidth: 130.0,
                  controller: controllerName,
                  hintText: 'Name',
                  validator: (text) {
                    if (text.toString().isEmpty) {
                      return 'required';
                    }
                  },
                ),
                SizedBox(
                  width: 10.0,
                ),
                ReusableTextbill(
                  text: 'Amount',
                  containerWidth: 100.0,
                  controller: controllerAmount,
                  hintText: 'Amount',
                  digitsOnly: true,
                  validator: (text) {
                    if (text.toString().isEmpty) {
                      return 'required';
                    }
                  },
                ),
              ],
            )),
        actions: [
          MaterialButton(
            onPressed: () async {
              if (formkey.currentState!.validate()) {
                await usercollection
                    .doc(_auth.currentUser!.uid)
                    .collection('income')
                    .add({
                  'name': controllerName.text,
                  'amount': controllerAmount.text,
                }).then((value) {
                  Fluttertoast.showToast(
                    msg: 'Income Added',
                    toastLength: Toast.LENGTH_SHORT,
                    gravity: ToastGravity.BOTTOM,
                    backgroundColor: Colors.green,
                    textColor: Colors.white,
                    fontSize: 16.0,
                  );
                }).onError((error, StackTrace) {
                  Fluttertoast.showToast(
                    msg: 'add income error = $error',
                    toastLength: Toast.LENGTH_SHORT,
                    gravity: ToastGravity.BOTTOM,
                    backgroundColor: Colors.red,
                    textColor: Colors.white,
                    fontSize: 16.0,
                  );
                  return DialogBox(context, error.toString());
                });
                Navigator.pop(context);
              }
            },
            child: Text(
              'Save',
              style: GoogleFonts.openSans(color: Colors.white),
            ),
            splashColor: Colors.blueGrey,
            color: Colors.black,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10.0),
            ),
          )
        ],
      ),
    );
  }

  void expensesStream() async {
    await for (var snapshot in usercollection
        .doc(_auth.currentUser!.uid)
        .collection('expenses')
        .snapshots()) {
      expenseAmount = [];
      expenseName = [];
      for (var expense in snapshot.docs) {
        expenseName.add(expense.data()['name']);
        expenseAmount.add(expense.data()['amount']);
        notifyListeners();
      }
    }
    ;
  }

  void incomesStream() async {
    await for (var snapshot in usercollection
        .doc(_auth.currentUser!.uid)
        .collection('income')
        .snapshots()) {
      incomeAmount = [];
      incomesName = [];
      for (var income in snapshot.docs) {
        incomesName.add(income.data()['name']);
        incomeAmount.add(income.data()['amount']);
        notifyListeners();
      }
    }
  }

  Future<void> reset() async {
    await usercollection
        .doc(_auth.currentUser!.uid)
        .collection('expenses')
        .get()
        .then((snapshot) {
      for (DocumentSnapshot ds in snapshot.docs) {
        ds.reference.delete();
      }
    });
    await usercollection
        .doc(_auth.currentUser!.uid)
        .collection('income')
        .get()
        .then((snapshot) {
      for (DocumentSnapshot ds in snapshot.docs) {
        ds.reference.delete();
      }
    });
  }
}
