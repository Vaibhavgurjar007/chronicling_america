import 'package:flutter/foundation.dart';
import 'package:flutter_tts/flutter_tts.dart';

class AudioService extends ChangeNotifier {
  // Instance of FlutterTts for text-to-speech functionality
  final FlutterTts _flutterTts = FlutterTts();

  // Indicates whether audio is currently playing
  bool _isPlaying = false;

  // Holds the text that is currently being spoken
  String? _currentText;

  // Constructor to initialize the audio service and set up handlers
  AudioService() {
    // Handler called when speech starts
    _flutterTts.setStartHandler(() {
      _isPlaying = true;
      notifyListeners(); // Notify listeners that the state has changed
    });

    // Handler called when speech completes
    _flutterTts.setCompletionHandler(() {
      _isPlaying = false;
      _currentText = null;
      notifyListeners(); // Notify listeners that the state has changed
    });

    // Handler called when an error occurs
    _flutterTts.setErrorHandler((error) {
      _isPlaying = false;
      _currentText = null;
      notifyListeners(); // Notify listeners that the state has changed
    });
  }

  // Getter to check if audio is currently playing
  bool get isPlaying => _isPlaying;

  // Getter to retrieve the current text being spoken
  String? get currentText => _currentText;

  // Holds the ID of the item currently being spoken
  String? _currentPlayingItemId;

  // Getter to retrieve the ID of the item currently being spoken
  String? get currentPlayingItemId => _currentPlayingItemId;

  /// Starts speaking the provided text if it is not already being spoken
  ///
  /// [text] - The text to be spoken.
  /// [itemId] - The ID of the item associated with the text.
  ///
  /// Ensures that the text is spoken only if it differs from the current text
  /// or if no text is currently being spoken.
  Future<void> speak(String text, String itemId) async {
    // Check if the text is already being spoken
    if (_currentText == text && _isPlaying) return;

    _currentPlayingItemId = itemId; // Set the ID of the currently playing item
    _currentText = text; // Set the text to be spoken
    _isPlaying = true; // Update the playing state

    // Start speaking the text
    await _flutterTts.speak(text);
    notifyListeners(); // Notify listeners that the state has changed
  }

  /// Pauses the current speech
  ///
  /// Stops the speech if it is currently playing and updates the state
  Future<void> pause() async {
    // Check if audio is not currently playing
    if (!_isPlaying) return;

    _currentPlayingItemId = null; // Clear the ID of the currently playing item
    _isPlaying = false; // Update the playing state

    // Stop the speech
    await _flutterTts.stop();
    notifyListeners(); // Notify listeners that the state has changed
  }
}
