import 'package:easy_localization/easy_localization.dart';
import 'package:easy_localization_loader/easy_localization_loader.dart';
import 'package:flutter/material.dart';

import 'lang_view.dart';
import 'localization/strings.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await EasyLocalization.ensureInitialized();

  runApp(EasyLocalization(
      child: MyApp(),
      supportedLocales: Strings.supportedLocales,
      path: 'assets/langs/langs.csv',
      // fallbackLocale: Locale('en', 'US'),
      // startLocale: Locale('de', 'DE'),
      // saveLocale: false,
      // useOnlyLangCode: true,

      // optional assetLoader default used is RootBundleAssetLoader which uses flutter's assetloader
      // install easy_localization_loader for enable custom loaders
      // assetLoader: RootBundleAssetLoader()
      // assetLoader: HttpAssetLoader()
      // assetLoader: FileAssetLoader()
      assetLoader: CsvAssetLoader()
      // assetLoader: YamlAssetLoader() //multiple files
      // assetLoader: YamlSingleAssetLoader() //single file
      // assetLoader: XmlAssetLoader() //multiple files
      // assetLoader: XmlSingleAssetLoader() //single file
      // assetLoader: CodegenLoader()
      ));
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      localizationsDelegates: context.localizationDelegates,
      supportedLocales: context.supportedLocales,
      locale: context.locale,
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: MyHomePage(title: 'Easy localization'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key? key, this.title}) : super(key: key);

  final String? title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  int counter = 0;
  bool _gender = true;

  void incrementCounter() {
    setState(() {
      counter++;
    });
  }

  void switchGender(bool val) {
    setState(() {
      _gender = val;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(Strings.title),
        actions: <Widget>[
          ElevatedButton(
            child: Icon(Icons.language),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (_) => LanguageView(), fullscreenDialog: true),
              );
            },
          ),
        ],
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Spacer(
              flex: 1,
            ),
            Text(
                Strings.supportedLanguage(
                    language: Strings.supportedLocales.length.toString()),
                style: TextStyle(
                    color: Colors.grey.shade600,
                    fontSize: 19,
                    fontWeight: FontWeight.bold)),
            Spacer(
              flex: 1,
            ),
            Text(
              Strings.gender,
              style: TextStyle(
                  color: Colors.grey.shade600,
                  fontSize: 19,
                  fontWeight: FontWeight.bold),
            ).tr(gender: _gender ? 'female' : 'male'),
            Center(child: Switch(value: _gender, onChanged: switchGender)),
            Spacer(
              flex: 1,
            ),
            Text(Strings.amount(counter)),
            Spacer(
              flex: 1,
            ),
            Text(Strings.msg(
              name: 'Jack',
              type: 'Hot',
            )),
            Text(Strings.clicked(counter, count: counter)),
            ElevatedButton(
              onPressed: () {
                incrementCounter();
              },
              child: Text(Strings.clickMe),
            ),
            SizedBox(
              height: 15,
            ),
            SizedBox(
              height: 20,
            ),
            ElevatedButton(
              onPressed: () {
                context.deleteSaveLocale();
                context.setLocale(Strings.supportedLocales.first);
              },
              child: Text(Strings.resetLocale),
            ),
            Spacer(
              flex: 1,
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: incrementCounter,
        child: Text('+1'),
      ),
    );
  }
}
