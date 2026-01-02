import 'dart:async';
import 'dart:convert';
import 'package:http/http.dart' as http;
import '../../../core/constants/hospital_credentials.dart';

class HospitalScraperService {
  // Status stream to update UI
  final StreamController<String> _statusController = StreamController<String>.broadcast();
  Stream<String> get statusStream => _statusController.stream;

  bool _isCancelled = false;

  void stop() {
    _isCancelled = true;
    _statusController.add("Deteniendo...");
  }

  /// Conecta con el Robot (server.js) local para buscar datos
  Future<Map<String, dynamic>?> loginAndSearch(String patientDni) async {
    _isCancelled = false;
    _statusController.add("Contactando al Robot Local (${HospitalCredentials.robotUrl})...");

    try {
      // 1. Health Check
      try {
        final health = await http.get(Uri.parse(HospitalCredentials.robotUrl)).timeout(const Duration(seconds: 3));
        if (health.statusCode == 200) {
           _statusController.add("Robot detectado y online.");
        } else {
           throw Exception("Robot respondió con error ${health.statusCode}");
        }
      } catch (e) {
        _statusController.add("⚠ No se encuentra el Robot en ${HospitalCredentials.robotUrl}");
        _statusController.add("Asegúrate de ejecutar 'node server.js' en la terminal.");
        throw Exception("Robot desconectado");
      }

      if (_isCancelled) return null;

      // 2. Request Scraping
      _statusController.add("Enviando orden de búsqueda: DNI $patientDni...");
      final url = Uri.parse('${HospitalCredentials.robotUrl}/scrape/$patientDni');
      
      final response = await http.get(url).timeout(const Duration(minutes: 2)); // Give it time to scrape

      if (_isCancelled) return null;

      if (response.statusCode == 200) {
        final Map<String, dynamic> jsonResponse = jsonDecode(response.body);
        
        if (jsonResponse['success'] == true) {
           _statusController.add("¡Datos recibidos!");
           return jsonResponse['data']; // Returns structure with 'labs'
        } else {
           throw Exception(jsonResponse['error'] ?? "Error desconocido del robot");
        }
      } else {
         throw Exception("Error del servidor: ${response.statusCode}");
      }

    } catch (e) {
      if (!_isCancelled) {
        _statusController.add("Error: $e");
        rethrow;
      }
    }
    return null;
  }
}
