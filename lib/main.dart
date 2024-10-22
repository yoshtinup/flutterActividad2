import 'package:flutter/material.dart';
import 'Pages/HomePage.dart';
import 'Pages/GeolocationPage.dart'; // Importa la página de geolocalización
import 'Pages/QRScanPage.dart'; // Importa la página para escanear QR
import 'Pages/SensorsPage.dart'; // Importa la página de sensores
import 'Pages/SpeechToTextPage.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'ChatBot App',
      debugShowCheckedModeBanner: false,
      initialRoute: '/home',
      routes: {
        '/home': (context) => const HomePage(), // Ruta para la página principal
        '/geolocation': (context) => GeolocationPage(), // Ruta para la página de geolocalización
        '/qrscan': (context) => QRScanPage(), // Ruta para escanear QR
        '/sensors': (context) => SensorsPage(), // Ruta para la página de sensores
        '/speech_text' :(context) => SpeechTextPage(),
      },
    );
  }
}