import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:html/parser.dart';

class Tools {
  /// Snack bar
  static showSnackBar(ScaffoldState? scaffoldState, message, Color color) {
    // ignore: deprecated_member_use
    scaffoldState!.showSnackBar(SnackBar(
      content: Text(
        message,
        textAlign: TextAlign.center,
      ),
      backgroundColor: color,
      behavior: SnackBarBehavior.floating,
    ));
  }

  ///Calling Snack bar demo
  //  Tools.showSnackBar(_scaffoldKey.currentState,  (_controller.state as UserError).message.toString(),Colors.red);

  /// Alert dialogue box
  static showAlert(BuildContext context, String title, String content,
      TextButton textButton1, TextButton textButton2) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(title),
          content: Text(content),
          actions: <Widget>[
            textButton1,
            textButton2,
          ],
        );
      },
    );
  }

  ///Calling dialogue box demo
//  Tools.showAlert(
//                  context,
//                  'Logout',
//                  'Are you sure you want to Logout?',
//                  TextButton(
//                    onPressed: () {
//                      Navigator.of(context).pop();
//                    },
//                    child: Text('Yes'),
//                  ),
//                  TextButton(
//                    onPressed: () {
//                      Navigator.of(context).pop();
//                    },
//                    child: Text('No'),
//                  ),
//                );

  ///Hide keyboard
  static void hideKeyboard(BuildContext context) {
    //FocusScope.of(context).requestFocus(FocusNode());
    FocusManager.instance.primaryFocus!.unfocus();
  }

  /// Calling hide keyboard demo
  //Tools.hideKeyboard(context),
}

class HtmlHelper {
  static String parseHtmlString(String htmlString) {
    var document = parse(htmlString);
    String parsedString = parse(document.body!.text).documentElement!.text;
    return parsedString;
  }
}

// Text(HtmlHelper.parseHtmlString(text)),

///Validation
class Validator {
  static isValidEmail(String email) {
    if (email.isEmpty) {
      return 'Please Enter Email';
    } else if (!RegExp(
        r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+")
        .hasMatch(email)) {
      return 'Enter Valid Email';
    }
    return null;
  }

  static isValidPassword(String password) {
    if (password.isEmpty) {
      return 'Please Enter Password';
    } else if (!RegExp(
        r'^(?=.*?[A-Z])(?=.*?[a-z])(?=.*?[0-9])(?=.*?[!@#\$&*~]).{8,14}$')
        .hasMatch(password)) {
      return 'Enter Valid Password';
    } else {
      return null;
    }
  }

  static isValidConfirmPassword(String password, String confirmPassword) {
    if (confirmPassword.isEmpty) {
      return 'Please Enter Confirm Password';
    } else if (confirmPassword != password) {
      return 'Not Match';
    } else if (!RegExp(
        r'^(?=.*?[A-Z])(?=.*?[a-z])(?=.*?[0-9])(?=.*?[!@#\$&*~]).{8,14}$')
        .hasMatch(confirmPassword)) {
      return 'Enter Valid Confirm Password';
    } else {
      return null;
    }
  }

  static isValidMobileNo(String phoneNo) {
    if (phoneNo.length < 0 || phoneNo.length == 0 || phoneNo.length == 10) {
      return null;
    } else {
      return 'Enter Valid Phone No.';
    }
  }

  static isValidTitle(String title) {
    if (title.isEmpty) {
      return 'Please Enter Title';
    } else if (title.length < 4 || title.length > 12) {
      return 'Title length should be between 4 to 12 character';
    }
    return null;
  }

  static isValidDetail(String detail) {
    if (detail.isEmpty) {
      return 'Please Enter Description';
    } else if (detail.length > 25) {
      return 'Description length must be less then 25';
    }
    return null;
  }
}

///DateTime
class DateTimeUtils {
  static String getDate(DateTime dateTime) {
    final dateFormat = DateFormat(DateTimeFormatConstants.ddMMyyyy);
    return dateFormat.format(dateTime);
  }

  static String format(int timestamp, String format) {
    final date = DateTime.fromMillisecondsSinceEpoch(timestamp * 1000);
    final dateFormat = DateFormat(format);
    return dateFormat.format(date);
  }

  static String getDateFromTimeStamp(int timestamp) {
    final date = DateTime.fromMillisecondsSinceEpoch(timestamp * 1000);
    final dateFormat = DateFormat(DateTimeFormatConstants.ddMMyyyy);
    return dateFormat.format(date);
  }

  static String getTimeAndDate(int timestamp) {
    final date = DateTime.fromMillisecondsSinceEpoch(timestamp * 1000);
    final dateFormat = DateFormat(DateTimeFormatConstants.hHddMMyyyy);
    return '${date.hour}h ${dateFormat.format(date)}';
  }

  static String getTimeBooking(DateTime time) {
    final dateFormat = DateFormat(DateTimeFormatConstants.timeBooking);
    return dateFormat.format(time);
  }

  static DateTime parse(int timestamp) {
    try {
      return DateTime.fromMillisecondsSinceEpoch(timestamp * 1000);
    } catch (_) {
      return DateTime.now();
    }
  }
}

class DateTimeFormatConstants {
  static const iso8601WithMillisecondsOnly = 'yyyy-MM-dd\'T\'HH:mm:ss.SSS\'Z\'';
  static const defaultDateTimeFormat = 'EEEE, d MMM y';
  static const dMMMyyyyHHmmFormatID = 'd MMM yyyy, HH.mm';
  static const dMMMyyyyHHmmFormatEN = 'd MMM yyyy, HH:mm';
  static const dMMMyyyyFormat = 'd MMM yyyy';
  static const ddMMMyyyyFormat = 'dd MMM yyyy';
  static const dMMMMyyyyFormat = 'd MMMM yyyy';
  static const ddMMyyyyFormat = 'ddMMyyyy';
  static const mMMyyyyFormat = 'MMM yyyy';
  static const ddMMMFormat = 'd MMM';
  static const timeHHmmssFormatID = 'HH.mm.ss';
  static const timeHHmmssFormatEN = 'HH:mm:ss';
  static const timeHHmmFormatID = 'HH.mm';
  static const timeHHmmFormatEN = 'HH:mm';
  static const eEEEdMMMMyFormat = 'EEEE, d MMMM y';
  static const yyyyMMdd = 'yyyy-MM-dd';
  static const ddMMyyyy = 'dd-MM-yyyy';
  static const day = 'dd';
  static const weekday = 'EEEE';
  static const month = 'MMM';
  static const ddMMMMyyyy = 'dd MMMM yyyy';
  static const ddMMMyyyy = 'dd MMM yyyy';
  static const timeMMMMyyyy = 'MMMM yyyy';
  static const mmyy = 'MM/yy';
  static const timeSeparater = ':';
  static const String monthFull = 'MMMM';
  static const String year = 'y';

  static const timeBooking = 'HH:mm';
  static const hHddMMyyyy = 'dd/MM/yyyy';
}
