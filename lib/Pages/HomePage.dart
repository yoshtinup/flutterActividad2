import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

class HomePage extends StatelessWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black, // Fondo del Scaffold en negro
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [Colors.black, Color.fromARGB(255, 20, 20, 20)], // Degradado oscuro más suave
          ),
        ),
        child: SafeArea(
          child: Center(
            child: SingleChildScrollView(
              padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 50),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  _buildInfoCard(context), // Tarjeta de información con botones
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  // Tarjeta que contiene la información de la universidad y los botones
  Widget _buildInfoCard(BuildContext context) {
    return Card(
      elevation: 12,
      color: const Color.fromARGB(255, 45, 45, 45), // Fondo más oscuro para la tarjeta
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(25),
      ),
      child: Padding(
        padding: const EdgeInsets.all(25),
        child: Column(
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(50),
              child: Image.asset(
                'assets/logo_universidad.png', // Logo de la universidad
                height: 100,
                width: 100,
                fit: BoxFit.cover,
              ),
            ),
            const SizedBox(height: 20),
            Text(
              'Universidad Politécnica de Chiapas',
              style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                    fontWeight: FontWeight.bold,
                    color: Colors.white, // Texto en blanco
                  ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 10),
            const Divider(color: Colors.white54), // Divisor más claro
            const SizedBox(height: 10),
            _buildInfoText('Carrera: Ingeniería en Software'),
            _buildInfoText('Materia: PROGRAMACIÓN PARA MÓVILES II'),
            _buildInfoText('Grupo: B'),
            _buildInfoText('Nombre: Yoshitn German Gutierrez Perez'),
            _buildInfoText('Matrícula: 221246'),
            const SizedBox(height: 20),
            
            // Aquí están los botones dentro de la misma tarjeta
            _buildCustomButton(
              label: 'Ver Repositorio en GitHub',
              color: Colors.grey[800]!,
              onPressed: () async {
                const url = 'https://github.com/tu-repositorio';
                if (await canLaunchUrl(Uri.parse(url))) {
                  await launchUrl(Uri.parse(url));
                } else {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text('No se pudo abrir el enlace de GitHub'),
                    ),
                  );
                }
              },
            ),
            const SizedBox(height: 15),
            _buildCustomButton(
              label: 'Geolocalización',
              color: Colors.grey[700]!,
              onPressed: () {
                Navigator.pushNamed(context, '/geolocation'); // Redirige a la página de geolocalización
              },
            ),
            const SizedBox(height: 15),
            _buildCustomButton(
              label: 'Escanear QR',
              color: Colors.grey[600]!,
              onPressed: () {
                Navigator.pushNamed(context, '/qrscan'); // Redirige a la página de escanear QR
              },
            ),
            const SizedBox(height: 15),
            _buildCustomButton(
              label: 'Sensores',
              color: Colors.grey[700]!,
              onPressed: () {
                Navigator.pushNamed(context, '/sensors'); // Redirige a la página de sensores
              },
            ),
            const SizedBox(height: 15),
            _buildCustomButton(
              label: 'Speech to Text y Text to Speech',
              color: Colors.grey[800]!,
              onPressed: () {
                Navigator.pushNamed(context, '/speech_text'); // Redirige a la nueva vista combinada
              },
            ),
          ],
        ),
      ),
    );
  }

  // Botones individuales dentro de la tarjeta de información
  Widget _buildCustomButton({
    required String label,
    required Color color,
    required VoidCallback onPressed,
  }) {
    return SizedBox(
      width: double.infinity, // Ancho completo para todos los botones
      child: ElevatedButton(
        child: Text(
          label,
          style: const TextStyle(color: Colors.white, fontSize: 16),
        ),
        style: ElevatedButton.styleFrom(
          backgroundColor: color, // Fondo del botón en color gris
          padding: const EdgeInsets.symmetric(vertical: 15), // Tamaño uniforme de los botones
          textStyle: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(30),
          ),
          shadowColor: Colors.black.withOpacity(0.3), // Sombra más suave
          elevation: 10,
        ),
        onPressed: onPressed,
      ),
    );
  }

  // Texto de la tarjeta de información
  Widget _buildInfoText(String text) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 5),
      child: Text(
        text,
        style: const TextStyle(fontSize: 16, color: Colors.white70), // Texto en blanco grisáceo
        textAlign: TextAlign.center,
      ),
    );
  }
}
