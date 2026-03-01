import 'dart:async';
import 'package:speech_to_text/speech_to_text.dart';
import 'package:speech_to_text/speech_recognition_result.dart';

/// Callback for when emergency keyword is detected
typedef EmergencyKeywordCallback = void Function();

/// Service for voice-based emergency detection
class VoiceDetectionService {
  static final VoiceDetectionService _instance = VoiceDetectionService._internal();
  factory VoiceDetectionService() => _instance;
  VoiceDetectionService._internal();

  final SpeechToText _speechToText = SpeechToText();
  bool _isInitialized = false;
  bool _isListening = false;
  EmergencyKeywordCallback? _onEmergencyDetected;

  // Emergency keywords to detect
  static const List<String> _emergencyKeywords = [
    'help',
    'sos',
    'emergency',
    'help me',
    'save me',
    'danger',
    'police',
    'help!',
    'sos!',
    'emergency!',
  ];

  /// Initialize speech recognition
  Future<bool> initialize() async {
    if (_isInitialized) return true;

    try {
      _isInitialized = await _speechToText.initialize(
        onError: (error) {
          // Handle error silently
        },
        onStatus: (status) {
          if (status == 'done' || status == 'notListening') {
            // Restart listening if it stopped unexpectedly
            if (_isListening && _onEmergencyDetected != null) {
              _startListening();
            }
          }
        },
      );
      return _isInitialized;
    } catch (e) {
      return false;
    }
  }

  /// Check if speech recognition is available
  Future<bool> isAvailable() async {
    if (!_isInitialized) {
      await initialize();
    }
    return _isInitialized;
  }

  /// Start listening for emergency keywords
  Future<bool> startListening({
    required EmergencyKeywordCallback onEmergencyDetected,
    Duration listenDuration = const Duration(seconds: 30),
  }) async {
    if (_isListening) return true;

    final available = await isAvailable();
    if (!available) return false;

    _onEmergencyDetected = onEmergencyDetected;
    _isListening = true;

    // Start continuous listening
    await _speechToText.listen(
      onResult: _onSpeechResult,
      listenFor: listenDuration,
      pauseFor: const Duration(seconds: 3),
      partialResults: true,
      localeId: 'en_US',
      cancelOnError: false,
      listenMode: ListenMode.confirmation,
    );

    return true;
  }

  /// Handle speech recognition result
  void _onSpeechResult(SpeechRecognitionResult result) {
    if (result.finalResult) {
      final String recognizedWords = result.recognizedWords.toLowerCase();
      
      // Check for emergency keywords
      for (final keyword in _emergencyKeywords) {
        if (recognizedWords.contains(keyword)) {
          _onEmergencyDetected?.call();
          break;
        }
      }
    }
  }

  /// Stop listening
  Future<void> stopListening() async {
    _isListening = false;
    await _speechToText.stop();
  }

  /// Get available locales
  Future<List<LocaleName>> getLocales() async {
    if (!_isInitialized) {
      await initialize();
    }
    return _speechToText.locales();
  }

  /// Check if currently listening
  bool get isListening => _isListening;

  /// Get emergency keywords
  List<String> get emergencyKeywords => _emergencyKeywords;
}
