/// Google sheet Example:
/// str | en_US
/// key: clickMe | value: click me
class Item {
  Item({
    required this.key,
    required this.value,
    this.isPlural = false,
  });

  String key;
  String value;
  bool isPlural;
}
