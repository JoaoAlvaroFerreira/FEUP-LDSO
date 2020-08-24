import 'package:flutter/material.dart';

class Style {
  static const TextStyle baseTextStyle = TextStyle(fontFamily: 'Poppins');

  static final TextStyle smallTextStyle = commonTextStyle.copyWith(
    fontSize: 9.0,
  );

  static final TextStyle commonTextStyle = baseTextStyle.copyWith(
      color: const Color(0xffb6b2df),
      fontSize: 14.0,
      fontWeight: FontWeight.w400);

  static final TextStyle titleTextStyle = baseTextStyle.copyWith(
      color: Colors.white, fontSize: 18.0, fontWeight: FontWeight.w600);

  static final TextStyle titleTextStyleggameinfo = baseTextStyle.copyWith(
      color: Colors.white, fontSize: 16.0, fontWeight: FontWeight.w600);

  static final TextStyle headerTextStyle = baseTextStyle.copyWith(
      color: Colors.white, fontSize: 20.0, fontWeight: FontWeight.w400);

  static final TextStyle blacktitleTextStyle = baseTextStyle.copyWith(
      color: Colors.black, fontSize: 18.0, fontWeight: FontWeight.bold);

  static final TextStyle joinleaguetitleStyle = baseTextStyle.copyWith(
      color: Colors.black54, fontSize: 22.0, fontWeight: FontWeight.w900);

  static final TextStyle joinleagueplayernumberStyle = baseTextStyle.copyWith(
      color: const Color.fromRGBO(231, 231, 231, 1),
      fontSize: 19.0,
      fontWeight: FontWeight.w900);

  static final TextStyle playerprofilename = baseTextStyle.copyWith(
      color: const Color.fromRGBO(0, 0, 0, 1),
      fontSize: 25.0,
      fontWeight: FontWeight.w400);

  static final TextStyle playerprofilesubtitle = baseTextStyle.copyWith(
      color: const Color.fromRGBO(100, 100, 100, 1),
      fontSize: 15.0,
      fontWeight: FontWeight.w400);

  static final TextStyle playerprofileboldsubtitle = baseTextStyle.copyWith(
      color: const Color.fromRGBO(80, 80, 80, 1),
      fontSize: 16.0,
      fontWeight: FontWeight.w900);
}
