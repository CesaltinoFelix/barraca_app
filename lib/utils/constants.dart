import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

const Color kPrimaryColor = Color(0xFFF2994A);
const Color kSecondaryColor = Color(0xFF3F1391);
const Color kWhiteColor = Colors.white;

OutlineInputBorder defaultOutlineInputBorder = OutlineInputBorder(
  borderRadius: BorderRadius.circular(14),
  borderSide: const BorderSide(color: Color(0xFFF3F3F3)),
);

const kSpacingUnit = 10;

const kDarkPrimaryColor = Color(0xFF212121);
const kDarkSecondaryColor = Color(0xFF373737);
const kLightPrimaryColor = Color(0xFFFFB74D);
const kLightSecondaryColor = Color(0xFFF3F7FB);
const kAccentColor = Color(0xFFEEEEEE);
const kDarkColor = Color(0xFF303030);
const kTransparent = Colors.transparent;
const kLightColor = Color(0xFF808080);
const kDefaultPadding = 24.0;
const kLessPadding = 10.0;
const kFixPadding = 16.0;
const kLess = 4.0;

const kShape = 30.0;

const kRadius = 0.0;
const kAppBarHeight = 56.0;

const kHeadTextStyle = TextStyle(
  fontSize: 24.0,
  fontWeight: FontWeight.bold,
);

const kSubTextStyle = TextStyle(
  fontSize: 18.0,
  color: kLightColor,
);

const kTitleTextStyle = TextStyle(
  fontSize: 20.0,
  color: kPrimaryColor,
);

const kTitleTextOptionStyle = TextStyle(
  fontSize: 16.0,
  color: kDarkColor,
);

const kDarkTextStyle = TextStyle(
  fontSize: 20.0,
  color: kDarkColor,
);
const kLightTextStyle = TextStyle(
  fontSize: 20.0,
  color: kLightColor,
);

const kDivider = Divider(
  color: kAccentColor,
  thickness: kLessPadding,
);

const kSmallDivider = Divider(
  color: kAccentColor,
  thickness: 5.0,
);

final kCaptionTextStyle = TextStyle(
  fontSize: ScreenUtil().setSp(kSpacingUnit.w * 1.3),
  fontWeight: FontWeight.w100,
);

final kButtonTextStyle = TextStyle(
  fontSize: ScreenUtil().setSp(kSpacingUnit.w * 1.5),
  fontWeight: FontWeight.w400,
  color: kDarkPrimaryColor,
);

final kDarkTheme = ThemeData(
  brightness: Brightness.dark,
  fontFamily: 'SFProText',
  primaryColor: kDarkPrimaryColor,
  canvasColor: kDarkPrimaryColor,
  secondaryHeaderColor: kAccentColor,
  iconTheme: ThemeData.dark().iconTheme.copyWith(
        color: kLightSecondaryColor,
      ),
  textTheme: ThemeData.dark().textTheme.apply(
        fontFamily: 'SFProText',
        bodyColor: kLightSecondaryColor,
        displayColor: kLightSecondaryColor,
      ), //colorScheme: ColorScheme(background: kDarkSecondaryColor),
);

final kLightTheme = ThemeData(
  brightness: Brightness.light,
  fontFamily: 'SFProText',
  primaryColor: kLightPrimaryColor,
  canvasColor: kLightPrimaryColor,
  secondaryHeaderColor: kAccentColor,
  iconTheme: ThemeData.light().iconTheme.copyWith(
        color: kDarkSecondaryColor,
      ),
  textTheme: ThemeData.light().textTheme.apply(
        fontFamily: 'SFProText',
        bodyColor: kDarkSecondaryColor,
        displayColor: kDarkSecondaryColor,
      ), //colorScheme: ColorScheme(background: kLightSecondaryColor),
);

final paymentLabels = [
  'Unitel Money',
  'Guita',
  // 'Cash',
  // 'Cartão de Credito/Debito',
];

final paymentIcons = [
  Icons.account_balance_wallet,
  Icons.account_balance_wallet,
  Icons.money_off,
  Icons.payment,
];

const String chatBubble = 'assets/images/chat.json';
const String conversation = 'assets/images/chat.json';
const String logo = 'assets/images/logo-1.png';
const String profile = 'assets/images/avatar.jpeg';
const String success = 'assets/images/success.json';
const String emptyBox = 'assets/images/empty-box.json';
