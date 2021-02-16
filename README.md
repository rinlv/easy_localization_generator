# easy_localization_generator

[![Pub](https://img.shields.io/pub/v/easy_localization_generator.svg)](https://pub.dev/packages/easy_localization_generator)
![Code Climate issues](https://img.shields.io/github/issues/rinlv/easy_localization_generator?style=flat-square)
![GitHub closed issues](https://img.shields.io/github/issues-closed/rinlv/easy_localization_generator?style=flat-square)
![GitHub contributors](https://img.shields.io/github/contributors/rinlv/easy_localization_generator?style=flat-square)
![GitHub repo size](https://img.shields.io/github/repo-size/rinlv/easy_localization_generator?style=flat-square)
![GitHub forks](https://img.shields.io/github/forks/rinlv/easy_localization_generator?style=flat-square)
![GitHub stars](https://img.shields.io/github/stars/rinlv/easy_localization_generator?style=flat-square)
![GitHub license](https://img.shields.io/github/license/rinlv/easy_localization_generator?style=flat-square)

## Easy Localization Generator

Download CSV file and generates the localization keys from an online Google Sheet to working with [easy_localization](https://pub.dev/packages/easy_localization) and [easy_localization_loader](https://pub.dev/packages/easy_localization_loader)

This tool inspired by [flutter_sheet_localization_generator](https://pub.dev/packages/flutter_sheet_localization_generator)

### 🔩 Installation

Add to your `pubspec.yaml`:

```yaml
dependencies:
  easy_localization: <last_version>
  easy_localization_loader: <last_version>

dev_dependencies:
  build_runner: <last_version>
  easy_localization_generator: <last_version>
```

### 🔌 Usage

#### 1. Create a CSV Google Sheet

Create a sheet with your translations (following the bellow format, [an example sheet is available here](https://docs.google.com/spreadsheets/d/1v2Y3e0Uvn0JTwHvsduNT70u7Fy9TG43DIcZYJxPu1ZA/edit?usp=sharing)) :

![csv example file](https://raw.githubusercontent.com/rinlv/easy_localization_generator/main/csv_example.png)

Make sure that your sheet is shared :

![share](https://raw.githubusercontent.com/rinlv/easy_localization_generator/main/share.png)

Extract from the link the `DOCID` value : `https://docs.google.com/spreadsheets/d/<DOCID>/edit?usp=sharing`) :

#### 2. Declare a localization delegate

Declare the following `_LocaleKeys` class with the `SheetLocalization` annotation pointing to your sheet in a `lib/localization/locale_keys.dart` file :

```dart
import 'dart:ui';

import 'package:easy_localization_generator/easy_localization_generator.dart';

part 'locale_keys.g.dart';

@SheetLocalization(
    docId: 'DOCID',
    version: 1, // the `1` is the generated version.
    //You must increment it each time you want to regenerate a new version of the labels.
    outDir: 'resources/langs', //default directory save downloaded CSV file
    outName: 'langs.csv', //default CSV file name
    preservedKeywords: [
      'few',
      'many',
      'one',
      'other',
      'two',
      'zero',
      'male',
      'female',
    ])
class _LocaleKeys {}
```

#### 3. Generate your localizations

Run the following command to generate a `lib/localization/locale_keys.g.dart` file :

```
flutter pub run build_runner build
```

Sample of [locale_keys.g.dart](https://github.com/rinlv/easy_localization_generator/blob/main/example/lib/localization/locale_keys.g.dart)

#### 4. Configure your app
Last, config step by step following this tutorial from [README.md of easy_localization ](https://github.com/aissat/easy_localization/blob/develop/README.md)

### ⚡ Regeneration

Because of the caching system of the build_runner, it can't detect if there is a change on the distant sheet and it can't know if a new generation is needed.

The `version` parameter of the `@SheetLocalization` annotation solves this issue.

Each time you want to trigger a new generation, simply increment that version number and call the build runner again.

### ❓️ Why ?

I find the [easy_localization](https://pub.dev/packages/easy_localization) has already [Code generation](https://github.com/aissat/easy_localization/blob/develop/README.md#-code-generation), but it doesn't support working with Google Sheet and generate keys from CSV file. So, I make this simple generator tool.