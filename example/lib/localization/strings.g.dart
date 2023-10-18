// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'strings.dart';

// **************************************************************************
// LocalizationGenerator
// **************************************************************************

// Generated at: Thu, 28 Mar 2024 12:49:54 +08:00
class Strings {
  static const supportedLocales = [
    Locale('en', 'US'),
    Locale('zh', 'TW'),
    Locale('ar', 'DZ'),
    Locale('de', 'DE'),
    Locale('ru', 'RU'),
    Locale('vi', 'VN')
  ];

  // title
  static const title = 'title';

  // clickMe
  static const clickMe = 'clickMe';

  // profile
  static const profile = 'profile';
  static const profileResetPassword = 'profile.reset_password';
  static const profileResetPasswordLabel = 'profile.reset_password.label';
  static const profileResetPasswordUsername = 'profile.reset_password.username';
  static const profileResetPasswordPassword = 'profile.reset_password.password';

  // clicked
  static String clicked(
    int countForUnit, {
    required dynamic count,
  }) =>
      'clicked'.plural(
        countForUnit,
        namedArgs: {
          'count': '$count',
        },
      );

  // amount
  static String amount(
    int countForUnit,
  ) =>
      'amount'.plural(
        countForUnit,
      );

  // gender
  static const gender = 'gender';
  static String genderWithArg({
    required dynamic name,
  }) =>
      'gender.with_arg'.tr(
        namedArgs: {
          'name': '$name',
        },
      );

  // reset
  static const resetLocale = 'reset_locale';

  // supported
  static String supportedLanguage({
    required dynamic language,
  }) =>
      'supported_language'.tr(
        namedArgs: {
          'language': '$language',
        },
      );

  // msg
  static String msg({
    required dynamic name,
    required dynamic type,
  }) =>
      'msg'.tr(
        namedArgs: {
          'name': '$name',
          'type': '$type',
        },
      );

  // hello
  static String hello({
    required dynamic name,
  }) =>
      'hello'.tr(
        namedArgs: {
          'name': '$name',
        },
      );
}
