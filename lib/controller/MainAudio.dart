import 'dart:math';

import 'package:audio_service/audio_service.dart';
import 'package:audio_session/audio_session.dart';
import 'package:flutter_tts/flutter_tts.dart';
import 'package:intl/intl.dart';
import 'package:localstorage/localstorage.dart';

void textToSpeechTaskEntrypoint() async {
  AudioServiceBackground.run(() => TextPlayerTask());
}

class TextPlayerTask extends BackgroundAudioTask {
  FlutterTts tts = FlutterTts();

  final LocalStorage storage = new LocalStorage('opentextview');
  AudioSession session;

  List contents = [];
  Map<String, dynamic> params;

  bool get _playing => AudioServiceBackground.state.playing;

  List filterList;
  // final ctl = Get.find<MainCtl>();

  @override
  Future<void> onStart(Map<String, dynamic> params) async {
    // ctl = Get.find<MainCtl>();
    AudioServiceBackground.androidForceEnableMediaButtons();

    session = await AudioSession.instance;
    await session.configure(AudioSessionConfiguration.speech());
    session.becomingNoisyEventStream.listen((_) {
      onPause();
    });
    session.interruptionEventStream.listen((event) {
      if (event.type == AudioInterruptionType.pause) {
        if (event.begin) {
          onPause();
        } else {
          onPlay();
        }
        return;
      }
      if (event.begin && event.type == AudioInterruptionType.unknown) {
        if (params['tts']['audiosession']) {
          onPause();
        } else {}
      }
    });

    Map ttsConf = params['tts'];
    await tts.awaitSpeakCompletion(true);
    await tts.setSpeechRate(ttsConf['speechRate']);
    await tts.setVolume(ttsConf['volume']);
    await tts.setPitch(ttsConf['pitch']);

    this.params = params;
    contents = params['contents'];

    filterList = (params['filter'] as List)
        .where((element) => element['enable'])
        .toList();

    // flutter_tts resets the AVAudioSession category to playAndRecord and the
    // options to defaultToSpeaker whenever this background isolate is loaded,
    // so we need to set our preferred audio session configuration here after
    // that has happened.
    // final session = await AudioSession.instance;
    // await session.configure(AudioSessionConfiguration.speech());
    // Handle audio interruptions.
    // session.interruptionEventStream.listen((event) {
    //   print('event.begin : ${event.begin}');
    //   print('event.type : ${event.type}');

    //   if (event.begin) {
    //     if (_playing) {
    //       onPause();
    //       _interrupted = true;
    //     }
    //   } else {
    //     switch (event.type) {
    //       case AudioInterruptionType.pause:
    //       case AudioInterruptionType.duck:
    //         if (!_playing && _interrupted) {
    //           onPlay();
    //         }
    //         break;
    //       case AudioInterruptionType.unknown:
    //         break;
    //     }
    //     _interrupted = false;
    //   }
    // });
    // Handle unplugged headphones.
    // session.becomingNoisyEventStream.listen((_) {
    //   if (_playing) onPause();
    // });

    // _completer.complete();
    // super.onStart(params);
    return;
  }

  @override
  Future onCustomAction(String name, arguments) async {
    if (name == 'tts') {
      await tts.setSpeechRate(arguments['speechRate']);
      await tts.setVolume(arguments['volume']);
      await tts.setPitch(arguments['pitch']);
      params['tts'] = arguments;
    }
    if (name == 'filter') {
      filterList =
          (arguments as List).where((element) => element['enable']).toList();
    }

    return super.onCustomAction(name, arguments);
  }

  @override
  Future<void> onPlay() async {
    if (!await session.setActive(true)) {
      return;
    }
    // if (await session.setActive(true)) {
    //   // Now play audio.
    // } else {
    //   // The request was denied and the app should not play audio
    // }
    AudioServiceBackground.setState(
      controls: [
        MediaControl.pause,
        MediaControl.stop,
      ],
      playing: true,
      processingState: AudioProcessingState.buffering,
    );

    // tts start
    Map ttsConf = params['tts'];

    int count = ttsConf['groupcnt'].toInt();

    int historyIdx = params['history'].indexWhere((element) {
      return element['name'] == (params['picker'] as Map)['name'];
    });
    int curpos = params['history'][historyIdx]['pos'];
    for (var i = curpos; i < contents.length; i += count) {
      count = params['tts']['groupcnt'].toInt();

      int endIdx = contents.length > i + count ? i + count : contents.length;
      String speakText = contents.getRange(i, endIdx).join('\n');

      filterList.forEach((e) {
        if (e['expr'] != null && e['expr']) {
          speakText = speakText.replaceAllMapped(
              RegExp('${e["filter"] ?? ""}'), (match) => e['to'] ?? "");
        } else {
          speakText = speakText.replaceAll(e["filter"] ?? "", e['to'] ?? "");
        }
      });
      AudioServiceBackground.setMediaItem(MediaItem(
          id: 'tts_',
          album: 'TTS',
          title: params['picker']['name'],
          artist:
              '${i} / ${(i / max(1, contents.length) * 100).toStringAsPrecision(2)}%',
          extras: {"pos": i},
          duration: Duration(seconds: max(1, contents.length))));
      AudioServiceBackground.setState(
        controls: [
          MediaControl.pause,
          MediaControl.stop,
        ],
        playing: true,
        processingState: AudioProcessingState.buffering,
        position: Duration(seconds: i),
      );
      await tts.speak(speakText);
      saveState(i);
    }

    onStop();
    return super.onPlay();
  }

  @override
  Future<void> onClick(MediaButton button) {
    if (params['tts']['headsetbutton']) {
      if (AudioServiceBackground.state.playing) {
        onPause();
      } else {
        onPlay();
      }
    }

    // return super.onClick(button);
  }

  void saveState(int idx) async {
    int historyIdx = params['history'].indexWhere((element) {
      return element['name'] == (params['picker'] as Map)['name'];
    });
    if (await storage.ready) {
      DateTime now = DateTime.now();
      DateFormat formatter = new DateFormat('yyyy-MM-dd hh-mm-ss');
      params['history'][historyIdx]['date'] = formatter.format(now);
      params['history'][historyIdx]['pos'] = idx;
      await storage.setItem('history', params['history']);
    }
  }

  @override
  Future<void> onPause() async {
    // await session.setActive(true);

    AudioServiceBackground.setState(controls: [
      MediaControl.play,
      MediaControl.stop,
    ], playing: false, processingState: AudioProcessingState.ready);
    tts.stop();
  }

  @override
  Future<void> onStop() async {
    await session.setActive(false);
    AudioServiceBackground.setState(
        controls: [],
        playing: false,
        processingState: AudioProcessingState.none);
    tts.stop();
    super.onStop();
    // super.cacheManager.emptyCache();
    // Signal the speech to stop
    // _finished = true;
    // _sleeper.interrupt();
    // _tts.interrupt();
    // // Wait for the speech to stop
    // await _completer.future;
    // // Shut down this task
    // await super.onStop();
  }
}
