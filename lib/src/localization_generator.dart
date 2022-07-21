import 'dart:async';
import 'dart:io';

import 'package:analyzer/dart/element/element.dart';
import 'package:build/build.dart';
import 'package:csv/csv.dart';
import 'package:easy_localization_generator/src/sheet_localization.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';
import 'package:path/path.dart' as path;
import 'package:source_gen/source_gen.dart';

class LocalizationGenerator extends GeneratorForAnnotation<SheetLocalization> {
  @override
  FutureOr<String> generateForAnnotatedElement(
          Element element, ConstantReader annotation, BuildStep buildStep) =>
      _generateSource(element, annotation);

  Future<String> _generateSource(Element element, ConstantReader annotation) async {
    final headers = {'Content-Type': 'text/csv; charset=utf-8', 'Accept': '*/*'};
    final response = await http.get(
        Uri.parse(
            'https://docs.google.com/spreadsheets/export?format=csv&id=${annotation.read('docId').stringValue}'),
        headers: headers);
    final classBuilder = StringBuffer();
    classBuilder.writeln('// Generated at: ${formatDateWithOffset(DateTime.now().toLocal())}');
    classBuilder.writeln('class ${element.displayName.substring(1)}{');
    if (response.statusCode == 200) {
      final outputDir = annotation.read('outDir').stringValue;
      final outputFileName = annotation.read('outName').stringValue;
      final preservedKeywords =
          annotation.read('preservedKeywords').listValue.map((e) => e.toStringValue()).toList();
      final current = Directory.current;
      final output = Directory.fromUri(Uri.parse(outputDir));
      final outputPath = Directory(path.join(current.path, output.path, outputFileName));

      final generatedFile = File(outputPath.path);
      if (!generatedFile.existsSync()) {
        generatedFile.createSync(recursive: true);
      }
      generatedFile.writeAsBytesSync(response.bodyBytes);
      final csvParser = CSVParser(response.body);
      classBuilder.writeln(csvParser.getSupportedLocales());
      classBuilder.writeln(csvParser.getLocaleKeys(preservedKeywords));
    } else {
      throw Exception('http reasonPhrase: ${response.reasonPhrase}');
    }
    classBuilder.writeln('}');
    return classBuilder.toString();
  }

  String formatDateWithOffset(DateTime date, {String format = 'EEE, dd MMM yyyy HH:mm:ss'}) {
    String twoDigits(int n) => n >= 10 ? "$n" : "0$n";

    final hours = twoDigits(date.timeZoneOffset.inHours.abs());
    final minutes = twoDigits(date.timeZoneOffset.inMinutes.remainder(60));
    final sign = date.timeZoneOffset.inHours > 0 ? "+" : "-";
    final formattedDate = DateFormat(format).format(date);

    return "$formattedDate $sign$hours:$minutes";
  }
}

class CSVParser {
  final String fieldDelimiter;
  final String strings;
  final List<List<dynamic>> lines;

  CSVParser(this.strings, {this.fieldDelimiter = ','})
      : lines = CsvToListConverter().convert(strings, fieldDelimiter: fieldDelimiter);

  String getSupportedLocales() {
    final locales = lines.first.sublist(1, lines.first.length).map((e) {
      final languages = e.toString().split('_');
      return "const Locale('${languages[0]}', '${languages[1]}')";
    }).toList();
    return 'static const supportedLocales = const [\n${locales.join(',\n')}\n];';
  }

  String getLocaleKeys(List<String?> preservedKeywords) {
    final oldKeys = lines.getRange(1, lines.length).map((e) => e.first.toString()).toList();
    final keys = <String>[];
    final strBuilder = StringBuffer();
    oldKeys.forEach((element) {
      _reNewKeys(preservedKeywords, keys, element);
    });
    keys.sort();
    for (int idx = 0; idx < keys.length; idx++) {
      final group1 = keys[idx].split(RegExp(r"[._]"));
      if (idx == 0) {
        _groupKey(strBuilder, group1, keys[idx]);
        continue;
      }
      final group2 = keys[idx - 1].split(RegExp(r"[._]"));
      if (group1[0] != group2[0]) {
        strBuilder.writeln('\n   // ${group1[0]}');
      }
      strBuilder.writeln('static const ${_joinKey(group1)} = \'${keys[idx]}\';');
    }
    return strBuilder.toString();
  }

  void _groupKey(StringBuffer strBuilder, List<String> group, String key) {
    strBuilder.writeln('\n   // ${group[0]}');
    strBuilder.writeln('static const ${_joinKey(group)} = \'$key\';');
  }

  void _reNewKeys(List<String?> preservedKeywords, List<String> newKeys, String key) {
    final keys = key.split('.');
    for (int index = 0; index < keys.length; index++) {
      if (index == 0) {
        _addNewKey(newKeys, keys[index]);
        continue;
      }
      if (index == keys.length - 1 && preservedKeywords.contains(keys[index])) {
        continue;
      }
      _addNewKey(newKeys, keys.sublist(0, index + 1).join('.'));
    }
  }

  void _addNewKey(List<String> newKeys, String key) {
    if (!newKeys.contains(key)) {
      newKeys.add(key);
    }
  }

  String _capitalize(String str) => '${str[0].toUpperCase()}${str.substring(1)}';

  String _normalize(String str) => '${str[0].toLowerCase()}${str.substring(1)}';

  String _joinKey(List<String> keys) => _normalize(keys.map((e) => _capitalize(e)).toList().join());
}
