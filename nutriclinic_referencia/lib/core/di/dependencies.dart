import 'package:get_it/get_it.dart';

import 'package:nutrivigil/data/local/app_database.dart';
import 'package:nutrivigil/data/local/daos/alert_dao.dart';
import 'package:nutrivigil/data/local/daos/monitoring_dao.dart';
import 'package:nutrivigil/data/local/daos/nutrition_target_dao.dart';
import 'package:nutrivigil/data/local/daos/patient_dao.dart';
import 'package:nutrivigil/data/local/daos/weight_assessment_dao.dart';
import 'package:nutrivigil/data/local/daos/nutritional_assessment_dao.dart';
import 'package:nutrivigil/data/local/daos/energy_plan_dao.dart';
import 'package:nutrivigil/data/repositories/alert_repository.dart';
import 'package:nutrivigil/data/repositories/impl/alert_repository_impl.dart';
import 'package:nutrivigil/data/repositories/impl/monitoring_repository_impl.dart';
import 'package:nutrivigil/data/repositories/impl/nutrition_repository_impl.dart';
import 'package:nutrivigil/data/repositories/impl/patient_repository_impl.dart';
import 'package:nutrivigil/data/repositories/impl/weight_assessment_repository_impl.dart';
import 'package:nutrivigil/data/repositories/impl/nutritional_assessment_repository_impl.dart';
import 'package:nutrivigil/data/repositories/impl/energy_plan_repository_impl.dart';
import 'package:nutrivigil/data/repositories/monitoring_repository.dart';
import 'package:nutrivigil/data/repositories/nutrition_repository.dart';
import 'package:nutrivigil/data/repositories/patient_repository.dart';
import 'package:nutrivigil/data/repositories/nutritional_assessment_repository.dart';
import 'package:nutrivigil/data/repositories/weight_assessment_repository.dart';
import 'package:nutrivigil/data/repositories/energy_plan_repository.dart';
import 'package:nutrivigil/data/repositories/report_history_repository.dart';
import 'package:nutrivigil/data/repositories/impl/report_history_repository_impl.dart';
import 'package:nutrivigil/core/notifications/notification_service.dart';
import 'package:nutrivigil/domain/alerts/alert_engine.dart';
import 'package:nutrivigil/domain/patient/services/weight_assessment_service.dart';
import 'package:nutrivigil/domain/reporting/report_service.dart';
import 'package:nutrivigil/domain/nutrition/services/nutritional_scoring_service.dart';
import 'package:nutrivigil/domain/nutrition/services/energy_adjustment_service.dart';
import 'package:nutrivigil/domain/nutrition/services/formula_service.dart';
import 'package:nutrivigil/domain/care_episode/care_episode_cubit.dart';
import 'package:shared_preferences/shared_preferences.dart';

final GetIt sl = GetIt.instance;

class Dependencies {
  static Future<void> register() async {
    // Base de datos Drift
    sl.registerLazySingleton<AppDatabase>(AppDatabase.new);

    // DAOs
    sl.registerLazySingleton<PatientDao>(() => PatientDao(sl<AppDatabase>()));
    sl.registerLazySingleton<MonitoringDao>(() => MonitoringDao(sl<AppDatabase>()));
    sl.registerLazySingleton<NutritionTargetDao>(() => NutritionTargetDao(sl<AppDatabase>()));
    sl.registerLazySingleton<AlertDao>(() => AlertDao(sl<AppDatabase>()));
    sl.registerLazySingleton<WeightAssessmentDao>(() => WeightAssessmentDao(sl<AppDatabase>()));
    sl.registerLazySingleton<NutritionalAssessmentDao>(
        () => NutritionalAssessmentDao(sl<AppDatabase>()));
    sl.registerLazySingleton<EnergyPlanDao>(() => EnergyPlanDao(sl<AppDatabase>()));

    // Repositorios
    sl.registerLazySingleton<PatientRepository>(() => PatientRepositoryImpl(sl()));
    sl.registerLazySingleton<MonitoringRepository>(() => MonitoringRepositoryImpl(sl()));
    sl.registerLazySingleton<NutritionRepository>(() => NutritionRepositoryImpl(sl()));
    sl.registerLazySingleton<AlertRepository>(() => AlertRepositoryImpl(sl()));
    sl.registerLazySingleton<WeightAssessmentRepository>(() => WeightAssessmentRepositoryImpl(sl()));
    sl.registerLazySingleton<NutritionalAssessmentRepository>(
        () => NutritionalAssessmentRepositoryImpl(sl()));
    sl.registerLazySingleton<EnergyPlanRepository>(() => EnergyPlanRepositoryImpl(sl()));
    sl.registerLazySingleton<ReportHistoryRepository>(
      () => ReportHistoryRepositoryImpl(SharedPreferences.getInstance()),
    );

    // Servicios
    sl.registerLazySingleton<NotificationService>(NotificationService.new);
    sl.registerLazySingleton<ReportService>(
      () => ReportService(
        sl<PatientRepository>(),
        sl<NutritionRepository>(),
        sl<NutritionalAssessmentRepository>(),
        sl<EnergyPlanRepository>(),
      ),
    );
    sl.registerLazySingleton<AlertEngine>(() => AlertEngine(sl(), sl(), sl(), sl(), sl()));
    sl.registerLazySingleton<WeightAssessmentService>(WeightAssessmentService.new);
    sl.registerLazySingleton<NutritionalScoringService>(NutritionalScoringService.new);
    sl.registerLazySingleton<EnergyAdjustmentService>(EnergyAdjustmentService.new);
    sl.registerLazySingleton<FormulaService>(FormulaService.new);
    sl.registerSingleton<CareEpisodeCubit>(CareEpisodeCubit());
  }
}
