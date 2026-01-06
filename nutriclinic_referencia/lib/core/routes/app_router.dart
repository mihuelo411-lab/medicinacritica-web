import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:nutrivigil/core/di/dependencies.dart';
import 'package:nutrivigil/presentation/home/home_page.dart';
import 'package:nutrivigil/presentation/monitoring/bloc/monitoring_bloc.dart';
import 'package:nutrivigil/presentation/monitoring/entries/monitoring_list_page.dart';
import 'package:nutrivigil/presentation/nutrition/calculators/calculator_hub_page.dart';
import 'package:nutrivigil/presentation/patient/bloc/patient_form_cubit.dart';
import 'package:nutrivigil/presentation/patient/bloc/patient_list_bloc.dart';
import 'package:nutrivigil/presentation/patient/patient_form_page.dart';
import 'package:nutrivigil/presentation/patient/patient_list_page.dart';
import 'package:nutrivigil/presentation/report/report_page.dart';
import 'package:nutrivigil/presentation/follow_up/follow_up_page.dart';
import 'package:nutrivigil/presentation/follow_up/patient_timeline_page.dart'; // Import added
import 'package:nutrivigil/presentation/splash/splash_page.dart';
import 'package:nutrivigil/presentation/weight_assessment/weight_assessment_page.dart';
import 'package:nutrivigil/presentation/nutrition/calculators/energy_calculator_page.dart';
import 'package:nutrivigil/presentation/nutrition/status/nutritional_status_page.dart';
import 'package:nutrivigil/presentation/nutrition/adjustment/energy_adjustment_page.dart';
import 'package:nutrivigil/presentation/nutrition/product_selector/formula_selector_page.dart';
import 'package:nutrivigil/presentation/summary/evaluation_summary_page.dart';

class AppRouter {
  static const String splash = '/splash';
  static const String home = '/';
  static const String patientList = '/patients';
  static const String patientForm = '/patients/new';
  static const String calculators = '/calculators';
  static const String monitoring = '/monitoring';
  static const String reports = '/reports';
  static const String weightAssessment = '/weightAssessment';
  static const String energyCalculator = '/energyCalculator';
  static const String energyAdjustment = '/nutrition/energy-adjustment';
  static const String formulaSelector = '/nutrition/formula-selector';
  static const String evaluationSummary = '/nutrition/evaluation-summary';
  static const String nutritionalStatus = '/nutritionalStatus';
  static const String followUp = '/followUp';
  static const String patientTimeline = '/followUp/timeline';

  static Route<dynamic> onGenerateRoute(RouteSettings settings) {
    switch (settings.name) {
      case splash:
        return MaterialPageRoute(builder: (_) => const SplashPage());
      case home:
        return MaterialPageRoute(builder: (_) => const HomePage());
      case patientList:
        return MaterialPageRoute(
          builder: (_) => BlocProvider(
            create: (_) =>
                PatientListBloc(sl())..add(const PatientsRequested()),
            child: const PatientListPage(),
          ),
        );
      case patientForm:
        final patientId = settings.arguments as String?;
        return MaterialPageRoute(
          builder: (_) => BlocProvider(
            create: (_) => PatientFormCubit(sl()),
            child: PatientFormPage(patientId: patientId),
          ),
        );
      case monitoring:
        final args = settings.arguments as MonitoringPageArgs;
        return MaterialPageRoute(
          builder: (_) => BlocProvider(
            create: (_) =>
                MonitoringBloc(sl())..add(MonitoringRequested(args.patientId)),
            child: MonitoringListPage(
              patientId: args.patientId,
              patientName: args.patientName,
            ),
          ),
        );
      case calculators:
        return MaterialPageRoute(builder: (_) => const CalculatorHubPage());
      case reports:
        return MaterialPageRoute(builder: (_) => const ReportPage());
      case followUp:
        // Reuse PatientListBloc for selection
        return MaterialPageRoute(
          builder: (_) => BlocProvider(
            create: (_) => PatientListBloc(sl())..add(const PatientsRequested()),
            child: const FollowUpPage(),
          ),
        );
      case patientTimeline:
        final patientId = settings.arguments as String;
        return MaterialPageRoute(
          builder: (_) => PatientTimelinePage(patientId: patientId),
        );
      case weightAssessment:
        final args = settings.arguments as WeightAssessmentPageArgs;
        return MaterialPageRoute(
          builder: (_) => WeightAssessmentPage(patientId: args.patientId),
        );
      case nutritionalStatus:
        final args = settings.arguments as NutritionalStatusPageArgs;
        return MaterialPageRoute(
          builder: (_) => NutritionalStatusPage(patientId: args.patientId),
        );
      case energyCalculator:
        final args = settings.arguments as EnergyCalculatorPageArgs?;
        return MaterialPageRoute(
          builder: (_) => EnergyCalculatorPage(
            initialPatientId: args?.patientId,
            initialWeightKg: args?.workWeightKg,
            initialHeightCm: args?.heightCm,
            initialAge: args?.age,
            initialIsMale: args?.isMale,
            initialPatientName: args?.patientName,
            initialRiskLabel: args?.riskLabel,
            initialRequiresVentilation: args?.requiresVentilation ?? false,
            initialTriglycerides: args?.triglycerides,
          ),
        );
      case energyAdjustment:
        final args = settings.arguments as EnergyAdjustmentPageArgs;
        return MaterialPageRoute(
          builder: (_) => EnergyAdjustmentPage(args: args),
        );
      case formulaSelector:
        final args = settings.arguments as FormulaSelectorPageArgs;
        return MaterialPageRoute(
          builder: (_) => FormulaSelectorPage(args: args),
        );
      case evaluationSummary:
        return MaterialPageRoute(
          builder: (_) => const EvaluationSummaryPage(),
        );
      default:
        return MaterialPageRoute(
          builder: (_) => const Scaffold(
            body: Center(child: Text('Ruta no encontrada')),
          ),
        );
    }
  }
}

class MonitoringPageArgs {
  MonitoringPageArgs({required this.patientId, required this.patientName});

  final String patientId;
  final String patientName;
}

class WeightAssessmentPageArgs {
  WeightAssessmentPageArgs({required this.patientId});

  final String patientId;
}

class NutritionalStatusPageArgs {
  NutritionalStatusPageArgs({required this.patientId});

  final String patientId;
}

class EnergyCalculatorPageArgs {
  EnergyCalculatorPageArgs({
    this.patientId,
    this.workWeightKg,
    this.heightCm,
    this.age,
    this.isMale,
    this.patientName,
    this.riskLabel,
    this.requiresVentilation,
    this.triglycerides,
  });

  final String? patientId;
  final double? workWeightKg;
  final double? heightCm;
  final int? age;
  final bool? isMale;
  final String? patientName;
  final String? riskLabel;
  final bool? requiresVentilation;
  final double? triglycerides;
}
