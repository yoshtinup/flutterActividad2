import 'package:flutter/material.dart';
import 'package:speech_to_text/speech_to_text.dart' as stt;
import 'package:flutter_tts/flutter_tts.dart';
import 'package:permission_handler/permission_handler.dart';

class SpeechTextPage extends StatefulWidget {
  @override
  _SpeechTextPageState createState() => _SpeechTextPageState();
}

class _SpeechTextPageState extends State<SpeechTextPage> {
  late stt.SpeechToText _speech;
  late FlutterTts _flutterTts;
  bool _isListening = false;
  String _text = 'Presiona el botón y empieza a hablar';
  String _manualText = ''; // Texto escrito manualmente
  double _confidence = 1.0;
  bool _speechEnabled = false;

  @override
  void initState() {
    super.initState();
    _speech = stt.SpeechToText();
    _flutterTts = FlutterTts();
    _requestPermissions();
  }

  Future<void> _requestPermissions() async {
    final status = await Permission.microphone.request();
    if (status.isGranted) {
      _initializeSpeech();
      _initializeTts();
    } else {
      _showError('Se requiere permiso del micrófono para usar esta función');
    }
  }

  void _initializeSpeech() async {
    try {
      _speechEnabled = await _speech.initialize(
        onStatus: (status) {
          if (status == 'notListening') {
            setState(() => _isListening = false);
          }
        },
        onError: (errorNotification) {
          _showError('Error: ${errorNotification.errorMsg}');
        },
      );
      setState(() {});
    } catch (e) {
      _showError('Error al inicializar el reconocimiento de voz');
    }
  }

  void _initializeTts() async {
    try {
      await _flutterTts.setLanguage("es-ES");
      await _flutterTts.setPitch(1.0);
      await _flutterTts.setSpeechRate(0.7);
      await _flutterTts.setVolume(1.0);
    } catch (e) {
      _showError('Error al inicializar TTS');
    }
  }

  void _showError(String message) {
    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(message),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  void _listen() async {
    if (!_speech.isAvailable) {
      _showError('El reconocimiento de voz no está disponible');
      return;
    }

    if (!_isListening) {
      try {
        bool available = await _speech.initialize();

        if (available) {
          setState(() => _isListening = true);
          await _speech.listen(
            onResult: (result) {
              setState(() {
                _text = result.recognizedWords;
                if (result.hasConfidenceRating && result.confidence > 0) {
                  _confidence = result.confidence;
                }
              });
            },
            localeId: "es-ES",
            listenMode: stt.ListenMode.dictation,
            cancelOnError: false,
            partialResults: true,
          );
        }
      } catch (e) {
        _showError('Error al iniciar el reconocimiento de voz');
      }
    } else {
      setState(() => _isListening = false);
      await _speech.stop();
    }
  }

  Future<void> _speak() async {
    String textToSpeak = _manualText.isNotEmpty ? _manualText : _text;

    if (textToSpeak.isNotEmpty) {
      try {
        await _flutterTts.stop();
        await _flutterTts.speak(textToSpeak);
      } catch (e) {
        _showError('Error al reproducir el texto');
      }
    }
  }

  @override
  void dispose() {
    _speech.stop();
    _flutterTts.stop();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Conversor Voz a Texto'),
        backgroundColor: Colors.black,
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: <Widget>[
            Text(
              _isListening ? 'Escuchando...' : 'No escuchando',
              style: TextStyle(
                color: _isListening ? Colors.greenAccent : Colors.redAccent,
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 20),
            Expanded(
              child: Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.black54,
                  borderRadius: BorderRadius.circular(12),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black38,
                      blurRadius: 10,
                      spreadRadius: 2,
                    ),
                  ],
                ),
                child: SingleChildScrollView(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Nivel de confianza: ${(_confidence * 100.0).toStringAsFixed(1)}%',
                        style: const TextStyle(fontSize: 16, color: Colors.white70),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        _text,
                        style: const TextStyle(fontSize: 24, color: Colors.white),
                      ),
                    ],
                  ),
                ),
              ),
            ),
            const SizedBox(height: 20),
            TextField(
              decoration: InputDecoration(
                filled: true,
                fillColor: Colors.black54,
                hintText: 'Escribe algo...',
                hintStyle: const TextStyle(color: Colors.white38),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              style: const TextStyle(color: Colors.white),
              onChanged: (value) {
                setState(() {
                  _manualText = value;
                });
              },
            ),
            const SizedBox(height: 20),
            Stack(
              alignment: Alignment.center,
              children: [
                FloatingActionButton(
                  onPressed: _listen,
                  child: Icon(_isListening ? Icons.mic : Icons.mic_none),
                  backgroundColor: _isListening ? Colors.redAccent : Colors.blueAccent,
                ),
                if (_isListening)
                  Container(
                    width: 80,
                    height: 80,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      border: Border.all(color: Colors.redAccent.withOpacity(0.5), width: 2),
                    ),
                  ),
              ],
            ),
            const SizedBox(height: 20),
            ElevatedButton.icon(
              icon: const Icon(Icons.volume_up),
              label: const Text(
                'Reproducir texto en voz alta',
                style: TextStyle(color: Colors.white),
              ),
              onPressed: _speak,
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.black,
                padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
              ),
            ),
          ],
        ),
      ),
      backgroundColor: Colors.black87,
    );
  }
}
