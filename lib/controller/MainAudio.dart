import 'dart:convert';

import 'package:audio_service/audio_service.dart';
import 'package:audio_session/audio_session.dart';
import 'package:flutter_tts/flutter_tts.dart';
import 'package:get/instance_manager.dart';
import 'package:intl/intl.dart';
import 'package:localstorage/localstorage.dart';
import 'package:open_textview/controller/MainCtl.dart';

void textToSpeechTaskEntrypoint() async {
  AudioServiceBackground.run(() => TextPlayerTask());
}

class TextPlayerTask extends BackgroundAudioTask {
  FlutterTts tts = FlutterTts();

  final LocalStorage storage = new LocalStorage('opentextview');
  AudioSession session;
  bool _finished = false;
  bool _interrupted = false;

  List contents = [];
  Map<String, dynamic> params;

  bool get _playing => AudioServiceBackground.state.playing;

  // final ctl = Get.find<MainCtl>();
  @override
  Future<void> onStart(Map<String, dynamic> params) async {
    // ctl = Get.find<MainCtl>();
    session = await AudioSession.instance;
    await session.configure(AudioSessionConfiguration.speech());

    session.interruptionEventStream.listen((event) {
      print('interruptionEventStream : ${event.begin}');
      print('interruptionEventStream : ${event.type}');
    });
    Map ttsConf = params['tts'];
    await tts.awaitSpeakCompletion(true);
    await tts.setSpeechRate(ttsConf['speechRate']);
    await tts.setVolume(ttsConf['volume']);
    await tts.setPitch(ttsConf['pitch']);
    this.params = params;
    contents = params['contents'];
    // flutter_tts resets the AVAudioSession category to playAndRecord and the
    // options to defaultToSpeaker whenever this background isolate is loaded,
    // so we need to set our preferred audio session configuration here after
    // that has happened.
    // final session = await AudioSession.instance;
    // await session.configure(AudioSessionConfiguration.speech());
    // Handle audio interruptions.
    // session.interruptionEventStream.listen((event) {
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
  Future<void> onPlay() async {
    AudioServiceBackground.setState(controls: [
      MediaControl.pause,
      MediaControl.stop,
    ], playing: true, processingState: AudioProcessingState.buffering);

    // tts start
    Map ttsConf = params['tts'];
    var filterList = (params['filter'] as List)
        .where((element) => element['enable'])
        .toList();
    int count = ttsConf['groupcnt'].toInt();

    int historyIdx = params['history'].indexWhere((element) {
      return element['name'] == (params['picker'] as Map)['name'];
    });
    int curpos = params['history'][historyIdx]['pos'];
    for (var i = curpos; i < contents.length; i += count) {
      int endIdx = contents.length > i + count ? i + count : contents.length;
      String speakText = contents.getRange(i, endIdx).join('\n');
      filterList.forEach((e) {
        if (e['expr']) {
          speakText = speakText.replaceAllMapped(
              RegExp('${e["filter"]}'), (match) => e['to']);
        } else {
          speakText = speakText.replaceAll(e["filter"], e['to']);
        }
      });
      print(speakText);
      AudioServiceBackground.setMediaItem(MediaItem(
          id: 'tts_',
          album: 'TTS',
          title: params['picker']['name'],
          artist:
              '${i} / ${(i / contents.length * 100).toStringAsPrecision(2)}%',
          extras: {"pos": i}));
      await tts.speak(speakText);
      saveState(i);
    }
    // print('>>> ${speakText}');
    // print(speakText.split('\n'));

    return super.onPlay();
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
  Future<void> onPause() {
    AudioServiceBackground.setState(controls: [
      MediaControl.play,
      MediaControl.stop,
    ], playing: true, processingState: AudioProcessingState.ready);
    tts.stop();
  }

  @override
  Future<void> onStop() async {
    print('onStoponStoponStoponStop');
    super.onStop();
    AudioServiceBackground.setState(
        controls: [],
        playing: false,
        processingState: AudioProcessingState.none);
    tts.stop();
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

  Future<void> _playPause() async {
    // if (_playing) {
    //   _interrupted = false;
    //   await AudioServiceBackground.setState(
    //     controls: [MediaControl.play, MediaControl.stop],
    //     processingState: AudioProcessingState.ready,
    //     playing: false,
    //   );
    //   _sleeper.interrupt();
    //   _tts.interrupt();
    // } else {
    //   final session = await AudioSession.instance;
    //   // flutter_tts doesn't activate the session, so we do it here. This
    //   // allows the app to stop other apps from playing audio while we are
    //   // playing audio.
    //   if (await session.setActive(true)) {
    //     // If we successfully activated the session, set the state to playing
    //     // and resume playback.
    //     await AudioServiceBackground.setState(
    //       controls: [MediaControl.pause, MediaControl.stop],
    //       processingState: AudioProcessingState.ready,
    //       playing: true,
    //     );
    //     _sleeper.interrupt();
    //   }
    // }
  }
}
