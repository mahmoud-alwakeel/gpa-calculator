import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:uuid/uuid.dart';

import '../../data/local/gpa_local_data_source.dart';
import '../../domain/entities/course.dart';
import '../../domain/entities/semester.dart';
import '../../domain/usecases/calculate_gpa.dart';
import 'gpa_event.dart';
import 'gpa_state.dart';

class GpaBloc extends Bloc<GpaEvent, GpaState> {
  final CalculateGpa _calculateGpa;
  final GpaLocalDataSource? _dataSource;
  final Uuid _uuid = const Uuid();
  int _semesterCounter = 1;

  GpaBloc({CalculateGpa? calculateGpa, GpaLocalDataSource? dataSource})
      : _calculateGpa = calculateGpa ?? CalculateGpa(),
        _dataSource = dataSource,
        super(const GpaState()) {
    on<AddSemester>(_onAddSemester);
    on<RemoveSemester>(_onRemoveSemester);
    on<ToggleSemesterExpansion>(_onToggleSemesterExpansion);
    on<AddCourse>(_onAddCourse);
    on<RemoveCourse>(_onRemoveCourse);
    on<UpdateCourseName>(_onUpdateCourseName);
    on<UpdateCourseCredits>(_onUpdateCourseCredits);
    on<UpdateCourseGrade>(_onUpdateCourseGrade);
    on<UpdatePriorGpa>(_onUpdatePriorGpa);
    on<UpdatePriorCredits>(_onUpdatePriorCredits);
    on<CalculateGpaEvent>(_onCalculate);
    on<ResetAll>(_onReset);
    on<LoadSavedData>(_onLoadSavedData);

    // Try to load saved data, fall back to default semester
    add(LoadSavedData());
  }

  Semester _createSemester() {
    return Semester(
      id: _uuid.v4(),
      label: 'Semester ${_semesterCounter++}',
      courses: [Course(id: _uuid.v4())],
    );
  }

  GpaState _recompute(GpaState newState) {
    final result = _calculateGpa(
      semesters: newState.semesters,
      priorGpa: newState.priorGpa,
      priorCredits: newState.priorCredits,
    );
    return newState.copyWith(liveResult: result);
  }

  void _save(GpaState state) {
    _dataSource?.save(
      semesters: state.semesters,
      priorGpa: state.priorGpa,
      priorCredits: state.priorCredits,
      semesterCounter: _semesterCounter,
    );
  }

  List<Semester> _updateCourse(
    List<Semester> semesters,
    String semesterId,
    String courseId,
    Course Function(Course) update,
  ) {
    return semesters.map((s) {
      if (s.id != semesterId) return s;
      return s.copyWith(
        courses: s.courses.map((c) {
          if (c.id != courseId) return c;
          return update(c);
        }).toList(),
      );
    }).toList();
  }

  void _onLoadSavedData(LoadSavedData event, Emitter<GpaState> emit) {
    final data = _dataSource?.load();
    if (data != null) {
      final semesters = (data['semesters'] as List)
          .map((s) => Semester.fromJson(s as Map<String, dynamic>))
          .toList();
      _semesterCounter = data['semesterCounter'] as int? ?? semesters.length + 1;
      final newState = GpaState(
        semesters: semesters,
        priorGpa: (data['priorGpa'] as num?)?.toDouble(),
        priorCredits: data['priorCredits'] as int?,
      );
      emit(_recompute(newState));
    } else {
      // No saved data — start with one default semester
      final newState = GpaState(semesters: [_createSemester()]);
      emit(_recompute(newState));
    }
  }

  void _onAddSemester(AddSemester event, Emitter<GpaState> emit) {
    final newSemesters = [...state.semesters, _createSemester()];
    final newState = _recompute(state.copyWith(semesters: newSemesters));
    _save(newState);
    emit(newState);
  }

  void _onRemoveSemester(RemoveSemester event, Emitter<GpaState> emit) {
    final newSemesters =
        state.semesters.where((s) => s.id != event.semesterId).toList();
    final newState = _recompute(state.copyWith(semesters: newSemesters));
    _save(newState);
    emit(newState);
  }

  void _onToggleSemesterExpansion(
    ToggleSemesterExpansion event,
    Emitter<GpaState> emit,
  ) {
    final newSemesters = state.semesters.map((s) {
      if (s.id != event.semesterId) return s;
      return s.copyWith(isExpanded: !s.isExpanded);
    }).toList();
    emit(state.copyWith(semesters: newSemesters));
  }

  void _onAddCourse(AddCourse event, Emitter<GpaState> emit) {
    final newSemesters = state.semesters.map((s) {
      if (s.id != event.semesterId) return s;
      return s.copyWith(
        courses: [...s.courses, Course(id: _uuid.v4())],
      );
    }).toList();
    final newState = _recompute(state.copyWith(semesters: newSemesters));
    _save(newState);
    emit(newState);
  }

  void _onRemoveCourse(RemoveCourse event, Emitter<GpaState> emit) {
    final newSemesters = state.semesters.map((s) {
      if (s.id != event.semesterId) return s;
      return s.copyWith(
        courses: s.courses.where((c) => c.id != event.courseId).toList(),
      );
    }).toList();
    final newState = _recompute(state.copyWith(semesters: newSemesters));
    _save(newState);
    emit(newState);
  }

  void _onUpdateCourseName(UpdateCourseName event, Emitter<GpaState> emit) {
    final newSemesters = _updateCourse(
      state.semesters,
      event.semesterId,
      event.courseId,
      (c) => c.copyWith(name: event.name),
    );
    final newState = state.copyWith(semesters: newSemesters);
    _save(newState);
    emit(newState);
  }

  void _onUpdateCourseCredits(
    UpdateCourseCredits event,
    Emitter<GpaState> emit,
  ) {
    final newSemesters = _updateCourse(
      state.semesters,
      event.semesterId,
      event.courseId,
      (c) => c.copyWith(credits: event.credits),
    );
    final newState = _recompute(state.copyWith(semesters: newSemesters));
    _save(newState);
    emit(newState);
  }

  void _onUpdateCourseGrade(UpdateCourseGrade event, Emitter<GpaState> emit) {
    final newSemesters = _updateCourse(
      state.semesters,
      event.semesterId,
      event.courseId,
      (c) => c.copyWith(grade: event.grade),
    );
    final newState = _recompute(state.copyWith(semesters: newSemesters));
    _save(newState);
    emit(newState);
  }

  void _onUpdatePriorGpa(UpdatePriorGpa event, Emitter<GpaState> emit) {
    final newState = _recompute(
      event.priorGpa == null
          ? state.copyWith(clearPriorGpa: true)
          : state.copyWith(priorGpa: event.priorGpa),
    );
    _save(newState);
    emit(newState);
  }

  void _onUpdatePriorCredits(
    UpdatePriorCredits event,
    Emitter<GpaState> emit,
  ) {
    final newState = _recompute(
      event.priorCredits == null
          ? state.copyWith(clearPriorCredits: true)
          : state.copyWith(priorCredits: event.priorCredits),
    );
    _save(newState);
    emit(newState);
  }

  void _onCalculate(CalculateGpaEvent event, Emitter<GpaState> emit) {
    final hasGradedCourse = state.semesters.any(
      (s) => s.courses.any((c) => c.grade != null),
    );

    if (!hasGradedCourse) {
      emit(state.copyWith(
        errorMessage: 'Please add at least one course with a grade selected',
        clearConfirmedResult: true,
      ));
      return;
    }

    final result = _calculateGpa(
      semesters: state.semesters,
      priorGpa: state.priorGpa,
      priorCredits: state.priorCredits,
    );

    emit(state.copyWith(
      confirmedResult: result,
      clearErrorMessage: true,
    ));
  }

  void _onReset(ResetAll event, Emitter<GpaState> emit) {
    _semesterCounter = 1;
    _dataSource?.clear();
    final semester = _createSemester();
    final newState = GpaState(semesters: [semester]);
    emit(_recompute(newState));
  }
}
