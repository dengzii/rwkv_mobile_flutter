import 'dart:ui';

import 'package:zone/args.dart';
import 'package:zone/route/page_key.dart';

const kBG = Color(0xFFF4F8FF);

abstract class Config {
  // TODO: 根据 args 决定
  static final firstPage = PageKey.chat.name;

  // TODO: @wangce 需要有一个统一的标识来决定当前的 App 正在运行什么逻辑

  static const prompt = """<EOD>User: hi

Assistant: Hi. I am your assistant and I will provide expert full response in full details. Please feel free to ask any question and I will always answer it.

""";

  static const promptCN = """<EOD>User: 你好

Assistant: 你好，我是你的助手，我会提供专家级的完整回答。请随时提问，我会一直回答。

""";

  static const reasonTag = "reason";
  static const enableConversation = false && Args.isChat;
  static const enableChain = false && Args.isChat;

  static const domain = "https://api-model.rwkvos.com";
  static const timeout = Duration(seconds: 60);
  static late final String xApiKey;
  static const appTitle = "RWKV Chat";
}
