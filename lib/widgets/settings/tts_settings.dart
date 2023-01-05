import 'package:acroulette/bloc/tts/tts_bloc.dart';
import 'package:acroulette/constants/settings.dart';
import 'package:acroulette/constants/widgets.dart';
import 'package:acroulette/widgets/formWidgets/heading.dart';
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
              child: Card(
                child: ListView(
                  shrinkWrap: true,
                  children: <Widget>[
                    const Heading(headingLabel: ttsText),
                    Text("Volume: ${ttsBloc.volume}"),
                    Padding(
                        padding: const EdgeInsets.symmetric(
                            vertical: size / 4, horizontal: size / 4),
                        child: Slider(
                            value: ttsBloc.volume,
                            onChanged: (newVolume) {
                              ttsBloc.volume = newVolume;
                            },
                            min: 0.0,
                            max: 1.0,
                            divisions: 10,
                            label: "Volume: ${ttsBloc.volume}")),
                    Text("Pitch: ${ttsBloc.pitch}"),
                    Padding(
                        padding: const EdgeInsets.symmetric(
                            vertical: size / 4, horizontal: size / 4),
                        child: Slider(
                          value: ttsBloc.pitch,
                          onChanged: (newPitch) {
                            ttsBloc.pitch = newPitch;
                          },
                          min: 0.5,
                          max: 2.0,
                          divisions: 15,
                          label: "Pitch: ${ttsBloc.pitch}",
                          activeColor: Colors.red,
                        )),
                    Text("Rate: ${ttsBloc.speechRate}"),
                    Padding(
                        padding: const EdgeInsets.symmetric(
                            vertical: size / 4, horizontal: size / 4),
                        child: Slider(
                          value: ttsBloc.speechRate,
                          onChanged: (newRate) {
                            ttsBloc.speechRate = newRate;
                          },
                          min: 0.0,
                          max: 1.0,
                          divisions: 10,
                          label: "Rate: ${ttsBloc.speechRate}",
                          activeColor: Colors.green,
                        )),
                    _languageSection(ttsBloc),
                    _engineSection(ttsBloc),
                    if (ttsBloc.isAndroid) ...[
                      _defaultEngine(ttsBloc),
                      _defaultVoice(ttsBloc),
                    ]
                  ],
                ),
              ));
        }));
  }
}

FutureBuilder<dynamic> _languageSection(TtsBloc ttsBloc) =>
    FutureBuilder<dynamic>(
        future: ttsBloc.languages,
        builder: (BuildContext context, AsyncSnapshot<dynamic> snapshot) {
          if (snapshot.hasData) {
            return _languageDropDownSection(snapshot.data, ttsBloc);
          } else if (snapshot.hasError) {
            return const Text('Error loading languages...');
          } else {
            return const Text('Loading Languages...');
          }
        });

Widget _languageDropDownSection(dynamic languages, TtsBloc ttsBloc) =>
    Column(children: [
      Row(
        children: [
          const Text("Speech language:"),
          DropdownButton<String?>(
            value: ttsBloc.language,
            items: getLanguageDropDownMenuItems(languages),
            onChanged: (value) => changedLanguageDropDownItem(value, ttsBloc),
          ),
        ],
      ),
      Visibility(
        visible: ttsBloc.isAndroid,
        child: Row(children: [
          Text("Is installed: ${ttsBloc.isCurrentLanguageInstalled}")
        ]),
      ),
    ]);

List<DropdownMenuItem<String>> getLanguageDropDownMenuItems(dynamic languages) {
  var items = <DropdownMenuItem<String>>[];
  for (dynamic type in languages) {
    items.add(
        DropdownMenuItem(value: type as String?, child: Text(type as String)));
  }
  return items;
}

void changedLanguageDropDownItem(String? selectedType, TtsBloc ttsBloc) {
  var language = selectedType!;
  ttsBloc.language = language;
}

Widget _engineSection(TtsBloc ttsBloc) {
  if (ttsBloc.isAndroid) {
    return FutureBuilder<dynamic>(
        future: ttsBloc.engines,
        builder: (BuildContext context, AsyncSnapshot<dynamic> snapshot) {
          if (snapshot.hasData) {
            return _enginesDropDownSection(snapshot.data, ttsBloc);
          } else if (snapshot.hasError) {
            return const Text('Error loading engines...');
          } else {
            return const Text('Loading engines...');
          }
        });
  } else {
    return const SizedBox(width: 0, height: 0);
  }
}

List<DropdownMenuItem<String>> getEnginesDropDownMenuItems(dynamic engines) {
  var items = <DropdownMenuItem<String>>[];
  for (dynamic type in engines) {
    items.add(
        DropdownMenuItem(value: type as String?, child: Text(type as String)));
  }
  return items;
}

void changedEnginesDropDownItem(String? selectedEngine, TtsBloc ttsBloc) async {
  ttsBloc.engine = selectedEngine!;
}

Widget _enginesDropDownSection(dynamic engines, TtsBloc ttsBloc) =>
    Row(mainAxisAlignment: MainAxisAlignment.center, children: [
      DropdownButton<String?>(
        value: ttsBloc.engine,
        items: getEnginesDropDownMenuItems(engines),
        onChanged: (value) => changedEnginesDropDownItem(value, ttsBloc),
      ),
    ]);

FutureBuilder<dynamic> _defaultEngine(TtsBloc ttsBloc) =>
    FutureBuilder<dynamic>(
        future: ttsBloc.defaultEngine,
        builder: (BuildContext context, AsyncSnapshot<dynamic> snapshot) {
          if (snapshot.hasData) {
            return Text("Default engine: ${snapshot.data}");
          } else if (snapshot.hasError) {
            return const Text('Error loading default engine.');
          } else {
            return const Text('Loading default engine...');
          }
        });

FutureBuilder<dynamic> _defaultVoice(TtsBloc ttsBloc) => FutureBuilder<dynamic>(
    future: ttsBloc.defaultVoice,
    builder: (BuildContext context, AsyncSnapshot<dynamic> snapshot) {
      if (snapshot.hasData) {
        return Text("Default voice: ${snapshot.data}");
      } else if (snapshot.hasError) {
        return const Text('Error default language.');
      } else {
        return const Text('Loading default language...');
      }
    });
