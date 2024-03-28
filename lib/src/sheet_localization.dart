class SheetLocalization {
  /// Optional. If null then the local file (outName) will be used
  final String? docId;
  final String lineSeparator;
  final int version;
  final String outDir; //output directory
  final String outName; //output file name
  final List<String> preservedKeywords;
  final bool injectGenerationDateTime;
  final bool immediateTranslationEnabled;

  const SheetLocalization({
    this.docId,
    this.version = 1,
    this.outDir = 'resources/langs',
    this.lineSeparator = '\n',
    this.outName = 'langs.csv',
    this.preservedKeywords = const [],
    this.injectGenerationDateTime = true,
    this.immediateTranslationEnabled = true,
  });
}
