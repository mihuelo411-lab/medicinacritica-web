import 'package:nutrivigil/core/notifications/notification_service.dart';
import 'package:nutrivigil/data/repositories/alert_repository.dart';
import 'package:nutrivigil/data/repositories/monitoring_repository.dart';
import 'package:nutrivigil/data/repositories/nutrition_repository.dart';
import 'package:nutrivigil/data/repositories/patient_repository.dart';
import 'package:nutrivigil/domain/alerts/alert_entity.dart';

class AlertEngine {
  AlertEngine(
    this._patientRepository,
    this._monitoringRepository,
    this._nutritionRepository,
    this._alertRepository,
    this._notificationService,
  );

  final PatientRepository _patientRepository;
  final MonitoringRepository _monitoringRepository;
  final NutritionRepository _nutritionRepository;
  final AlertRepository _alertRepository;
  final NotificationService _notificationService;

  Future<void> evaluate() async {
    final patients = await _patientRepository.fetchAll();
    for (final patient in patients) {
      final entries = await _monitoringRepository.fetchByPatient(patient.id);
      if (entries.isEmpty) {
        await _registerAlert(
          AlertItem(
            id: '',
            patientId: patient.id,
            type: 'datos_faltantes',
            message: 'No hay registros diarios para ${patient.fullName}.',
            createdAt: DateTime.now(),
            dueDate: DateTime.now(),
          ),
        );
        continue;
      }
      entries.sort((a, b) => b.date.compareTo(a.date));
      final latest = entries.first;
      final now = DateTime.now();
      if (now.difference(latest.date).inDays >= 3) {
        await _registerAlert(
          AlertItem(
            id: '',
            patientId: patient.id,
            type: 'datos_faltantes',
            message: 'Registra datos para ${patient.fullName}; han pasado más de 3 días.',
            createdAt: now,
            dueDate: latest.date.add(const Duration(days: 3)),
          ),
        );
      }

      final targets = await _nutritionRepository.historyForPatient(patient.id);
      if (targets.isNotEmpty && latest.caloricIntakeKcal != null) {
        final latestTarget = targets.first;
        if (latest.caloricIntakeKcal! < latestTarget.caloriesPerDay * 0.7) {
          await _registerAlert(
            AlertItem(
              id: '',
              patientId: patient.id,
              type: 'aporte_bajo',
              message: 'Aporte calórico <70% para ${patient.fullName}.',
              createdAt: now,
              dueDate: now,
            ),
          );
        }
      }

      if (latest.triglyceridesMgDl != null && latest.triglyceridesMgDl! >= 400) {
        await _registerAlert(
          AlertItem(
            id: '',
            patientId: patient.id,
            type: 'hipertrigliceridemia',
            message: 'Triglicéridos elevados en ${patient.fullName}.',
            createdAt: now,
            dueDate: now,
          ),
        );
      }

      if (latest.glucoseMax != null && latest.glucoseMax! >= 180) {
        await _registerAlert(
          AlertItem(
            id: '',
            patientId: patient.id,
            type: 'hiperglucemia',
            message: 'Glucosa máxima elevada en ${patient.fullName}.',
            createdAt: now,
            dueDate: now,
          ),
        );
      }
    }
  }

  Future<void> _registerAlert(AlertItem alert) async {
    await _alertRepository.save(alert);
    await _notificationService.showSimple(
      id: alert.hashCode,
      title: 'Alerta Nutricional',
      body: alert.message,
    );
  }
}
