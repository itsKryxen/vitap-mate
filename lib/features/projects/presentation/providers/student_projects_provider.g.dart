// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'student_projects_provider.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(StudentProjects)
final studentProjectsProvider = StudentProjectsProvider._();

final class StudentProjectsProvider
    extends $AsyncNotifierProvider<StudentProjects, StudentProjectsPayload> {
  StudentProjectsProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'studentProjectsProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$studentProjectsHash();

  @$internal
  @override
  StudentProjects create() => StudentProjects();
}

String _$studentProjectsHash() => r'eac7521d9310a70b8328cb019acb761d1f5ecda9';

abstract class _$StudentProjects
    extends $AsyncNotifier<StudentProjectsPayload> {
  FutureOr<StudentProjectsPayload> build();
  @$mustCallSuper
  @override
  void runBuild() {
    final ref =
        this.ref
            as $Ref<AsyncValue<StudentProjectsPayload>, StudentProjectsPayload>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<
                AsyncValue<StudentProjectsPayload>,
                StudentProjectsPayload
              >,
              AsyncValue<StudentProjectsPayload>,
              Object?,
              Object?
            >;
    element.handleCreate(ref, build);
  }
}
