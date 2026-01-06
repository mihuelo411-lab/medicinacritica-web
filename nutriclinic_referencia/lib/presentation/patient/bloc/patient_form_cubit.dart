import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:nutrivigil/data/repositories/patient_repository.dart';
import 'package:nutrivigil/domain/patient/patient_entity.dart';

class PatientFormState extends Equatable {
  const PatientFormState({
    this.patient,
    this.isSaving = false,
    this.saveSuccess = false,
    this.error,
  });

  final PatientProfile? patient;
  final bool isSaving;
  final bool saveSuccess;
  final String? error;

  PatientFormState copyWith({
    PatientProfile? patient,
    bool? isSaving,
    bool? saveSuccess,
    String? error,
  }) {
    return PatientFormState(
      patient: patient ?? this.patient,
      isSaving: isSaving ?? this.isSaving,
      saveSuccess: saveSuccess ?? this.saveSuccess,
      error: error,
    );
  }

  @override
  List<Object?> get props => [patient, isSaving, saveSuccess, error];
}

class PatientFormCubit extends Cubit<PatientFormState> {
  PatientFormCubit(this._repository) : super(const PatientFormState());

  final PatientRepository _repository;

  Future<void> loadPatient(String? id) async {
    if (id == null) {
      emit(state.copyWith(patient: _emptyPatient()));
      return;
    }
    try {
      final patient = await _repository.fetchById(id);
      emit(state.copyWith(patient: patient));
    } catch (error) {
      emit(state.copyWith(error: error.toString()));
    }
  }

  Future<void> save(PatientProfile profile) async {
    emit(state.copyWith(isSaving: true, error: null, saveSuccess: false));
    try {
      final trimmedName = profile.fullName.trim();
      if (trimmedName.isEmpty) {
        throw Exception('El nombre del paciente es obligatorio');
      }
      final patientToSave = profile.copyWith(
        id: profile.id.isEmpty ? trimmedName : profile.id,
        fullName: trimmedName,
      );
      await _repository.save(patientToSave);
      emit(state.copyWith(
          isSaving: false, saveSuccess: true, patient: patientToSave));
    } catch (error) {
      emit(state.copyWith(isSaving: false, error: error.toString()));
    }
  }

  PatientProfile _emptyPatient() {
    return const PatientProfile(
      id: '',
      fullName: '',
      age: 0,
      sex: '',
      diagnosis: '',
      weightKg: 0,
      heightCm: 0,
      bedNumber: null,
    );
  }
}
