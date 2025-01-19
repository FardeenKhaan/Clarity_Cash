import 'package:clarity_cash/mob/expense_view_mobile.dart';
import 'package:clarity_cash/mob/login_view_mobile.dart';
import 'package:clarity_cash/mob/signUp_view_mobile.dart';
import 'package:clarity_cash/view_model.dart';
import 'package:clarity_cash/web/expense_view_web.dart';
import 'package:clarity_cash/web/login_view_web.dart';
import 'package:clarity_cash/web/signUp_view_web.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

class ResponsiveHandler extends HookConsumerWidget {
  const ResponsiveHandler({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // final viewModelProvider = ref.watch(viewModel);
    // viewModelProvider.isLoggedIn();
    final _authState = ref.watch(authStateProvider);
    return _authState.when(
        data: (data) {
          if (data != null) {
            return LayoutBuilder(
              builder: (BuildContext context, BoxConstraints constraints) {
                if (constraints.maxWidth > 680) {
                  return ExpenseViewWeb();
                } else {
                  return ExpenseViewMobile();
                }
              },
            );
          }
          return LayoutBuilder(
            builder: (BuildContext context, BoxConstraints constraints) {
              if (constraints.maxWidth > 680) {
                return SignupViewWeb();
              } else {
                return SignupViewMobile();
              }
            },
          );
        },
        error: (e, trace) {
          return LayoutBuilder(
            builder: (BuildContext context, BoxConstraints constraints) {
              if (constraints.maxWidth > 680) {
                return SignupViewWeb();
              } else {
                return SignupViewMobile();
              }
            },
          );
        },
        loading: () => LayoutBuilder(
              builder: (BuildContext context, BoxConstraints constraints) {
                if (constraints.maxWidth > 680) {
                  return SignupViewWeb();
                } else {
                  return SignupViewMobile();
                }
              },
            ));
    // if (viewModelProvider.isSignedIn == true) {
    //   return LayoutBuilder(
    //     builder: (BuildContext context, BoxConstraints constraints) {
    //       if (constraints.maxWidth > 680) {
    //         return ExpenseViewWeb();
    //       } else {
    //         return ExpenseViewMobile();
    //       }
    //     },
    //   );
    // } else {
    //   return LayoutBuilder(
    //     builder: (BuildContext context, BoxConstraints constraints) {
    //       if (constraints.maxWidth > 680) {
    //         return SignupViewWeb();
    //       } else {
    //         return SignupViewMobile();
    //       }
    //     },
    //   );
    // }
  }
}
