import 'dart:async';
import 'dart:convert';

import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:vitapmate/core/providers/settings.dart';
import 'package:vitapmate/core/utils/featureflags/feature_flags.dart';

part 'student_projects_provider.g.dart';

const defaultStudentProjectsPayloadJson = <String, Object?>{
  'schemaVersion': 2,
  'rotation': {'enabled': true, 'mode': 'withinCategory'},
  'cta': {
    'label': 'Want your project here? Contact @itsKryxen',
    'url': 'https://www.instagram.com/itsKryxen',
  },
  'categories': [
    {
      'id': 'academics',
      'label': 'Academics',
      'description': 'Study tools, grades, GPA, planning, and coursework.',
    },
    {
      'id': 'campus',
      'label': 'Campus',
      'description': 'Tools for travel, hostel life, clubs, and campus help.',
    },
    {
      'id': 'miscellaneous',
      'label': 'Miscellaneous',
      'description': 'Useful student-built experiments and utilities.',
    },
  ],
  'projects': [
    {
      'id': 1001,
      'name': 'GPA Calculator',
      'summary': 'Calculate GPA/CGPA quickly for VIT-AP students.',
      'type': 'Website',
      'category': 'academics',
      'madeBy': 'Venkatsubash07',
      'url': 'https://vitapcgpacalculator.vercel.app/',
      'previewImage': null,
      'sourceUrl': 'https://github.com/Venkatsubash07/vitapcgpacalculator',
      'status': 'active',
      'featured': false,
      'tags': ['GPA', 'CGPA'],
    },
    {
      'id': 1002,
      'name': 'GPA Calculator',
      'summary': 'VIT-AP GPA calculator app for VIT-AP students.',
      'type': 'App',
      'category': 'academics',
      'madeBy': 'Maddikeri Narendranath Reddy',
      'url': 'https://play.google.com/store/apps/details?id=com.gcalc.gcalcpro',
      'previewImage': null,
      'sourceUrl': null,
      'status': 'active',
      'featured': false,
      'tags': ['GPA', 'App'],
    },
    {
      'id': 1003,
      'name': 'VIT-AP Confessions',
      'summary': 'Anonymous confessions platform for VIT-AP students.',
      'type': 'Website',
      'category': 'miscellaneous',
      'madeBy': 'Abhay Agnihotri',
      'url': 'https://vit-ap-confessions.netlify.app',
      'previewImage': null,
      'sourceUrl': 'https://github.com/Notxabhay16/Vit-ap-confessions',
      'status': 'active',
      'featured': false,
      'tags': ['Anonymous', 'Community'],
    },
    {
      'id': 1004,
      'name': 'VIT-AP Travel Buddy',
      'summary': 'Travel planning and ride-sharing helper for VIT-AP students.',
      'type': 'Website',
      'category': 'campus',
      'madeBy': 'Srijita',
      'url': 'https://vitap-travel-buddy-beta.netlify.app/',
      'previewImage': null,
      'sourceUrl': null,
      'status': 'active',
      'featured': false,
      'tags': ['Travel', 'Rides'],
    },
    {
      'id': 1005,
      'name': 'VCampusGo',
      'summary':
          'Student utility portal for VIT-AP with faculty directory, PYQs, mess updates, and daily mail-style notifications.',
      'type': 'Website',
      'category': 'campus',
      'madeBy': 'Vyshrawan P',
      'url': 'https://vcampusgo.vercel.app',
      'previewImage': null,
      'sourceUrl': null,
      'status': 'active',
      'featured': false,
      'tags': ['Utilities', 'PYQs'],
    },
    {
      'id': 1006,
      'name': 'KnowYourFaculty',
      'summary':
          'Anonymous faculty reviews and ratings platform for VIT-AP students.',
      'type': 'Website',
      'category': 'academics',
      'madeBy': 'Jishith K',
      'url': 'https://knowyourfaculty.vercel.app',
      'previewImage': null,
      'sourceUrl': 'https://github.com/notvenu/KnowYourFaculty',
      'status': 'active',
      'featured': false,
      'tags': ['Faculty', 'Reviews'],
    },
    {
      'id': 1007,
      'name': 'Slotify',
      'summary':
          'Modern timetable builder for academics with clash detection, visual grid, and export options.',
      'type': 'Website',
      'category': 'academics',
      'madeBy': 'Venu K',
      'url': 'https://slotify.vercel.app',
      'previewImage': null,
      'sourceUrl': 'https://github.com/notvenu/slotify',
      'status': 'active',
      'featured': false,
      'tags': ['Timetable', 'Planner'],
    },
    {
      'id': 1008,
      'name': 'Campus Events',
      'summary':
          'Centralized event portal for VIT-AP students to discover upcoming campus events, key details, and schedules in one place.',
      'type': 'Website',
      'category': 'campus',
      'madeBy': 'Pranjal',
      'url': 'https://events.pranjalk.tech/',
      'previewImage': null,
      'sourceUrl': null,
      'status': 'active',
      'featured': false,
      'tags': ['Events', 'Campus'],
    },
    {
      'id': 1009,
      'name': 'GPA Calculator',
      'summary':
          'Simple GPA calculator for VIT-AP students to quickly compute semester GPA based on grades and credits.',
      'type': 'Website',
      'category': 'academics',
      'madeBy': 'Sai KondaReddy',
      'url': 'https://sai630414.github.io/gpa-calculator/index.html',
      'previewImage': null,
      'sourceUrl': null,
      'status': 'active',
      'featured': false,
      'tags': ['GPA', 'Credits'],
    },
    {
      'id': 1010,
      'name': 'Lost & Found Portal',
      'summary':
          'Campus lost-and-found portal for VIT-AP students to report, browse, and reconnect lost items with their owners.',
      'type': 'Website',
      'category': 'campus',
      'madeBy': 'Jayasree',
      'url': 'https://lost-found-cemp.vercel.app/',
      'previewImage': null,
      'sourceUrl': null,
      'status': 'active',
      'featured': false,
      'tags': ['Lost Found', 'Campus'],
    },
    {
      'id': 1011,
      'name': 'WeGoVroom',
      'summary':
          'Student app for VIT-AP with campus-focused utility features, available on the Play Store.',
      'type': 'App',
      'category': 'campus',
      'madeBy': 'WeGoVroom Team',
      'url': 'https://play.google.com/store/apps/details?id=com.wegovroom.app',
      'previewImage': null,
      'sourceUrl': null,
      'status': 'active',
      'featured': false,
      'tags': ['App', 'Utilities'],
    },
    {
      'id': 1012,
      'name': 'VIT-AP Updates',
      'summary':
          'Student portal for VIT-AP with mess menu, CGPA, attendance, and student-connect utilities in one place.',
      'type': 'Website',
      'category': 'campus',
      'madeBy': 'VIT-AP Updates Team',
      'url': 'https://lovevitap.purlyedit.in/student.php',
      'previewImage': null,
      'sourceUrl': null,
      'status': 'active',
      'featured': false,
      'tags': ['Mess', 'Updates'],
    },
  ],
};

final defaultStudentProjectsPayload = parseStudentProjectsPayloadV2(
  defaultStudentProjectsPayloadJson,
);

@riverpod
class StudentProjects extends _$StudentProjects {
  static const _cacheKey = 'settings_student_projects_json';
  static const _featureKey = 'student-projects';
  static const _rotationSeedKey = 'settings_student_projects_rotation_seed';

  @override
  Future<StudentProjectsPayload> build() async {
    final prefs = await ref.read(settingsProvider.future);
    final rotationSeed = prefs.getInt(_rotationSeedKey) ?? 0;
    final cached = await _readFromCache();
    final initial = _rotatePayload(cached, rotationSeed);
    await prefs.setInt(_rotationSeedKey, rotationSeed + 1);
    unawaited(_refreshFromGb(current: initial, rotationSeed: rotationSeed));
    return initial;
  }

  Future<void> refresh() async {
    final current = state.value ?? defaultStudentProjectsPayload;
    final prefs = await ref.read(settingsProvider.future);
    final nextRotationSeed = prefs.getInt(_rotationSeedKey) ?? 0;
    final activeRotationSeed = nextRotationSeed > 0 ? nextRotationSeed - 1 : 0;
    await _refreshFromGb(
      current: current,
      forceStateUpdate: true,
      rotationSeed: activeRotationSeed,
    );
  }

  Future<StudentProjectsPayload> _readFromCache() async {
    try {
      final prefs = await ref.read(settingsProvider.future);
      final raw = prefs.getString(_cacheKey);
      if (raw == null || raw.isEmpty) return defaultStudentProjectsPayload;
      return parseStudentProjectsPayloadV2(jsonDecode(raw));
    } catch (_) {
      return defaultStudentProjectsPayload;
    }
  }

  Future<void> _refreshFromGb({
    required StudentProjectsPayload current,
    required int rotationSeed,
    bool forceStateUpdate = false,
  }) async {
    try {
      final gb = await ref.read(gbProvider.future);
      throwIfDiscontinued(gb);
      final feature = gb.feature(_featureKey);
      if (!feature.on) return;

      final remotePayload = parseStudentProjectsPayloadV2(feature.value);
      final rotatedPayload = _rotatePayload(remotePayload, rotationSeed);
      final prefs = await ref.read(settingsProvider.future);
      await prefs.setString(_cacheKey, jsonEncode(remotePayload.toJson()));

      if (forceStateUpdate || current != rotatedPayload) {
        state = AsyncData(rotatedPayload);
      }
    } catch (_) {
      if (forceStateUpdate) {
        state = AsyncData(defaultStudentProjectsPayload);
      }
    }
  }

  StudentProjectsPayload _rotatePayload(
    StudentProjectsPayload payload,
    int rotationSeed,
  ) {
    if (!payload.rotation.enabled ||
        payload.rotation.mode != StudentProjectsRotationMode.withinCategory ||
        payload.projects.length < 2) {
      return payload;
    }

    final grouped = <String, List<StudentProject>>{
      for (final category in payload.categories)
        category.id: <StudentProject>[],
    };
    for (final project in payload.projects) {
      grouped[project.category]?.add(project);
    }

    return payload.copyWith(
      projects: [
        for (final category in payload.categories)
          ..._rotateCategory(grouped[category.id] ?? const [], rotationSeed),
      ],
    );
  }

  List<StudentProject> _rotateCategory(
    List<StudentProject> projects,
    int rotationSeed,
  ) {
    if (projects.length < 2) return projects;
    final offset = rotationSeed % projects.length;
    if (offset == 0) return projects;
    return [...projects.sublist(offset), ...projects.sublist(0, offset)];
  }
}

StudentProjectsPayload parseStudentProjectsPayloadV2(dynamic payload) {
  if (payload is! Map) {
    throw const FormatException('Student projects payload must be an object.');
  }
  final json = Map<String, dynamic>.from(payload);
  if (json['schemaVersion'] != 2) {
    throw const FormatException(
      'Student projects payload schemaVersion must be 2.',
    );
  }

  final categoriesRaw = json['categories'];
  final projectsRaw = json['projects'];
  if (categoriesRaw is! List || projectsRaw is! List) {
    throw const FormatException(
      'Student projects payload requires categories and projects.',
    );
  }

  final categories = <StudentProjectCategory>[];
  for (final item in categoriesRaw) {
    if (item is! Map) {
      throw const FormatException(
        'Student project category must be an object.',
      );
    }
    categories.add(
      StudentProjectCategory.fromJson(Map<String, dynamic>.from(item)),
    );
  }
  if (categories.isEmpty) {
    throw const FormatException(
      'Student projects payload requires categories.',
    );
  }

  final categoryIds = categories.map((category) => category.id).toSet();
  final projects = <StudentProject>[];
  for (final item in projectsRaw) {
    if (item is! Map) {
      throw const FormatException('Student project must be an object.');
    }
    final project = StudentProject.fromJson(Map<String, dynamic>.from(item));
    if (project.status == StudentProjectStatus.active &&
        categoryIds.contains(project.category)) {
      projects.add(project);
    }
  }

  return StudentProjectsPayload(
    schemaVersion: 2,
    rotation: StudentProjectsRotation.fromJson(json['rotation']),
    cta: StudentProjectsCta.fromJson(json['cta']),
    categories: categories,
    projects: projects,
  );
}

class StudentProjectsPayload {
  final int schemaVersion;
  final StudentProjectsRotation rotation;
  final StudentProjectsCta cta;
  final List<StudentProjectCategory> categories;
  final List<StudentProject> projects;

  const StudentProjectsPayload({
    required this.schemaVersion,
    required this.rotation,
    required this.cta,
    required this.categories,
    required this.projects,
  });

  StudentProjectsPayload copyWith({List<StudentProject>? projects}) {
    return StudentProjectsPayload(
      schemaVersion: schemaVersion,
      rotation: rotation,
      cta: cta,
      categories: categories,
      projects: projects ?? this.projects,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'schemaVersion': schemaVersion,
      'rotation': rotation.toJson(),
      'cta': cta.toJson(),
      'categories': categories.map((category) => category.toJson()).toList(),
      'projects': projects.map((project) => project.toJson()).toList(),
    };
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is StudentProjectsPayload &&
        other.schemaVersion == schemaVersion &&
        other.rotation == rotation &&
        other.cta == cta &&
        _sameList(other.categories, categories) &&
        _sameList(other.projects, projects);
  }

  @override
  int get hashCode {
    return Object.hash(
      schemaVersion,
      rotation,
      cta,
      Object.hashAll(categories),
      Object.hashAll(projects),
    );
  }
}

class StudentProjectCategory {
  final String id;
  final String label;
  final String description;

  const StudentProjectCategory({
    required this.id,
    required this.label,
    required this.description,
  });

  factory StudentProjectCategory.fromJson(Map<String, dynamic> json) {
    final id = json['id'];
    final label = json['label'];
    final description = json['description'];
    if (id is! String ||
        id.trim().isEmpty ||
        label is! String ||
        label.trim().isEmpty ||
        description is! String) {
      throw const FormatException('Invalid student project category.');
    }
    return StudentProjectCategory(
      id: id.trim(),
      label: label.trim(),
      description: description.trim(),
    );
  }

  Map<String, dynamic> toJson() {
    return {'id': id, 'label': label, 'description': description};
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is StudentProjectCategory &&
        other.id == id &&
        other.label == label &&
        other.description == description;
  }

  @override
  int get hashCode => Object.hash(id, label, description);
}

class StudentProjectsCta {
  final String label;
  final String url;

  const StudentProjectsCta({required this.label, required this.url});

  factory StudentProjectsCta.fromJson(dynamic raw) {
    if (raw is! Map) return defaultStudentProjectsCta;
    final json = Map<String, dynamic>.from(raw);
    final label = json['label'];
    final url = json['url'];
    if (label is! String ||
        label.trim().isEmpty ||
        url is! String ||
        Uri.tryParse(url.trim()) == null) {
      return defaultStudentProjectsCta;
    }
    return StudentProjectsCta(label: label.trim(), url: url.trim());
  }

  Map<String, dynamic> toJson() {
    return {'label': label, 'url': url};
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is StudentProjectsCta &&
        other.label == label &&
        other.url == url;
  }

  @override
  int get hashCode => Object.hash(label, url);
}

const defaultStudentProjectsCta = StudentProjectsCta(
  label: 'Want your project here? Contact @itsKryxen',
  url: 'https://www.instagram.com/itsKryxen',
);

class StudentProjectsRotation {
  final bool enabled;
  final StudentProjectsRotationMode mode;

  const StudentProjectsRotation({required this.enabled, required this.mode});

  factory StudentProjectsRotation.fromJson(dynamic raw) {
    if (raw is! Map) return StudentProjectsRotation.defaultValue();
    final json = Map<String, dynamic>.from(raw);
    return StudentProjectsRotation(
      enabled: json['enabled'] is bool ? json['enabled'] as bool : true,
      mode: StudentProjectsRotationMode.fromJson(json['mode']),
    );
  }

  factory StudentProjectsRotation.defaultValue() {
    return const StudentProjectsRotation(
      enabled: true,
      mode: StudentProjectsRotationMode.withinCategory,
    );
  }

  Map<String, dynamic> toJson() {
    return {'enabled': enabled, 'mode': mode.value};
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is StudentProjectsRotation &&
        other.enabled == enabled &&
        other.mode == mode;
  }

  @override
  int get hashCode => Object.hash(enabled, mode);
}

enum StudentProjectsRotationMode {
  withinCategory('withinCategory'),
  none('none');

  const StudentProjectsRotationMode(this.value);
  final String value;

  static StudentProjectsRotationMode fromJson(dynamic raw) {
    if (raw == none.value) return none;
    return withinCategory;
  }
}

enum StudentProjectStatus {
  active('active'),
  inactive('inactive');

  const StudentProjectStatus(this.value);
  final String value;

  static StudentProjectStatus fromJson(dynamic raw) {
    if (raw == active.value) return active;
    if (raw == inactive.value) return inactive;
    throw const FormatException('Invalid student project status.');
  }
}

class StudentProject {
  final int id;
  final String name;
  final String summary;
  final String type;
  final String category;
  final String madeBy;
  final String url;
  final String? previewImage;
  final String? sourceUrl;
  final StudentProjectStatus status;
  final bool featured;
  final List<String> tags;

  const StudentProject({
    required this.id,
    required this.name,
    required this.summary,
    required this.type,
    required this.category,
    required this.madeBy,
    required this.url,
    required this.previewImage,
    required this.sourceUrl,
    required this.status,
    required this.featured,
    required this.tags,
  });

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'summary': summary,
      'type': type,
      'category': category,
      'madeBy': madeBy,
      'url': url,
      'previewImage': previewImage,
      'sourceUrl': sourceUrl,
      'status': status.value,
      'featured': featured,
      'tags': tags,
    };
  }

  factory StudentProject.fromJson(Map<String, dynamic> json) {
    final id = json['id'];
    final name = json['name'];
    final summary = json['summary'];
    final type = json['type'];
    final category = json['category'];
    final madeBy = json['madeBy'];
    final url = json['url'];
    final previewImage = json['previewImage'];
    final sourceUrl = json['sourceUrl'];
    final status = json['status'];
    final featured = json['featured'];
    final tags = json['tags'];

    if (id is! num ||
        name is! String ||
        name.trim().isEmpty ||
        summary is! String ||
        summary.trim().isEmpty ||
        type is! String ||
        type.trim().isEmpty ||
        category is! String ||
        category.trim().isEmpty ||
        madeBy is! String ||
        madeBy.trim().isEmpty ||
        url is! String ||
        Uri.tryParse(url.trim()) == null) {
      throw const FormatException('Invalid student project.');
    }

    return StudentProject(
      id: id.toInt(),
      name: name.trim(),
      summary: summary.trim(),
      type: type.trim(),
      category: _normalizeCategory(category),
      madeBy: madeBy.trim(),
      url: url.trim(),
      previewImage: _optionalUrl(previewImage),
      sourceUrl: _optionalUrl(sourceUrl),
      status: StudentProjectStatus.fromJson(status),
      featured: featured is bool ? featured : false,
      tags: _parseTags(tags),
    );
  }

  static String? _optionalUrl(dynamic raw) {
    if (raw is! String || raw.trim().isEmpty) return null;
    final value = raw.trim();
    return Uri.tryParse(value) == null ? null : value;
  }

  static List<String> _parseTags(dynamic raw) {
    if (raw is! List) return const [];
    return raw
        .whereType<String>()
        .map((tag) => tag.trim())
        .where((tag) => tag.isNotEmpty)
        .toList(growable: false);
  }

  static String _normalizeCategory(String raw) {
    final value = raw.trim().toLowerCase();
    if (value == 'academic') return 'academics';
    if (value == 'misc' ||
        value == 'miscilanius' ||
        value == 'miscellaneouss') {
      return 'miscellaneous';
    }
    return value;
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is StudentProject &&
        other.id == id &&
        other.name == name &&
        other.summary == summary &&
        other.type == type &&
        other.category == category &&
        other.madeBy == madeBy &&
        other.url == url &&
        other.previewImage == previewImage &&
        other.sourceUrl == sourceUrl &&
        other.status == status &&
        other.featured == featured &&
        _sameList(other.tags, tags);
  }

  @override
  int get hashCode {
    return Object.hash(
      id,
      name,
      summary,
      type,
      category,
      madeBy,
      url,
      previewImage,
      sourceUrl,
      status,
      featured,
      Object.hashAll(tags),
    );
  }
}

bool _sameList<T>(List<T> a, List<T> b) {
  if (identical(a, b)) return true;
  if (a.length != b.length) return false;
  for (var i = 0; i < a.length; i++) {
    if (a[i] != b[i]) return false;
  }
  return true;
}
