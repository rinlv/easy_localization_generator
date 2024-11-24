import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';

class LanguageView extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          '',
          style: TextStyle(color: Colors.black),
        ),
        backgroundColor: Colors.white,
        iconTheme: IconThemeData(color: Colors.black),
        elevation: 0,
      ),
      body: Container(
        color: Colors.white,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              padding: EdgeInsets.only(top: 26),
              margin: EdgeInsets.symmetric(
                horizontal: 24,
              ),
              child: Text(
                'Choose language',
                style: TextStyle(
                  color: Colors.blue,
                  fontFamily: 'Montserrat',
                  fontWeight: FontWeight.w700,
                  fontSize: 18,
                ),
              ),
            ),
            buildSwitchListTileMenuItem(
                context: context,
                title: 'English',
                subtitle: 'English',
                locale: context.supportedLocales[0]),
            buildDivider(),
            buildSwitchListTileMenuItem(
                context: context,
                title: 'Chinese',
                subtitle: 'Chinese',
                locale:
                    context.supportedLocales[1] //BuildContext extension method
                ),
            buildDivider(),
            buildSwitchListTileMenuItem(
                context: context,
                title: 'عربي',
                subtitle: 'عربي',
                locale:
                    context.supportedLocales[2] //BuildContext extension method
                ),
            buildDivider(),
            buildSwitchListTileMenuItem(
                context: context,
                title: 'German',
                subtitle: 'German',
                locale: context.supportedLocales[3]),
            buildDivider(),
            buildSwitchListTileMenuItem(
                context: context,
                title: 'Русский',
                subtitle: 'Русский',
                locale: context.supportedLocales[4]),
            buildDivider(),
            buildSwitchListTileMenuItem(
                context: context,
                title: 'Vietnamese',
                subtitle: 'Vietnamese',
                locale: context.supportedLocales[5]),
            buildDivider(),
          ],
        ),
      ),
    );
  }

  Container buildDivider() => Container(
        margin: EdgeInsets.symmetric(
          horizontal: 24,
        ),
        child: Divider(
          color: Colors.grey,
        ),
      );

  Container buildSwitchListTileMenuItem(
      {required BuildContext context,
      String? title,
      String? subtitle,
      Locale? locale}) {
    return Container(
      margin: EdgeInsets.only(
        left: 10,
        right: 10,
        top: 5,
      ),
      child: ListTile(
          dense: true,
          // isThreeLine: true,
          title: Text(
            title ?? '',
          ),
          subtitle: Text(
            subtitle ?? '',
          ),
          onTap: () {
            context.setLocale(
                locale ?? Locale('en', 'US')); //BuildContext extension method
            Navigator.pop(context);
          }),
    );
  }
}
