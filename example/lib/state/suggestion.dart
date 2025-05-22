part of 'p.dart';

class _Suggestion {
  final suggestions = qs<List<String>>([]);

  FV loadSuggestions() async {
    final demoType = P.app.demoType.q;
    final isChat = demoType == DemoType.chat;
    if (!isChat && demoType != DemoType.tts) return;
    final shouldUseEn =
        P.preference.preferredLanguage.q.resolved.locale.languageCode != "zh";

    const head = "assets/config/chat/suggestions";
    final lang = shouldUseEn ? ".en-US" : ".zh-hans";
    final suffix = kDebugMode ? ".debug" : "";

    final assetPath = "$head$lang$suffix.json";

    final jsonString = await rootBundle.loadString(assetPath);
    final list = HF.list(jsonDecode(jsonString));
    final s = list
        .map((e) {
          if (isChat) {
            return jsonEncode(e);
          } else {
            return e.toString().replaceAll("🚧", "");
          }
        })
        .shuffled()
        .take(3)
        .toList();
    suggestions.q = s;

    if (kDebugMode) {
      // Merge suggestions
      final anotherAssetPath = "$head$lang$suffix.json";
      final anotherJsonString = await rootBundle.loadString(anotherAssetPath);
      final anotherList = HF.list(jsonDecode(anotherJsonString));
      final anotherSuggestions = anotherList.map((e) {
        if (isChat) {
          return jsonEncode(e);
        } else {
          return e.toString().replaceAll("🚧", "");
        }
      }).toList();
      suggestions.ul(anotherSuggestions);
    }

    suggestions.q = suggestions.q.shuffled.take(3).toList();
  }
}

/// Private methods
extension _$Suggestion on _Suggestion {
  FV _init() async {
    qq;
  }
}

/// Public methods
extension $Suggestion on _Suggestion {}
