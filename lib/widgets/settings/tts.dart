import 'dart:developer';

import 'package:acroulette/bloc/tts/tts_bloc.dart';
import 'package:acroulette/constants/settings.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class TtsSettings extends StatefulWidget {
  final TtsBloc ttsBloc;

  const TtsSettings({Key? key, required this.ttsBloc}) : super(key: key);

  @override
  State<TtsSettings> createState() => _TtsSettings();
}

class _TtsSettings extends State<TtsSettings> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return BlocProvider.value(
        value: widget.ttsBloc,
        child: BlocBuilder<TtsBloc, TtsState>(buildWhen: (previous, current) {
          return true;
        }, builder: (BuildContext context, state) {
          TtsBloc ttsBloc = context.read<TtsBloc>();
          return Form(
            key: _formKey,
            child: ListView(
              shrinkWrap: true,
              children: <Widget>[
                const Text(ttsText),
                Slider(
                    value: ttsBloc.volume,
                    onChanged: (newVolume) {
                      ttsBloc.volume = newVolume;
                    },
                    min: 0.0,
                    max: 1.0,
                    divisions: 10,
                    label: "Volume: $ttsBloc.volume"),
                Slider(
                  value: ttsBloc.pitch,
                  onChanged: (newPitch) {
                    ttsBloc.pitch = newPitch;
                  },
                  min: 0.5,
                  max: 2.0,
                  divisions: 15,
                  label: "Pitch: $ttsBloc.pitch",
                  activeColor: Colors.red,
                ),
                Slider(
                  value: ttsBloc.speechRate,
                  onChanged: (newRate) {
                    ttsBloc.speechRate = newRate;
                  },
                  min: 0.0,
                  max: 1.0,
                  divisions: 10,
                  label: "Rate: $ttsBloc.speechRate",
                  activeColor: Colors.green,
                )
              ],
            ),
          );
        }));
  }
}
