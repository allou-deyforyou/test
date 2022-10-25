import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'fonts.gen.dart';

class Themes {
  const Themes._();

  static const secondaryColor = Color(0xFFFF583B);
  static const primaryColor = Color(0xFF13B9FF);

  static ThemeData get theme => ThemeData(
        useMaterial3: true,
        brightness: Brightness.light,
        colorSchemeSeed: primaryColor,
        indicatorColor: secondaryColor,
        fontFamily: FontFamily.firaGO,
        dividerColor: CupertinoColors.systemFill,
        appBarTheme: const AppBarTheme(
          systemOverlayStyle: SystemUiOverlayStyle(
            statusBarBrightness: Brightness.light,
            statusBarIconBrightness: Brightness.dark,
          ),
        ),
        bottomSheetTheme: const BottomSheetThemeData(
          clipBehavior: Clip.antiAlias,
          shape: RoundedRectangleBorder(
            // borderRadius: BorderRadius.vertical(top: Radius.circular(12.0)),
            side: BorderSide(color: CupertinoColors.systemGrey4),
          ),
        ),
        floatingActionButtonTheme: const FloatingActionButtonThemeData(
          foregroundColor: CupertinoColors.systemGrey,
        ),
        cupertinoOverrideTheme: const NoDefaultCupertinoThemeData(
          textTheme: CupertinoTextThemeData(),
        ),
        dividerTheme: const DividerThemeData(space: 0.8, thickness: 0.8),
      );

  static ThemeData get darkTheme => ThemeData(
        useMaterial3: true,
        brightness: Brightness.dark,
        colorSchemeSeed: primaryColor,
        indicatorColor: secondaryColor,
        fontFamily: FontFamily.firaGO,
        dividerColor: CupertinoColors.systemFill,
        appBarTheme: const AppBarTheme(
          systemOverlayStyle: SystemUiOverlayStyle(
            statusBarBrightness: Brightness.dark,
            statusBarIconBrightness: Brightness.light,
          ),
        ),
        bottomSheetTheme: const BottomSheetThemeData(
          clipBehavior: Clip.antiAlias,
          shape: RoundedRectangleBorder(
            // borderRadius: BorderRadius.vertical(top: Radius.circular(12.0)),
            side: BorderSide(color: CupertinoColors.darkBackgroundGray),
          ),
        ),
        cupertinoOverrideTheme: const NoDefaultCupertinoThemeData(
          textTheme: CupertinoTextThemeData(),
        ),
        dividerTheme: const DividerThemeData(space: 0.8, thickness: 0.8),
      );
}
