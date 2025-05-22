import 'dart:io';
import 'package:flutter/material.dart';
import 'package:halo/halo.dart';
import 'package:halo_state/halo_state.dart';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:zone/model/message.dart';
import 'package:zone/route/router.dart';
import 'package:zone/state/p.dart';

void dumpChatMessages() async {
  qq;

  // Request storage permission
  var status = await Permission.storage.status;
  if (!status.isGranted) {
    status = await Permission.storage.request();
  }

  if (!status.isGranted) {
    // Handle the case where permission is not granted
    ScaffoldMessenger.of(getContext()!).showSnackBar(const SnackBar(content: T("Storage permission not granted")));
    return;
  }

  final messages = P.chat.messages.q;
  final List<String> imagePaths = [];
  String content = "";
  for (final m in messages) {
    final type = m.type;
    switch (type) {
      case MessageType.text:
        content += m.isMine ? "User:\n" : "Bot:\n";
        content += m.content + "\n";
        break;
      case MessageType.userImage:
        if (m.imageUrl != null && m.imageUrl!.isNotEmpty) {
          imagePaths.add(m.imageUrl!);
        }
        break;
      case MessageType.userAudio:
      case MessageType.userTTS:
      case MessageType.ttsGeneration:
        break;
    }
  }

  Directory? externalDir;
  if (Platform.isAndroid) {
    externalDir = Directory("/storage/emulated/0/Download");
    // Alternatively, use getExternalStorageDirectory() from path_provider
    // externalDir = await getExternalStorageDirectory();
  } else if (Platform.isIOS) {
    externalDir = await getApplicationDocumentsDirectory();
  }

  if (externalDir == null) {
    ScaffoldMessenger.of(getContext()!).showSnackBar(const SnackBar(content: T("Could not get external directory")));
    return;
  }

  final timestamp = DateTime.now().millisecondsSinceEpoch;
  final newDirPath = '${externalDir.path}/ChatDump_$timestamp';
  final newDir = Directory(newDirPath);
  await newDir.create(recursive: true);

  // Save text content
  final textFile = File('${newDir.path}/chat_log.txt');
  await textFile.writeAsString(content);

  // Save images
  for (int i = 0; i < imagePaths.length; i++) {
    final imagePath = imagePaths[i];
    final originalFile = File(imagePath);
    if (await originalFile.exists()) {
      final fileName = imagePath.split('/').last;
      final newImagePath = '${newDir.path}/$fileName';
      await originalFile.copy(newImagePath);
    }
  }

  ScaffoldMessenger.of(getContext()!).showSnackBar(
    SnackBar(content: T('Files saved to ${newDir.path}')),
  );
}
