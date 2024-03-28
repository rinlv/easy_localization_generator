import 'package:csv/csv.dart';

import 'item.dart';

class CSVParser {
  final String fieldDelimiter;
  final String strings;
  final List<List<dynamic>> lines;

  CSVParser(this.strings, {this.fieldDelimiter = ','})
      : lines = CsvToListConverter()
            .convert(strings, fieldDelimiter: fieldDelimiter);

  String getSupportedLocales() {
    final locales = lines.first.sublist(1, lines.first.length).map((e) {
      final languages = e.toString().split('_');
      return "Locale('${languages[0]}', '${languages[1]}')";
    }).toList();
    return 'static const supportedLocales = [\n${locales.join(',\n')}\n];';
  }

  String generateTranslationUsages(
      List<String?> preservedKeywords, bool immediateTranslationEnabled) {
    final List<Item> items = [];

    lines.getRange(1, lines.length).forEach((e) {
      final String key = e.first;
      final String value = e[1];
      final Item item = Item(key: key, value: value);

      _checkAndAddItem(
        preservedKeywords,
        items,
        item,
      );
    });

    final strBuilder = StringBuffer();
    String lastGroupName = '';
    for (int idx = 0; idx < items.length; idx++) {
      final Item item = items[idx];
      String value = item.value;

      // Write key-group annotation string.
      final List<String> keyParts = item.key.split(RegExp(r"[._]"));
      final currentGroupName = keyParts.first;
      if (currentGroupName != lastGroupName) {
        strBuilder.writeln('\n   // $currentGroupName');
        lastGroupName = currentGroupName;
      }

      // Check value is include args or not.
      final bool hasArgs = value.contains('{') && value.contains('}');
      if (hasArgs) {
        final List<String> args = [];

        strBuilder.write('static String ${_joinKey(keyParts)}(');

        // If is plural key, will use plural(int) method for translate.
        // We state this num value is 'countForUnit' for displaying unit of translation.
        if (item.isPlural) {
          strBuilder.write('int countForUnit, ');
        }

        // Write names args of function
        int processedArgCount = 0;
        while (value.contains('{')) {
          final int startIndex = value.indexOf('{');
          final int endIndex = value.indexOf('}');
          if (startIndex >= endIndex || endIndex - startIndex == 1) {
            break;
          }

          if (processedArgCount == 0) {
            strBuilder.write('{');
          }

          strBuilder.write('required dynamic ');
          final arg = value.substring(startIndex + 1, endIndex);
          args.add(arg);
          strBuilder.write(arg);
          strBuilder.write(', ');

          value = value.substring(endIndex + 1);

          processedArgCount++;
        }

        if (processedArgCount > 0) {
          strBuilder.write('}');
        }

        strBuilder.write(') => ');
        strBuilder.write('\'${item.key}\'');

        // Choose api of translation.
        if (item.isPlural) {
          strBuilder.write('.plural(countForUnit, ');
        } else {
          strBuilder.write('.tr(');
        }

        // Write named args for api of translation.
        if (args.isNotEmpty) {
          strBuilder.write('namedArgs: {');
          for (final String arg in args) {
            strBuilder.write("'$arg': '\$$arg', ");
          }
          strBuilder.write('},');
        }

        strBuilder.writeln(');');
      } else if (immediateTranslationEnabled) {
        strBuilder.writeln(
            "static String get ${_joinKey(keyParts)} => '${item.key}'.tr();");
      } else {
        strBuilder
            .writeln("static const ${_joinKey(keyParts)} = '${item.key}';");
      }
    }

    return strBuilder.toString();
  }

  /// store key to List and ignore preserved-keyword-key
  void _checkAndAddItem(
      List<String?> preservedKeywords, List<Item> itemList, Item item) {
    final keyParts = item.key.split('.');

    final isPlural = _checkIsPluralKey(keyParts);

    for (int index = 0; index < keyParts.length; index++) {
      if (index == 0) {
        _addNewItemToList(
          itemList,
          Item(
            key: keyParts[index],
            value: item.value,
            isPlural: isPlural,
          ),
        );
        continue;
      }
      if (index == keyParts.length - 1 &&
          preservedKeywords.contains(keyParts[index])) {
        continue;
      }
      _addNewItemToList(
        itemList,
        Item(
          key: keyParts.sublist(0, index + 1).join('.'),
          value: item.value,
          isPlural: isPlural,
        ),
      );
    }
  }

  void _addNewItemToList(List<Item> pairList, Item pair) {
    final isExist =
        pairList.where((element) => element.key == pair.key).isNotEmpty;
    if (!isExist) {
      pairList.add(pair);
    }
  }

  bool _checkIsPluralKey(List<String> keyParts) {
    final List<String> pluralKeywords = [
      'few',
      'many',
      'one',
      'other',
      'two',
      'zero',
    ];
    return pluralKeywords.contains(keyParts.last);
  }

  String _capitalize(String str) =>
      '${str[0].toUpperCase()}${str.substring(1)}';

  String _normalize(String str) => '${str[0].toLowerCase()}${str.substring(1)}';

  String _joinKey(List<String> keys) =>
      _normalize(keys.map((e) => _capitalize(e)).toList().join());
}
