// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'strings.dart';

// **************************************************************************
// LocalizationGenerator
// **************************************************************************

// Generated at: Tue, 15 Nov 2022 01:16:49 +08:00
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
  static String get title => 'title'.tr();

  // clickMe
  static String get clickMe => 'clickMe'.tr();

  // profile
  static String get profile => 'profile'.tr();
  static String get profileResetPassword => 'profile.reset_password'.tr();
  static String get profileResetPasswordLabel =>
      'profile.reset_password.label'.tr();
  static String get profileResetPasswordUsername =>
      'profile.reset_password.username'.tr();
  static String get profileResetPasswordPassword =>
      'profile.reset_password.password'.tr();

  // clicked
  static String clicked(
    int countForUnit, {
    required dynamic count,
  }) =>
      'clicked'.plural(
        countForUnit,
        namedArgs: {
          'count': count.toString(),
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
  static String get gender => 'gender'.tr();
  static String genderWithArg({
    required dynamic name,
  }) =>
      'gender.with_arg'.tr(
        namedArgs: {
          'name': name.toString(),
        },
      );

  // reset
  static String get resetLocale => 'reset_locale'.tr();

  // supported
  static String supportedLanguage({
    required dynamic language,
  }) =>
      'supported_language'.tr(
        namedArgs: {
          'language': language.toString(),
        },
      );

  // msg
  static String msg({
    required dynamic name,
    required dynamic type,
  }) =>
      'msg'.tr(
        namedArgs: {
          'name': name.toString(),
          'type': type.toString(),
        },
      );

  // hello
  static String hello({
    required dynamic name,
  }) =>
      'hello'.tr(
        namedArgs: {
          'name': name.toString(),
        },
      );
}
