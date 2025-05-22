import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:halo/halo.dart';
import 'package:zone/gen/l10n.dart';
import 'package:zone/model/demo_type.dart';
import 'package:zone/model/message.dart' as model;
import 'package:zone/state/p.dart';

class UserTtsContent extends ConsumerWidget {
  const UserTtsContent(this.msg, this.index, {super.key});

  final model.Message msg;
  final int index;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final s = S.of(context);
    final demoType = ref.watch(P.app.demoType);
    if (demoType != DemoType.tts) return const SizedBox.shrink();
    final primary = Theme.of(context).colorScheme.primary;
    return Co(
      c: CAA.start,
      children: [
        C(
          decoration: BD(
            color: kW.q(.5),
            borderRadius: 10.r,
            border: Border.all(
              color: primary,
              width: .5,
            ),
          ),
          padding: const EI.s(h: 6, v: 4),
          child: Text.rich(
            // c: CAA.start,
            TextSpan(
              children: [
                if (msg.ttsSourceAudioPath != null) ...[
                  TextSpan(text: s.according_to_the_following_audio_file),
                  TextSpan(text: P.tts.flagChange(msg.ttsSourceAudioPath!.split("/").last).replaceAll("_", " ")),
                ],
                if (msg.ttsSpeakerName != null) ...[
                  TextSpan(text: " 模仿 ${P.tts.safe(msg.ttsSpeakerName!)} 的声音"),
                ],
                if (msg.ttsSpeakerName == null && msg.ttsInstruction != null && msg.ttsInstruction!.isNotEmpty) ...[
                  TextSpan(text: msg.ttsInstruction!),
                ],
                if (msg.ttsCFMSteps != null) ...[
                  TextSpan(text: " CFM Steps: ${msg.ttsCFMSteps!}"),
                ],
              ],
            ),
          ),
        ),
        4.h,
        T(
          msg.ttsTarget,
          s: const TS(s: 16),
        ),
      ],
    );
  }
}
