import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/services.dart';

enum AppSound { thud, lidOpen, fanSpread, cardTap, screenOpen, boxClose }

class SoundService {
  static final SoundService _i = SoundService._();
  factory SoundService() => _i;
  SoundService._();

  bool enabled = true;

  static const _files = {
    AppSound.thud:       'audio/thud.wav',
    AppSound.lidOpen:    'audio/lid_open.wav',
    AppSound.fanSpread:  'audio/fan_spread.wav',
    AppSound.cardTap:    'audio/card_tap.wav',
    AppSound.screenOpen: 'audio/screen_open.wav',
    AppSound.boxClose:   'audio/box_close.wav',
  };

  static const _haptics = {
    AppSound.thud:       _HapticType.heavy,
    AppSound.lidOpen:    _HapticType.medium,
    AppSound.fanSpread:  _HapticType.light,
    AppSound.cardTap:    _HapticType.selection,
    AppSound.screenOpen: _HapticType.light,
    AppSound.boxClose:   _HapticType.medium,
  };

  Future<void> play(AppSound sound, {double volume = 1.0}) async {
    _triggerHaptic(_haptics[sound]!);
    if (!enabled) return;
    try {
      final player = AudioPlayer();
      await player.setVolume(volume.clamp(0.0, 1.0));
      await player.play(AssetSource(_files[sound]!));
      player.onPlayerComplete.listen((_) => player.dispose());
    } catch (_) {}
  }

  void _triggerHaptic(_HapticType type) {
    switch (type) {
      case _HapticType.heavy:
        HapticFeedback.heavyImpact();
      case _HapticType.medium:
        HapticFeedback.mediumImpact();
      case _HapticType.light:
        HapticFeedback.lightImpact();
      case _HapticType.selection:
        HapticFeedback.selectionClick();
    }
  }
}

enum _HapticType { heavy, medium, light, selection }
