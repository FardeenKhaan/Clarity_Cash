import 'package:clarity_cash/components.dart';
import 'package:clarity_cash/view_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:url_launcher/url_launcher.dart';

bool isloading = true;

class ExpenseViewMobile extends HookConsumerWidget {
  const ExpenseViewMobile({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final ViewModelProvider = ref.watch(viewModel);
    final devicewidth = MediaQuery.of(context).size.width;
    final deviceheight = MediaQuery.of(context).size.height;
    if (isloading == true) {
      ViewModelProvider.expensesStream();
      ViewModelProvider.incomesStream();
      isloading = false;
    }
    int totalExpense = 0;
    int totalIncome = 0;
    void calculate() {
      for (int i = 0; i < ViewModelProvider.expenseAmount.length; i++) {
        totalExpense =
            totalExpense + int.parse(ViewModelProvider.expenseAmount[i]);
      }
      for (int i = 0; i < ViewModelProvider.incomeAmount.length; i++) {
        totalIncome =
            totalIncome + int.parse(ViewModelProvider.incomeAmount[i]);
      }
    }

    calculate();
    int budgetLeft = totalIncome - totalExpense;

    return Scaffold(
      // backgroundColor: Colors.white,
      appBar: AppBar(
        iconTheme: IconThemeData(color: Colors.grey),
        title: Text(
          'Dashboard',
          style:
              GoogleFonts.poppins(fontSize: 20.0, color: Colors.grey.shade600),
        ),
        actions: [
          IconButton(
              onPressed: () {
                ViewModelProvider.reset();
              },
              icon: Icon(Icons.refresh))
        ],
      ),
      drawer: ReusableDrawer(),
      body: ListView(
        children: [
          SizedBox(
            height: deviceheight * 0.04,
          ),
          Column(
            children: [
              Container(
                height: deviceheight * 0.3,
                width: devicewidth / 1.5,
                padding: EdgeInsets.all(15.0),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(10.0),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    Column(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Budget Left',
                          style: GoogleFonts.poppins(
                              textStyle: TextStyle(
                                  fontSize: 14,
                                  color: Colors.black,
                                  fontWeight: FontWeight.bold)),
                        ),
                        Text(
                          'Total Expense',
                          style: GoogleFonts.poppins(
                              textStyle: TextStyle(
                                  fontSize: 14,
                                  color: Colors.black,
                                  fontWeight: FontWeight.bold)),
                        ),
                        Text(
                          'Total Income',
                          style: GoogleFonts.poppins(
                              textStyle: TextStyle(
                                  fontSize: 14,
                                  color: Colors.black,
                                  fontWeight: FontWeight.bold)),
                        ),
                      ],
                    ),
                    RotatedBox(
                      quarterTurns: 1,
                      child: Divider(
                        indent: 30.0,
                        endIndent: 30.0,
                        thickness: 3.0,
                        color: Colors.black,
                      ),
                    ),
                    Column(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          budgetLeft.toString(),
                          style: GoogleFonts.poppins(
                              textStyle: TextStyle(
                                  fontSize: 14.0,
                                  color: Colors.black,
                                  fontWeight: FontWeight.w600)),
                        ),
                        Text(
                          totalExpense.toString(),
                          style: GoogleFonts.poppins(
                              textStyle: TextStyle(
                                  fontSize: 14.0,
                                  color: Colors.black,
                                  fontWeight: FontWeight.w600)),
                        ),
                        Text(
                          totalIncome.toString(),
                          style: GoogleFonts.poppins(
                              textStyle: TextStyle(
                                  fontSize: 14.0,
                                  color: Colors.black,
                                  fontWeight: FontWeight.w600)),
                        )
                      ],
                    )
                  ],
                ),
              )
            ],
          ),
          SizedBox(
            height: 40.0,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              //Add Expense Button
              SizedBox(
                height: deviceheight * 0.06,
                width: devicewidth * 0.45,
                child: MaterialButton(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        Icons.add,
                        color: Colors.white,
                      ),
                      Text(
                        'Add Expense',
                        style: GoogleFonts.poppins(
                            textStyle:
                                TextStyle(color: Colors.white, fontSize: 16)),
                      ),
                    ],
                  ),
                  splashColor: Colors.grey,
                  color: Colors.blueGrey,
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10.0)),
                  onPressed: () async {
                    await ViewModelProvider.addExpense(context);
                  },
                ),
              ),
              //Add Income Button
              SizedBox(
                height: deviceheight * 0.06,
                width: devicewidth * 0.45,
                child: MaterialButton(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        Icons.add,
                        color: Colors.white,
                      ),
                      Text(
                        'Add Income',
                        style: GoogleFonts.poppins(
                            textStyle:
                                TextStyle(color: Colors.white, fontSize: 16)),
                      ),
                    ],
                  ),
                  splashColor: Colors.grey,
                  color: Colors.blueGrey,
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10.0)),
                  onPressed: () async {
                    await ViewModelProvider.addIncome(context);
                  },
                ),
              ),
            ],
          ),
          SizedBox(
            height: 10.0,
          ),
          Divider(
            thickness: 2.0,
            color: Colors.white,
            indent: 50.0,
            endIndent: 50.0,
          ),
          SizedBox(
            height: 10.0,
          ),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 10.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                  decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(15.0),
                      border: Border.all(color: Colors.black87, width: 3.0)),
                  height: deviceheight * 0.35,
                  width: devicewidth * 0.4,
                  child: Column(
                    children: [
                      Text('Expenses',
                          style: GoogleFonts.poppins(
                              textStyle: TextStyle(
                                  fontSize: 20,
                                  color: Colors.black,
                                  fontWeight: FontWeight.bold))),
                      SizedBox(
                        height: 10,
                      ),
                      Divider(
                        thickness: 3.0,
                        color: Colors.black,
                        indent: 30.0,
                        endIndent: 30.0,
                      ),
                      SizedBox(
                        height: 10,
                      ),
                      Container(
                        height: deviceheight * 0.2,
                        width: devicewidth * 0.3,
                        padding: EdgeInsets.all(7.0),
                        decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(15.0),
                            border:
                                Border.all(color: Colors.black87, width: 5.0)),
                        child: ListView.builder(
                            itemCount: ViewModelProvider.expenseAmount.length,
                            itemBuilder: (BuildContext context, int index) =>
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text(
                                      ViewModelProvider.expenseName[index],
                                      style: GoogleFonts.poppins(
                                          fontSize: 12,
                                          color: Colors.black,
                                          fontWeight: FontWeight.w600),
                                    ),
                                    Align(
                                      alignment: Alignment.centerRight,
                                      child: Text(
                                          ViewModelProvider
                                              .expenseAmount[index],
                                          style: GoogleFonts.poppins(
                                              fontSize: 12,
                                              color: Colors.black,
                                              fontWeight: FontWeight.w600)),
                                    )
                                  ],
                                )),
                      )
                    ],
                  ),
                ),
                SizedBox(
                  width: 20.0,
                ),
                //Income List
                Container(
                  decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(15.0),
                      border: Border.all(color: Colors.black87, width: 3.0)),
                  height: deviceheight * 0.35,
                  width: devicewidth * 0.4,
                  child: Column(
                    children: [
                      Text(
                        'Incomes',
                        style: GoogleFonts.poppins(
                            fontSize: 20.0,
                            color: Colors.black,
                            fontWeight: FontWeight.bold),
                      ),
                      SizedBox(
                        height: 10,
                      ),
                      Divider(
                        thickness: 3.0,
                        color: Colors.black,
                        indent: 30.0,
                        endIndent: 30.0,
                      ),
                      SizedBox(
                        height: 10,
                      ),
                      Container(
                        height: deviceheight * 0.2,
                        width: devicewidth * 0.3,
                        padding: EdgeInsets.all(7.0),
                        decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(15.0),
                            border:
                                Border.all(color: Colors.black87, width: 5.0)),
                        child: ListView.builder(
                            itemCount: ViewModelProvider.incomeAmount.length,
                            itemBuilder: (context, index) => Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text(
                                      ViewModelProvider.incomesName[index],
                                      style: GoogleFonts.poppins(
                                          fontSize: 12,
                                          color: Colors.black,
                                          fontWeight: FontWeight.w600),
                                    ),
                                    Align(
                                      alignment: Alignment.centerRight,
                                      child: Text(
                                          ViewModelProvider.incomeAmount[index],
                                          style: GoogleFonts.poppins(
                                              fontSize: 12,
                                              color: Colors.black,
                                              fontWeight: FontWeight.w600)),
                                    )
                                  ],
                                )),
                      )
                    ],
                  ),
                )
              ],
            ),
          ),
          SizedBox(
            height: 5,
          )
        ],
      ),
    );
  }
}
