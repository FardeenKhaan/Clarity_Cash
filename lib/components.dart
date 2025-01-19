import 'package:clarity_cash/view_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/svg.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:url_launcher/url_launcher.dart';

DialogBox(BuildContext context, String title) {
  return showDialog(
    context: context,
    builder: (context) {
      return AlertDialog(
        title: Text(title),
        contentPadding: EdgeInsets.all(32),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
          side: BorderSide(width: 2.0, color: Colors.black),
        ),
        actions: [
          MaterialButton(
            onPressed: () {
              Navigator.pop(context);
            },
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(5.0)),
            color: Colors.blueGrey,
            child: Text('OK'),
          )
        ],
      );
    },
  );
}

final RegExp EMAIL_VALIDATION_REGEX =
    RegExp(r"^[\w-\.+]+@([\w-]+\.)+[\w-]{2,4}$");

final RegExp PASSWORD_VALIDATION_REGEX =
    RegExp(r"^(?=.*\d)(?=.*[a-z])(?=.*[A-Z])(?=.*[a-zA-Z]).{8,}$");

final RegExp NAME_VALIDATION_REGEX = RegExp(r"\b([A-Za-zÿ][-a-z. ']+[ ]*)+");

class ReusableTextform extends StatelessWidget {
  final hintText;
  final controller;
  final RegExp validationRegEx;
  final Widget? PrefixIcon; //icon
  ReusableTextform(
      {super.key,
      required this.controller,
      required this.hintText,
      required this.PrefixIcon,
      required this.validationRegEx});

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      validator: (value) {
        if (value != null && validationRegEx.hasMatch(value)) {
          return null;
        }
        return "Enter a valid ${hintText.toLowerCase()}";
      },
      controller: controller,
      decoration: InputDecoration(
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
        enabledBorder: OutlineInputBorder(
            borderSide: BorderSide(color: Colors.white),
            borderRadius: BorderRadius.all(Radius.circular(10))),
        focusedErrorBorder: OutlineInputBorder(
            borderRadius: BorderRadius.all(Radius.circular(10))),
        prefixIcon: PrefixIcon,
        hintStyle: GoogleFonts.poppins(fontSize: 13.0),
        hintText: hintText,
      ),
    );
  }
}

class ReusableTextbill extends StatelessWidget {
  final text;
  final containerWidth;
  final hintText;
  final digitsOnly;
  final controller;
  final validator;
  ReusableTextbill(
      {super.key,
      required this.text,
      required this.containerWidth,
      this.digitsOnly,
      required this.controller,
      this.validator,
      required this.hintText});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text(
          text,
          style: TextStyle(fontSize: 13.0),
        ),
        SizedBox(height: 5.0),
        SizedBox(
          width: containerWidth == null ? 300 : containerWidth,
          child: TextFormField(
            validator: validator,
            inputFormatters: digitsOnly != null
                ? [FilteringTextInputFormatter.digitsOnly]
                : [],
            controller: controller,
            decoration: InputDecoration(
              errorBorder: OutlineInputBorder(
                  borderSide: BorderSide(color: Colors.red, width: 1.0),
                  borderRadius: BorderRadius.circular(10.0)),
              focusedErrorBorder: OutlineInputBorder(
                  borderSide: BorderSide(color: Colors.red, width: 1.0),
                  borderRadius: BorderRadius.circular(15.0)),
              enabledBorder: OutlineInputBorder(
                  borderSide: BorderSide(color: Colors.red, width: 1.0),
                  borderRadius: BorderRadius.circular(10.0)),
              focusedBorder: OutlineInputBorder(
                  borderSide: BorderSide(color: Colors.red, width: 2.0),
                  borderRadius: BorderRadius.circular(15.0)),
              hintStyle: GoogleFonts.poppins(fontSize: 13.0),
              hintText: hintText,
            ),
          ),
        )
      ],
    );
  }
}

class ReusableDrawer extends HookConsumerWidget {
  const ReusableDrawer({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final ViewModelProvider = ref.watch(viewModel);
    return Drawer(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Padding(padding: EdgeInsets.only(bottom: 20)),
          Container(
            decoration: BoxDecoration(
                shape: BoxShape.circle, border: Border.all(width: 1.0)),
            child: CircleAvatar(
              backgroundColor: Colors.grey,
              radius: 83.0,
              child: CircleAvatar(
                radius: 80.0,
                backgroundImage: AssetImage('assets/minelogo.png'),
              ),
            ),
          ),
          SizedBox(
            height: 5,
          ),
          Divider(
            color: Colors.blueGrey,
            thickness: 3.0,
            indent: 30.0,
            endIndent: 30.0,
          ),
          SizedBox(
            height: 5,
          ),
          MaterialButton(
            onPressed: () {
              ViewModelProvider.LoggedOut();
            },
            child: Text('Logout'),
            color: Colors.blueGrey,
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(5.0)),
          ),
          SizedBox(
            height: 20,
          ),
          Text('View Some Other Projects'),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              IconButton(
                  onPressed: () async => await launchUrl(
                      Uri.parse('https://github.com/FardeenKhaan')),
                  icon: SvgPicture.asset('assets/icons8-github.svg')),
              SizedBox(
                width: 5,
              ),
              IconButton(
                  onPressed: () async => await launchUrl(
                      Uri.parse('https://linkedin.com/in/fardeenkhan51')),
                  icon: SvgPicture.asset('assets/icons8-linkedin-logo.svg')),
            ],
          )
        ],
      ),
    );
  }
}
