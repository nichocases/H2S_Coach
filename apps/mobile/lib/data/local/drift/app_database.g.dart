// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'app_database.dart';

// ignore_for_file: type=lint
class $CoachesTable extends Coaches with TableInfo<$CoachesTable, Coach> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $CoachesTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
    'id',
    aliasedName,
    false,
    additionalChecks: GeneratedColumn.checkTextLength(),
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _displayNameMeta = const VerificationMeta(
    'displayName',
  );
  @override
  late final GeneratedColumn<String> displayName = GeneratedColumn<String>(
    'display_name',
    aliasedName,
    false,
    additionalChecks: GeneratedColumn.checkTextLength(
      minTextLength: 1,
      maxTextLength: 120,
    ),
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _createdAtMeta = const VerificationMeta(
    'createdAt',
  );
  @override
  late final GeneratedColumn<DateTime> createdAt = GeneratedColumn<DateTime>(
    'created_at',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _updatedAtMeta = const VerificationMeta(
    'updatedAt',
  );
  @override
  late final GeneratedColumn<DateTime> updatedAt = GeneratedColumn<DateTime>(
    'updated_at',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _versionMeta = const VerificationMeta(
    'version',
  );
  @override
  late final GeneratedColumn<int> version = GeneratedColumn<int>(
    'version',
    aliasedName,
    false,
    check: () => ComparableExpr(version).isBiggerOrEqualValue(1),
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultValue: const Constant(1),
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    displayName,
    createdAt,
    updatedAt,
    version,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'coaches';
  @override
  VerificationContext validateIntegrity(
    Insertable<Coach> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('display_name')) {
      context.handle(
        _displayNameMeta,
        displayName.isAcceptableOrUnknown(
          data['display_name']!,
          _displayNameMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_displayNameMeta);
    }
    if (data.containsKey('created_at')) {
      context.handle(
        _createdAtMeta,
        createdAt.isAcceptableOrUnknown(data['created_at']!, _createdAtMeta),
      );
    } else if (isInserting) {
      context.missing(_createdAtMeta);
    }
    if (data.containsKey('updated_at')) {
      context.handle(
        _updatedAtMeta,
        updatedAt.isAcceptableOrUnknown(data['updated_at']!, _updatedAtMeta),
      );
    } else if (isInserting) {
      context.missing(_updatedAtMeta);
    }
    if (data.containsKey('version')) {
      context.handle(
        _versionMeta,
        version.isAcceptableOrUnknown(data['version']!, _versionMeta),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  Coach map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return Coach(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}id'],
      )!,
      displayName: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}display_name'],
      )!,
      createdAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}created_at'],
      )!,
      updatedAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}updated_at'],
      )!,
      version: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}version'],
      )!,
    );
  }

  @override
  $CoachesTable createAlias(String alias) {
    return $CoachesTable(attachedDatabase, alias);
  }
}

class Coach extends DataClass implements Insertable<Coach> {
  final String id;
  final String displayName;
  final DateTime createdAt;
  final DateTime updatedAt;
  final int version;
  const Coach({
    required this.id,
    required this.displayName,
    required this.createdAt,
    required this.updatedAt,
    required this.version,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['display_name'] = Variable<String>(displayName);
    map['created_at'] = Variable<DateTime>(createdAt);
    map['updated_at'] = Variable<DateTime>(updatedAt);
    map['version'] = Variable<int>(version);
    return map;
  }

  CoachesCompanion toCompanion(bool nullToAbsent) {
    return CoachesCompanion(
      id: Value(id),
      displayName: Value(displayName),
      createdAt: Value(createdAt),
      updatedAt: Value(updatedAt),
      version: Value(version),
    );
  }

  factory Coach.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return Coach(
      id: serializer.fromJson<String>(json['id']),
      displayName: serializer.fromJson<String>(json['displayName']),
      createdAt: serializer.fromJson<DateTime>(json['createdAt']),
      updatedAt: serializer.fromJson<DateTime>(json['updatedAt']),
      version: serializer.fromJson<int>(json['version']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'displayName': serializer.toJson<String>(displayName),
      'createdAt': serializer.toJson<DateTime>(createdAt),
      'updatedAt': serializer.toJson<DateTime>(updatedAt),
      'version': serializer.toJson<int>(version),
    };
  }

  Coach copyWith({
    String? id,
    String? displayName,
    DateTime? createdAt,
    DateTime? updatedAt,
    int? version,
  }) => Coach(
    id: id ?? this.id,
    displayName: displayName ?? this.displayName,
    createdAt: createdAt ?? this.createdAt,
    updatedAt: updatedAt ?? this.updatedAt,
    version: version ?? this.version,
  );
  Coach copyWithCompanion(CoachesCompanion data) {
    return Coach(
      id: data.id.present ? data.id.value : this.id,
      displayName: data.displayName.present
          ? data.displayName.value
          : this.displayName,
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
      updatedAt: data.updatedAt.present ? data.updatedAt.value : this.updatedAt,
      version: data.version.present ? data.version.value : this.version,
    );
  }

  @override
  String toString() {
    return (StringBuffer('Coach(')
          ..write('id: $id, ')
          ..write('displayName: $displayName, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt, ')
          ..write('version: $version')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode =>
      Object.hash(id, displayName, createdAt, updatedAt, version);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is Coach &&
          other.id == this.id &&
          other.displayName == this.displayName &&
          other.createdAt == this.createdAt &&
          other.updatedAt == this.updatedAt &&
          other.version == this.version);
}

class CoachesCompanion extends UpdateCompanion<Coach> {
  final Value<String> id;
  final Value<String> displayName;
  final Value<DateTime> createdAt;
  final Value<DateTime> updatedAt;
  final Value<int> version;
  final Value<int> rowid;
  const CoachesCompanion({
    this.id = const Value.absent(),
    this.displayName = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.updatedAt = const Value.absent(),
    this.version = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  CoachesCompanion.insert({
    required String id,
    required String displayName,
    required DateTime createdAt,
    required DateTime updatedAt,
    this.version = const Value.absent(),
    this.rowid = const Value.absent(),
  }) : id = Value(id),
       displayName = Value(displayName),
       createdAt = Value(createdAt),
       updatedAt = Value(updatedAt);
  static Insertable<Coach> custom({
    Expression<String>? id,
    Expression<String>? displayName,
    Expression<DateTime>? createdAt,
    Expression<DateTime>? updatedAt,
    Expression<int>? version,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (displayName != null) 'display_name': displayName,
      if (createdAt != null) 'created_at': createdAt,
      if (updatedAt != null) 'updated_at': updatedAt,
      if (version != null) 'version': version,
      if (rowid != null) 'rowid': rowid,
    });
  }

  CoachesCompanion copyWith({
    Value<String>? id,
    Value<String>? displayName,
    Value<DateTime>? createdAt,
    Value<DateTime>? updatedAt,
    Value<int>? version,
    Value<int>? rowid,
  }) {
    return CoachesCompanion(
      id: id ?? this.id,
      displayName: displayName ?? this.displayName,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      version: version ?? this.version,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (displayName.present) {
      map['display_name'] = Variable<String>(displayName.value);
    }
    if (createdAt.present) {
      map['created_at'] = Variable<DateTime>(createdAt.value);
    }
    if (updatedAt.present) {
      map['updated_at'] = Variable<DateTime>(updatedAt.value);
    }
    if (version.present) {
      map['version'] = Variable<int>(version.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('CoachesCompanion(')
          ..write('id: $id, ')
          ..write('displayName: $displayName, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt, ')
          ..write('version: $version, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $TeamsTable extends Teams with TableInfo<$TeamsTable, Team> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $TeamsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
    'id',
    aliasedName,
    false,
    additionalChecks: GeneratedColumn.checkTextLength(),
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _nameMeta = const VerificationMeta('name');
  @override
  late final GeneratedColumn<String> name = GeneratedColumn<String>(
    'name',
    aliasedName,
    false,
    additionalChecks: GeneratedColumn.checkTextLength(
      minTextLength: 1,
      maxTextLength: 120,
    ),
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _categoryMeta = const VerificationMeta(
    'category',
  );
  @override
  late final GeneratedColumn<String> category = GeneratedColumn<String>(
    'category',
    aliasedName,
    true,
    additionalChecks: GeneratedColumn.checkTextLength(maxTextLength: 80),
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _createdAtMeta = const VerificationMeta(
    'createdAt',
  );
  @override
  late final GeneratedColumn<DateTime> createdAt = GeneratedColumn<DateTime>(
    'created_at',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _updatedAtMeta = const VerificationMeta(
    'updatedAt',
  );
  @override
  late final GeneratedColumn<DateTime> updatedAt = GeneratedColumn<DateTime>(
    'updated_at',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _versionMeta = const VerificationMeta(
    'version',
  );
  @override
  late final GeneratedColumn<int> version = GeneratedColumn<int>(
    'version',
    aliasedName,
    false,
    check: () => ComparableExpr(version).isBiggerOrEqualValue(1),
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultValue: const Constant(1),
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    name,
    category,
    createdAt,
    updatedAt,
    version,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'teams';
  @override
  VerificationContext validateIntegrity(
    Insertable<Team> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('name')) {
      context.handle(
        _nameMeta,
        name.isAcceptableOrUnknown(data['name']!, _nameMeta),
      );
    } else if (isInserting) {
      context.missing(_nameMeta);
    }
    if (data.containsKey('category')) {
      context.handle(
        _categoryMeta,
        category.isAcceptableOrUnknown(data['category']!, _categoryMeta),
      );
    }
    if (data.containsKey('created_at')) {
      context.handle(
        _createdAtMeta,
        createdAt.isAcceptableOrUnknown(data['created_at']!, _createdAtMeta),
      );
    } else if (isInserting) {
      context.missing(_createdAtMeta);
    }
    if (data.containsKey('updated_at')) {
      context.handle(
        _updatedAtMeta,
        updatedAt.isAcceptableOrUnknown(data['updated_at']!, _updatedAtMeta),
      );
    } else if (isInserting) {
      context.missing(_updatedAtMeta);
    }
    if (data.containsKey('version')) {
      context.handle(
        _versionMeta,
        version.isAcceptableOrUnknown(data['version']!, _versionMeta),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  Team map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return Team(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}id'],
      )!,
      name: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}name'],
      )!,
      category: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}category'],
      ),
      createdAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}created_at'],
      )!,
      updatedAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}updated_at'],
      )!,
      version: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}version'],
      )!,
    );
  }

  @override
  $TeamsTable createAlias(String alias) {
    return $TeamsTable(attachedDatabase, alias);
  }
}

class Team extends DataClass implements Insertable<Team> {
  final String id;
  final String name;
  final String? category;
  final DateTime createdAt;
  final DateTime updatedAt;
  final int version;
  const Team({
    required this.id,
    required this.name,
    this.category,
    required this.createdAt,
    required this.updatedAt,
    required this.version,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['name'] = Variable<String>(name);
    if (!nullToAbsent || category != null) {
      map['category'] = Variable<String>(category);
    }
    map['created_at'] = Variable<DateTime>(createdAt);
    map['updated_at'] = Variable<DateTime>(updatedAt);
    map['version'] = Variable<int>(version);
    return map;
  }

  TeamsCompanion toCompanion(bool nullToAbsent) {
    return TeamsCompanion(
      id: Value(id),
      name: Value(name),
      category: category == null && nullToAbsent
          ? const Value.absent()
          : Value(category),
      createdAt: Value(createdAt),
      updatedAt: Value(updatedAt),
      version: Value(version),
    );
  }

  factory Team.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return Team(
      id: serializer.fromJson<String>(json['id']),
      name: serializer.fromJson<String>(json['name']),
      category: serializer.fromJson<String?>(json['category']),
      createdAt: serializer.fromJson<DateTime>(json['createdAt']),
      updatedAt: serializer.fromJson<DateTime>(json['updatedAt']),
      version: serializer.fromJson<int>(json['version']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'name': serializer.toJson<String>(name),
      'category': serializer.toJson<String?>(category),
      'createdAt': serializer.toJson<DateTime>(createdAt),
      'updatedAt': serializer.toJson<DateTime>(updatedAt),
      'version': serializer.toJson<int>(version),
    };
  }

  Team copyWith({
    String? id,
    String? name,
    Value<String?> category = const Value.absent(),
    DateTime? createdAt,
    DateTime? updatedAt,
    int? version,
  }) => Team(
    id: id ?? this.id,
    name: name ?? this.name,
    category: category.present ? category.value : this.category,
    createdAt: createdAt ?? this.createdAt,
    updatedAt: updatedAt ?? this.updatedAt,
    version: version ?? this.version,
  );
  Team copyWithCompanion(TeamsCompanion data) {
    return Team(
      id: data.id.present ? data.id.value : this.id,
      name: data.name.present ? data.name.value : this.name,
      category: data.category.present ? data.category.value : this.category,
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
      updatedAt: data.updatedAt.present ? data.updatedAt.value : this.updatedAt,
      version: data.version.present ? data.version.value : this.version,
    );
  }

  @override
  String toString() {
    return (StringBuffer('Team(')
          ..write('id: $id, ')
          ..write('name: $name, ')
          ..write('category: $category, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt, ')
          ..write('version: $version')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode =>
      Object.hash(id, name, category, createdAt, updatedAt, version);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is Team &&
          other.id == this.id &&
          other.name == this.name &&
          other.category == this.category &&
          other.createdAt == this.createdAt &&
          other.updatedAt == this.updatedAt &&
          other.version == this.version);
}

class TeamsCompanion extends UpdateCompanion<Team> {
  final Value<String> id;
  final Value<String> name;
  final Value<String?> category;
  final Value<DateTime> createdAt;
  final Value<DateTime> updatedAt;
  final Value<int> version;
  final Value<int> rowid;
  const TeamsCompanion({
    this.id = const Value.absent(),
    this.name = const Value.absent(),
    this.category = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.updatedAt = const Value.absent(),
    this.version = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  TeamsCompanion.insert({
    required String id,
    required String name,
    this.category = const Value.absent(),
    required DateTime createdAt,
    required DateTime updatedAt,
    this.version = const Value.absent(),
    this.rowid = const Value.absent(),
  }) : id = Value(id),
       name = Value(name),
       createdAt = Value(createdAt),
       updatedAt = Value(updatedAt);
  static Insertable<Team> custom({
    Expression<String>? id,
    Expression<String>? name,
    Expression<String>? category,
    Expression<DateTime>? createdAt,
    Expression<DateTime>? updatedAt,
    Expression<int>? version,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (name != null) 'name': name,
      if (category != null) 'category': category,
      if (createdAt != null) 'created_at': createdAt,
      if (updatedAt != null) 'updated_at': updatedAt,
      if (version != null) 'version': version,
      if (rowid != null) 'rowid': rowid,
    });
  }

  TeamsCompanion copyWith({
    Value<String>? id,
    Value<String>? name,
    Value<String?>? category,
    Value<DateTime>? createdAt,
    Value<DateTime>? updatedAt,
    Value<int>? version,
    Value<int>? rowid,
  }) {
    return TeamsCompanion(
      id: id ?? this.id,
      name: name ?? this.name,
      category: category ?? this.category,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      version: version ?? this.version,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (name.present) {
      map['name'] = Variable<String>(name.value);
    }
    if (category.present) {
      map['category'] = Variable<String>(category.value);
    }
    if (createdAt.present) {
      map['created_at'] = Variable<DateTime>(createdAt.value);
    }
    if (updatedAt.present) {
      map['updated_at'] = Variable<DateTime>(updatedAt.value);
    }
    if (version.present) {
      map['version'] = Variable<int>(version.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('TeamsCompanion(')
          ..write('id: $id, ')
          ..write('name: $name, ')
          ..write('category: $category, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt, ')
          ..write('version: $version, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $PlayersTable extends Players with TableInfo<$PlayersTable, Player> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $PlayersTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
    'id',
    aliasedName,
    false,
    additionalChecks: GeneratedColumn.checkTextLength(),
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _teamIdMeta = const VerificationMeta('teamId');
  @override
  late final GeneratedColumn<String> teamId = GeneratedColumn<String>(
    'team_id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'REFERENCES teams (id)',
    ),
  );
  static const VerificationMeta _displayNameMeta = const VerificationMeta(
    'displayName',
  );
  @override
  late final GeneratedColumn<String> displayName = GeneratedColumn<String>(
    'display_name',
    aliasedName,
    false,
    additionalChecks: GeneratedColumn.checkTextLength(
      minTextLength: 1,
      maxTextLength: 120,
    ),
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _jerseyNumberMeta = const VerificationMeta(
    'jerseyNumber',
  );
  @override
  late final GeneratedColumn<int> jerseyNumber = GeneratedColumn<int>(
    'jersey_number',
    aliasedName,
    false,
    check: () => ComparableExpr(jerseyNumber).isBetweenValues(0, 99),
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _defaultRoleMeta = const VerificationMeta(
    'defaultRole',
  );
  @override
  late final GeneratedColumn<String> defaultRole = GeneratedColumn<String>(
    'default_role',
    aliasedName,
    false,
    check: () => defaultRole.isIn(
      _storageValues(PlayerRole.values, (role) => role.storageValue),
    ),
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _activeMeta = const VerificationMeta('active');
  @override
  late final GeneratedColumn<bool> active = GeneratedColumn<bool>(
    'active',
    aliasedName,
    false,
    type: DriftSqlType.bool,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'CHECK ("active" IN (0, 1))',
    ),
    defaultValue: const Constant(true),
  );
  static const VerificationMeta _createdAtMeta = const VerificationMeta(
    'createdAt',
  );
  @override
  late final GeneratedColumn<DateTime> createdAt = GeneratedColumn<DateTime>(
    'created_at',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _updatedAtMeta = const VerificationMeta(
    'updatedAt',
  );
  @override
  late final GeneratedColumn<DateTime> updatedAt = GeneratedColumn<DateTime>(
    'updated_at',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _versionMeta = const VerificationMeta(
    'version',
  );
  @override
  late final GeneratedColumn<int> version = GeneratedColumn<int>(
    'version',
    aliasedName,
    false,
    check: () => ComparableExpr(version).isBiggerOrEqualValue(1),
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultValue: const Constant(1),
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    teamId,
    displayName,
    jerseyNumber,
    defaultRole,
    active,
    createdAt,
    updatedAt,
    version,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'players';
  @override
  VerificationContext validateIntegrity(
    Insertable<Player> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('team_id')) {
      context.handle(
        _teamIdMeta,
        teamId.isAcceptableOrUnknown(data['team_id']!, _teamIdMeta),
      );
    } else if (isInserting) {
      context.missing(_teamIdMeta);
    }
    if (data.containsKey('display_name')) {
      context.handle(
        _displayNameMeta,
        displayName.isAcceptableOrUnknown(
          data['display_name']!,
          _displayNameMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_displayNameMeta);
    }
    if (data.containsKey('jersey_number')) {
      context.handle(
        _jerseyNumberMeta,
        jerseyNumber.isAcceptableOrUnknown(
          data['jersey_number']!,
          _jerseyNumberMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_jerseyNumberMeta);
    }
    if (data.containsKey('default_role')) {
      context.handle(
        _defaultRoleMeta,
        defaultRole.isAcceptableOrUnknown(
          data['default_role']!,
          _defaultRoleMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_defaultRoleMeta);
    }
    if (data.containsKey('active')) {
      context.handle(
        _activeMeta,
        active.isAcceptableOrUnknown(data['active']!, _activeMeta),
      );
    }
    if (data.containsKey('created_at')) {
      context.handle(
        _createdAtMeta,
        createdAt.isAcceptableOrUnknown(data['created_at']!, _createdAtMeta),
      );
    } else if (isInserting) {
      context.missing(_createdAtMeta);
    }
    if (data.containsKey('updated_at')) {
      context.handle(
        _updatedAtMeta,
        updatedAt.isAcceptableOrUnknown(data['updated_at']!, _updatedAtMeta),
      );
    } else if (isInserting) {
      context.missing(_updatedAtMeta);
    }
    if (data.containsKey('version')) {
      context.handle(
        _versionMeta,
        version.isAcceptableOrUnknown(data['version']!, _versionMeta),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  Player map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return Player(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}id'],
      )!,
      teamId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}team_id'],
      )!,
      displayName: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}display_name'],
      )!,
      jerseyNumber: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}jersey_number'],
      )!,
      defaultRole: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}default_role'],
      )!,
      active: attachedDatabase.typeMapping.read(
        DriftSqlType.bool,
        data['${effectivePrefix}active'],
      )!,
      createdAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}created_at'],
      )!,
      updatedAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}updated_at'],
      )!,
      version: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}version'],
      )!,
    );
  }

  @override
  $PlayersTable createAlias(String alias) {
    return $PlayersTable(attachedDatabase, alias);
  }
}

class Player extends DataClass implements Insertable<Player> {
  final String id;
  final String teamId;
  final String displayName;
  final int jerseyNumber;
  final String defaultRole;
  final bool active;
  final DateTime createdAt;
  final DateTime updatedAt;
  final int version;
  const Player({
    required this.id,
    required this.teamId,
    required this.displayName,
    required this.jerseyNumber,
    required this.defaultRole,
    required this.active,
    required this.createdAt,
    required this.updatedAt,
    required this.version,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['team_id'] = Variable<String>(teamId);
    map['display_name'] = Variable<String>(displayName);
    map['jersey_number'] = Variable<int>(jerseyNumber);
    map['default_role'] = Variable<String>(defaultRole);
    map['active'] = Variable<bool>(active);
    map['created_at'] = Variable<DateTime>(createdAt);
    map['updated_at'] = Variable<DateTime>(updatedAt);
    map['version'] = Variable<int>(version);
    return map;
  }

  PlayersCompanion toCompanion(bool nullToAbsent) {
    return PlayersCompanion(
      id: Value(id),
      teamId: Value(teamId),
      displayName: Value(displayName),
      jerseyNumber: Value(jerseyNumber),
      defaultRole: Value(defaultRole),
      active: Value(active),
      createdAt: Value(createdAt),
      updatedAt: Value(updatedAt),
      version: Value(version),
    );
  }

  factory Player.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return Player(
      id: serializer.fromJson<String>(json['id']),
      teamId: serializer.fromJson<String>(json['teamId']),
      displayName: serializer.fromJson<String>(json['displayName']),
      jerseyNumber: serializer.fromJson<int>(json['jerseyNumber']),
      defaultRole: serializer.fromJson<String>(json['defaultRole']),
      active: serializer.fromJson<bool>(json['active']),
      createdAt: serializer.fromJson<DateTime>(json['createdAt']),
      updatedAt: serializer.fromJson<DateTime>(json['updatedAt']),
      version: serializer.fromJson<int>(json['version']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'teamId': serializer.toJson<String>(teamId),
      'displayName': serializer.toJson<String>(displayName),
      'jerseyNumber': serializer.toJson<int>(jerseyNumber),
      'defaultRole': serializer.toJson<String>(defaultRole),
      'active': serializer.toJson<bool>(active),
      'createdAt': serializer.toJson<DateTime>(createdAt),
      'updatedAt': serializer.toJson<DateTime>(updatedAt),
      'version': serializer.toJson<int>(version),
    };
  }

  Player copyWith({
    String? id,
    String? teamId,
    String? displayName,
    int? jerseyNumber,
    String? defaultRole,
    bool? active,
    DateTime? createdAt,
    DateTime? updatedAt,
    int? version,
  }) => Player(
    id: id ?? this.id,
    teamId: teamId ?? this.teamId,
    displayName: displayName ?? this.displayName,
    jerseyNumber: jerseyNumber ?? this.jerseyNumber,
    defaultRole: defaultRole ?? this.defaultRole,
    active: active ?? this.active,
    createdAt: createdAt ?? this.createdAt,
    updatedAt: updatedAt ?? this.updatedAt,
    version: version ?? this.version,
  );
  Player copyWithCompanion(PlayersCompanion data) {
    return Player(
      id: data.id.present ? data.id.value : this.id,
      teamId: data.teamId.present ? data.teamId.value : this.teamId,
      displayName: data.displayName.present
          ? data.displayName.value
          : this.displayName,
      jerseyNumber: data.jerseyNumber.present
          ? data.jerseyNumber.value
          : this.jerseyNumber,
      defaultRole: data.defaultRole.present
          ? data.defaultRole.value
          : this.defaultRole,
      active: data.active.present ? data.active.value : this.active,
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
      updatedAt: data.updatedAt.present ? data.updatedAt.value : this.updatedAt,
      version: data.version.present ? data.version.value : this.version,
    );
  }

  @override
  String toString() {
    return (StringBuffer('Player(')
          ..write('id: $id, ')
          ..write('teamId: $teamId, ')
          ..write('displayName: $displayName, ')
          ..write('jerseyNumber: $jerseyNumber, ')
          ..write('defaultRole: $defaultRole, ')
          ..write('active: $active, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt, ')
          ..write('version: $version')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    id,
    teamId,
    displayName,
    jerseyNumber,
    defaultRole,
    active,
    createdAt,
    updatedAt,
    version,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is Player &&
          other.id == this.id &&
          other.teamId == this.teamId &&
          other.displayName == this.displayName &&
          other.jerseyNumber == this.jerseyNumber &&
          other.defaultRole == this.defaultRole &&
          other.active == this.active &&
          other.createdAt == this.createdAt &&
          other.updatedAt == this.updatedAt &&
          other.version == this.version);
}

class PlayersCompanion extends UpdateCompanion<Player> {
  final Value<String> id;
  final Value<String> teamId;
  final Value<String> displayName;
  final Value<int> jerseyNumber;
  final Value<String> defaultRole;
  final Value<bool> active;
  final Value<DateTime> createdAt;
  final Value<DateTime> updatedAt;
  final Value<int> version;
  final Value<int> rowid;
  const PlayersCompanion({
    this.id = const Value.absent(),
    this.teamId = const Value.absent(),
    this.displayName = const Value.absent(),
    this.jerseyNumber = const Value.absent(),
    this.defaultRole = const Value.absent(),
    this.active = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.updatedAt = const Value.absent(),
    this.version = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  PlayersCompanion.insert({
    required String id,
    required String teamId,
    required String displayName,
    required int jerseyNumber,
    required String defaultRole,
    this.active = const Value.absent(),
    required DateTime createdAt,
    required DateTime updatedAt,
    this.version = const Value.absent(),
    this.rowid = const Value.absent(),
  }) : id = Value(id),
       teamId = Value(teamId),
       displayName = Value(displayName),
       jerseyNumber = Value(jerseyNumber),
       defaultRole = Value(defaultRole),
       createdAt = Value(createdAt),
       updatedAt = Value(updatedAt);
  static Insertable<Player> custom({
    Expression<String>? id,
    Expression<String>? teamId,
    Expression<String>? displayName,
    Expression<int>? jerseyNumber,
    Expression<String>? defaultRole,
    Expression<bool>? active,
    Expression<DateTime>? createdAt,
    Expression<DateTime>? updatedAt,
    Expression<int>? version,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (teamId != null) 'team_id': teamId,
      if (displayName != null) 'display_name': displayName,
      if (jerseyNumber != null) 'jersey_number': jerseyNumber,
      if (defaultRole != null) 'default_role': defaultRole,
      if (active != null) 'active': active,
      if (createdAt != null) 'created_at': createdAt,
      if (updatedAt != null) 'updated_at': updatedAt,
      if (version != null) 'version': version,
      if (rowid != null) 'rowid': rowid,
    });
  }

  PlayersCompanion copyWith({
    Value<String>? id,
    Value<String>? teamId,
    Value<String>? displayName,
    Value<int>? jerseyNumber,
    Value<String>? defaultRole,
    Value<bool>? active,
    Value<DateTime>? createdAt,
    Value<DateTime>? updatedAt,
    Value<int>? version,
    Value<int>? rowid,
  }) {
    return PlayersCompanion(
      id: id ?? this.id,
      teamId: teamId ?? this.teamId,
      displayName: displayName ?? this.displayName,
      jerseyNumber: jerseyNumber ?? this.jerseyNumber,
      defaultRole: defaultRole ?? this.defaultRole,
      active: active ?? this.active,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      version: version ?? this.version,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (teamId.present) {
      map['team_id'] = Variable<String>(teamId.value);
    }
    if (displayName.present) {
      map['display_name'] = Variable<String>(displayName.value);
    }
    if (jerseyNumber.present) {
      map['jersey_number'] = Variable<int>(jerseyNumber.value);
    }
    if (defaultRole.present) {
      map['default_role'] = Variable<String>(defaultRole.value);
    }
    if (active.present) {
      map['active'] = Variable<bool>(active.value);
    }
    if (createdAt.present) {
      map['created_at'] = Variable<DateTime>(createdAt.value);
    }
    if (updatedAt.present) {
      map['updated_at'] = Variable<DateTime>(updatedAt.value);
    }
    if (version.present) {
      map['version'] = Variable<int>(version.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('PlayersCompanion(')
          ..write('id: $id, ')
          ..write('teamId: $teamId, ')
          ..write('displayName: $displayName, ')
          ..write('jerseyNumber: $jerseyNumber, ')
          ..write('defaultRole: $defaultRole, ')
          ..write('active: $active, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt, ')
          ..write('version: $version, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $TournamentSessionsTable extends TournamentSessions
    with TableInfo<$TournamentSessionsTable, TournamentSession> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $TournamentSessionsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
    'id',
    aliasedName,
    false,
    additionalChecks: GeneratedColumn.checkTextLength(),
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _tournamentNameMeta = const VerificationMeta(
    'tournamentName',
  );
  @override
  late final GeneratedColumn<String> tournamentName = GeneratedColumn<String>(
    'tournament_name',
    aliasedName,
    false,
    additionalChecks: GeneratedColumn.checkTextLength(
      minTextLength: 1,
      maxTextLength: 120,
    ),
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _scheduledDateMeta = const VerificationMeta(
    'scheduledDate',
  );
  @override
  late final GeneratedColumn<String> scheduledDate = GeneratedColumn<String>(
    'scheduled_date',
    aliasedName,
    false,
    additionalChecks: GeneratedColumn.checkTextLength(
      minTextLength: 10,
      maxTextLength: 10,
    ),
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _startTimeMeta = const VerificationMeta(
    'startTime',
  );
  @override
  late final GeneratedColumn<String> startTime = GeneratedColumn<String>(
    'start_time',
    aliasedName,
    true,
    additionalChecks: GeneratedColumn.checkTextLength(
      minTextLength: 5,
      maxTextLength: 5,
    ),
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _teamIdMeta = const VerificationMeta('teamId');
  @override
  late final GeneratedColumn<String> teamId = GeneratedColumn<String>(
    'team_id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'REFERENCES teams (id)',
    ),
  );
  static const VerificationMeta _coachIdMeta = const VerificationMeta(
    'coachId',
  );
  @override
  late final GeneratedColumn<String> coachId = GeneratedColumn<String>(
    'coach_id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'REFERENCES coaches (id)',
    ),
  );
  static const VerificationMeta _activeGoalkeeperIdMeta =
      const VerificationMeta('activeGoalkeeperId');
  @override
  late final GeneratedColumn<String> activeGoalkeeperId =
      GeneratedColumn<String>(
        'active_goalkeeper_id',
        aliasedName,
        false,
        type: DriftSqlType.string,
        requiredDuringInsert: true,
        defaultConstraints: GeneratedColumn.constraintIsAlways(
          'REFERENCES players (id)',
        ),
      );
  static const VerificationMeta _statusMeta = const VerificationMeta('status');
  @override
  late final GeneratedColumn<String> status = GeneratedColumn<String>(
    'status',
    aliasedName,
    false,
    check: () => status.isIn(
      _storageValues(SessionStatus.values, (status) => status.storageValue),
    ),
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _elapsedMsMeta = const VerificationMeta(
    'elapsedMs',
  );
  @override
  late final GeneratedColumn<int> elapsedMs = GeneratedColumn<int>(
    'elapsed_ms',
    aliasedName,
    false,
    check: () => ComparableExpr(elapsedMs).isBiggerOrEqualValue(0),
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultValue: const Constant(0),
  );
  static const VerificationMeta _startedAtMeta = const VerificationMeta(
    'startedAt',
  );
  @override
  late final GeneratedColumn<DateTime> startedAt = GeneratedColumn<DateTime>(
    'started_at',
    aliasedName,
    true,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _finishedAtMeta = const VerificationMeta(
    'finishedAt',
  );
  @override
  late final GeneratedColumn<DateTime> finishedAt = GeneratedColumn<DateTime>(
    'finished_at',
    aliasedName,
    true,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _deviceIdMeta = const VerificationMeta(
    'deviceId',
  );
  @override
  late final GeneratedColumn<String> deviceId = GeneratedColumn<String>(
    'device_id',
    aliasedName,
    false,
    additionalChecks: GeneratedColumn.checkTextLength(),
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _createdAtMeta = const VerificationMeta(
    'createdAt',
  );
  @override
  late final GeneratedColumn<DateTime> createdAt = GeneratedColumn<DateTime>(
    'created_at',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _updatedAtMeta = const VerificationMeta(
    'updatedAt',
  );
  @override
  late final GeneratedColumn<DateTime> updatedAt = GeneratedColumn<DateTime>(
    'updated_at',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _versionMeta = const VerificationMeta(
    'version',
  );
  @override
  late final GeneratedColumn<int> version = GeneratedColumn<int>(
    'version',
    aliasedName,
    false,
    check: () => ComparableExpr(version).isBiggerOrEqualValue(1),
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultValue: const Constant(1),
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    tournamentName,
    scheduledDate,
    startTime,
    teamId,
    coachId,
    activeGoalkeeperId,
    status,
    elapsedMs,
    startedAt,
    finishedAt,
    deviceId,
    createdAt,
    updatedAt,
    version,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'tournament_sessions';
  @override
  VerificationContext validateIntegrity(
    Insertable<TournamentSession> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('tournament_name')) {
      context.handle(
        _tournamentNameMeta,
        tournamentName.isAcceptableOrUnknown(
          data['tournament_name']!,
          _tournamentNameMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_tournamentNameMeta);
    }
    if (data.containsKey('scheduled_date')) {
      context.handle(
        _scheduledDateMeta,
        scheduledDate.isAcceptableOrUnknown(
          data['scheduled_date']!,
          _scheduledDateMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_scheduledDateMeta);
    }
    if (data.containsKey('start_time')) {
      context.handle(
        _startTimeMeta,
        startTime.isAcceptableOrUnknown(data['start_time']!, _startTimeMeta),
      );
    }
    if (data.containsKey('team_id')) {
      context.handle(
        _teamIdMeta,
        teamId.isAcceptableOrUnknown(data['team_id']!, _teamIdMeta),
      );
    } else if (isInserting) {
      context.missing(_teamIdMeta);
    }
    if (data.containsKey('coach_id')) {
      context.handle(
        _coachIdMeta,
        coachId.isAcceptableOrUnknown(data['coach_id']!, _coachIdMeta),
      );
    } else if (isInserting) {
      context.missing(_coachIdMeta);
    }
    if (data.containsKey('active_goalkeeper_id')) {
      context.handle(
        _activeGoalkeeperIdMeta,
        activeGoalkeeperId.isAcceptableOrUnknown(
          data['active_goalkeeper_id']!,
          _activeGoalkeeperIdMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_activeGoalkeeperIdMeta);
    }
    if (data.containsKey('status')) {
      context.handle(
        _statusMeta,
        status.isAcceptableOrUnknown(data['status']!, _statusMeta),
      );
    } else if (isInserting) {
      context.missing(_statusMeta);
    }
    if (data.containsKey('elapsed_ms')) {
      context.handle(
        _elapsedMsMeta,
        elapsedMs.isAcceptableOrUnknown(data['elapsed_ms']!, _elapsedMsMeta),
      );
    }
    if (data.containsKey('started_at')) {
      context.handle(
        _startedAtMeta,
        startedAt.isAcceptableOrUnknown(data['started_at']!, _startedAtMeta),
      );
    }
    if (data.containsKey('finished_at')) {
      context.handle(
        _finishedAtMeta,
        finishedAt.isAcceptableOrUnknown(data['finished_at']!, _finishedAtMeta),
      );
    }
    if (data.containsKey('device_id')) {
      context.handle(
        _deviceIdMeta,
        deviceId.isAcceptableOrUnknown(data['device_id']!, _deviceIdMeta),
      );
    } else if (isInserting) {
      context.missing(_deviceIdMeta);
    }
    if (data.containsKey('created_at')) {
      context.handle(
        _createdAtMeta,
        createdAt.isAcceptableOrUnknown(data['created_at']!, _createdAtMeta),
      );
    } else if (isInserting) {
      context.missing(_createdAtMeta);
    }
    if (data.containsKey('updated_at')) {
      context.handle(
        _updatedAtMeta,
        updatedAt.isAcceptableOrUnknown(data['updated_at']!, _updatedAtMeta),
      );
    } else if (isInserting) {
      context.missing(_updatedAtMeta);
    }
    if (data.containsKey('version')) {
      context.handle(
        _versionMeta,
        version.isAcceptableOrUnknown(data['version']!, _versionMeta),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  TournamentSession map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return TournamentSession(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}id'],
      )!,
      tournamentName: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}tournament_name'],
      )!,
      scheduledDate: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}scheduled_date'],
      )!,
      startTime: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}start_time'],
      ),
      teamId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}team_id'],
      )!,
      coachId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}coach_id'],
      )!,
      activeGoalkeeperId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}active_goalkeeper_id'],
      )!,
      status: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}status'],
      )!,
      elapsedMs: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}elapsed_ms'],
      )!,
      startedAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}started_at'],
      ),
      finishedAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}finished_at'],
      ),
      deviceId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}device_id'],
      )!,
      createdAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}created_at'],
      )!,
      updatedAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}updated_at'],
      )!,
      version: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}version'],
      )!,
    );
  }

  @override
  $TournamentSessionsTable createAlias(String alias) {
    return $TournamentSessionsTable(attachedDatabase, alias);
  }
}

class TournamentSession extends DataClass
    implements Insertable<TournamentSession> {
  final String id;
  final String tournamentName;
  final String scheduledDate;
  final String? startTime;
  final String teamId;
  final String coachId;
  final String activeGoalkeeperId;
  final String status;
  final int elapsedMs;
  final DateTime? startedAt;
  final DateTime? finishedAt;
  final String deviceId;
  final DateTime createdAt;
  final DateTime updatedAt;
  final int version;
  const TournamentSession({
    required this.id,
    required this.tournamentName,
    required this.scheduledDate,
    this.startTime,
    required this.teamId,
    required this.coachId,
    required this.activeGoalkeeperId,
    required this.status,
    required this.elapsedMs,
    this.startedAt,
    this.finishedAt,
    required this.deviceId,
    required this.createdAt,
    required this.updatedAt,
    required this.version,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['tournament_name'] = Variable<String>(tournamentName);
    map['scheduled_date'] = Variable<String>(scheduledDate);
    if (!nullToAbsent || startTime != null) {
      map['start_time'] = Variable<String>(startTime);
    }
    map['team_id'] = Variable<String>(teamId);
    map['coach_id'] = Variable<String>(coachId);
    map['active_goalkeeper_id'] = Variable<String>(activeGoalkeeperId);
    map['status'] = Variable<String>(status);
    map['elapsed_ms'] = Variable<int>(elapsedMs);
    if (!nullToAbsent || startedAt != null) {
      map['started_at'] = Variable<DateTime>(startedAt);
    }
    if (!nullToAbsent || finishedAt != null) {
      map['finished_at'] = Variable<DateTime>(finishedAt);
    }
    map['device_id'] = Variable<String>(deviceId);
    map['created_at'] = Variable<DateTime>(createdAt);
    map['updated_at'] = Variable<DateTime>(updatedAt);
    map['version'] = Variable<int>(version);
    return map;
  }

  TournamentSessionsCompanion toCompanion(bool nullToAbsent) {
    return TournamentSessionsCompanion(
      id: Value(id),
      tournamentName: Value(tournamentName),
      scheduledDate: Value(scheduledDate),
      startTime: startTime == null && nullToAbsent
          ? const Value.absent()
          : Value(startTime),
      teamId: Value(teamId),
      coachId: Value(coachId),
      activeGoalkeeperId: Value(activeGoalkeeperId),
      status: Value(status),
      elapsedMs: Value(elapsedMs),
      startedAt: startedAt == null && nullToAbsent
          ? const Value.absent()
          : Value(startedAt),
      finishedAt: finishedAt == null && nullToAbsent
          ? const Value.absent()
          : Value(finishedAt),
      deviceId: Value(deviceId),
      createdAt: Value(createdAt),
      updatedAt: Value(updatedAt),
      version: Value(version),
    );
  }

  factory TournamentSession.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return TournamentSession(
      id: serializer.fromJson<String>(json['id']),
      tournamentName: serializer.fromJson<String>(json['tournamentName']),
      scheduledDate: serializer.fromJson<String>(json['scheduledDate']),
      startTime: serializer.fromJson<String?>(json['startTime']),
      teamId: serializer.fromJson<String>(json['teamId']),
      coachId: serializer.fromJson<String>(json['coachId']),
      activeGoalkeeperId: serializer.fromJson<String>(
        json['activeGoalkeeperId'],
      ),
      status: serializer.fromJson<String>(json['status']),
      elapsedMs: serializer.fromJson<int>(json['elapsedMs']),
      startedAt: serializer.fromJson<DateTime?>(json['startedAt']),
      finishedAt: serializer.fromJson<DateTime?>(json['finishedAt']),
      deviceId: serializer.fromJson<String>(json['deviceId']),
      createdAt: serializer.fromJson<DateTime>(json['createdAt']),
      updatedAt: serializer.fromJson<DateTime>(json['updatedAt']),
      version: serializer.fromJson<int>(json['version']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'tournamentName': serializer.toJson<String>(tournamentName),
      'scheduledDate': serializer.toJson<String>(scheduledDate),
      'startTime': serializer.toJson<String?>(startTime),
      'teamId': serializer.toJson<String>(teamId),
      'coachId': serializer.toJson<String>(coachId),
      'activeGoalkeeperId': serializer.toJson<String>(activeGoalkeeperId),
      'status': serializer.toJson<String>(status),
      'elapsedMs': serializer.toJson<int>(elapsedMs),
      'startedAt': serializer.toJson<DateTime?>(startedAt),
      'finishedAt': serializer.toJson<DateTime?>(finishedAt),
      'deviceId': serializer.toJson<String>(deviceId),
      'createdAt': serializer.toJson<DateTime>(createdAt),
      'updatedAt': serializer.toJson<DateTime>(updatedAt),
      'version': serializer.toJson<int>(version),
    };
  }

  TournamentSession copyWith({
    String? id,
    String? tournamentName,
    String? scheduledDate,
    Value<String?> startTime = const Value.absent(),
    String? teamId,
    String? coachId,
    String? activeGoalkeeperId,
    String? status,
    int? elapsedMs,
    Value<DateTime?> startedAt = const Value.absent(),
    Value<DateTime?> finishedAt = const Value.absent(),
    String? deviceId,
    DateTime? createdAt,
    DateTime? updatedAt,
    int? version,
  }) => TournamentSession(
    id: id ?? this.id,
    tournamentName: tournamentName ?? this.tournamentName,
    scheduledDate: scheduledDate ?? this.scheduledDate,
    startTime: startTime.present ? startTime.value : this.startTime,
    teamId: teamId ?? this.teamId,
    coachId: coachId ?? this.coachId,
    activeGoalkeeperId: activeGoalkeeperId ?? this.activeGoalkeeperId,
    status: status ?? this.status,
    elapsedMs: elapsedMs ?? this.elapsedMs,
    startedAt: startedAt.present ? startedAt.value : this.startedAt,
    finishedAt: finishedAt.present ? finishedAt.value : this.finishedAt,
    deviceId: deviceId ?? this.deviceId,
    createdAt: createdAt ?? this.createdAt,
    updatedAt: updatedAt ?? this.updatedAt,
    version: version ?? this.version,
  );
  TournamentSession copyWithCompanion(TournamentSessionsCompanion data) {
    return TournamentSession(
      id: data.id.present ? data.id.value : this.id,
      tournamentName: data.tournamentName.present
          ? data.tournamentName.value
          : this.tournamentName,
      scheduledDate: data.scheduledDate.present
          ? data.scheduledDate.value
          : this.scheduledDate,
      startTime: data.startTime.present ? data.startTime.value : this.startTime,
      teamId: data.teamId.present ? data.teamId.value : this.teamId,
      coachId: data.coachId.present ? data.coachId.value : this.coachId,
      activeGoalkeeperId: data.activeGoalkeeperId.present
          ? data.activeGoalkeeperId.value
          : this.activeGoalkeeperId,
      status: data.status.present ? data.status.value : this.status,
      elapsedMs: data.elapsedMs.present ? data.elapsedMs.value : this.elapsedMs,
      startedAt: data.startedAt.present ? data.startedAt.value : this.startedAt,
      finishedAt: data.finishedAt.present
          ? data.finishedAt.value
          : this.finishedAt,
      deviceId: data.deviceId.present ? data.deviceId.value : this.deviceId,
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
      updatedAt: data.updatedAt.present ? data.updatedAt.value : this.updatedAt,
      version: data.version.present ? data.version.value : this.version,
    );
  }

  @override
  String toString() {
    return (StringBuffer('TournamentSession(')
          ..write('id: $id, ')
          ..write('tournamentName: $tournamentName, ')
          ..write('scheduledDate: $scheduledDate, ')
          ..write('startTime: $startTime, ')
          ..write('teamId: $teamId, ')
          ..write('coachId: $coachId, ')
          ..write('activeGoalkeeperId: $activeGoalkeeperId, ')
          ..write('status: $status, ')
          ..write('elapsedMs: $elapsedMs, ')
          ..write('startedAt: $startedAt, ')
          ..write('finishedAt: $finishedAt, ')
          ..write('deviceId: $deviceId, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt, ')
          ..write('version: $version')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    id,
    tournamentName,
    scheduledDate,
    startTime,
    teamId,
    coachId,
    activeGoalkeeperId,
    status,
    elapsedMs,
    startedAt,
    finishedAt,
    deviceId,
    createdAt,
    updatedAt,
    version,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is TournamentSession &&
          other.id == this.id &&
          other.tournamentName == this.tournamentName &&
          other.scheduledDate == this.scheduledDate &&
          other.startTime == this.startTime &&
          other.teamId == this.teamId &&
          other.coachId == this.coachId &&
          other.activeGoalkeeperId == this.activeGoalkeeperId &&
          other.status == this.status &&
          other.elapsedMs == this.elapsedMs &&
          other.startedAt == this.startedAt &&
          other.finishedAt == this.finishedAt &&
          other.deviceId == this.deviceId &&
          other.createdAt == this.createdAt &&
          other.updatedAt == this.updatedAt &&
          other.version == this.version);
}

class TournamentSessionsCompanion extends UpdateCompanion<TournamentSession> {
  final Value<String> id;
  final Value<String> tournamentName;
  final Value<String> scheduledDate;
  final Value<String?> startTime;
  final Value<String> teamId;
  final Value<String> coachId;
  final Value<String> activeGoalkeeperId;
  final Value<String> status;
  final Value<int> elapsedMs;
  final Value<DateTime?> startedAt;
  final Value<DateTime?> finishedAt;
  final Value<String> deviceId;
  final Value<DateTime> createdAt;
  final Value<DateTime> updatedAt;
  final Value<int> version;
  final Value<int> rowid;
  const TournamentSessionsCompanion({
    this.id = const Value.absent(),
    this.tournamentName = const Value.absent(),
    this.scheduledDate = const Value.absent(),
    this.startTime = const Value.absent(),
    this.teamId = const Value.absent(),
    this.coachId = const Value.absent(),
    this.activeGoalkeeperId = const Value.absent(),
    this.status = const Value.absent(),
    this.elapsedMs = const Value.absent(),
    this.startedAt = const Value.absent(),
    this.finishedAt = const Value.absent(),
    this.deviceId = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.updatedAt = const Value.absent(),
    this.version = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  TournamentSessionsCompanion.insert({
    required String id,
    required String tournamentName,
    required String scheduledDate,
    this.startTime = const Value.absent(),
    required String teamId,
    required String coachId,
    required String activeGoalkeeperId,
    required String status,
    this.elapsedMs = const Value.absent(),
    this.startedAt = const Value.absent(),
    this.finishedAt = const Value.absent(),
    required String deviceId,
    required DateTime createdAt,
    required DateTime updatedAt,
    this.version = const Value.absent(),
    this.rowid = const Value.absent(),
  }) : id = Value(id),
       tournamentName = Value(tournamentName),
       scheduledDate = Value(scheduledDate),
       teamId = Value(teamId),
       coachId = Value(coachId),
       activeGoalkeeperId = Value(activeGoalkeeperId),
       status = Value(status),
       deviceId = Value(deviceId),
       createdAt = Value(createdAt),
       updatedAt = Value(updatedAt);
  static Insertable<TournamentSession> custom({
    Expression<String>? id,
    Expression<String>? tournamentName,
    Expression<String>? scheduledDate,
    Expression<String>? startTime,
    Expression<String>? teamId,
    Expression<String>? coachId,
    Expression<String>? activeGoalkeeperId,
    Expression<String>? status,
    Expression<int>? elapsedMs,
    Expression<DateTime>? startedAt,
    Expression<DateTime>? finishedAt,
    Expression<String>? deviceId,
    Expression<DateTime>? createdAt,
    Expression<DateTime>? updatedAt,
    Expression<int>? version,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (tournamentName != null) 'tournament_name': tournamentName,
      if (scheduledDate != null) 'scheduled_date': scheduledDate,
      if (startTime != null) 'start_time': startTime,
      if (teamId != null) 'team_id': teamId,
      if (coachId != null) 'coach_id': coachId,
      if (activeGoalkeeperId != null)
        'active_goalkeeper_id': activeGoalkeeperId,
      if (status != null) 'status': status,
      if (elapsedMs != null) 'elapsed_ms': elapsedMs,
      if (startedAt != null) 'started_at': startedAt,
      if (finishedAt != null) 'finished_at': finishedAt,
      if (deviceId != null) 'device_id': deviceId,
      if (createdAt != null) 'created_at': createdAt,
      if (updatedAt != null) 'updated_at': updatedAt,
      if (version != null) 'version': version,
      if (rowid != null) 'rowid': rowid,
    });
  }

  TournamentSessionsCompanion copyWith({
    Value<String>? id,
    Value<String>? tournamentName,
    Value<String>? scheduledDate,
    Value<String?>? startTime,
    Value<String>? teamId,
    Value<String>? coachId,
    Value<String>? activeGoalkeeperId,
    Value<String>? status,
    Value<int>? elapsedMs,
    Value<DateTime?>? startedAt,
    Value<DateTime?>? finishedAt,
    Value<String>? deviceId,
    Value<DateTime>? createdAt,
    Value<DateTime>? updatedAt,
    Value<int>? version,
    Value<int>? rowid,
  }) {
    return TournamentSessionsCompanion(
      id: id ?? this.id,
      tournamentName: tournamentName ?? this.tournamentName,
      scheduledDate: scheduledDate ?? this.scheduledDate,
      startTime: startTime ?? this.startTime,
      teamId: teamId ?? this.teamId,
      coachId: coachId ?? this.coachId,
      activeGoalkeeperId: activeGoalkeeperId ?? this.activeGoalkeeperId,
      status: status ?? this.status,
      elapsedMs: elapsedMs ?? this.elapsedMs,
      startedAt: startedAt ?? this.startedAt,
      finishedAt: finishedAt ?? this.finishedAt,
      deviceId: deviceId ?? this.deviceId,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      version: version ?? this.version,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (tournamentName.present) {
      map['tournament_name'] = Variable<String>(tournamentName.value);
    }
    if (scheduledDate.present) {
      map['scheduled_date'] = Variable<String>(scheduledDate.value);
    }
    if (startTime.present) {
      map['start_time'] = Variable<String>(startTime.value);
    }
    if (teamId.present) {
      map['team_id'] = Variable<String>(teamId.value);
    }
    if (coachId.present) {
      map['coach_id'] = Variable<String>(coachId.value);
    }
    if (activeGoalkeeperId.present) {
      map['active_goalkeeper_id'] = Variable<String>(activeGoalkeeperId.value);
    }
    if (status.present) {
      map['status'] = Variable<String>(status.value);
    }
    if (elapsedMs.present) {
      map['elapsed_ms'] = Variable<int>(elapsedMs.value);
    }
    if (startedAt.present) {
      map['started_at'] = Variable<DateTime>(startedAt.value);
    }
    if (finishedAt.present) {
      map['finished_at'] = Variable<DateTime>(finishedAt.value);
    }
    if (deviceId.present) {
      map['device_id'] = Variable<String>(deviceId.value);
    }
    if (createdAt.present) {
      map['created_at'] = Variable<DateTime>(createdAt.value);
    }
    if (updatedAt.present) {
      map['updated_at'] = Variable<DateTime>(updatedAt.value);
    }
    if (version.present) {
      map['version'] = Variable<int>(version.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('TournamentSessionsCompanion(')
          ..write('id: $id, ')
          ..write('tournamentName: $tournamentName, ')
          ..write('scheduledDate: $scheduledDate, ')
          ..write('startTime: $startTime, ')
          ..write('teamId: $teamId, ')
          ..write('coachId: $coachId, ')
          ..write('activeGoalkeeperId: $activeGoalkeeperId, ')
          ..write('status: $status, ')
          ..write('elapsedMs: $elapsedMs, ')
          ..write('startedAt: $startedAt, ')
          ..write('finishedAt: $finishedAt, ')
          ..write('deviceId: $deviceId, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt, ')
          ..write('version: $version, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $SessionPlayersTable extends SessionPlayers
    with TableInfo<$SessionPlayersTable, SessionPlayer> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $SessionPlayersTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _sessionIdMeta = const VerificationMeta(
    'sessionId',
  );
  @override
  late final GeneratedColumn<String> sessionId = GeneratedColumn<String>(
    'session_id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'REFERENCES tournament_sessions (id) ON DELETE CASCADE',
    ),
  );
  static const VerificationMeta _playerIdMeta = const VerificationMeta(
    'playerId',
  );
  @override
  late final GeneratedColumn<String> playerId = GeneratedColumn<String>(
    'player_id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'REFERENCES players (id)',
    ),
  );
  static const VerificationMeta _roleMeta = const VerificationMeta('role');
  @override
  late final GeneratedColumn<String> role = GeneratedColumn<String>(
    'role',
    aliasedName,
    false,
    check: () => role.isIn(
      _storageValues(PlayerRole.values, (role) => role.storageValue),
    ),
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _createdAtMeta = const VerificationMeta(
    'createdAt',
  );
  @override
  late final GeneratedColumn<DateTime> createdAt = GeneratedColumn<DateTime>(
    'created_at',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _updatedAtMeta = const VerificationMeta(
    'updatedAt',
  );
  @override
  late final GeneratedColumn<DateTime> updatedAt = GeneratedColumn<DateTime>(
    'updated_at',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _versionMeta = const VerificationMeta(
    'version',
  );
  @override
  late final GeneratedColumn<int> version = GeneratedColumn<int>(
    'version',
    aliasedName,
    false,
    check: () => ComparableExpr(version).isBiggerOrEqualValue(1),
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultValue: const Constant(1),
  );
  @override
  List<GeneratedColumn> get $columns => [
    sessionId,
    playerId,
    role,
    createdAt,
    updatedAt,
    version,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'session_players';
  @override
  VerificationContext validateIntegrity(
    Insertable<SessionPlayer> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('session_id')) {
      context.handle(
        _sessionIdMeta,
        sessionId.isAcceptableOrUnknown(data['session_id']!, _sessionIdMeta),
      );
    } else if (isInserting) {
      context.missing(_sessionIdMeta);
    }
    if (data.containsKey('player_id')) {
      context.handle(
        _playerIdMeta,
        playerId.isAcceptableOrUnknown(data['player_id']!, _playerIdMeta),
      );
    } else if (isInserting) {
      context.missing(_playerIdMeta);
    }
    if (data.containsKey('role')) {
      context.handle(
        _roleMeta,
        role.isAcceptableOrUnknown(data['role']!, _roleMeta),
      );
    } else if (isInserting) {
      context.missing(_roleMeta);
    }
    if (data.containsKey('created_at')) {
      context.handle(
        _createdAtMeta,
        createdAt.isAcceptableOrUnknown(data['created_at']!, _createdAtMeta),
      );
    } else if (isInserting) {
      context.missing(_createdAtMeta);
    }
    if (data.containsKey('updated_at')) {
      context.handle(
        _updatedAtMeta,
        updatedAt.isAcceptableOrUnknown(data['updated_at']!, _updatedAtMeta),
      );
    } else if (isInserting) {
      context.missing(_updatedAtMeta);
    }
    if (data.containsKey('version')) {
      context.handle(
        _versionMeta,
        version.isAcceptableOrUnknown(data['version']!, _versionMeta),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {sessionId, playerId};
  @override
  SessionPlayer map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return SessionPlayer(
      sessionId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}session_id'],
      )!,
      playerId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}player_id'],
      )!,
      role: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}role'],
      )!,
      createdAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}created_at'],
      )!,
      updatedAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}updated_at'],
      )!,
      version: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}version'],
      )!,
    );
  }

  @override
  $SessionPlayersTable createAlias(String alias) {
    return $SessionPlayersTable(attachedDatabase, alias);
  }
}

class SessionPlayer extends DataClass implements Insertable<SessionPlayer> {
  final String sessionId;
  final String playerId;
  final String role;
  final DateTime createdAt;
  final DateTime updatedAt;
  final int version;
  const SessionPlayer({
    required this.sessionId,
    required this.playerId,
    required this.role,
    required this.createdAt,
    required this.updatedAt,
    required this.version,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['session_id'] = Variable<String>(sessionId);
    map['player_id'] = Variable<String>(playerId);
    map['role'] = Variable<String>(role);
    map['created_at'] = Variable<DateTime>(createdAt);
    map['updated_at'] = Variable<DateTime>(updatedAt);
    map['version'] = Variable<int>(version);
    return map;
  }

  SessionPlayersCompanion toCompanion(bool nullToAbsent) {
    return SessionPlayersCompanion(
      sessionId: Value(sessionId),
      playerId: Value(playerId),
      role: Value(role),
      createdAt: Value(createdAt),
      updatedAt: Value(updatedAt),
      version: Value(version),
    );
  }

  factory SessionPlayer.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return SessionPlayer(
      sessionId: serializer.fromJson<String>(json['sessionId']),
      playerId: serializer.fromJson<String>(json['playerId']),
      role: serializer.fromJson<String>(json['role']),
      createdAt: serializer.fromJson<DateTime>(json['createdAt']),
      updatedAt: serializer.fromJson<DateTime>(json['updatedAt']),
      version: serializer.fromJson<int>(json['version']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'sessionId': serializer.toJson<String>(sessionId),
      'playerId': serializer.toJson<String>(playerId),
      'role': serializer.toJson<String>(role),
      'createdAt': serializer.toJson<DateTime>(createdAt),
      'updatedAt': serializer.toJson<DateTime>(updatedAt),
      'version': serializer.toJson<int>(version),
    };
  }

  SessionPlayer copyWith({
    String? sessionId,
    String? playerId,
    String? role,
    DateTime? createdAt,
    DateTime? updatedAt,
    int? version,
  }) => SessionPlayer(
    sessionId: sessionId ?? this.sessionId,
    playerId: playerId ?? this.playerId,
    role: role ?? this.role,
    createdAt: createdAt ?? this.createdAt,
    updatedAt: updatedAt ?? this.updatedAt,
    version: version ?? this.version,
  );
  SessionPlayer copyWithCompanion(SessionPlayersCompanion data) {
    return SessionPlayer(
      sessionId: data.sessionId.present ? data.sessionId.value : this.sessionId,
      playerId: data.playerId.present ? data.playerId.value : this.playerId,
      role: data.role.present ? data.role.value : this.role,
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
      updatedAt: data.updatedAt.present ? data.updatedAt.value : this.updatedAt,
      version: data.version.present ? data.version.value : this.version,
    );
  }

  @override
  String toString() {
    return (StringBuffer('SessionPlayer(')
          ..write('sessionId: $sessionId, ')
          ..write('playerId: $playerId, ')
          ..write('role: $role, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt, ')
          ..write('version: $version')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode =>
      Object.hash(sessionId, playerId, role, createdAt, updatedAt, version);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is SessionPlayer &&
          other.sessionId == this.sessionId &&
          other.playerId == this.playerId &&
          other.role == this.role &&
          other.createdAt == this.createdAt &&
          other.updatedAt == this.updatedAt &&
          other.version == this.version);
}

class SessionPlayersCompanion extends UpdateCompanion<SessionPlayer> {
  final Value<String> sessionId;
  final Value<String> playerId;
  final Value<String> role;
  final Value<DateTime> createdAt;
  final Value<DateTime> updatedAt;
  final Value<int> version;
  final Value<int> rowid;
  const SessionPlayersCompanion({
    this.sessionId = const Value.absent(),
    this.playerId = const Value.absent(),
    this.role = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.updatedAt = const Value.absent(),
    this.version = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  SessionPlayersCompanion.insert({
    required String sessionId,
    required String playerId,
    required String role,
    required DateTime createdAt,
    required DateTime updatedAt,
    this.version = const Value.absent(),
    this.rowid = const Value.absent(),
  }) : sessionId = Value(sessionId),
       playerId = Value(playerId),
       role = Value(role),
       createdAt = Value(createdAt),
       updatedAt = Value(updatedAt);
  static Insertable<SessionPlayer> custom({
    Expression<String>? sessionId,
    Expression<String>? playerId,
    Expression<String>? role,
    Expression<DateTime>? createdAt,
    Expression<DateTime>? updatedAt,
    Expression<int>? version,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (sessionId != null) 'session_id': sessionId,
      if (playerId != null) 'player_id': playerId,
      if (role != null) 'role': role,
      if (createdAt != null) 'created_at': createdAt,
      if (updatedAt != null) 'updated_at': updatedAt,
      if (version != null) 'version': version,
      if (rowid != null) 'rowid': rowid,
    });
  }

  SessionPlayersCompanion copyWith({
    Value<String>? sessionId,
    Value<String>? playerId,
    Value<String>? role,
    Value<DateTime>? createdAt,
    Value<DateTime>? updatedAt,
    Value<int>? version,
    Value<int>? rowid,
  }) {
    return SessionPlayersCompanion(
      sessionId: sessionId ?? this.sessionId,
      playerId: playerId ?? this.playerId,
      role: role ?? this.role,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      version: version ?? this.version,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (sessionId.present) {
      map['session_id'] = Variable<String>(sessionId.value);
    }
    if (playerId.present) {
      map['player_id'] = Variable<String>(playerId.value);
    }
    if (role.present) {
      map['role'] = Variable<String>(role.value);
    }
    if (createdAt.present) {
      map['created_at'] = Variable<DateTime>(createdAt.value);
    }
    if (updatedAt.present) {
      map['updated_at'] = Variable<DateTime>(updatedAt.value);
    }
    if (version.present) {
      map['version'] = Variable<int>(version.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('SessionPlayersCompanion(')
          ..write('sessionId: $sessionId, ')
          ..write('playerId: $playerId, ')
          ..write('role: $role, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt, ')
          ..write('version: $version, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $MatchActionsTable extends MatchActions
    with TableInfo<$MatchActionsTable, MatchAction> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $MatchActionsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
    'id',
    aliasedName,
    false,
    additionalChecks: GeneratedColumn.checkTextLength(),
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _sessionIdMeta = const VerificationMeta(
    'sessionId',
  );
  @override
  late final GeneratedColumn<String> sessionId = GeneratedColumn<String>(
    'session_id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'REFERENCES tournament_sessions (id)',
    ),
  );
  static const VerificationMeta _playerIdMeta = const VerificationMeta(
    'playerId',
  );
  @override
  late final GeneratedColumn<String> playerId = GeneratedColumn<String>(
    'player_id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'REFERENCES players (id)',
    ),
  );
  static const VerificationMeta _actionTypeMeta = const VerificationMeta(
    'actionType',
  );
  @override
  late final GeneratedColumn<String> actionType = GeneratedColumn<String>(
    'action_type',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _outcomeMeta = const VerificationMeta(
    'outcome',
  );
  @override
  late final GeneratedColumn<String> outcome = GeneratedColumn<String>(
    'outcome',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _clockMsMeta = const VerificationMeta(
    'clockMs',
  );
  @override
  late final GeneratedColumn<int> clockMs = GeneratedColumn<int>(
    'clock_ms',
    aliasedName,
    false,
    check: () => ComparableExpr(clockMs).isBiggerOrEqualValue(0),
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _rinkZoneMeta = const VerificationMeta(
    'rinkZone',
  );
  @override
  late final GeneratedColumn<String> rinkZone = GeneratedColumn<String>(
    'rink_zone',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _noteMeta = const VerificationMeta('note');
  @override
  late final GeneratedColumn<String> note = GeneratedColumn<String>(
    'note',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _clientEventIdMeta = const VerificationMeta(
    'clientEventId',
  );
  @override
  late final GeneratedColumn<String> clientEventId = GeneratedColumn<String>(
    'client_event_id',
    aliasedName,
    false,
    additionalChecks: GeneratedColumn.checkTextLength(),
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _deviceIdMeta = const VerificationMeta(
    'deviceId',
  );
  @override
  late final GeneratedColumn<String> deviceId = GeneratedColumn<String>(
    'device_id',
    aliasedName,
    false,
    additionalChecks: GeneratedColumn.checkTextLength(),
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _createdAtMeta = const VerificationMeta(
    'createdAt',
  );
  @override
  late final GeneratedColumn<DateTime> createdAt = GeneratedColumn<DateTime>(
    'created_at',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _updatedAtMeta = const VerificationMeta(
    'updatedAt',
  );
  @override
  late final GeneratedColumn<DateTime> updatedAt = GeneratedColumn<DateTime>(
    'updated_at',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _versionMeta = const VerificationMeta(
    'version',
  );
  @override
  late final GeneratedColumn<int> version = GeneratedColumn<int>(
    'version',
    aliasedName,
    false,
    check: () => ComparableExpr(version).isBiggerOrEqualValue(1),
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultValue: const Constant(1),
  );
  static const VerificationMeta _voidedAtMeta = const VerificationMeta(
    'voidedAt',
  );
  @override
  late final GeneratedColumn<DateTime> voidedAt = GeneratedColumn<DateTime>(
    'voided_at',
    aliasedName,
    true,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _voidReasonMeta = const VerificationMeta(
    'voidReason',
  );
  @override
  late final GeneratedColumn<String> voidReason = GeneratedColumn<String>(
    'void_reason',
    aliasedName,
    true,
    additionalChecks: GeneratedColumn.checkTextLength(maxTextLength: 200),
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    sessionId,
    playerId,
    actionType,
    outcome,
    clockMs,
    rinkZone,
    note,
    clientEventId,
    deviceId,
    createdAt,
    updatedAt,
    version,
    voidedAt,
    voidReason,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'match_actions';
  @override
  VerificationContext validateIntegrity(
    Insertable<MatchAction> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('session_id')) {
      context.handle(
        _sessionIdMeta,
        sessionId.isAcceptableOrUnknown(data['session_id']!, _sessionIdMeta),
      );
    } else if (isInserting) {
      context.missing(_sessionIdMeta);
    }
    if (data.containsKey('player_id')) {
      context.handle(
        _playerIdMeta,
        playerId.isAcceptableOrUnknown(data['player_id']!, _playerIdMeta),
      );
    } else if (isInserting) {
      context.missing(_playerIdMeta);
    }
    if (data.containsKey('action_type')) {
      context.handle(
        _actionTypeMeta,
        actionType.isAcceptableOrUnknown(data['action_type']!, _actionTypeMeta),
      );
    } else if (isInserting) {
      context.missing(_actionTypeMeta);
    }
    if (data.containsKey('outcome')) {
      context.handle(
        _outcomeMeta,
        outcome.isAcceptableOrUnknown(data['outcome']!, _outcomeMeta),
      );
    }
    if (data.containsKey('clock_ms')) {
      context.handle(
        _clockMsMeta,
        clockMs.isAcceptableOrUnknown(data['clock_ms']!, _clockMsMeta),
      );
    } else if (isInserting) {
      context.missing(_clockMsMeta);
    }
    if (data.containsKey('rink_zone')) {
      context.handle(
        _rinkZoneMeta,
        rinkZone.isAcceptableOrUnknown(data['rink_zone']!, _rinkZoneMeta),
      );
    }
    if (data.containsKey('note')) {
      context.handle(
        _noteMeta,
        note.isAcceptableOrUnknown(data['note']!, _noteMeta),
      );
    }
    if (data.containsKey('client_event_id')) {
      context.handle(
        _clientEventIdMeta,
        clientEventId.isAcceptableOrUnknown(
          data['client_event_id']!,
          _clientEventIdMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_clientEventIdMeta);
    }
    if (data.containsKey('device_id')) {
      context.handle(
        _deviceIdMeta,
        deviceId.isAcceptableOrUnknown(data['device_id']!, _deviceIdMeta),
      );
    } else if (isInserting) {
      context.missing(_deviceIdMeta);
    }
    if (data.containsKey('created_at')) {
      context.handle(
        _createdAtMeta,
        createdAt.isAcceptableOrUnknown(data['created_at']!, _createdAtMeta),
      );
    } else if (isInserting) {
      context.missing(_createdAtMeta);
    }
    if (data.containsKey('updated_at')) {
      context.handle(
        _updatedAtMeta,
        updatedAt.isAcceptableOrUnknown(data['updated_at']!, _updatedAtMeta),
      );
    } else if (isInserting) {
      context.missing(_updatedAtMeta);
    }
    if (data.containsKey('version')) {
      context.handle(
        _versionMeta,
        version.isAcceptableOrUnknown(data['version']!, _versionMeta),
      );
    }
    if (data.containsKey('voided_at')) {
      context.handle(
        _voidedAtMeta,
        voidedAt.isAcceptableOrUnknown(data['voided_at']!, _voidedAtMeta),
      );
    }
    if (data.containsKey('void_reason')) {
      context.handle(
        _voidReasonMeta,
        voidReason.isAcceptableOrUnknown(data['void_reason']!, _voidReasonMeta),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  List<Set<GeneratedColumn>> get uniqueKeys => [
    {deviceId, clientEventId},
  ];
  @override
  MatchAction map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return MatchAction(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}id'],
      )!,
      sessionId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}session_id'],
      )!,
      playerId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}player_id'],
      )!,
      actionType: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}action_type'],
      )!,
      outcome: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}outcome'],
      ),
      clockMs: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}clock_ms'],
      )!,
      rinkZone: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}rink_zone'],
      ),
      note: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}note'],
      ),
      clientEventId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}client_event_id'],
      )!,
      deviceId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}device_id'],
      )!,
      createdAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}created_at'],
      )!,
      updatedAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}updated_at'],
      )!,
      version: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}version'],
      )!,
      voidedAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}voided_at'],
      ),
      voidReason: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}void_reason'],
      ),
    );
  }

  @override
  $MatchActionsTable createAlias(String alias) {
    return $MatchActionsTable(attachedDatabase, alias);
  }
}

class MatchAction extends DataClass implements Insertable<MatchAction> {
  final String id;
  final String sessionId;
  final String playerId;
  final String actionType;
  final String? outcome;
  final int clockMs;
  final String? rinkZone;
  final String? note;
  final String clientEventId;
  final String deviceId;
  final DateTime createdAt;
  final DateTime updatedAt;
  final int version;
  final DateTime? voidedAt;
  final String? voidReason;
  const MatchAction({
    required this.id,
    required this.sessionId,
    required this.playerId,
    required this.actionType,
    this.outcome,
    required this.clockMs,
    this.rinkZone,
    this.note,
    required this.clientEventId,
    required this.deviceId,
    required this.createdAt,
    required this.updatedAt,
    required this.version,
    this.voidedAt,
    this.voidReason,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['session_id'] = Variable<String>(sessionId);
    map['player_id'] = Variable<String>(playerId);
    map['action_type'] = Variable<String>(actionType);
    if (!nullToAbsent || outcome != null) {
      map['outcome'] = Variable<String>(outcome);
    }
    map['clock_ms'] = Variable<int>(clockMs);
    if (!nullToAbsent || rinkZone != null) {
      map['rink_zone'] = Variable<String>(rinkZone);
    }
    if (!nullToAbsent || note != null) {
      map['note'] = Variable<String>(note);
    }
    map['client_event_id'] = Variable<String>(clientEventId);
    map['device_id'] = Variable<String>(deviceId);
    map['created_at'] = Variable<DateTime>(createdAt);
    map['updated_at'] = Variable<DateTime>(updatedAt);
    map['version'] = Variable<int>(version);
    if (!nullToAbsent || voidedAt != null) {
      map['voided_at'] = Variable<DateTime>(voidedAt);
    }
    if (!nullToAbsent || voidReason != null) {
      map['void_reason'] = Variable<String>(voidReason);
    }
    return map;
  }

  MatchActionsCompanion toCompanion(bool nullToAbsent) {
    return MatchActionsCompanion(
      id: Value(id),
      sessionId: Value(sessionId),
      playerId: Value(playerId),
      actionType: Value(actionType),
      outcome: outcome == null && nullToAbsent
          ? const Value.absent()
          : Value(outcome),
      clockMs: Value(clockMs),
      rinkZone: rinkZone == null && nullToAbsent
          ? const Value.absent()
          : Value(rinkZone),
      note: note == null && nullToAbsent ? const Value.absent() : Value(note),
      clientEventId: Value(clientEventId),
      deviceId: Value(deviceId),
      createdAt: Value(createdAt),
      updatedAt: Value(updatedAt),
      version: Value(version),
      voidedAt: voidedAt == null && nullToAbsent
          ? const Value.absent()
          : Value(voidedAt),
      voidReason: voidReason == null && nullToAbsent
          ? const Value.absent()
          : Value(voidReason),
    );
  }

  factory MatchAction.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return MatchAction(
      id: serializer.fromJson<String>(json['id']),
      sessionId: serializer.fromJson<String>(json['sessionId']),
      playerId: serializer.fromJson<String>(json['playerId']),
      actionType: serializer.fromJson<String>(json['actionType']),
      outcome: serializer.fromJson<String?>(json['outcome']),
      clockMs: serializer.fromJson<int>(json['clockMs']),
      rinkZone: serializer.fromJson<String?>(json['rinkZone']),
      note: serializer.fromJson<String?>(json['note']),
      clientEventId: serializer.fromJson<String>(json['clientEventId']),
      deviceId: serializer.fromJson<String>(json['deviceId']),
      createdAt: serializer.fromJson<DateTime>(json['createdAt']),
      updatedAt: serializer.fromJson<DateTime>(json['updatedAt']),
      version: serializer.fromJson<int>(json['version']),
      voidedAt: serializer.fromJson<DateTime?>(json['voidedAt']),
      voidReason: serializer.fromJson<String?>(json['voidReason']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'sessionId': serializer.toJson<String>(sessionId),
      'playerId': serializer.toJson<String>(playerId),
      'actionType': serializer.toJson<String>(actionType),
      'outcome': serializer.toJson<String?>(outcome),
      'clockMs': serializer.toJson<int>(clockMs),
      'rinkZone': serializer.toJson<String?>(rinkZone),
      'note': serializer.toJson<String?>(note),
      'clientEventId': serializer.toJson<String>(clientEventId),
      'deviceId': serializer.toJson<String>(deviceId),
      'createdAt': serializer.toJson<DateTime>(createdAt),
      'updatedAt': serializer.toJson<DateTime>(updatedAt),
      'version': serializer.toJson<int>(version),
      'voidedAt': serializer.toJson<DateTime?>(voidedAt),
      'voidReason': serializer.toJson<String?>(voidReason),
    };
  }

  MatchAction copyWith({
    String? id,
    String? sessionId,
    String? playerId,
    String? actionType,
    Value<String?> outcome = const Value.absent(),
    int? clockMs,
    Value<String?> rinkZone = const Value.absent(),
    Value<String?> note = const Value.absent(),
    String? clientEventId,
    String? deviceId,
    DateTime? createdAt,
    DateTime? updatedAt,
    int? version,
    Value<DateTime?> voidedAt = const Value.absent(),
    Value<String?> voidReason = const Value.absent(),
  }) => MatchAction(
    id: id ?? this.id,
    sessionId: sessionId ?? this.sessionId,
    playerId: playerId ?? this.playerId,
    actionType: actionType ?? this.actionType,
    outcome: outcome.present ? outcome.value : this.outcome,
    clockMs: clockMs ?? this.clockMs,
    rinkZone: rinkZone.present ? rinkZone.value : this.rinkZone,
    note: note.present ? note.value : this.note,
    clientEventId: clientEventId ?? this.clientEventId,
    deviceId: deviceId ?? this.deviceId,
    createdAt: createdAt ?? this.createdAt,
    updatedAt: updatedAt ?? this.updatedAt,
    version: version ?? this.version,
    voidedAt: voidedAt.present ? voidedAt.value : this.voidedAt,
    voidReason: voidReason.present ? voidReason.value : this.voidReason,
  );
  MatchAction copyWithCompanion(MatchActionsCompanion data) {
    return MatchAction(
      id: data.id.present ? data.id.value : this.id,
      sessionId: data.sessionId.present ? data.sessionId.value : this.sessionId,
      playerId: data.playerId.present ? data.playerId.value : this.playerId,
      actionType: data.actionType.present
          ? data.actionType.value
          : this.actionType,
      outcome: data.outcome.present ? data.outcome.value : this.outcome,
      clockMs: data.clockMs.present ? data.clockMs.value : this.clockMs,
      rinkZone: data.rinkZone.present ? data.rinkZone.value : this.rinkZone,
      note: data.note.present ? data.note.value : this.note,
      clientEventId: data.clientEventId.present
          ? data.clientEventId.value
          : this.clientEventId,
      deviceId: data.deviceId.present ? data.deviceId.value : this.deviceId,
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
      updatedAt: data.updatedAt.present ? data.updatedAt.value : this.updatedAt,
      version: data.version.present ? data.version.value : this.version,
      voidedAt: data.voidedAt.present ? data.voidedAt.value : this.voidedAt,
      voidReason: data.voidReason.present
          ? data.voidReason.value
          : this.voidReason,
    );
  }

  @override
  String toString() {
    return (StringBuffer('MatchAction(')
          ..write('id: $id, ')
          ..write('sessionId: $sessionId, ')
          ..write('playerId: $playerId, ')
          ..write('actionType: $actionType, ')
          ..write('outcome: $outcome, ')
          ..write('clockMs: $clockMs, ')
          ..write('rinkZone: $rinkZone, ')
          ..write('note: $note, ')
          ..write('clientEventId: $clientEventId, ')
          ..write('deviceId: $deviceId, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt, ')
          ..write('version: $version, ')
          ..write('voidedAt: $voidedAt, ')
          ..write('voidReason: $voidReason')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    id,
    sessionId,
    playerId,
    actionType,
    outcome,
    clockMs,
    rinkZone,
    note,
    clientEventId,
    deviceId,
    createdAt,
    updatedAt,
    version,
    voidedAt,
    voidReason,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is MatchAction &&
          other.id == this.id &&
          other.sessionId == this.sessionId &&
          other.playerId == this.playerId &&
          other.actionType == this.actionType &&
          other.outcome == this.outcome &&
          other.clockMs == this.clockMs &&
          other.rinkZone == this.rinkZone &&
          other.note == this.note &&
          other.clientEventId == this.clientEventId &&
          other.deviceId == this.deviceId &&
          other.createdAt == this.createdAt &&
          other.updatedAt == this.updatedAt &&
          other.version == this.version &&
          other.voidedAt == this.voidedAt &&
          other.voidReason == this.voidReason);
}

class MatchActionsCompanion extends UpdateCompanion<MatchAction> {
  final Value<String> id;
  final Value<String> sessionId;
  final Value<String> playerId;
  final Value<String> actionType;
  final Value<String?> outcome;
  final Value<int> clockMs;
  final Value<String?> rinkZone;
  final Value<String?> note;
  final Value<String> clientEventId;
  final Value<String> deviceId;
  final Value<DateTime> createdAt;
  final Value<DateTime> updatedAt;
  final Value<int> version;
  final Value<DateTime?> voidedAt;
  final Value<String?> voidReason;
  final Value<int> rowid;
  const MatchActionsCompanion({
    this.id = const Value.absent(),
    this.sessionId = const Value.absent(),
    this.playerId = const Value.absent(),
    this.actionType = const Value.absent(),
    this.outcome = const Value.absent(),
    this.clockMs = const Value.absent(),
    this.rinkZone = const Value.absent(),
    this.note = const Value.absent(),
    this.clientEventId = const Value.absent(),
    this.deviceId = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.updatedAt = const Value.absent(),
    this.version = const Value.absent(),
    this.voidedAt = const Value.absent(),
    this.voidReason = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  MatchActionsCompanion.insert({
    required String id,
    required String sessionId,
    required String playerId,
    required String actionType,
    this.outcome = const Value.absent(),
    required int clockMs,
    this.rinkZone = const Value.absent(),
    this.note = const Value.absent(),
    required String clientEventId,
    required String deviceId,
    required DateTime createdAt,
    required DateTime updatedAt,
    this.version = const Value.absent(),
    this.voidedAt = const Value.absent(),
    this.voidReason = const Value.absent(),
    this.rowid = const Value.absent(),
  }) : id = Value(id),
       sessionId = Value(sessionId),
       playerId = Value(playerId),
       actionType = Value(actionType),
       clockMs = Value(clockMs),
       clientEventId = Value(clientEventId),
       deviceId = Value(deviceId),
       createdAt = Value(createdAt),
       updatedAt = Value(updatedAt);
  static Insertable<MatchAction> custom({
    Expression<String>? id,
    Expression<String>? sessionId,
    Expression<String>? playerId,
    Expression<String>? actionType,
    Expression<String>? outcome,
    Expression<int>? clockMs,
    Expression<String>? rinkZone,
    Expression<String>? note,
    Expression<String>? clientEventId,
    Expression<String>? deviceId,
    Expression<DateTime>? createdAt,
    Expression<DateTime>? updatedAt,
    Expression<int>? version,
    Expression<DateTime>? voidedAt,
    Expression<String>? voidReason,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (sessionId != null) 'session_id': sessionId,
      if (playerId != null) 'player_id': playerId,
      if (actionType != null) 'action_type': actionType,
      if (outcome != null) 'outcome': outcome,
      if (clockMs != null) 'clock_ms': clockMs,
      if (rinkZone != null) 'rink_zone': rinkZone,
      if (note != null) 'note': note,
      if (clientEventId != null) 'client_event_id': clientEventId,
      if (deviceId != null) 'device_id': deviceId,
      if (createdAt != null) 'created_at': createdAt,
      if (updatedAt != null) 'updated_at': updatedAt,
      if (version != null) 'version': version,
      if (voidedAt != null) 'voided_at': voidedAt,
      if (voidReason != null) 'void_reason': voidReason,
      if (rowid != null) 'rowid': rowid,
    });
  }

  MatchActionsCompanion copyWith({
    Value<String>? id,
    Value<String>? sessionId,
    Value<String>? playerId,
    Value<String>? actionType,
    Value<String?>? outcome,
    Value<int>? clockMs,
    Value<String?>? rinkZone,
    Value<String?>? note,
    Value<String>? clientEventId,
    Value<String>? deviceId,
    Value<DateTime>? createdAt,
    Value<DateTime>? updatedAt,
    Value<int>? version,
    Value<DateTime?>? voidedAt,
    Value<String?>? voidReason,
    Value<int>? rowid,
  }) {
    return MatchActionsCompanion(
      id: id ?? this.id,
      sessionId: sessionId ?? this.sessionId,
      playerId: playerId ?? this.playerId,
      actionType: actionType ?? this.actionType,
      outcome: outcome ?? this.outcome,
      clockMs: clockMs ?? this.clockMs,
      rinkZone: rinkZone ?? this.rinkZone,
      note: note ?? this.note,
      clientEventId: clientEventId ?? this.clientEventId,
      deviceId: deviceId ?? this.deviceId,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      version: version ?? this.version,
      voidedAt: voidedAt ?? this.voidedAt,
      voidReason: voidReason ?? this.voidReason,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (sessionId.present) {
      map['session_id'] = Variable<String>(sessionId.value);
    }
    if (playerId.present) {
      map['player_id'] = Variable<String>(playerId.value);
    }
    if (actionType.present) {
      map['action_type'] = Variable<String>(actionType.value);
    }
    if (outcome.present) {
      map['outcome'] = Variable<String>(outcome.value);
    }
    if (clockMs.present) {
      map['clock_ms'] = Variable<int>(clockMs.value);
    }
    if (rinkZone.present) {
      map['rink_zone'] = Variable<String>(rinkZone.value);
    }
    if (note.present) {
      map['note'] = Variable<String>(note.value);
    }
    if (clientEventId.present) {
      map['client_event_id'] = Variable<String>(clientEventId.value);
    }
    if (deviceId.present) {
      map['device_id'] = Variable<String>(deviceId.value);
    }
    if (createdAt.present) {
      map['created_at'] = Variable<DateTime>(createdAt.value);
    }
    if (updatedAt.present) {
      map['updated_at'] = Variable<DateTime>(updatedAt.value);
    }
    if (version.present) {
      map['version'] = Variable<int>(version.value);
    }
    if (voidedAt.present) {
      map['voided_at'] = Variable<DateTime>(voidedAt.value);
    }
    if (voidReason.present) {
      map['void_reason'] = Variable<String>(voidReason.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('MatchActionsCompanion(')
          ..write('id: $id, ')
          ..write('sessionId: $sessionId, ')
          ..write('playerId: $playerId, ')
          ..write('actionType: $actionType, ')
          ..write('outcome: $outcome, ')
          ..write('clockMs: $clockMs, ')
          ..write('rinkZone: $rinkZone, ')
          ..write('note: $note, ')
          ..write('clientEventId: $clientEventId, ')
          ..write('deviceId: $deviceId, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt, ')
          ..write('version: $version, ')
          ..write('voidedAt: $voidedAt, ')
          ..write('voidReason: $voidReason, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $ShootDetailsTable extends ShootDetails
    with TableInfo<$ShootDetailsTable, ShootDetail> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $ShootDetailsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _actionIdMeta = const VerificationMeta(
    'actionId',
  );
  @override
  late final GeneratedColumn<String> actionId = GeneratedColumn<String>(
    'action_id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'REFERENCES match_actions (id) ON DELETE CASCADE',
    ),
  );
  static const VerificationMeta _targetZoneMeta = const VerificationMeta(
    'targetZone',
  );
  @override
  late final GeneratedColumn<String> targetZone = GeneratedColumn<String>(
    'target_zone',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _isGoalMeta = const VerificationMeta('isGoal');
  @override
  late final GeneratedColumn<bool> isGoal = GeneratedColumn<bool>(
    'is_goal',
    aliasedName,
    false,
    type: DriftSqlType.bool,
    requiredDuringInsert: true,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'CHECK ("is_goal" IN (0, 1))',
    ),
  );
  static const VerificationMeta _goalieTouchedMeta = const VerificationMeta(
    'goalieTouched',
  );
  @override
  late final GeneratedColumn<bool> goalieTouched = GeneratedColumn<bool>(
    'goalie_touched',
    aliasedName,
    true,
    type: DriftSqlType.bool,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'CHECK ("goalie_touched" IN (0, 1))',
    ),
  );
  @override
  List<GeneratedColumn> get $columns => [
    actionId,
    targetZone,
    isGoal,
    goalieTouched,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'shoot_details';
  @override
  VerificationContext validateIntegrity(
    Insertable<ShootDetail> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('action_id')) {
      context.handle(
        _actionIdMeta,
        actionId.isAcceptableOrUnknown(data['action_id']!, _actionIdMeta),
      );
    } else if (isInserting) {
      context.missing(_actionIdMeta);
    }
    if (data.containsKey('target_zone')) {
      context.handle(
        _targetZoneMeta,
        targetZone.isAcceptableOrUnknown(data['target_zone']!, _targetZoneMeta),
      );
    } else if (isInserting) {
      context.missing(_targetZoneMeta);
    }
    if (data.containsKey('is_goal')) {
      context.handle(
        _isGoalMeta,
        isGoal.isAcceptableOrUnknown(data['is_goal']!, _isGoalMeta),
      );
    } else if (isInserting) {
      context.missing(_isGoalMeta);
    }
    if (data.containsKey('goalie_touched')) {
      context.handle(
        _goalieTouchedMeta,
        goalieTouched.isAcceptableOrUnknown(
          data['goalie_touched']!,
          _goalieTouchedMeta,
        ),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {actionId};
  @override
  ShootDetail map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return ShootDetail(
      actionId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}action_id'],
      )!,
      targetZone: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}target_zone'],
      )!,
      isGoal: attachedDatabase.typeMapping.read(
        DriftSqlType.bool,
        data['${effectivePrefix}is_goal'],
      )!,
      goalieTouched: attachedDatabase.typeMapping.read(
        DriftSqlType.bool,
        data['${effectivePrefix}goalie_touched'],
      ),
    );
  }

  @override
  $ShootDetailsTable createAlias(String alias) {
    return $ShootDetailsTable(attachedDatabase, alias);
  }
}

class ShootDetail extends DataClass implements Insertable<ShootDetail> {
  final String actionId;
  final String targetZone;
  final bool isGoal;
  final bool? goalieTouched;
  const ShootDetail({
    required this.actionId,
    required this.targetZone,
    required this.isGoal,
    this.goalieTouched,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['action_id'] = Variable<String>(actionId);
    map['target_zone'] = Variable<String>(targetZone);
    map['is_goal'] = Variable<bool>(isGoal);
    if (!nullToAbsent || goalieTouched != null) {
      map['goalie_touched'] = Variable<bool>(goalieTouched);
    }
    return map;
  }

  ShootDetailsCompanion toCompanion(bool nullToAbsent) {
    return ShootDetailsCompanion(
      actionId: Value(actionId),
      targetZone: Value(targetZone),
      isGoal: Value(isGoal),
      goalieTouched: goalieTouched == null && nullToAbsent
          ? const Value.absent()
          : Value(goalieTouched),
    );
  }

  factory ShootDetail.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return ShootDetail(
      actionId: serializer.fromJson<String>(json['actionId']),
      targetZone: serializer.fromJson<String>(json['targetZone']),
      isGoal: serializer.fromJson<bool>(json['isGoal']),
      goalieTouched: serializer.fromJson<bool?>(json['goalieTouched']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'actionId': serializer.toJson<String>(actionId),
      'targetZone': serializer.toJson<String>(targetZone),
      'isGoal': serializer.toJson<bool>(isGoal),
      'goalieTouched': serializer.toJson<bool?>(goalieTouched),
    };
  }

  ShootDetail copyWith({
    String? actionId,
    String? targetZone,
    bool? isGoal,
    Value<bool?> goalieTouched = const Value.absent(),
  }) => ShootDetail(
    actionId: actionId ?? this.actionId,
    targetZone: targetZone ?? this.targetZone,
    isGoal: isGoal ?? this.isGoal,
    goalieTouched: goalieTouched.present
        ? goalieTouched.value
        : this.goalieTouched,
  );
  ShootDetail copyWithCompanion(ShootDetailsCompanion data) {
    return ShootDetail(
      actionId: data.actionId.present ? data.actionId.value : this.actionId,
      targetZone: data.targetZone.present
          ? data.targetZone.value
          : this.targetZone,
      isGoal: data.isGoal.present ? data.isGoal.value : this.isGoal,
      goalieTouched: data.goalieTouched.present
          ? data.goalieTouched.value
          : this.goalieTouched,
    );
  }

  @override
  String toString() {
    return (StringBuffer('ShootDetail(')
          ..write('actionId: $actionId, ')
          ..write('targetZone: $targetZone, ')
          ..write('isGoal: $isGoal, ')
          ..write('goalieTouched: $goalieTouched')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(actionId, targetZone, isGoal, goalieTouched);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is ShootDetail &&
          other.actionId == this.actionId &&
          other.targetZone == this.targetZone &&
          other.isGoal == this.isGoal &&
          other.goalieTouched == this.goalieTouched);
}

class ShootDetailsCompanion extends UpdateCompanion<ShootDetail> {
  final Value<String> actionId;
  final Value<String> targetZone;
  final Value<bool> isGoal;
  final Value<bool?> goalieTouched;
  final Value<int> rowid;
  const ShootDetailsCompanion({
    this.actionId = const Value.absent(),
    this.targetZone = const Value.absent(),
    this.isGoal = const Value.absent(),
    this.goalieTouched = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  ShootDetailsCompanion.insert({
    required String actionId,
    required String targetZone,
    required bool isGoal,
    this.goalieTouched = const Value.absent(),
    this.rowid = const Value.absent(),
  }) : actionId = Value(actionId),
       targetZone = Value(targetZone),
       isGoal = Value(isGoal);
  static Insertable<ShootDetail> custom({
    Expression<String>? actionId,
    Expression<String>? targetZone,
    Expression<bool>? isGoal,
    Expression<bool>? goalieTouched,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (actionId != null) 'action_id': actionId,
      if (targetZone != null) 'target_zone': targetZone,
      if (isGoal != null) 'is_goal': isGoal,
      if (goalieTouched != null) 'goalie_touched': goalieTouched,
      if (rowid != null) 'rowid': rowid,
    });
  }

  ShootDetailsCompanion copyWith({
    Value<String>? actionId,
    Value<String>? targetZone,
    Value<bool>? isGoal,
    Value<bool?>? goalieTouched,
    Value<int>? rowid,
  }) {
    return ShootDetailsCompanion(
      actionId: actionId ?? this.actionId,
      targetZone: targetZone ?? this.targetZone,
      isGoal: isGoal ?? this.isGoal,
      goalieTouched: goalieTouched ?? this.goalieTouched,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (actionId.present) {
      map['action_id'] = Variable<String>(actionId.value);
    }
    if (targetZone.present) {
      map['target_zone'] = Variable<String>(targetZone.value);
    }
    if (isGoal.present) {
      map['is_goal'] = Variable<bool>(isGoal.value);
    }
    if (goalieTouched.present) {
      map['goalie_touched'] = Variable<bool>(goalieTouched.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('ShootDetailsCompanion(')
          ..write('actionId: $actionId, ')
          ..write('targetZone: $targetZone, ')
          ..write('isGoal: $isGoal, ')
          ..write('goalieTouched: $goalieTouched, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $GoalkeeperActionsTable extends GoalkeeperActions
    with TableInfo<$GoalkeeperActionsTable, GoalkeeperAction> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $GoalkeeperActionsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
    'id',
    aliasedName,
    false,
    additionalChecks: GeneratedColumn.checkTextLength(),
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _sessionIdMeta = const VerificationMeta(
    'sessionId',
  );
  @override
  late final GeneratedColumn<String> sessionId = GeneratedColumn<String>(
    'session_id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'REFERENCES tournament_sessions (id)',
    ),
  );
  static const VerificationMeta _goalkeeperIdMeta = const VerificationMeta(
    'goalkeeperId',
  );
  @override
  late final GeneratedColumn<String> goalkeeperId = GeneratedColumn<String>(
    'goalkeeper_id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'REFERENCES players (id)',
    ),
  );
  static const VerificationMeta _actionTypeMeta = const VerificationMeta(
    'actionType',
  );
  @override
  late final GeneratedColumn<String> actionType = GeneratedColumn<String>(
    'action_type',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _clockMsMeta = const VerificationMeta(
    'clockMs',
  );
  @override
  late final GeneratedColumn<int> clockMs = GeneratedColumn<int>(
    'clock_ms',
    aliasedName,
    false,
    check: () => ComparableExpr(clockMs).isBiggerOrEqualValue(0),
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _rinkZoneMeta = const VerificationMeta(
    'rinkZone',
  );
  @override
  late final GeneratedColumn<String> rinkZone = GeneratedColumn<String>(
    'rink_zone',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _targetZoneMeta = const VerificationMeta(
    'targetZone',
  );
  @override
  late final GeneratedColumn<String> targetZone = GeneratedColumn<String>(
    'target_zone',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _noteMeta = const VerificationMeta('note');
  @override
  late final GeneratedColumn<String> note = GeneratedColumn<String>(
    'note',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _clientEventIdMeta = const VerificationMeta(
    'clientEventId',
  );
  @override
  late final GeneratedColumn<String> clientEventId = GeneratedColumn<String>(
    'client_event_id',
    aliasedName,
    false,
    additionalChecks: GeneratedColumn.checkTextLength(),
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _deviceIdMeta = const VerificationMeta(
    'deviceId',
  );
  @override
  late final GeneratedColumn<String> deviceId = GeneratedColumn<String>(
    'device_id',
    aliasedName,
    false,
    additionalChecks: GeneratedColumn.checkTextLength(),
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _createdAtMeta = const VerificationMeta(
    'createdAt',
  );
  @override
  late final GeneratedColumn<DateTime> createdAt = GeneratedColumn<DateTime>(
    'created_at',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _updatedAtMeta = const VerificationMeta(
    'updatedAt',
  );
  @override
  late final GeneratedColumn<DateTime> updatedAt = GeneratedColumn<DateTime>(
    'updated_at',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _versionMeta = const VerificationMeta(
    'version',
  );
  @override
  late final GeneratedColumn<int> version = GeneratedColumn<int>(
    'version',
    aliasedName,
    false,
    check: () => ComparableExpr(version).isBiggerOrEqualValue(1),
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultValue: const Constant(1),
  );
  static const VerificationMeta _voidedAtMeta = const VerificationMeta(
    'voidedAt',
  );
  @override
  late final GeneratedColumn<DateTime> voidedAt = GeneratedColumn<DateTime>(
    'voided_at',
    aliasedName,
    true,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _voidReasonMeta = const VerificationMeta(
    'voidReason',
  );
  @override
  late final GeneratedColumn<String> voidReason = GeneratedColumn<String>(
    'void_reason',
    aliasedName,
    true,
    additionalChecks: GeneratedColumn.checkTextLength(maxTextLength: 200),
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    sessionId,
    goalkeeperId,
    actionType,
    clockMs,
    rinkZone,
    targetZone,
    note,
    clientEventId,
    deviceId,
    createdAt,
    updatedAt,
    version,
    voidedAt,
    voidReason,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'goalkeeper_actions';
  @override
  VerificationContext validateIntegrity(
    Insertable<GoalkeeperAction> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('session_id')) {
      context.handle(
        _sessionIdMeta,
        sessionId.isAcceptableOrUnknown(data['session_id']!, _sessionIdMeta),
      );
    } else if (isInserting) {
      context.missing(_sessionIdMeta);
    }
    if (data.containsKey('goalkeeper_id')) {
      context.handle(
        _goalkeeperIdMeta,
        goalkeeperId.isAcceptableOrUnknown(
          data['goalkeeper_id']!,
          _goalkeeperIdMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_goalkeeperIdMeta);
    }
    if (data.containsKey('action_type')) {
      context.handle(
        _actionTypeMeta,
        actionType.isAcceptableOrUnknown(data['action_type']!, _actionTypeMeta),
      );
    } else if (isInserting) {
      context.missing(_actionTypeMeta);
    }
    if (data.containsKey('clock_ms')) {
      context.handle(
        _clockMsMeta,
        clockMs.isAcceptableOrUnknown(data['clock_ms']!, _clockMsMeta),
      );
    } else if (isInserting) {
      context.missing(_clockMsMeta);
    }
    if (data.containsKey('rink_zone')) {
      context.handle(
        _rinkZoneMeta,
        rinkZone.isAcceptableOrUnknown(data['rink_zone']!, _rinkZoneMeta),
      );
    }
    if (data.containsKey('target_zone')) {
      context.handle(
        _targetZoneMeta,
        targetZone.isAcceptableOrUnknown(data['target_zone']!, _targetZoneMeta),
      );
    }
    if (data.containsKey('note')) {
      context.handle(
        _noteMeta,
        note.isAcceptableOrUnknown(data['note']!, _noteMeta),
      );
    }
    if (data.containsKey('client_event_id')) {
      context.handle(
        _clientEventIdMeta,
        clientEventId.isAcceptableOrUnknown(
          data['client_event_id']!,
          _clientEventIdMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_clientEventIdMeta);
    }
    if (data.containsKey('device_id')) {
      context.handle(
        _deviceIdMeta,
        deviceId.isAcceptableOrUnknown(data['device_id']!, _deviceIdMeta),
      );
    } else if (isInserting) {
      context.missing(_deviceIdMeta);
    }
    if (data.containsKey('created_at')) {
      context.handle(
        _createdAtMeta,
        createdAt.isAcceptableOrUnknown(data['created_at']!, _createdAtMeta),
      );
    } else if (isInserting) {
      context.missing(_createdAtMeta);
    }
    if (data.containsKey('updated_at')) {
      context.handle(
        _updatedAtMeta,
        updatedAt.isAcceptableOrUnknown(data['updated_at']!, _updatedAtMeta),
      );
    } else if (isInserting) {
      context.missing(_updatedAtMeta);
    }
    if (data.containsKey('version')) {
      context.handle(
        _versionMeta,
        version.isAcceptableOrUnknown(data['version']!, _versionMeta),
      );
    }
    if (data.containsKey('voided_at')) {
      context.handle(
        _voidedAtMeta,
        voidedAt.isAcceptableOrUnknown(data['voided_at']!, _voidedAtMeta),
      );
    }
    if (data.containsKey('void_reason')) {
      context.handle(
        _voidReasonMeta,
        voidReason.isAcceptableOrUnknown(data['void_reason']!, _voidReasonMeta),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  List<Set<GeneratedColumn>> get uniqueKeys => [
    {deviceId, clientEventId},
  ];
  @override
  GoalkeeperAction map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return GoalkeeperAction(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}id'],
      )!,
      sessionId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}session_id'],
      )!,
      goalkeeperId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}goalkeeper_id'],
      )!,
      actionType: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}action_type'],
      )!,
      clockMs: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}clock_ms'],
      )!,
      rinkZone: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}rink_zone'],
      ),
      targetZone: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}target_zone'],
      ),
      note: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}note'],
      ),
      clientEventId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}client_event_id'],
      )!,
      deviceId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}device_id'],
      )!,
      createdAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}created_at'],
      )!,
      updatedAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}updated_at'],
      )!,
      version: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}version'],
      )!,
      voidedAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}voided_at'],
      ),
      voidReason: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}void_reason'],
      ),
    );
  }

  @override
  $GoalkeeperActionsTable createAlias(String alias) {
    return $GoalkeeperActionsTable(attachedDatabase, alias);
  }
}

class GoalkeeperAction extends DataClass
    implements Insertable<GoalkeeperAction> {
  final String id;
  final String sessionId;
  final String goalkeeperId;
  final String actionType;
  final int clockMs;
  final String? rinkZone;
  final String? targetZone;
  final String? note;
  final String clientEventId;
  final String deviceId;
  final DateTime createdAt;
  final DateTime updatedAt;
  final int version;
  final DateTime? voidedAt;
  final String? voidReason;
  const GoalkeeperAction({
    required this.id,
    required this.sessionId,
    required this.goalkeeperId,
    required this.actionType,
    required this.clockMs,
    this.rinkZone,
    this.targetZone,
    this.note,
    required this.clientEventId,
    required this.deviceId,
    required this.createdAt,
    required this.updatedAt,
    required this.version,
    this.voidedAt,
    this.voidReason,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['session_id'] = Variable<String>(sessionId);
    map['goalkeeper_id'] = Variable<String>(goalkeeperId);
    map['action_type'] = Variable<String>(actionType);
    map['clock_ms'] = Variable<int>(clockMs);
    if (!nullToAbsent || rinkZone != null) {
      map['rink_zone'] = Variable<String>(rinkZone);
    }
    if (!nullToAbsent || targetZone != null) {
      map['target_zone'] = Variable<String>(targetZone);
    }
    if (!nullToAbsent || note != null) {
      map['note'] = Variable<String>(note);
    }
    map['client_event_id'] = Variable<String>(clientEventId);
    map['device_id'] = Variable<String>(deviceId);
    map['created_at'] = Variable<DateTime>(createdAt);
    map['updated_at'] = Variable<DateTime>(updatedAt);
    map['version'] = Variable<int>(version);
    if (!nullToAbsent || voidedAt != null) {
      map['voided_at'] = Variable<DateTime>(voidedAt);
    }
    if (!nullToAbsent || voidReason != null) {
      map['void_reason'] = Variable<String>(voidReason);
    }
    return map;
  }

  GoalkeeperActionsCompanion toCompanion(bool nullToAbsent) {
    return GoalkeeperActionsCompanion(
      id: Value(id),
      sessionId: Value(sessionId),
      goalkeeperId: Value(goalkeeperId),
      actionType: Value(actionType),
      clockMs: Value(clockMs),
      rinkZone: rinkZone == null && nullToAbsent
          ? const Value.absent()
          : Value(rinkZone),
      targetZone: targetZone == null && nullToAbsent
          ? const Value.absent()
          : Value(targetZone),
      note: note == null && nullToAbsent ? const Value.absent() : Value(note),
      clientEventId: Value(clientEventId),
      deviceId: Value(deviceId),
      createdAt: Value(createdAt),
      updatedAt: Value(updatedAt),
      version: Value(version),
      voidedAt: voidedAt == null && nullToAbsent
          ? const Value.absent()
          : Value(voidedAt),
      voidReason: voidReason == null && nullToAbsent
          ? const Value.absent()
          : Value(voidReason),
    );
  }

  factory GoalkeeperAction.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return GoalkeeperAction(
      id: serializer.fromJson<String>(json['id']),
      sessionId: serializer.fromJson<String>(json['sessionId']),
      goalkeeperId: serializer.fromJson<String>(json['goalkeeperId']),
      actionType: serializer.fromJson<String>(json['actionType']),
      clockMs: serializer.fromJson<int>(json['clockMs']),
      rinkZone: serializer.fromJson<String?>(json['rinkZone']),
      targetZone: serializer.fromJson<String?>(json['targetZone']),
      note: serializer.fromJson<String?>(json['note']),
      clientEventId: serializer.fromJson<String>(json['clientEventId']),
      deviceId: serializer.fromJson<String>(json['deviceId']),
      createdAt: serializer.fromJson<DateTime>(json['createdAt']),
      updatedAt: serializer.fromJson<DateTime>(json['updatedAt']),
      version: serializer.fromJson<int>(json['version']),
      voidedAt: serializer.fromJson<DateTime?>(json['voidedAt']),
      voidReason: serializer.fromJson<String?>(json['voidReason']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'sessionId': serializer.toJson<String>(sessionId),
      'goalkeeperId': serializer.toJson<String>(goalkeeperId),
      'actionType': serializer.toJson<String>(actionType),
      'clockMs': serializer.toJson<int>(clockMs),
      'rinkZone': serializer.toJson<String?>(rinkZone),
      'targetZone': serializer.toJson<String?>(targetZone),
      'note': serializer.toJson<String?>(note),
      'clientEventId': serializer.toJson<String>(clientEventId),
      'deviceId': serializer.toJson<String>(deviceId),
      'createdAt': serializer.toJson<DateTime>(createdAt),
      'updatedAt': serializer.toJson<DateTime>(updatedAt),
      'version': serializer.toJson<int>(version),
      'voidedAt': serializer.toJson<DateTime?>(voidedAt),
      'voidReason': serializer.toJson<String?>(voidReason),
    };
  }

  GoalkeeperAction copyWith({
    String? id,
    String? sessionId,
    String? goalkeeperId,
    String? actionType,
    int? clockMs,
    Value<String?> rinkZone = const Value.absent(),
    Value<String?> targetZone = const Value.absent(),
    Value<String?> note = const Value.absent(),
    String? clientEventId,
    String? deviceId,
    DateTime? createdAt,
    DateTime? updatedAt,
    int? version,
    Value<DateTime?> voidedAt = const Value.absent(),
    Value<String?> voidReason = const Value.absent(),
  }) => GoalkeeperAction(
    id: id ?? this.id,
    sessionId: sessionId ?? this.sessionId,
    goalkeeperId: goalkeeperId ?? this.goalkeeperId,
    actionType: actionType ?? this.actionType,
    clockMs: clockMs ?? this.clockMs,
    rinkZone: rinkZone.present ? rinkZone.value : this.rinkZone,
    targetZone: targetZone.present ? targetZone.value : this.targetZone,
    note: note.present ? note.value : this.note,
    clientEventId: clientEventId ?? this.clientEventId,
    deviceId: deviceId ?? this.deviceId,
    createdAt: createdAt ?? this.createdAt,
    updatedAt: updatedAt ?? this.updatedAt,
    version: version ?? this.version,
    voidedAt: voidedAt.present ? voidedAt.value : this.voidedAt,
    voidReason: voidReason.present ? voidReason.value : this.voidReason,
  );
  GoalkeeperAction copyWithCompanion(GoalkeeperActionsCompanion data) {
    return GoalkeeperAction(
      id: data.id.present ? data.id.value : this.id,
      sessionId: data.sessionId.present ? data.sessionId.value : this.sessionId,
      goalkeeperId: data.goalkeeperId.present
          ? data.goalkeeperId.value
          : this.goalkeeperId,
      actionType: data.actionType.present
          ? data.actionType.value
          : this.actionType,
      clockMs: data.clockMs.present ? data.clockMs.value : this.clockMs,
      rinkZone: data.rinkZone.present ? data.rinkZone.value : this.rinkZone,
      targetZone: data.targetZone.present
          ? data.targetZone.value
          : this.targetZone,
      note: data.note.present ? data.note.value : this.note,
      clientEventId: data.clientEventId.present
          ? data.clientEventId.value
          : this.clientEventId,
      deviceId: data.deviceId.present ? data.deviceId.value : this.deviceId,
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
      updatedAt: data.updatedAt.present ? data.updatedAt.value : this.updatedAt,
      version: data.version.present ? data.version.value : this.version,
      voidedAt: data.voidedAt.present ? data.voidedAt.value : this.voidedAt,
      voidReason: data.voidReason.present
          ? data.voidReason.value
          : this.voidReason,
    );
  }

  @override
  String toString() {
    return (StringBuffer('GoalkeeperAction(')
          ..write('id: $id, ')
          ..write('sessionId: $sessionId, ')
          ..write('goalkeeperId: $goalkeeperId, ')
          ..write('actionType: $actionType, ')
          ..write('clockMs: $clockMs, ')
          ..write('rinkZone: $rinkZone, ')
          ..write('targetZone: $targetZone, ')
          ..write('note: $note, ')
          ..write('clientEventId: $clientEventId, ')
          ..write('deviceId: $deviceId, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt, ')
          ..write('version: $version, ')
          ..write('voidedAt: $voidedAt, ')
          ..write('voidReason: $voidReason')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    id,
    sessionId,
    goalkeeperId,
    actionType,
    clockMs,
    rinkZone,
    targetZone,
    note,
    clientEventId,
    deviceId,
    createdAt,
    updatedAt,
    version,
    voidedAt,
    voidReason,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is GoalkeeperAction &&
          other.id == this.id &&
          other.sessionId == this.sessionId &&
          other.goalkeeperId == this.goalkeeperId &&
          other.actionType == this.actionType &&
          other.clockMs == this.clockMs &&
          other.rinkZone == this.rinkZone &&
          other.targetZone == this.targetZone &&
          other.note == this.note &&
          other.clientEventId == this.clientEventId &&
          other.deviceId == this.deviceId &&
          other.createdAt == this.createdAt &&
          other.updatedAt == this.updatedAt &&
          other.version == this.version &&
          other.voidedAt == this.voidedAt &&
          other.voidReason == this.voidReason);
}

class GoalkeeperActionsCompanion extends UpdateCompanion<GoalkeeperAction> {
  final Value<String> id;
  final Value<String> sessionId;
  final Value<String> goalkeeperId;
  final Value<String> actionType;
  final Value<int> clockMs;
  final Value<String?> rinkZone;
  final Value<String?> targetZone;
  final Value<String?> note;
  final Value<String> clientEventId;
  final Value<String> deviceId;
  final Value<DateTime> createdAt;
  final Value<DateTime> updatedAt;
  final Value<int> version;
  final Value<DateTime?> voidedAt;
  final Value<String?> voidReason;
  final Value<int> rowid;
  const GoalkeeperActionsCompanion({
    this.id = const Value.absent(),
    this.sessionId = const Value.absent(),
    this.goalkeeperId = const Value.absent(),
    this.actionType = const Value.absent(),
    this.clockMs = const Value.absent(),
    this.rinkZone = const Value.absent(),
    this.targetZone = const Value.absent(),
    this.note = const Value.absent(),
    this.clientEventId = const Value.absent(),
    this.deviceId = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.updatedAt = const Value.absent(),
    this.version = const Value.absent(),
    this.voidedAt = const Value.absent(),
    this.voidReason = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  GoalkeeperActionsCompanion.insert({
    required String id,
    required String sessionId,
    required String goalkeeperId,
    required String actionType,
    required int clockMs,
    this.rinkZone = const Value.absent(),
    this.targetZone = const Value.absent(),
    this.note = const Value.absent(),
    required String clientEventId,
    required String deviceId,
    required DateTime createdAt,
    required DateTime updatedAt,
    this.version = const Value.absent(),
    this.voidedAt = const Value.absent(),
    this.voidReason = const Value.absent(),
    this.rowid = const Value.absent(),
  }) : id = Value(id),
       sessionId = Value(sessionId),
       goalkeeperId = Value(goalkeeperId),
       actionType = Value(actionType),
       clockMs = Value(clockMs),
       clientEventId = Value(clientEventId),
       deviceId = Value(deviceId),
       createdAt = Value(createdAt),
       updatedAt = Value(updatedAt);
  static Insertable<GoalkeeperAction> custom({
    Expression<String>? id,
    Expression<String>? sessionId,
    Expression<String>? goalkeeperId,
    Expression<String>? actionType,
    Expression<int>? clockMs,
    Expression<String>? rinkZone,
    Expression<String>? targetZone,
    Expression<String>? note,
    Expression<String>? clientEventId,
    Expression<String>? deviceId,
    Expression<DateTime>? createdAt,
    Expression<DateTime>? updatedAt,
    Expression<int>? version,
    Expression<DateTime>? voidedAt,
    Expression<String>? voidReason,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (sessionId != null) 'session_id': sessionId,
      if (goalkeeperId != null) 'goalkeeper_id': goalkeeperId,
      if (actionType != null) 'action_type': actionType,
      if (clockMs != null) 'clock_ms': clockMs,
      if (rinkZone != null) 'rink_zone': rinkZone,
      if (targetZone != null) 'target_zone': targetZone,
      if (note != null) 'note': note,
      if (clientEventId != null) 'client_event_id': clientEventId,
      if (deviceId != null) 'device_id': deviceId,
      if (createdAt != null) 'created_at': createdAt,
      if (updatedAt != null) 'updated_at': updatedAt,
      if (version != null) 'version': version,
      if (voidedAt != null) 'voided_at': voidedAt,
      if (voidReason != null) 'void_reason': voidReason,
      if (rowid != null) 'rowid': rowid,
    });
  }

  GoalkeeperActionsCompanion copyWith({
    Value<String>? id,
    Value<String>? sessionId,
    Value<String>? goalkeeperId,
    Value<String>? actionType,
    Value<int>? clockMs,
    Value<String?>? rinkZone,
    Value<String?>? targetZone,
    Value<String?>? note,
    Value<String>? clientEventId,
    Value<String>? deviceId,
    Value<DateTime>? createdAt,
    Value<DateTime>? updatedAt,
    Value<int>? version,
    Value<DateTime?>? voidedAt,
    Value<String?>? voidReason,
    Value<int>? rowid,
  }) {
    return GoalkeeperActionsCompanion(
      id: id ?? this.id,
      sessionId: sessionId ?? this.sessionId,
      goalkeeperId: goalkeeperId ?? this.goalkeeperId,
      actionType: actionType ?? this.actionType,
      clockMs: clockMs ?? this.clockMs,
      rinkZone: rinkZone ?? this.rinkZone,
      targetZone: targetZone ?? this.targetZone,
      note: note ?? this.note,
      clientEventId: clientEventId ?? this.clientEventId,
      deviceId: deviceId ?? this.deviceId,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      version: version ?? this.version,
      voidedAt: voidedAt ?? this.voidedAt,
      voidReason: voidReason ?? this.voidReason,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (sessionId.present) {
      map['session_id'] = Variable<String>(sessionId.value);
    }
    if (goalkeeperId.present) {
      map['goalkeeper_id'] = Variable<String>(goalkeeperId.value);
    }
    if (actionType.present) {
      map['action_type'] = Variable<String>(actionType.value);
    }
    if (clockMs.present) {
      map['clock_ms'] = Variable<int>(clockMs.value);
    }
    if (rinkZone.present) {
      map['rink_zone'] = Variable<String>(rinkZone.value);
    }
    if (targetZone.present) {
      map['target_zone'] = Variable<String>(targetZone.value);
    }
    if (note.present) {
      map['note'] = Variable<String>(note.value);
    }
    if (clientEventId.present) {
      map['client_event_id'] = Variable<String>(clientEventId.value);
    }
    if (deviceId.present) {
      map['device_id'] = Variable<String>(deviceId.value);
    }
    if (createdAt.present) {
      map['created_at'] = Variable<DateTime>(createdAt.value);
    }
    if (updatedAt.present) {
      map['updated_at'] = Variable<DateTime>(updatedAt.value);
    }
    if (version.present) {
      map['version'] = Variable<int>(version.value);
    }
    if (voidedAt.present) {
      map['voided_at'] = Variable<DateTime>(voidedAt.value);
    }
    if (voidReason.present) {
      map['void_reason'] = Variable<String>(voidReason.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('GoalkeeperActionsCompanion(')
          ..write('id: $id, ')
          ..write('sessionId: $sessionId, ')
          ..write('goalkeeperId: $goalkeeperId, ')
          ..write('actionType: $actionType, ')
          ..write('clockMs: $clockMs, ')
          ..write('rinkZone: $rinkZone, ')
          ..write('targetZone: $targetZone, ')
          ..write('note: $note, ')
          ..write('clientEventId: $clientEventId, ')
          ..write('deviceId: $deviceId, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt, ')
          ..write('version: $version, ')
          ..write('voidedAt: $voidedAt, ')
          ..write('voidReason: $voidReason, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $SyncQueueTable extends SyncQueue
    with TableInfo<$SyncQueueTable, SyncQueueData> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $SyncQueueTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
    'id',
    aliasedName,
    false,
    additionalChecks: GeneratedColumn.checkTextLength(),
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _entityTypeMeta = const VerificationMeta(
    'entityType',
  );
  @override
  late final GeneratedColumn<String> entityType = GeneratedColumn<String>(
    'entity_type',
    aliasedName,
    false,
    check: () => entityType.isIn(
      _storageValues(SyncEntityType.values, (type) => type.storageValue),
    ),
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _entityIdMeta = const VerificationMeta(
    'entityId',
  );
  @override
  late final GeneratedColumn<String> entityId = GeneratedColumn<String>(
    'entity_id',
    aliasedName,
    false,
    additionalChecks: GeneratedColumn.checkTextLength(),
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _operationMeta = const VerificationMeta(
    'operation',
  );
  @override
  late final GeneratedColumn<String> operation = GeneratedColumn<String>(
    'operation',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    defaultValue: Constant(SyncOperation.upsert.storageValue),
  );
  static const VerificationMeta _payloadJsonMeta = const VerificationMeta(
    'payloadJson',
  );
  @override
  late final GeneratedColumn<String> payloadJson = GeneratedColumn<String>(
    'payload_json',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _stateMeta = const VerificationMeta('state');
  @override
  late final GeneratedColumn<String> state = GeneratedColumn<String>(
    'state',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    defaultValue: Constant(SyncState.pending.storageValue),
  );
  static const VerificationMeta _attemptsMeta = const VerificationMeta(
    'attempts',
  );
  @override
  late final GeneratedColumn<int> attempts = GeneratedColumn<int>(
    'attempts',
    aliasedName,
    false,
    check: () => ComparableExpr(attempts).isBiggerOrEqualValue(0),
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultValue: const Constant(0),
  );
  static const VerificationMeta _nextAttemptAtMeta = const VerificationMeta(
    'nextAttemptAt',
  );
  @override
  late final GeneratedColumn<DateTime> nextAttemptAt =
      GeneratedColumn<DateTime>(
        'next_attempt_at',
        aliasedName,
        true,
        type: DriftSqlType.dateTime,
        requiredDuringInsert: false,
      );
  static const VerificationMeta _lastErrorMeta = const VerificationMeta(
    'lastError',
  );
  @override
  late final GeneratedColumn<String> lastError = GeneratedColumn<String>(
    'last_error',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _createdAtMeta = const VerificationMeta(
    'createdAt',
  );
  @override
  late final GeneratedColumn<DateTime> createdAt = GeneratedColumn<DateTime>(
    'created_at',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _updatedAtMeta = const VerificationMeta(
    'updatedAt',
  );
  @override
  late final GeneratedColumn<DateTime> updatedAt = GeneratedColumn<DateTime>(
    'updated_at',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: true,
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    entityType,
    entityId,
    operation,
    payloadJson,
    state,
    attempts,
    nextAttemptAt,
    lastError,
    createdAt,
    updatedAt,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'sync_queue';
  @override
  VerificationContext validateIntegrity(
    Insertable<SyncQueueData> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('entity_type')) {
      context.handle(
        _entityTypeMeta,
        entityType.isAcceptableOrUnknown(data['entity_type']!, _entityTypeMeta),
      );
    } else if (isInserting) {
      context.missing(_entityTypeMeta);
    }
    if (data.containsKey('entity_id')) {
      context.handle(
        _entityIdMeta,
        entityId.isAcceptableOrUnknown(data['entity_id']!, _entityIdMeta),
      );
    } else if (isInserting) {
      context.missing(_entityIdMeta);
    }
    if (data.containsKey('operation')) {
      context.handle(
        _operationMeta,
        operation.isAcceptableOrUnknown(data['operation']!, _operationMeta),
      );
    }
    if (data.containsKey('payload_json')) {
      context.handle(
        _payloadJsonMeta,
        payloadJson.isAcceptableOrUnknown(
          data['payload_json']!,
          _payloadJsonMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_payloadJsonMeta);
    }
    if (data.containsKey('state')) {
      context.handle(
        _stateMeta,
        state.isAcceptableOrUnknown(data['state']!, _stateMeta),
      );
    }
    if (data.containsKey('attempts')) {
      context.handle(
        _attemptsMeta,
        attempts.isAcceptableOrUnknown(data['attempts']!, _attemptsMeta),
      );
    }
    if (data.containsKey('next_attempt_at')) {
      context.handle(
        _nextAttemptAtMeta,
        nextAttemptAt.isAcceptableOrUnknown(
          data['next_attempt_at']!,
          _nextAttemptAtMeta,
        ),
      );
    }
    if (data.containsKey('last_error')) {
      context.handle(
        _lastErrorMeta,
        lastError.isAcceptableOrUnknown(data['last_error']!, _lastErrorMeta),
      );
    }
    if (data.containsKey('created_at')) {
      context.handle(
        _createdAtMeta,
        createdAt.isAcceptableOrUnknown(data['created_at']!, _createdAtMeta),
      );
    } else if (isInserting) {
      context.missing(_createdAtMeta);
    }
    if (data.containsKey('updated_at')) {
      context.handle(
        _updatedAtMeta,
        updatedAt.isAcceptableOrUnknown(data['updated_at']!, _updatedAtMeta),
      );
    } else if (isInserting) {
      context.missing(_updatedAtMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  SyncQueueData map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return SyncQueueData(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}id'],
      )!,
      entityType: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}entity_type'],
      )!,
      entityId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}entity_id'],
      )!,
      operation: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}operation'],
      )!,
      payloadJson: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}payload_json'],
      )!,
      state: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}state'],
      )!,
      attempts: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}attempts'],
      )!,
      nextAttemptAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}next_attempt_at'],
      ),
      lastError: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}last_error'],
      ),
      createdAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}created_at'],
      )!,
      updatedAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}updated_at'],
      )!,
    );
  }

  @override
  $SyncQueueTable createAlias(String alias) {
    return $SyncQueueTable(attachedDatabase, alias);
  }
}

class SyncQueueData extends DataClass implements Insertable<SyncQueueData> {
  final String id;
  final String entityType;
  final String entityId;
  final String operation;
  final String payloadJson;
  final String state;
  final int attempts;
  final DateTime? nextAttemptAt;
  final String? lastError;
  final DateTime createdAt;
  final DateTime updatedAt;
  const SyncQueueData({
    required this.id,
    required this.entityType,
    required this.entityId,
    required this.operation,
    required this.payloadJson,
    required this.state,
    required this.attempts,
    this.nextAttemptAt,
    this.lastError,
    required this.createdAt,
    required this.updatedAt,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['entity_type'] = Variable<String>(entityType);
    map['entity_id'] = Variable<String>(entityId);
    map['operation'] = Variable<String>(operation);
    map['payload_json'] = Variable<String>(payloadJson);
    map['state'] = Variable<String>(state);
    map['attempts'] = Variable<int>(attempts);
    if (!nullToAbsent || nextAttemptAt != null) {
      map['next_attempt_at'] = Variable<DateTime>(nextAttemptAt);
    }
    if (!nullToAbsent || lastError != null) {
      map['last_error'] = Variable<String>(lastError);
    }
    map['created_at'] = Variable<DateTime>(createdAt);
    map['updated_at'] = Variable<DateTime>(updatedAt);
    return map;
  }

  SyncQueueCompanion toCompanion(bool nullToAbsent) {
    return SyncQueueCompanion(
      id: Value(id),
      entityType: Value(entityType),
      entityId: Value(entityId),
      operation: Value(operation),
      payloadJson: Value(payloadJson),
      state: Value(state),
      attempts: Value(attempts),
      nextAttemptAt: nextAttemptAt == null && nullToAbsent
          ? const Value.absent()
          : Value(nextAttemptAt),
      lastError: lastError == null && nullToAbsent
          ? const Value.absent()
          : Value(lastError),
      createdAt: Value(createdAt),
      updatedAt: Value(updatedAt),
    );
  }

  factory SyncQueueData.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return SyncQueueData(
      id: serializer.fromJson<String>(json['id']),
      entityType: serializer.fromJson<String>(json['entityType']),
      entityId: serializer.fromJson<String>(json['entityId']),
      operation: serializer.fromJson<String>(json['operation']),
      payloadJson: serializer.fromJson<String>(json['payloadJson']),
      state: serializer.fromJson<String>(json['state']),
      attempts: serializer.fromJson<int>(json['attempts']),
      nextAttemptAt: serializer.fromJson<DateTime?>(json['nextAttemptAt']),
      lastError: serializer.fromJson<String?>(json['lastError']),
      createdAt: serializer.fromJson<DateTime>(json['createdAt']),
      updatedAt: serializer.fromJson<DateTime>(json['updatedAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'entityType': serializer.toJson<String>(entityType),
      'entityId': serializer.toJson<String>(entityId),
      'operation': serializer.toJson<String>(operation),
      'payloadJson': serializer.toJson<String>(payloadJson),
      'state': serializer.toJson<String>(state),
      'attempts': serializer.toJson<int>(attempts),
      'nextAttemptAt': serializer.toJson<DateTime?>(nextAttemptAt),
      'lastError': serializer.toJson<String?>(lastError),
      'createdAt': serializer.toJson<DateTime>(createdAt),
      'updatedAt': serializer.toJson<DateTime>(updatedAt),
    };
  }

  SyncQueueData copyWith({
    String? id,
    String? entityType,
    String? entityId,
    String? operation,
    String? payloadJson,
    String? state,
    int? attempts,
    Value<DateTime?> nextAttemptAt = const Value.absent(),
    Value<String?> lastError = const Value.absent(),
    DateTime? createdAt,
    DateTime? updatedAt,
  }) => SyncQueueData(
    id: id ?? this.id,
    entityType: entityType ?? this.entityType,
    entityId: entityId ?? this.entityId,
    operation: operation ?? this.operation,
    payloadJson: payloadJson ?? this.payloadJson,
    state: state ?? this.state,
    attempts: attempts ?? this.attempts,
    nextAttemptAt: nextAttemptAt.present
        ? nextAttemptAt.value
        : this.nextAttemptAt,
    lastError: lastError.present ? lastError.value : this.lastError,
    createdAt: createdAt ?? this.createdAt,
    updatedAt: updatedAt ?? this.updatedAt,
  );
  SyncQueueData copyWithCompanion(SyncQueueCompanion data) {
    return SyncQueueData(
      id: data.id.present ? data.id.value : this.id,
      entityType: data.entityType.present
          ? data.entityType.value
          : this.entityType,
      entityId: data.entityId.present ? data.entityId.value : this.entityId,
      operation: data.operation.present ? data.operation.value : this.operation,
      payloadJson: data.payloadJson.present
          ? data.payloadJson.value
          : this.payloadJson,
      state: data.state.present ? data.state.value : this.state,
      attempts: data.attempts.present ? data.attempts.value : this.attempts,
      nextAttemptAt: data.nextAttemptAt.present
          ? data.nextAttemptAt.value
          : this.nextAttemptAt,
      lastError: data.lastError.present ? data.lastError.value : this.lastError,
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
      updatedAt: data.updatedAt.present ? data.updatedAt.value : this.updatedAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('SyncQueueData(')
          ..write('id: $id, ')
          ..write('entityType: $entityType, ')
          ..write('entityId: $entityId, ')
          ..write('operation: $operation, ')
          ..write('payloadJson: $payloadJson, ')
          ..write('state: $state, ')
          ..write('attempts: $attempts, ')
          ..write('nextAttemptAt: $nextAttemptAt, ')
          ..write('lastError: $lastError, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    id,
    entityType,
    entityId,
    operation,
    payloadJson,
    state,
    attempts,
    nextAttemptAt,
    lastError,
    createdAt,
    updatedAt,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is SyncQueueData &&
          other.id == this.id &&
          other.entityType == this.entityType &&
          other.entityId == this.entityId &&
          other.operation == this.operation &&
          other.payloadJson == this.payloadJson &&
          other.state == this.state &&
          other.attempts == this.attempts &&
          other.nextAttemptAt == this.nextAttemptAt &&
          other.lastError == this.lastError &&
          other.createdAt == this.createdAt &&
          other.updatedAt == this.updatedAt);
}

class SyncQueueCompanion extends UpdateCompanion<SyncQueueData> {
  final Value<String> id;
  final Value<String> entityType;
  final Value<String> entityId;
  final Value<String> operation;
  final Value<String> payloadJson;
  final Value<String> state;
  final Value<int> attempts;
  final Value<DateTime?> nextAttemptAt;
  final Value<String?> lastError;
  final Value<DateTime> createdAt;
  final Value<DateTime> updatedAt;
  final Value<int> rowid;
  const SyncQueueCompanion({
    this.id = const Value.absent(),
    this.entityType = const Value.absent(),
    this.entityId = const Value.absent(),
    this.operation = const Value.absent(),
    this.payloadJson = const Value.absent(),
    this.state = const Value.absent(),
    this.attempts = const Value.absent(),
    this.nextAttemptAt = const Value.absent(),
    this.lastError = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.updatedAt = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  SyncQueueCompanion.insert({
    required String id,
    required String entityType,
    required String entityId,
    this.operation = const Value.absent(),
    required String payloadJson,
    this.state = const Value.absent(),
    this.attempts = const Value.absent(),
    this.nextAttemptAt = const Value.absent(),
    this.lastError = const Value.absent(),
    required DateTime createdAt,
    required DateTime updatedAt,
    this.rowid = const Value.absent(),
  }) : id = Value(id),
       entityType = Value(entityType),
       entityId = Value(entityId),
       payloadJson = Value(payloadJson),
       createdAt = Value(createdAt),
       updatedAt = Value(updatedAt);
  static Insertable<SyncQueueData> custom({
    Expression<String>? id,
    Expression<String>? entityType,
    Expression<String>? entityId,
    Expression<String>? operation,
    Expression<String>? payloadJson,
    Expression<String>? state,
    Expression<int>? attempts,
    Expression<DateTime>? nextAttemptAt,
    Expression<String>? lastError,
    Expression<DateTime>? createdAt,
    Expression<DateTime>? updatedAt,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (entityType != null) 'entity_type': entityType,
      if (entityId != null) 'entity_id': entityId,
      if (operation != null) 'operation': operation,
      if (payloadJson != null) 'payload_json': payloadJson,
      if (state != null) 'state': state,
      if (attempts != null) 'attempts': attempts,
      if (nextAttemptAt != null) 'next_attempt_at': nextAttemptAt,
      if (lastError != null) 'last_error': lastError,
      if (createdAt != null) 'created_at': createdAt,
      if (updatedAt != null) 'updated_at': updatedAt,
      if (rowid != null) 'rowid': rowid,
    });
  }

  SyncQueueCompanion copyWith({
    Value<String>? id,
    Value<String>? entityType,
    Value<String>? entityId,
    Value<String>? operation,
    Value<String>? payloadJson,
    Value<String>? state,
    Value<int>? attempts,
    Value<DateTime?>? nextAttemptAt,
    Value<String?>? lastError,
    Value<DateTime>? createdAt,
    Value<DateTime>? updatedAt,
    Value<int>? rowid,
  }) {
    return SyncQueueCompanion(
      id: id ?? this.id,
      entityType: entityType ?? this.entityType,
      entityId: entityId ?? this.entityId,
      operation: operation ?? this.operation,
      payloadJson: payloadJson ?? this.payloadJson,
      state: state ?? this.state,
      attempts: attempts ?? this.attempts,
      nextAttemptAt: nextAttemptAt ?? this.nextAttemptAt,
      lastError: lastError ?? this.lastError,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (entityType.present) {
      map['entity_type'] = Variable<String>(entityType.value);
    }
    if (entityId.present) {
      map['entity_id'] = Variable<String>(entityId.value);
    }
    if (operation.present) {
      map['operation'] = Variable<String>(operation.value);
    }
    if (payloadJson.present) {
      map['payload_json'] = Variable<String>(payloadJson.value);
    }
    if (state.present) {
      map['state'] = Variable<String>(state.value);
    }
    if (attempts.present) {
      map['attempts'] = Variable<int>(attempts.value);
    }
    if (nextAttemptAt.present) {
      map['next_attempt_at'] = Variable<DateTime>(nextAttemptAt.value);
    }
    if (lastError.present) {
      map['last_error'] = Variable<String>(lastError.value);
    }
    if (createdAt.present) {
      map['created_at'] = Variable<DateTime>(createdAt.value);
    }
    if (updatedAt.present) {
      map['updated_at'] = Variable<DateTime>(updatedAt.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('SyncQueueCompanion(')
          ..write('id: $id, ')
          ..write('entityType: $entityType, ')
          ..write('entityId: $entityId, ')
          ..write('operation: $operation, ')
          ..write('payloadJson: $payloadJson, ')
          ..write('state: $state, ')
          ..write('attempts: $attempts, ')
          ..write('nextAttemptAt: $nextAttemptAt, ')
          ..write('lastError: $lastError, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

abstract class _$AppDatabase extends GeneratedDatabase {
  _$AppDatabase(QueryExecutor e) : super(e);
  $AppDatabaseManager get managers => $AppDatabaseManager(this);
  late final $CoachesTable coaches = $CoachesTable(this);
  late final $TeamsTable teams = $TeamsTable(this);
  late final $PlayersTable players = $PlayersTable(this);
  late final $TournamentSessionsTable tournamentSessions =
      $TournamentSessionsTable(this);
  late final $SessionPlayersTable sessionPlayers = $SessionPlayersTable(this);
  late final $MatchActionsTable matchActions = $MatchActionsTable(this);
  late final $ShootDetailsTable shootDetails = $ShootDetailsTable(this);
  late final $GoalkeeperActionsTable goalkeeperActions =
      $GoalkeeperActionsTable(this);
  late final $SyncQueueTable syncQueue = $SyncQueueTable(this);
  @override
  Iterable<TableInfo<Table, Object?>> get allTables =>
      allSchemaEntities.whereType<TableInfo<Table, Object?>>();
  @override
  List<DatabaseSchemaEntity> get allSchemaEntities => [
    coaches,
    teams,
    players,
    tournamentSessions,
    sessionPlayers,
    matchActions,
    shootDetails,
    goalkeeperActions,
    syncQueue,
  ];
  @override
  StreamQueryUpdateRules get streamUpdateRules => const StreamQueryUpdateRules([
    WritePropagation(
      on: TableUpdateQuery.onTableName(
        'tournament_sessions',
        limitUpdateKind: UpdateKind.delete,
      ),
      result: [TableUpdate('session_players', kind: UpdateKind.delete)],
    ),
    WritePropagation(
      on: TableUpdateQuery.onTableName(
        'match_actions',
        limitUpdateKind: UpdateKind.delete,
      ),
      result: [TableUpdate('shoot_details', kind: UpdateKind.delete)],
    ),
  ]);
}

typedef $$CoachesTableCreateCompanionBuilder =
    CoachesCompanion Function({
      required String id,
      required String displayName,
      required DateTime createdAt,
      required DateTime updatedAt,
      Value<int> version,
      Value<int> rowid,
    });
typedef $$CoachesTableUpdateCompanionBuilder =
    CoachesCompanion Function({
      Value<String> id,
      Value<String> displayName,
      Value<DateTime> createdAt,
      Value<DateTime> updatedAt,
      Value<int> version,
      Value<int> rowid,
    });

final class $$CoachesTableReferences
    extends BaseReferences<_$AppDatabase, $CoachesTable, Coach> {
  $$CoachesTableReferences(super.$_db, super.$_table, super.$_typedResult);

  static MultiTypedResultKey<$TournamentSessionsTable, List<TournamentSession>>
  _tournamentSessionsRefsTable(_$AppDatabase db) =>
      MultiTypedResultKey.fromTable(
        db.tournamentSessions,
        aliasName: 'coaches__id__tournament_sessions__coach_id',
      );

  $$TournamentSessionsTableProcessedTableManager get tournamentSessionsRefs {
    final manager = $$TournamentSessionsTableTableManager(
      $_db,
      $_db.tournamentSessions,
    ).filter((f) => f.coachId.id.sqlEquals($_itemColumn<String>('id')!));

    final cache = $_typedResult.readTableOrNull(
      _tournamentSessionsRefsTable($_db),
    );
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: cache),
    );
  }
}

class $$CoachesTableFilterComposer
    extends Composer<_$AppDatabase, $CoachesTable> {
  $$CoachesTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get displayName => $composableBuilder(
    column: $table.displayName,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get updatedAt => $composableBuilder(
    column: $table.updatedAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get version => $composableBuilder(
    column: $table.version,
    builder: (column) => ColumnFilters(column),
  );

  Expression<bool> tournamentSessionsRefs(
    Expression<bool> Function($$TournamentSessionsTableFilterComposer f) f,
  ) {
    final $$TournamentSessionsTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.tournamentSessions,
      getReferencedColumn: (t) => t.coachId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$TournamentSessionsTableFilterComposer(
            $db: $db,
            $table: $db.tournamentSessions,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }
}

class $$CoachesTableOrderingComposer
    extends Composer<_$AppDatabase, $CoachesTable> {
  $$CoachesTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get displayName => $composableBuilder(
    column: $table.displayName,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get updatedAt => $composableBuilder(
    column: $table.updatedAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get version => $composableBuilder(
    column: $table.version,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$CoachesTableAnnotationComposer
    extends Composer<_$AppDatabase, $CoachesTable> {
  $$CoachesTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get displayName => $composableBuilder(
    column: $table.displayName,
    builder: (column) => column,
  );

  GeneratedColumn<DateTime> get createdAt =>
      $composableBuilder(column: $table.createdAt, builder: (column) => column);

  GeneratedColumn<DateTime> get updatedAt =>
      $composableBuilder(column: $table.updatedAt, builder: (column) => column);

  GeneratedColumn<int> get version =>
      $composableBuilder(column: $table.version, builder: (column) => column);

  Expression<T> tournamentSessionsRefs<T extends Object>(
    Expression<T> Function($$TournamentSessionsTableAnnotationComposer a) f,
  ) {
    final $$TournamentSessionsTableAnnotationComposer composer =
        $composerBuilder(
          composer: this,
          getCurrentColumn: (t) => t.id,
          referencedTable: $db.tournamentSessions,
          getReferencedColumn: (t) => t.coachId,
          builder:
              (
                joinBuilder, {
                $addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer,
              }) => $$TournamentSessionsTableAnnotationComposer(
                $db: $db,
                $table: $db.tournamentSessions,
                $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
                joinBuilder: joinBuilder,
                $removeJoinBuilderFromRootComposer:
                    $removeJoinBuilderFromRootComposer,
              ),
        );
    return f(composer);
  }
}

class $$CoachesTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $CoachesTable,
          Coach,
          $$CoachesTableFilterComposer,
          $$CoachesTableOrderingComposer,
          $$CoachesTableAnnotationComposer,
          $$CoachesTableCreateCompanionBuilder,
          $$CoachesTableUpdateCompanionBuilder,
          (Coach, $$CoachesTableReferences),
          Coach,
          PrefetchHooks Function({bool tournamentSessionsRefs})
        > {
  $$CoachesTableTableManager(_$AppDatabase db, $CoachesTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$CoachesTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$CoachesTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$CoachesTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<String> id = const Value.absent(),
                Value<String> displayName = const Value.absent(),
                Value<DateTime> createdAt = const Value.absent(),
                Value<DateTime> updatedAt = const Value.absent(),
                Value<int> version = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => CoachesCompanion(
                id: id,
                displayName: displayName,
                createdAt: createdAt,
                updatedAt: updatedAt,
                version: version,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String id,
                required String displayName,
                required DateTime createdAt,
                required DateTime updatedAt,
                Value<int> version = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => CoachesCompanion.insert(
                id: id,
                displayName: displayName,
                createdAt: createdAt,
                updatedAt: updatedAt,
                version: version,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable(table),
                  $$CoachesTableReferences(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback: ({tournamentSessionsRefs = false}) {
            return PrefetchHooks(
              db: db,
              explicitlyWatchedTables: [
                if (tournamentSessionsRefs) db.tournamentSessions,
              ],
              addJoins: null,
              getPrefetchedDataCallback: (items) async {
                return [
                  if (tournamentSessionsRefs)
                    await $_getPrefetchedData<
                      Coach,
                      $CoachesTable,
                      TournamentSession
                    >(
                      currentTable: table,
                      referencedTable: $$CoachesTableReferences
                          ._tournamentSessionsRefsTable(db),
                      managerFromTypedResult: (p0) => $$CoachesTableReferences(
                        db,
                        table,
                        p0,
                      ).tournamentSessionsRefs,
                      referencedItemsForCurrentItem: (item, referencedItems) =>
                          referencedItems.where((e) => e.coachId == item.id),
                      typedResults: items,
                    ),
                ];
              },
            );
          },
        ),
      );
}

typedef $$CoachesTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $CoachesTable,
      Coach,
      $$CoachesTableFilterComposer,
      $$CoachesTableOrderingComposer,
      $$CoachesTableAnnotationComposer,
      $$CoachesTableCreateCompanionBuilder,
      $$CoachesTableUpdateCompanionBuilder,
      (Coach, $$CoachesTableReferences),
      Coach,
      PrefetchHooks Function({bool tournamentSessionsRefs})
    >;
typedef $$TeamsTableCreateCompanionBuilder =
    TeamsCompanion Function({
      required String id,
      required String name,
      Value<String?> category,
      required DateTime createdAt,
      required DateTime updatedAt,
      Value<int> version,
      Value<int> rowid,
    });
typedef $$TeamsTableUpdateCompanionBuilder =
    TeamsCompanion Function({
      Value<String> id,
      Value<String> name,
      Value<String?> category,
      Value<DateTime> createdAt,
      Value<DateTime> updatedAt,
      Value<int> version,
      Value<int> rowid,
    });

final class $$TeamsTableReferences
    extends BaseReferences<_$AppDatabase, $TeamsTable, Team> {
  $$TeamsTableReferences(super.$_db, super.$_table, super.$_typedResult);

  static MultiTypedResultKey<$PlayersTable, List<Player>> _playersRefsTable(
    _$AppDatabase db,
  ) => MultiTypedResultKey.fromTable(
    db.players,
    aliasName: 'teams__id__players__team_id',
  );

  $$PlayersTableProcessedTableManager get playersRefs {
    final manager = $$PlayersTableTableManager(
      $_db,
      $_db.players,
    ).filter((f) => f.teamId.id.sqlEquals($_itemColumn<String>('id')!));

    final cache = $_typedResult.readTableOrNull(_playersRefsTable($_db));
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: cache),
    );
  }

  static MultiTypedResultKey<$TournamentSessionsTable, List<TournamentSession>>
  _tournamentSessionsRefsTable(_$AppDatabase db) =>
      MultiTypedResultKey.fromTable(
        db.tournamentSessions,
        aliasName: 'teams__id__tournament_sessions__team_id',
      );

  $$TournamentSessionsTableProcessedTableManager get tournamentSessionsRefs {
    final manager = $$TournamentSessionsTableTableManager(
      $_db,
      $_db.tournamentSessions,
    ).filter((f) => f.teamId.id.sqlEquals($_itemColumn<String>('id')!));

    final cache = $_typedResult.readTableOrNull(
      _tournamentSessionsRefsTable($_db),
    );
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: cache),
    );
  }
}

class $$TeamsTableFilterComposer extends Composer<_$AppDatabase, $TeamsTable> {
  $$TeamsTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get name => $composableBuilder(
    column: $table.name,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get category => $composableBuilder(
    column: $table.category,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get updatedAt => $composableBuilder(
    column: $table.updatedAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get version => $composableBuilder(
    column: $table.version,
    builder: (column) => ColumnFilters(column),
  );

  Expression<bool> playersRefs(
    Expression<bool> Function($$PlayersTableFilterComposer f) f,
  ) {
    final $$PlayersTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.players,
      getReferencedColumn: (t) => t.teamId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$PlayersTableFilterComposer(
            $db: $db,
            $table: $db.players,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }

  Expression<bool> tournamentSessionsRefs(
    Expression<bool> Function($$TournamentSessionsTableFilterComposer f) f,
  ) {
    final $$TournamentSessionsTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.tournamentSessions,
      getReferencedColumn: (t) => t.teamId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$TournamentSessionsTableFilterComposer(
            $db: $db,
            $table: $db.tournamentSessions,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }
}

class $$TeamsTableOrderingComposer
    extends Composer<_$AppDatabase, $TeamsTable> {
  $$TeamsTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get name => $composableBuilder(
    column: $table.name,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get category => $composableBuilder(
    column: $table.category,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get updatedAt => $composableBuilder(
    column: $table.updatedAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get version => $composableBuilder(
    column: $table.version,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$TeamsTableAnnotationComposer
    extends Composer<_$AppDatabase, $TeamsTable> {
  $$TeamsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get name =>
      $composableBuilder(column: $table.name, builder: (column) => column);

  GeneratedColumn<String> get category =>
      $composableBuilder(column: $table.category, builder: (column) => column);

  GeneratedColumn<DateTime> get createdAt =>
      $composableBuilder(column: $table.createdAt, builder: (column) => column);

  GeneratedColumn<DateTime> get updatedAt =>
      $composableBuilder(column: $table.updatedAt, builder: (column) => column);

  GeneratedColumn<int> get version =>
      $composableBuilder(column: $table.version, builder: (column) => column);

  Expression<T> playersRefs<T extends Object>(
    Expression<T> Function($$PlayersTableAnnotationComposer a) f,
  ) {
    final $$PlayersTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.players,
      getReferencedColumn: (t) => t.teamId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$PlayersTableAnnotationComposer(
            $db: $db,
            $table: $db.players,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }

  Expression<T> tournamentSessionsRefs<T extends Object>(
    Expression<T> Function($$TournamentSessionsTableAnnotationComposer a) f,
  ) {
    final $$TournamentSessionsTableAnnotationComposer composer =
        $composerBuilder(
          composer: this,
          getCurrentColumn: (t) => t.id,
          referencedTable: $db.tournamentSessions,
          getReferencedColumn: (t) => t.teamId,
          builder:
              (
                joinBuilder, {
                $addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer,
              }) => $$TournamentSessionsTableAnnotationComposer(
                $db: $db,
                $table: $db.tournamentSessions,
                $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
                joinBuilder: joinBuilder,
                $removeJoinBuilderFromRootComposer:
                    $removeJoinBuilderFromRootComposer,
              ),
        );
    return f(composer);
  }
}

class $$TeamsTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $TeamsTable,
          Team,
          $$TeamsTableFilterComposer,
          $$TeamsTableOrderingComposer,
          $$TeamsTableAnnotationComposer,
          $$TeamsTableCreateCompanionBuilder,
          $$TeamsTableUpdateCompanionBuilder,
          (Team, $$TeamsTableReferences),
          Team,
          PrefetchHooks Function({
            bool playersRefs,
            bool tournamentSessionsRefs,
          })
        > {
  $$TeamsTableTableManager(_$AppDatabase db, $TeamsTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$TeamsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$TeamsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$TeamsTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<String> id = const Value.absent(),
                Value<String> name = const Value.absent(),
                Value<String?> category = const Value.absent(),
                Value<DateTime> createdAt = const Value.absent(),
                Value<DateTime> updatedAt = const Value.absent(),
                Value<int> version = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => TeamsCompanion(
                id: id,
                name: name,
                category: category,
                createdAt: createdAt,
                updatedAt: updatedAt,
                version: version,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String id,
                required String name,
                Value<String?> category = const Value.absent(),
                required DateTime createdAt,
                required DateTime updatedAt,
                Value<int> version = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => TeamsCompanion.insert(
                id: id,
                name: name,
                category: category,
                createdAt: createdAt,
                updatedAt: updatedAt,
                version: version,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) =>
                    (e.readTable(table), $$TeamsTableReferences(db, table, e)),
              )
              .toList(),
          prefetchHooksCallback:
              ({playersRefs = false, tournamentSessionsRefs = false}) {
                return PrefetchHooks(
                  db: db,
                  explicitlyWatchedTables: [
                    if (playersRefs) db.players,
                    if (tournamentSessionsRefs) db.tournamentSessions,
                  ],
                  addJoins: null,
                  getPrefetchedDataCallback: (items) async {
                    return [
                      if (playersRefs)
                        await $_getPrefetchedData<Team, $TeamsTable, Player>(
                          currentTable: table,
                          referencedTable: $$TeamsTableReferences
                              ._playersRefsTable(db),
                          managerFromTypedResult: (p0) =>
                              $$TeamsTableReferences(db, table, p0).playersRefs,
                          referencedItemsForCurrentItem:
                              (item, referencedItems) => referencedItems.where(
                                (e) => e.teamId == item.id,
                              ),
                          typedResults: items,
                        ),
                      if (tournamentSessionsRefs)
                        await $_getPrefetchedData<
                          Team,
                          $TeamsTable,
                          TournamentSession
                        >(
                          currentTable: table,
                          referencedTable: $$TeamsTableReferences
                              ._tournamentSessionsRefsTable(db),
                          managerFromTypedResult: (p0) =>
                              $$TeamsTableReferences(
                                db,
                                table,
                                p0,
                              ).tournamentSessionsRefs,
                          referencedItemsForCurrentItem:
                              (item, referencedItems) => referencedItems.where(
                                (e) => e.teamId == item.id,
                              ),
                          typedResults: items,
                        ),
                    ];
                  },
                );
              },
        ),
      );
}

typedef $$TeamsTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $TeamsTable,
      Team,
      $$TeamsTableFilterComposer,
      $$TeamsTableOrderingComposer,
      $$TeamsTableAnnotationComposer,
      $$TeamsTableCreateCompanionBuilder,
      $$TeamsTableUpdateCompanionBuilder,
      (Team, $$TeamsTableReferences),
      Team,
      PrefetchHooks Function({bool playersRefs, bool tournamentSessionsRefs})
    >;
typedef $$PlayersTableCreateCompanionBuilder =
    PlayersCompanion Function({
      required String id,
      required String teamId,
      required String displayName,
      required int jerseyNumber,
      required String defaultRole,
      Value<bool> active,
      required DateTime createdAt,
      required DateTime updatedAt,
      Value<int> version,
      Value<int> rowid,
    });
typedef $$PlayersTableUpdateCompanionBuilder =
    PlayersCompanion Function({
      Value<String> id,
      Value<String> teamId,
      Value<String> displayName,
      Value<int> jerseyNumber,
      Value<String> defaultRole,
      Value<bool> active,
      Value<DateTime> createdAt,
      Value<DateTime> updatedAt,
      Value<int> version,
      Value<int> rowid,
    });

final class $$PlayersTableReferences
    extends BaseReferences<_$AppDatabase, $PlayersTable, Player> {
  $$PlayersTableReferences(super.$_db, super.$_table, super.$_typedResult);

  static $TeamsTable _teamIdTable(_$AppDatabase db) =>
      db.teams.createAlias('players__team_id__teams__id');

  $$TeamsTableProcessedTableManager get teamId {
    final $_column = $_itemColumn<String>('team_id')!;

    final manager = $$TeamsTableTableManager(
      $_db,
      $_db.teams,
    ).filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_teamIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: [item]),
    );
  }

  static MultiTypedResultKey<$TournamentSessionsTable, List<TournamentSession>>
  _tournamentSessionsRefsTable(_$AppDatabase db) =>
      MultiTypedResultKey.fromTable(
        db.tournamentSessions,
        aliasName: 'players__id__tournament_sessions__active_goalkeeper_id',
      );

  $$TournamentSessionsTableProcessedTableManager get tournamentSessionsRefs {
    final manager =
        $$TournamentSessionsTableTableManager(
          $_db,
          $_db.tournamentSessions,
        ).filter(
          (f) => f.activeGoalkeeperId.id.sqlEquals($_itemColumn<String>('id')!),
        );

    final cache = $_typedResult.readTableOrNull(
      _tournamentSessionsRefsTable($_db),
    );
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: cache),
    );
  }

  static MultiTypedResultKey<$SessionPlayersTable, List<SessionPlayer>>
  _sessionPlayersRefsTable(_$AppDatabase db) => MultiTypedResultKey.fromTable(
    db.sessionPlayers,
    aliasName: 'players__id__session_players__player_id',
  );

  $$SessionPlayersTableProcessedTableManager get sessionPlayersRefs {
    final manager = $$SessionPlayersTableTableManager(
      $_db,
      $_db.sessionPlayers,
    ).filter((f) => f.playerId.id.sqlEquals($_itemColumn<String>('id')!));

    final cache = $_typedResult.readTableOrNull(_sessionPlayersRefsTable($_db));
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: cache),
    );
  }

  static MultiTypedResultKey<$MatchActionsTable, List<MatchAction>>
  _matchActionsRefsTable(_$AppDatabase db) => MultiTypedResultKey.fromTable(
    db.matchActions,
    aliasName: 'players__id__match_actions__player_id',
  );

  $$MatchActionsTableProcessedTableManager get matchActionsRefs {
    final manager = $$MatchActionsTableTableManager(
      $_db,
      $_db.matchActions,
    ).filter((f) => f.playerId.id.sqlEquals($_itemColumn<String>('id')!));

    final cache = $_typedResult.readTableOrNull(_matchActionsRefsTable($_db));
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: cache),
    );
  }

  static MultiTypedResultKey<$GoalkeeperActionsTable, List<GoalkeeperAction>>
  _goalkeeperActionsRefsTable(_$AppDatabase db) =>
      MultiTypedResultKey.fromTable(
        db.goalkeeperActions,
        aliasName: 'players__id__goalkeeper_actions__goalkeeper_id',
      );

  $$GoalkeeperActionsTableProcessedTableManager get goalkeeperActionsRefs {
    final manager = $$GoalkeeperActionsTableTableManager(
      $_db,
      $_db.goalkeeperActions,
    ).filter((f) => f.goalkeeperId.id.sqlEquals($_itemColumn<String>('id')!));

    final cache = $_typedResult.readTableOrNull(
      _goalkeeperActionsRefsTable($_db),
    );
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: cache),
    );
  }
}

class $$PlayersTableFilterComposer
    extends Composer<_$AppDatabase, $PlayersTable> {
  $$PlayersTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get displayName => $composableBuilder(
    column: $table.displayName,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get jerseyNumber => $composableBuilder(
    column: $table.jerseyNumber,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get defaultRole => $composableBuilder(
    column: $table.defaultRole,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<bool> get active => $composableBuilder(
    column: $table.active,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get updatedAt => $composableBuilder(
    column: $table.updatedAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get version => $composableBuilder(
    column: $table.version,
    builder: (column) => ColumnFilters(column),
  );

  $$TeamsTableFilterComposer get teamId {
    final $$TeamsTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.teamId,
      referencedTable: $db.teams,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$TeamsTableFilterComposer(
            $db: $db,
            $table: $db.teams,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  Expression<bool> tournamentSessionsRefs(
    Expression<bool> Function($$TournamentSessionsTableFilterComposer f) f,
  ) {
    final $$TournamentSessionsTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.tournamentSessions,
      getReferencedColumn: (t) => t.activeGoalkeeperId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$TournamentSessionsTableFilterComposer(
            $db: $db,
            $table: $db.tournamentSessions,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }

  Expression<bool> sessionPlayersRefs(
    Expression<bool> Function($$SessionPlayersTableFilterComposer f) f,
  ) {
    final $$SessionPlayersTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.sessionPlayers,
      getReferencedColumn: (t) => t.playerId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$SessionPlayersTableFilterComposer(
            $db: $db,
            $table: $db.sessionPlayers,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }

  Expression<bool> matchActionsRefs(
    Expression<bool> Function($$MatchActionsTableFilterComposer f) f,
  ) {
    final $$MatchActionsTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.matchActions,
      getReferencedColumn: (t) => t.playerId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$MatchActionsTableFilterComposer(
            $db: $db,
            $table: $db.matchActions,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }

  Expression<bool> goalkeeperActionsRefs(
    Expression<bool> Function($$GoalkeeperActionsTableFilterComposer f) f,
  ) {
    final $$GoalkeeperActionsTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.goalkeeperActions,
      getReferencedColumn: (t) => t.goalkeeperId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$GoalkeeperActionsTableFilterComposer(
            $db: $db,
            $table: $db.goalkeeperActions,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }
}

class $$PlayersTableOrderingComposer
    extends Composer<_$AppDatabase, $PlayersTable> {
  $$PlayersTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get displayName => $composableBuilder(
    column: $table.displayName,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get jerseyNumber => $composableBuilder(
    column: $table.jerseyNumber,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get defaultRole => $composableBuilder(
    column: $table.defaultRole,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<bool> get active => $composableBuilder(
    column: $table.active,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get updatedAt => $composableBuilder(
    column: $table.updatedAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get version => $composableBuilder(
    column: $table.version,
    builder: (column) => ColumnOrderings(column),
  );

  $$TeamsTableOrderingComposer get teamId {
    final $$TeamsTableOrderingComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.teamId,
      referencedTable: $db.teams,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$TeamsTableOrderingComposer(
            $db: $db,
            $table: $db.teams,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$PlayersTableAnnotationComposer
    extends Composer<_$AppDatabase, $PlayersTable> {
  $$PlayersTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get displayName => $composableBuilder(
    column: $table.displayName,
    builder: (column) => column,
  );

  GeneratedColumn<int> get jerseyNumber => $composableBuilder(
    column: $table.jerseyNumber,
    builder: (column) => column,
  );

  GeneratedColumn<String> get defaultRole => $composableBuilder(
    column: $table.defaultRole,
    builder: (column) => column,
  );

  GeneratedColumn<bool> get active =>
      $composableBuilder(column: $table.active, builder: (column) => column);

  GeneratedColumn<DateTime> get createdAt =>
      $composableBuilder(column: $table.createdAt, builder: (column) => column);

  GeneratedColumn<DateTime> get updatedAt =>
      $composableBuilder(column: $table.updatedAt, builder: (column) => column);

  GeneratedColumn<int> get version =>
      $composableBuilder(column: $table.version, builder: (column) => column);

  $$TeamsTableAnnotationComposer get teamId {
    final $$TeamsTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.teamId,
      referencedTable: $db.teams,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$TeamsTableAnnotationComposer(
            $db: $db,
            $table: $db.teams,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  Expression<T> tournamentSessionsRefs<T extends Object>(
    Expression<T> Function($$TournamentSessionsTableAnnotationComposer a) f,
  ) {
    final $$TournamentSessionsTableAnnotationComposer composer =
        $composerBuilder(
          composer: this,
          getCurrentColumn: (t) => t.id,
          referencedTable: $db.tournamentSessions,
          getReferencedColumn: (t) => t.activeGoalkeeperId,
          builder:
              (
                joinBuilder, {
                $addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer,
              }) => $$TournamentSessionsTableAnnotationComposer(
                $db: $db,
                $table: $db.tournamentSessions,
                $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
                joinBuilder: joinBuilder,
                $removeJoinBuilderFromRootComposer:
                    $removeJoinBuilderFromRootComposer,
              ),
        );
    return f(composer);
  }

  Expression<T> sessionPlayersRefs<T extends Object>(
    Expression<T> Function($$SessionPlayersTableAnnotationComposer a) f,
  ) {
    final $$SessionPlayersTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.sessionPlayers,
      getReferencedColumn: (t) => t.playerId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$SessionPlayersTableAnnotationComposer(
            $db: $db,
            $table: $db.sessionPlayers,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }

  Expression<T> matchActionsRefs<T extends Object>(
    Expression<T> Function($$MatchActionsTableAnnotationComposer a) f,
  ) {
    final $$MatchActionsTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.matchActions,
      getReferencedColumn: (t) => t.playerId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$MatchActionsTableAnnotationComposer(
            $db: $db,
            $table: $db.matchActions,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }

  Expression<T> goalkeeperActionsRefs<T extends Object>(
    Expression<T> Function($$GoalkeeperActionsTableAnnotationComposer a) f,
  ) {
    final $$GoalkeeperActionsTableAnnotationComposer composer =
        $composerBuilder(
          composer: this,
          getCurrentColumn: (t) => t.id,
          referencedTable: $db.goalkeeperActions,
          getReferencedColumn: (t) => t.goalkeeperId,
          builder:
              (
                joinBuilder, {
                $addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer,
              }) => $$GoalkeeperActionsTableAnnotationComposer(
                $db: $db,
                $table: $db.goalkeeperActions,
                $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
                joinBuilder: joinBuilder,
                $removeJoinBuilderFromRootComposer:
                    $removeJoinBuilderFromRootComposer,
              ),
        );
    return f(composer);
  }
}

class $$PlayersTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $PlayersTable,
          Player,
          $$PlayersTableFilterComposer,
          $$PlayersTableOrderingComposer,
          $$PlayersTableAnnotationComposer,
          $$PlayersTableCreateCompanionBuilder,
          $$PlayersTableUpdateCompanionBuilder,
          (Player, $$PlayersTableReferences),
          Player,
          PrefetchHooks Function({
            bool teamId,
            bool tournamentSessionsRefs,
            bool sessionPlayersRefs,
            bool matchActionsRefs,
            bool goalkeeperActionsRefs,
          })
        > {
  $$PlayersTableTableManager(_$AppDatabase db, $PlayersTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$PlayersTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$PlayersTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$PlayersTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<String> id = const Value.absent(),
                Value<String> teamId = const Value.absent(),
                Value<String> displayName = const Value.absent(),
                Value<int> jerseyNumber = const Value.absent(),
                Value<String> defaultRole = const Value.absent(),
                Value<bool> active = const Value.absent(),
                Value<DateTime> createdAt = const Value.absent(),
                Value<DateTime> updatedAt = const Value.absent(),
                Value<int> version = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => PlayersCompanion(
                id: id,
                teamId: teamId,
                displayName: displayName,
                jerseyNumber: jerseyNumber,
                defaultRole: defaultRole,
                active: active,
                createdAt: createdAt,
                updatedAt: updatedAt,
                version: version,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String id,
                required String teamId,
                required String displayName,
                required int jerseyNumber,
                required String defaultRole,
                Value<bool> active = const Value.absent(),
                required DateTime createdAt,
                required DateTime updatedAt,
                Value<int> version = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => PlayersCompanion.insert(
                id: id,
                teamId: teamId,
                displayName: displayName,
                jerseyNumber: jerseyNumber,
                defaultRole: defaultRole,
                active: active,
                createdAt: createdAt,
                updatedAt: updatedAt,
                version: version,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable(table),
                  $$PlayersTableReferences(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback:
              ({
                teamId = false,
                tournamentSessionsRefs = false,
                sessionPlayersRefs = false,
                matchActionsRefs = false,
                goalkeeperActionsRefs = false,
              }) {
                return PrefetchHooks(
                  db: db,
                  explicitlyWatchedTables: [
                    if (tournamentSessionsRefs) db.tournamentSessions,
                    if (sessionPlayersRefs) db.sessionPlayers,
                    if (matchActionsRefs) db.matchActions,
                    if (goalkeeperActionsRefs) db.goalkeeperActions,
                  ],
                  addJoins:
                      <
                        T extends TableManagerState<
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic
                        >
                      >(state) {
                        if (teamId) {
                          state =
                              state.withJoin(
                                    currentTable: table,
                                    currentColumn: table.teamId,
                                    referencedTable: $$PlayersTableReferences
                                        ._teamIdTable(db),
                                    referencedColumn: $$PlayersTableReferences
                                        ._teamIdTable(db)
                                        .id,
                                  )
                                  as T;
                        }

                        return state;
                      },
                  getPrefetchedDataCallback: (items) async {
                    return [
                      if (tournamentSessionsRefs)
                        await $_getPrefetchedData<
                          Player,
                          $PlayersTable,
                          TournamentSession
                        >(
                          currentTable: table,
                          referencedTable: $$PlayersTableReferences
                              ._tournamentSessionsRefsTable(db),
                          managerFromTypedResult: (p0) =>
                              $$PlayersTableReferences(
                                db,
                                table,
                                p0,
                              ).tournamentSessionsRefs,
                          referencedItemsForCurrentItem:
                              (item, referencedItems) => referencedItems.where(
                                (e) => e.activeGoalkeeperId == item.id,
                              ),
                          typedResults: items,
                        ),
                      if (sessionPlayersRefs)
                        await $_getPrefetchedData<
                          Player,
                          $PlayersTable,
                          SessionPlayer
                        >(
                          currentTable: table,
                          referencedTable: $$PlayersTableReferences
                              ._sessionPlayersRefsTable(db),
                          managerFromTypedResult: (p0) =>
                              $$PlayersTableReferences(
                                db,
                                table,
                                p0,
                              ).sessionPlayersRefs,
                          referencedItemsForCurrentItem:
                              (item, referencedItems) => referencedItems.where(
                                (e) => e.playerId == item.id,
                              ),
                          typedResults: items,
                        ),
                      if (matchActionsRefs)
                        await $_getPrefetchedData<
                          Player,
                          $PlayersTable,
                          MatchAction
                        >(
                          currentTable: table,
                          referencedTable: $$PlayersTableReferences
                              ._matchActionsRefsTable(db),
                          managerFromTypedResult: (p0) =>
                              $$PlayersTableReferences(
                                db,
                                table,
                                p0,
                              ).matchActionsRefs,
                          referencedItemsForCurrentItem:
                              (item, referencedItems) => referencedItems.where(
                                (e) => e.playerId == item.id,
                              ),
                          typedResults: items,
                        ),
                      if (goalkeeperActionsRefs)
                        await $_getPrefetchedData<
                          Player,
                          $PlayersTable,
                          GoalkeeperAction
                        >(
                          currentTable: table,
                          referencedTable: $$PlayersTableReferences
                              ._goalkeeperActionsRefsTable(db),
                          managerFromTypedResult: (p0) =>
                              $$PlayersTableReferences(
                                db,
                                table,
                                p0,
                              ).goalkeeperActionsRefs,
                          referencedItemsForCurrentItem:
                              (item, referencedItems) => referencedItems.where(
                                (e) => e.goalkeeperId == item.id,
                              ),
                          typedResults: items,
                        ),
                    ];
                  },
                );
              },
        ),
      );
}

typedef $$PlayersTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $PlayersTable,
      Player,
      $$PlayersTableFilterComposer,
      $$PlayersTableOrderingComposer,
      $$PlayersTableAnnotationComposer,
      $$PlayersTableCreateCompanionBuilder,
      $$PlayersTableUpdateCompanionBuilder,
      (Player, $$PlayersTableReferences),
      Player,
      PrefetchHooks Function({
        bool teamId,
        bool tournamentSessionsRefs,
        bool sessionPlayersRefs,
        bool matchActionsRefs,
        bool goalkeeperActionsRefs,
      })
    >;
typedef $$TournamentSessionsTableCreateCompanionBuilder =
    TournamentSessionsCompanion Function({
      required String id,
      required String tournamentName,
      required String scheduledDate,
      Value<String?> startTime,
      required String teamId,
      required String coachId,
      required String activeGoalkeeperId,
      required String status,
      Value<int> elapsedMs,
      Value<DateTime?> startedAt,
      Value<DateTime?> finishedAt,
      required String deviceId,
      required DateTime createdAt,
      required DateTime updatedAt,
      Value<int> version,
      Value<int> rowid,
    });
typedef $$TournamentSessionsTableUpdateCompanionBuilder =
    TournamentSessionsCompanion Function({
      Value<String> id,
      Value<String> tournamentName,
      Value<String> scheduledDate,
      Value<String?> startTime,
      Value<String> teamId,
      Value<String> coachId,
      Value<String> activeGoalkeeperId,
      Value<String> status,
      Value<int> elapsedMs,
      Value<DateTime?> startedAt,
      Value<DateTime?> finishedAt,
      Value<String> deviceId,
      Value<DateTime> createdAt,
      Value<DateTime> updatedAt,
      Value<int> version,
      Value<int> rowid,
    });

final class $$TournamentSessionsTableReferences
    extends
        BaseReferences<
          _$AppDatabase,
          $TournamentSessionsTable,
          TournamentSession
        > {
  $$TournamentSessionsTableReferences(
    super.$_db,
    super.$_table,
    super.$_typedResult,
  );

  static $TeamsTable _teamIdTable(_$AppDatabase db) =>
      db.teams.createAlias('tournament_sessions__team_id__teams__id');

  $$TeamsTableProcessedTableManager get teamId {
    final $_column = $_itemColumn<String>('team_id')!;

    final manager = $$TeamsTableTableManager(
      $_db,
      $_db.teams,
    ).filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_teamIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: [item]),
    );
  }

  static $CoachesTable _coachIdTable(_$AppDatabase db) =>
      db.coaches.createAlias('tournament_sessions__coach_id__coaches__id');

  $$CoachesTableProcessedTableManager get coachId {
    final $_column = $_itemColumn<String>('coach_id')!;

    final manager = $$CoachesTableTableManager(
      $_db,
      $_db.coaches,
    ).filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_coachIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: [item]),
    );
  }

  static $PlayersTable _activeGoalkeeperIdTable(_$AppDatabase db) => db.players
      .createAlias('tournament_sessions__active_goalkeeper_id__players__id');

  $$PlayersTableProcessedTableManager get activeGoalkeeperId {
    final $_column = $_itemColumn<String>('active_goalkeeper_id')!;

    final manager = $$PlayersTableTableManager(
      $_db,
      $_db.players,
    ).filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_activeGoalkeeperIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: [item]),
    );
  }

  static MultiTypedResultKey<$SessionPlayersTable, List<SessionPlayer>>
  _sessionPlayersRefsTable(_$AppDatabase db) => MultiTypedResultKey.fromTable(
    db.sessionPlayers,
    aliasName: 'tournament_sessions__id__session_players__session_id',
  );

  $$SessionPlayersTableProcessedTableManager get sessionPlayersRefs {
    final manager = $$SessionPlayersTableTableManager(
      $_db,
      $_db.sessionPlayers,
    ).filter((f) => f.sessionId.id.sqlEquals($_itemColumn<String>('id')!));

    final cache = $_typedResult.readTableOrNull(_sessionPlayersRefsTable($_db));
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: cache),
    );
  }

  static MultiTypedResultKey<$MatchActionsTable, List<MatchAction>>
  _matchActionsRefsTable(_$AppDatabase db) => MultiTypedResultKey.fromTable(
    db.matchActions,
    aliasName: 'tournament_sessions__id__match_actions__session_id',
  );

  $$MatchActionsTableProcessedTableManager get matchActionsRefs {
    final manager = $$MatchActionsTableTableManager(
      $_db,
      $_db.matchActions,
    ).filter((f) => f.sessionId.id.sqlEquals($_itemColumn<String>('id')!));

    final cache = $_typedResult.readTableOrNull(_matchActionsRefsTable($_db));
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: cache),
    );
  }

  static MultiTypedResultKey<$GoalkeeperActionsTable, List<GoalkeeperAction>>
  _goalkeeperActionsRefsTable(_$AppDatabase db) =>
      MultiTypedResultKey.fromTable(
        db.goalkeeperActions,
        aliasName: 'tournament_sessions__id__goalkeeper_actions__session_id',
      );

  $$GoalkeeperActionsTableProcessedTableManager get goalkeeperActionsRefs {
    final manager = $$GoalkeeperActionsTableTableManager(
      $_db,
      $_db.goalkeeperActions,
    ).filter((f) => f.sessionId.id.sqlEquals($_itemColumn<String>('id')!));

    final cache = $_typedResult.readTableOrNull(
      _goalkeeperActionsRefsTable($_db),
    );
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: cache),
    );
  }
}

class $$TournamentSessionsTableFilterComposer
    extends Composer<_$AppDatabase, $TournamentSessionsTable> {
  $$TournamentSessionsTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get tournamentName => $composableBuilder(
    column: $table.tournamentName,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get scheduledDate => $composableBuilder(
    column: $table.scheduledDate,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get startTime => $composableBuilder(
    column: $table.startTime,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get status => $composableBuilder(
    column: $table.status,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get elapsedMs => $composableBuilder(
    column: $table.elapsedMs,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get startedAt => $composableBuilder(
    column: $table.startedAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get finishedAt => $composableBuilder(
    column: $table.finishedAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get deviceId => $composableBuilder(
    column: $table.deviceId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get updatedAt => $composableBuilder(
    column: $table.updatedAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get version => $composableBuilder(
    column: $table.version,
    builder: (column) => ColumnFilters(column),
  );

  $$TeamsTableFilterComposer get teamId {
    final $$TeamsTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.teamId,
      referencedTable: $db.teams,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$TeamsTableFilterComposer(
            $db: $db,
            $table: $db.teams,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  $$CoachesTableFilterComposer get coachId {
    final $$CoachesTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.coachId,
      referencedTable: $db.coaches,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$CoachesTableFilterComposer(
            $db: $db,
            $table: $db.coaches,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  $$PlayersTableFilterComposer get activeGoalkeeperId {
    final $$PlayersTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.activeGoalkeeperId,
      referencedTable: $db.players,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$PlayersTableFilterComposer(
            $db: $db,
            $table: $db.players,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  Expression<bool> sessionPlayersRefs(
    Expression<bool> Function($$SessionPlayersTableFilterComposer f) f,
  ) {
    final $$SessionPlayersTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.sessionPlayers,
      getReferencedColumn: (t) => t.sessionId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$SessionPlayersTableFilterComposer(
            $db: $db,
            $table: $db.sessionPlayers,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }

  Expression<bool> matchActionsRefs(
    Expression<bool> Function($$MatchActionsTableFilterComposer f) f,
  ) {
    final $$MatchActionsTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.matchActions,
      getReferencedColumn: (t) => t.sessionId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$MatchActionsTableFilterComposer(
            $db: $db,
            $table: $db.matchActions,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }

  Expression<bool> goalkeeperActionsRefs(
    Expression<bool> Function($$GoalkeeperActionsTableFilterComposer f) f,
  ) {
    final $$GoalkeeperActionsTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.goalkeeperActions,
      getReferencedColumn: (t) => t.sessionId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$GoalkeeperActionsTableFilterComposer(
            $db: $db,
            $table: $db.goalkeeperActions,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }
}

class $$TournamentSessionsTableOrderingComposer
    extends Composer<_$AppDatabase, $TournamentSessionsTable> {
  $$TournamentSessionsTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get tournamentName => $composableBuilder(
    column: $table.tournamentName,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get scheduledDate => $composableBuilder(
    column: $table.scheduledDate,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get startTime => $composableBuilder(
    column: $table.startTime,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get status => $composableBuilder(
    column: $table.status,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get elapsedMs => $composableBuilder(
    column: $table.elapsedMs,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get startedAt => $composableBuilder(
    column: $table.startedAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get finishedAt => $composableBuilder(
    column: $table.finishedAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get deviceId => $composableBuilder(
    column: $table.deviceId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get updatedAt => $composableBuilder(
    column: $table.updatedAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get version => $composableBuilder(
    column: $table.version,
    builder: (column) => ColumnOrderings(column),
  );

  $$TeamsTableOrderingComposer get teamId {
    final $$TeamsTableOrderingComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.teamId,
      referencedTable: $db.teams,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$TeamsTableOrderingComposer(
            $db: $db,
            $table: $db.teams,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  $$CoachesTableOrderingComposer get coachId {
    final $$CoachesTableOrderingComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.coachId,
      referencedTable: $db.coaches,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$CoachesTableOrderingComposer(
            $db: $db,
            $table: $db.coaches,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  $$PlayersTableOrderingComposer get activeGoalkeeperId {
    final $$PlayersTableOrderingComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.activeGoalkeeperId,
      referencedTable: $db.players,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$PlayersTableOrderingComposer(
            $db: $db,
            $table: $db.players,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$TournamentSessionsTableAnnotationComposer
    extends Composer<_$AppDatabase, $TournamentSessionsTable> {
  $$TournamentSessionsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get tournamentName => $composableBuilder(
    column: $table.tournamentName,
    builder: (column) => column,
  );

  GeneratedColumn<String> get scheduledDate => $composableBuilder(
    column: $table.scheduledDate,
    builder: (column) => column,
  );

  GeneratedColumn<String> get startTime =>
      $composableBuilder(column: $table.startTime, builder: (column) => column);

  GeneratedColumn<String> get status =>
      $composableBuilder(column: $table.status, builder: (column) => column);

  GeneratedColumn<int> get elapsedMs =>
      $composableBuilder(column: $table.elapsedMs, builder: (column) => column);

  GeneratedColumn<DateTime> get startedAt =>
      $composableBuilder(column: $table.startedAt, builder: (column) => column);

  GeneratedColumn<DateTime> get finishedAt => $composableBuilder(
    column: $table.finishedAt,
    builder: (column) => column,
  );

  GeneratedColumn<String> get deviceId =>
      $composableBuilder(column: $table.deviceId, builder: (column) => column);

  GeneratedColumn<DateTime> get createdAt =>
      $composableBuilder(column: $table.createdAt, builder: (column) => column);

  GeneratedColumn<DateTime> get updatedAt =>
      $composableBuilder(column: $table.updatedAt, builder: (column) => column);

  GeneratedColumn<int> get version =>
      $composableBuilder(column: $table.version, builder: (column) => column);

  $$TeamsTableAnnotationComposer get teamId {
    final $$TeamsTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.teamId,
      referencedTable: $db.teams,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$TeamsTableAnnotationComposer(
            $db: $db,
            $table: $db.teams,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  $$CoachesTableAnnotationComposer get coachId {
    final $$CoachesTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.coachId,
      referencedTable: $db.coaches,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$CoachesTableAnnotationComposer(
            $db: $db,
            $table: $db.coaches,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  $$PlayersTableAnnotationComposer get activeGoalkeeperId {
    final $$PlayersTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.activeGoalkeeperId,
      referencedTable: $db.players,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$PlayersTableAnnotationComposer(
            $db: $db,
            $table: $db.players,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  Expression<T> sessionPlayersRefs<T extends Object>(
    Expression<T> Function($$SessionPlayersTableAnnotationComposer a) f,
  ) {
    final $$SessionPlayersTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.sessionPlayers,
      getReferencedColumn: (t) => t.sessionId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$SessionPlayersTableAnnotationComposer(
            $db: $db,
            $table: $db.sessionPlayers,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }

  Expression<T> matchActionsRefs<T extends Object>(
    Expression<T> Function($$MatchActionsTableAnnotationComposer a) f,
  ) {
    final $$MatchActionsTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.matchActions,
      getReferencedColumn: (t) => t.sessionId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$MatchActionsTableAnnotationComposer(
            $db: $db,
            $table: $db.matchActions,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }

  Expression<T> goalkeeperActionsRefs<T extends Object>(
    Expression<T> Function($$GoalkeeperActionsTableAnnotationComposer a) f,
  ) {
    final $$GoalkeeperActionsTableAnnotationComposer composer =
        $composerBuilder(
          composer: this,
          getCurrentColumn: (t) => t.id,
          referencedTable: $db.goalkeeperActions,
          getReferencedColumn: (t) => t.sessionId,
          builder:
              (
                joinBuilder, {
                $addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer,
              }) => $$GoalkeeperActionsTableAnnotationComposer(
                $db: $db,
                $table: $db.goalkeeperActions,
                $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
                joinBuilder: joinBuilder,
                $removeJoinBuilderFromRootComposer:
                    $removeJoinBuilderFromRootComposer,
              ),
        );
    return f(composer);
  }
}

class $$TournamentSessionsTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $TournamentSessionsTable,
          TournamentSession,
          $$TournamentSessionsTableFilterComposer,
          $$TournamentSessionsTableOrderingComposer,
          $$TournamentSessionsTableAnnotationComposer,
          $$TournamentSessionsTableCreateCompanionBuilder,
          $$TournamentSessionsTableUpdateCompanionBuilder,
          (TournamentSession, $$TournamentSessionsTableReferences),
          TournamentSession,
          PrefetchHooks Function({
            bool teamId,
            bool coachId,
            bool activeGoalkeeperId,
            bool sessionPlayersRefs,
            bool matchActionsRefs,
            bool goalkeeperActionsRefs,
          })
        > {
  $$TournamentSessionsTableTableManager(
    _$AppDatabase db,
    $TournamentSessionsTable table,
  ) : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$TournamentSessionsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$TournamentSessionsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$TournamentSessionsTableAnnotationComposer(
                $db: db,
                $table: table,
              ),
          updateCompanionCallback:
              ({
                Value<String> id = const Value.absent(),
                Value<String> tournamentName = const Value.absent(),
                Value<String> scheduledDate = const Value.absent(),
                Value<String?> startTime = const Value.absent(),
                Value<String> teamId = const Value.absent(),
                Value<String> coachId = const Value.absent(),
                Value<String> activeGoalkeeperId = const Value.absent(),
                Value<String> status = const Value.absent(),
                Value<int> elapsedMs = const Value.absent(),
                Value<DateTime?> startedAt = const Value.absent(),
                Value<DateTime?> finishedAt = const Value.absent(),
                Value<String> deviceId = const Value.absent(),
                Value<DateTime> createdAt = const Value.absent(),
                Value<DateTime> updatedAt = const Value.absent(),
                Value<int> version = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => TournamentSessionsCompanion(
                id: id,
                tournamentName: tournamentName,
                scheduledDate: scheduledDate,
                startTime: startTime,
                teamId: teamId,
                coachId: coachId,
                activeGoalkeeperId: activeGoalkeeperId,
                status: status,
                elapsedMs: elapsedMs,
                startedAt: startedAt,
                finishedAt: finishedAt,
                deviceId: deviceId,
                createdAt: createdAt,
                updatedAt: updatedAt,
                version: version,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String id,
                required String tournamentName,
                required String scheduledDate,
                Value<String?> startTime = const Value.absent(),
                required String teamId,
                required String coachId,
                required String activeGoalkeeperId,
                required String status,
                Value<int> elapsedMs = const Value.absent(),
                Value<DateTime?> startedAt = const Value.absent(),
                Value<DateTime?> finishedAt = const Value.absent(),
                required String deviceId,
                required DateTime createdAt,
                required DateTime updatedAt,
                Value<int> version = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => TournamentSessionsCompanion.insert(
                id: id,
                tournamentName: tournamentName,
                scheduledDate: scheduledDate,
                startTime: startTime,
                teamId: teamId,
                coachId: coachId,
                activeGoalkeeperId: activeGoalkeeperId,
                status: status,
                elapsedMs: elapsedMs,
                startedAt: startedAt,
                finishedAt: finishedAt,
                deviceId: deviceId,
                createdAt: createdAt,
                updatedAt: updatedAt,
                version: version,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable(table),
                  $$TournamentSessionsTableReferences(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback:
              ({
                teamId = false,
                coachId = false,
                activeGoalkeeperId = false,
                sessionPlayersRefs = false,
                matchActionsRefs = false,
                goalkeeperActionsRefs = false,
              }) {
                return PrefetchHooks(
                  db: db,
                  explicitlyWatchedTables: [
                    if (sessionPlayersRefs) db.sessionPlayers,
                    if (matchActionsRefs) db.matchActions,
                    if (goalkeeperActionsRefs) db.goalkeeperActions,
                  ],
                  addJoins:
                      <
                        T extends TableManagerState<
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic
                        >
                      >(state) {
                        if (teamId) {
                          state =
                              state.withJoin(
                                    currentTable: table,
                                    currentColumn: table.teamId,
                                    referencedTable:
                                        $$TournamentSessionsTableReferences
                                            ._teamIdTable(db),
                                    referencedColumn:
                                        $$TournamentSessionsTableReferences
                                            ._teamIdTable(db)
                                            .id,
                                  )
                                  as T;
                        }
                        if (coachId) {
                          state =
                              state.withJoin(
                                    currentTable: table,
                                    currentColumn: table.coachId,
                                    referencedTable:
                                        $$TournamentSessionsTableReferences
                                            ._coachIdTable(db),
                                    referencedColumn:
                                        $$TournamentSessionsTableReferences
                                            ._coachIdTable(db)
                                            .id,
                                  )
                                  as T;
                        }
                        if (activeGoalkeeperId) {
                          state =
                              state.withJoin(
                                    currentTable: table,
                                    currentColumn: table.activeGoalkeeperId,
                                    referencedTable:
                                        $$TournamentSessionsTableReferences
                                            ._activeGoalkeeperIdTable(db),
                                    referencedColumn:
                                        $$TournamentSessionsTableReferences
                                            ._activeGoalkeeperIdTable(db)
                                            .id,
                                  )
                                  as T;
                        }

                        return state;
                      },
                  getPrefetchedDataCallback: (items) async {
                    return [
                      if (sessionPlayersRefs)
                        await $_getPrefetchedData<
                          TournamentSession,
                          $TournamentSessionsTable,
                          SessionPlayer
                        >(
                          currentTable: table,
                          referencedTable: $$TournamentSessionsTableReferences
                              ._sessionPlayersRefsTable(db),
                          managerFromTypedResult: (p0) =>
                              $$TournamentSessionsTableReferences(
                                db,
                                table,
                                p0,
                              ).sessionPlayersRefs,
                          referencedItemsForCurrentItem:
                              (item, referencedItems) => referencedItems.where(
                                (e) => e.sessionId == item.id,
                              ),
                          typedResults: items,
                        ),
                      if (matchActionsRefs)
                        await $_getPrefetchedData<
                          TournamentSession,
                          $TournamentSessionsTable,
                          MatchAction
                        >(
                          currentTable: table,
                          referencedTable: $$TournamentSessionsTableReferences
                              ._matchActionsRefsTable(db),
                          managerFromTypedResult: (p0) =>
                              $$TournamentSessionsTableReferences(
                                db,
                                table,
                                p0,
                              ).matchActionsRefs,
                          referencedItemsForCurrentItem:
                              (item, referencedItems) => referencedItems.where(
                                (e) => e.sessionId == item.id,
                              ),
                          typedResults: items,
                        ),
                      if (goalkeeperActionsRefs)
                        await $_getPrefetchedData<
                          TournamentSession,
                          $TournamentSessionsTable,
                          GoalkeeperAction
                        >(
                          currentTable: table,
                          referencedTable: $$TournamentSessionsTableReferences
                              ._goalkeeperActionsRefsTable(db),
                          managerFromTypedResult: (p0) =>
                              $$TournamentSessionsTableReferences(
                                db,
                                table,
                                p0,
                              ).goalkeeperActionsRefs,
                          referencedItemsForCurrentItem:
                              (item, referencedItems) => referencedItems.where(
                                (e) => e.sessionId == item.id,
                              ),
                          typedResults: items,
                        ),
                    ];
                  },
                );
              },
        ),
      );
}

typedef $$TournamentSessionsTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $TournamentSessionsTable,
      TournamentSession,
      $$TournamentSessionsTableFilterComposer,
      $$TournamentSessionsTableOrderingComposer,
      $$TournamentSessionsTableAnnotationComposer,
      $$TournamentSessionsTableCreateCompanionBuilder,
      $$TournamentSessionsTableUpdateCompanionBuilder,
      (TournamentSession, $$TournamentSessionsTableReferences),
      TournamentSession,
      PrefetchHooks Function({
        bool teamId,
        bool coachId,
        bool activeGoalkeeperId,
        bool sessionPlayersRefs,
        bool matchActionsRefs,
        bool goalkeeperActionsRefs,
      })
    >;
typedef $$SessionPlayersTableCreateCompanionBuilder =
    SessionPlayersCompanion Function({
      required String sessionId,
      required String playerId,
      required String role,
      required DateTime createdAt,
      required DateTime updatedAt,
      Value<int> version,
      Value<int> rowid,
    });
typedef $$SessionPlayersTableUpdateCompanionBuilder =
    SessionPlayersCompanion Function({
      Value<String> sessionId,
      Value<String> playerId,
      Value<String> role,
      Value<DateTime> createdAt,
      Value<DateTime> updatedAt,
      Value<int> version,
      Value<int> rowid,
    });

final class $$SessionPlayersTableReferences
    extends BaseReferences<_$AppDatabase, $SessionPlayersTable, SessionPlayer> {
  $$SessionPlayersTableReferences(
    super.$_db,
    super.$_table,
    super.$_typedResult,
  );

  static $TournamentSessionsTable _sessionIdTable(_$AppDatabase db) => db
      .tournamentSessions
      .createAlias('session_players__session_id__tournament_sessions__id');

  $$TournamentSessionsTableProcessedTableManager get sessionId {
    final $_column = $_itemColumn<String>('session_id')!;

    final manager = $$TournamentSessionsTableTableManager(
      $_db,
      $_db.tournamentSessions,
    ).filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_sessionIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: [item]),
    );
  }

  static $PlayersTable _playerIdTable(_$AppDatabase db) =>
      db.players.createAlias('session_players__player_id__players__id');

  $$PlayersTableProcessedTableManager get playerId {
    final $_column = $_itemColumn<String>('player_id')!;

    final manager = $$PlayersTableTableManager(
      $_db,
      $_db.players,
    ).filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_playerIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: [item]),
    );
  }
}

class $$SessionPlayersTableFilterComposer
    extends Composer<_$AppDatabase, $SessionPlayersTable> {
  $$SessionPlayersTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get role => $composableBuilder(
    column: $table.role,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get updatedAt => $composableBuilder(
    column: $table.updatedAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get version => $composableBuilder(
    column: $table.version,
    builder: (column) => ColumnFilters(column),
  );

  $$TournamentSessionsTableFilterComposer get sessionId {
    final $$TournamentSessionsTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.sessionId,
      referencedTable: $db.tournamentSessions,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$TournamentSessionsTableFilterComposer(
            $db: $db,
            $table: $db.tournamentSessions,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  $$PlayersTableFilterComposer get playerId {
    final $$PlayersTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.playerId,
      referencedTable: $db.players,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$PlayersTableFilterComposer(
            $db: $db,
            $table: $db.players,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$SessionPlayersTableOrderingComposer
    extends Composer<_$AppDatabase, $SessionPlayersTable> {
  $$SessionPlayersTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get role => $composableBuilder(
    column: $table.role,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get updatedAt => $composableBuilder(
    column: $table.updatedAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get version => $composableBuilder(
    column: $table.version,
    builder: (column) => ColumnOrderings(column),
  );

  $$TournamentSessionsTableOrderingComposer get sessionId {
    final $$TournamentSessionsTableOrderingComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.sessionId,
      referencedTable: $db.tournamentSessions,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$TournamentSessionsTableOrderingComposer(
            $db: $db,
            $table: $db.tournamentSessions,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  $$PlayersTableOrderingComposer get playerId {
    final $$PlayersTableOrderingComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.playerId,
      referencedTable: $db.players,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$PlayersTableOrderingComposer(
            $db: $db,
            $table: $db.players,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$SessionPlayersTableAnnotationComposer
    extends Composer<_$AppDatabase, $SessionPlayersTable> {
  $$SessionPlayersTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get role =>
      $composableBuilder(column: $table.role, builder: (column) => column);

  GeneratedColumn<DateTime> get createdAt =>
      $composableBuilder(column: $table.createdAt, builder: (column) => column);

  GeneratedColumn<DateTime> get updatedAt =>
      $composableBuilder(column: $table.updatedAt, builder: (column) => column);

  GeneratedColumn<int> get version =>
      $composableBuilder(column: $table.version, builder: (column) => column);

  $$TournamentSessionsTableAnnotationComposer get sessionId {
    final $$TournamentSessionsTableAnnotationComposer composer =
        $composerBuilder(
          composer: this,
          getCurrentColumn: (t) => t.sessionId,
          referencedTable: $db.tournamentSessions,
          getReferencedColumn: (t) => t.id,
          builder:
              (
                joinBuilder, {
                $addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer,
              }) => $$TournamentSessionsTableAnnotationComposer(
                $db: $db,
                $table: $db.tournamentSessions,
                $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
                joinBuilder: joinBuilder,
                $removeJoinBuilderFromRootComposer:
                    $removeJoinBuilderFromRootComposer,
              ),
        );
    return composer;
  }

  $$PlayersTableAnnotationComposer get playerId {
    final $$PlayersTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.playerId,
      referencedTable: $db.players,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$PlayersTableAnnotationComposer(
            $db: $db,
            $table: $db.players,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$SessionPlayersTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $SessionPlayersTable,
          SessionPlayer,
          $$SessionPlayersTableFilterComposer,
          $$SessionPlayersTableOrderingComposer,
          $$SessionPlayersTableAnnotationComposer,
          $$SessionPlayersTableCreateCompanionBuilder,
          $$SessionPlayersTableUpdateCompanionBuilder,
          (SessionPlayer, $$SessionPlayersTableReferences),
          SessionPlayer,
          PrefetchHooks Function({bool sessionId, bool playerId})
        > {
  $$SessionPlayersTableTableManager(
    _$AppDatabase db,
    $SessionPlayersTable table,
  ) : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$SessionPlayersTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$SessionPlayersTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$SessionPlayersTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<String> sessionId = const Value.absent(),
                Value<String> playerId = const Value.absent(),
                Value<String> role = const Value.absent(),
                Value<DateTime> createdAt = const Value.absent(),
                Value<DateTime> updatedAt = const Value.absent(),
                Value<int> version = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => SessionPlayersCompanion(
                sessionId: sessionId,
                playerId: playerId,
                role: role,
                createdAt: createdAt,
                updatedAt: updatedAt,
                version: version,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String sessionId,
                required String playerId,
                required String role,
                required DateTime createdAt,
                required DateTime updatedAt,
                Value<int> version = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => SessionPlayersCompanion.insert(
                sessionId: sessionId,
                playerId: playerId,
                role: role,
                createdAt: createdAt,
                updatedAt: updatedAt,
                version: version,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable(table),
                  $$SessionPlayersTableReferences(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback: ({sessionId = false, playerId = false}) {
            return PrefetchHooks(
              db: db,
              explicitlyWatchedTables: [],
              addJoins:
                  <
                    T extends TableManagerState<
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic
                    >
                  >(state) {
                    if (sessionId) {
                      state =
                          state.withJoin(
                                currentTable: table,
                                currentColumn: table.sessionId,
                                referencedTable: $$SessionPlayersTableReferences
                                    ._sessionIdTable(db),
                                referencedColumn:
                                    $$SessionPlayersTableReferences
                                        ._sessionIdTable(db)
                                        .id,
                              )
                              as T;
                    }
                    if (playerId) {
                      state =
                          state.withJoin(
                                currentTable: table,
                                currentColumn: table.playerId,
                                referencedTable: $$SessionPlayersTableReferences
                                    ._playerIdTable(db),
                                referencedColumn:
                                    $$SessionPlayersTableReferences
                                        ._playerIdTable(db)
                                        .id,
                              )
                              as T;
                    }

                    return state;
                  },
              getPrefetchedDataCallback: (items) async {
                return [];
              },
            );
          },
        ),
      );
}

typedef $$SessionPlayersTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $SessionPlayersTable,
      SessionPlayer,
      $$SessionPlayersTableFilterComposer,
      $$SessionPlayersTableOrderingComposer,
      $$SessionPlayersTableAnnotationComposer,
      $$SessionPlayersTableCreateCompanionBuilder,
      $$SessionPlayersTableUpdateCompanionBuilder,
      (SessionPlayer, $$SessionPlayersTableReferences),
      SessionPlayer,
      PrefetchHooks Function({bool sessionId, bool playerId})
    >;
typedef $$MatchActionsTableCreateCompanionBuilder =
    MatchActionsCompanion Function({
      required String id,
      required String sessionId,
      required String playerId,
      required String actionType,
      Value<String?> outcome,
      required int clockMs,
      Value<String?> rinkZone,
      Value<String?> note,
      required String clientEventId,
      required String deviceId,
      required DateTime createdAt,
      required DateTime updatedAt,
      Value<int> version,
      Value<DateTime?> voidedAt,
      Value<String?> voidReason,
      Value<int> rowid,
    });
typedef $$MatchActionsTableUpdateCompanionBuilder =
    MatchActionsCompanion Function({
      Value<String> id,
      Value<String> sessionId,
      Value<String> playerId,
      Value<String> actionType,
      Value<String?> outcome,
      Value<int> clockMs,
      Value<String?> rinkZone,
      Value<String?> note,
      Value<String> clientEventId,
      Value<String> deviceId,
      Value<DateTime> createdAt,
      Value<DateTime> updatedAt,
      Value<int> version,
      Value<DateTime?> voidedAt,
      Value<String?> voidReason,
      Value<int> rowid,
    });

final class $$MatchActionsTableReferences
    extends BaseReferences<_$AppDatabase, $MatchActionsTable, MatchAction> {
  $$MatchActionsTableReferences(super.$_db, super.$_table, super.$_typedResult);

  static $TournamentSessionsTable _sessionIdTable(_$AppDatabase db) => db
      .tournamentSessions
      .createAlias('match_actions__session_id__tournament_sessions__id');

  $$TournamentSessionsTableProcessedTableManager get sessionId {
    final $_column = $_itemColumn<String>('session_id')!;

    final manager = $$TournamentSessionsTableTableManager(
      $_db,
      $_db.tournamentSessions,
    ).filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_sessionIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: [item]),
    );
  }

  static $PlayersTable _playerIdTable(_$AppDatabase db) =>
      db.players.createAlias('match_actions__player_id__players__id');

  $$PlayersTableProcessedTableManager get playerId {
    final $_column = $_itemColumn<String>('player_id')!;

    final manager = $$PlayersTableTableManager(
      $_db,
      $_db.players,
    ).filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_playerIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: [item]),
    );
  }

  static MultiTypedResultKey<$ShootDetailsTable, List<ShootDetail>>
  _shootDetailsRefsTable(_$AppDatabase db) => MultiTypedResultKey.fromTable(
    db.shootDetails,
    aliasName: 'match_actions__id__shoot_details__action_id',
  );

  $$ShootDetailsTableProcessedTableManager get shootDetailsRefs {
    final manager = $$ShootDetailsTableTableManager(
      $_db,
      $_db.shootDetails,
    ).filter((f) => f.actionId.id.sqlEquals($_itemColumn<String>('id')!));

    final cache = $_typedResult.readTableOrNull(_shootDetailsRefsTable($_db));
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: cache),
    );
  }
}

class $$MatchActionsTableFilterComposer
    extends Composer<_$AppDatabase, $MatchActionsTable> {
  $$MatchActionsTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get actionType => $composableBuilder(
    column: $table.actionType,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get outcome => $composableBuilder(
    column: $table.outcome,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get clockMs => $composableBuilder(
    column: $table.clockMs,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get rinkZone => $composableBuilder(
    column: $table.rinkZone,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get note => $composableBuilder(
    column: $table.note,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get clientEventId => $composableBuilder(
    column: $table.clientEventId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get deviceId => $composableBuilder(
    column: $table.deviceId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get updatedAt => $composableBuilder(
    column: $table.updatedAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get version => $composableBuilder(
    column: $table.version,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get voidedAt => $composableBuilder(
    column: $table.voidedAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get voidReason => $composableBuilder(
    column: $table.voidReason,
    builder: (column) => ColumnFilters(column),
  );

  $$TournamentSessionsTableFilterComposer get sessionId {
    final $$TournamentSessionsTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.sessionId,
      referencedTable: $db.tournamentSessions,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$TournamentSessionsTableFilterComposer(
            $db: $db,
            $table: $db.tournamentSessions,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  $$PlayersTableFilterComposer get playerId {
    final $$PlayersTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.playerId,
      referencedTable: $db.players,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$PlayersTableFilterComposer(
            $db: $db,
            $table: $db.players,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  Expression<bool> shootDetailsRefs(
    Expression<bool> Function($$ShootDetailsTableFilterComposer f) f,
  ) {
    final $$ShootDetailsTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.shootDetails,
      getReferencedColumn: (t) => t.actionId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$ShootDetailsTableFilterComposer(
            $db: $db,
            $table: $db.shootDetails,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }
}

class $$MatchActionsTableOrderingComposer
    extends Composer<_$AppDatabase, $MatchActionsTable> {
  $$MatchActionsTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get actionType => $composableBuilder(
    column: $table.actionType,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get outcome => $composableBuilder(
    column: $table.outcome,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get clockMs => $composableBuilder(
    column: $table.clockMs,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get rinkZone => $composableBuilder(
    column: $table.rinkZone,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get note => $composableBuilder(
    column: $table.note,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get clientEventId => $composableBuilder(
    column: $table.clientEventId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get deviceId => $composableBuilder(
    column: $table.deviceId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get updatedAt => $composableBuilder(
    column: $table.updatedAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get version => $composableBuilder(
    column: $table.version,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get voidedAt => $composableBuilder(
    column: $table.voidedAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get voidReason => $composableBuilder(
    column: $table.voidReason,
    builder: (column) => ColumnOrderings(column),
  );

  $$TournamentSessionsTableOrderingComposer get sessionId {
    final $$TournamentSessionsTableOrderingComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.sessionId,
      referencedTable: $db.tournamentSessions,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$TournamentSessionsTableOrderingComposer(
            $db: $db,
            $table: $db.tournamentSessions,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  $$PlayersTableOrderingComposer get playerId {
    final $$PlayersTableOrderingComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.playerId,
      referencedTable: $db.players,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$PlayersTableOrderingComposer(
            $db: $db,
            $table: $db.players,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$MatchActionsTableAnnotationComposer
    extends Composer<_$AppDatabase, $MatchActionsTable> {
  $$MatchActionsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get actionType => $composableBuilder(
    column: $table.actionType,
    builder: (column) => column,
  );

  GeneratedColumn<String> get outcome =>
      $composableBuilder(column: $table.outcome, builder: (column) => column);

  GeneratedColumn<int> get clockMs =>
      $composableBuilder(column: $table.clockMs, builder: (column) => column);

  GeneratedColumn<String> get rinkZone =>
      $composableBuilder(column: $table.rinkZone, builder: (column) => column);

  GeneratedColumn<String> get note =>
      $composableBuilder(column: $table.note, builder: (column) => column);

  GeneratedColumn<String> get clientEventId => $composableBuilder(
    column: $table.clientEventId,
    builder: (column) => column,
  );

  GeneratedColumn<String> get deviceId =>
      $composableBuilder(column: $table.deviceId, builder: (column) => column);

  GeneratedColumn<DateTime> get createdAt =>
      $composableBuilder(column: $table.createdAt, builder: (column) => column);

  GeneratedColumn<DateTime> get updatedAt =>
      $composableBuilder(column: $table.updatedAt, builder: (column) => column);

  GeneratedColumn<int> get version =>
      $composableBuilder(column: $table.version, builder: (column) => column);

  GeneratedColumn<DateTime> get voidedAt =>
      $composableBuilder(column: $table.voidedAt, builder: (column) => column);

  GeneratedColumn<String> get voidReason => $composableBuilder(
    column: $table.voidReason,
    builder: (column) => column,
  );

  $$TournamentSessionsTableAnnotationComposer get sessionId {
    final $$TournamentSessionsTableAnnotationComposer composer =
        $composerBuilder(
          composer: this,
          getCurrentColumn: (t) => t.sessionId,
          referencedTable: $db.tournamentSessions,
          getReferencedColumn: (t) => t.id,
          builder:
              (
                joinBuilder, {
                $addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer,
              }) => $$TournamentSessionsTableAnnotationComposer(
                $db: $db,
                $table: $db.tournamentSessions,
                $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
                joinBuilder: joinBuilder,
                $removeJoinBuilderFromRootComposer:
                    $removeJoinBuilderFromRootComposer,
              ),
        );
    return composer;
  }

  $$PlayersTableAnnotationComposer get playerId {
    final $$PlayersTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.playerId,
      referencedTable: $db.players,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$PlayersTableAnnotationComposer(
            $db: $db,
            $table: $db.players,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  Expression<T> shootDetailsRefs<T extends Object>(
    Expression<T> Function($$ShootDetailsTableAnnotationComposer a) f,
  ) {
    final $$ShootDetailsTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.shootDetails,
      getReferencedColumn: (t) => t.actionId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$ShootDetailsTableAnnotationComposer(
            $db: $db,
            $table: $db.shootDetails,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }
}

class $$MatchActionsTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $MatchActionsTable,
          MatchAction,
          $$MatchActionsTableFilterComposer,
          $$MatchActionsTableOrderingComposer,
          $$MatchActionsTableAnnotationComposer,
          $$MatchActionsTableCreateCompanionBuilder,
          $$MatchActionsTableUpdateCompanionBuilder,
          (MatchAction, $$MatchActionsTableReferences),
          MatchAction,
          PrefetchHooks Function({
            bool sessionId,
            bool playerId,
            bool shootDetailsRefs,
          })
        > {
  $$MatchActionsTableTableManager(_$AppDatabase db, $MatchActionsTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$MatchActionsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$MatchActionsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$MatchActionsTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<String> id = const Value.absent(),
                Value<String> sessionId = const Value.absent(),
                Value<String> playerId = const Value.absent(),
                Value<String> actionType = const Value.absent(),
                Value<String?> outcome = const Value.absent(),
                Value<int> clockMs = const Value.absent(),
                Value<String?> rinkZone = const Value.absent(),
                Value<String?> note = const Value.absent(),
                Value<String> clientEventId = const Value.absent(),
                Value<String> deviceId = const Value.absent(),
                Value<DateTime> createdAt = const Value.absent(),
                Value<DateTime> updatedAt = const Value.absent(),
                Value<int> version = const Value.absent(),
                Value<DateTime?> voidedAt = const Value.absent(),
                Value<String?> voidReason = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => MatchActionsCompanion(
                id: id,
                sessionId: sessionId,
                playerId: playerId,
                actionType: actionType,
                outcome: outcome,
                clockMs: clockMs,
                rinkZone: rinkZone,
                note: note,
                clientEventId: clientEventId,
                deviceId: deviceId,
                createdAt: createdAt,
                updatedAt: updatedAt,
                version: version,
                voidedAt: voidedAt,
                voidReason: voidReason,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String id,
                required String sessionId,
                required String playerId,
                required String actionType,
                Value<String?> outcome = const Value.absent(),
                required int clockMs,
                Value<String?> rinkZone = const Value.absent(),
                Value<String?> note = const Value.absent(),
                required String clientEventId,
                required String deviceId,
                required DateTime createdAt,
                required DateTime updatedAt,
                Value<int> version = const Value.absent(),
                Value<DateTime?> voidedAt = const Value.absent(),
                Value<String?> voidReason = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => MatchActionsCompanion.insert(
                id: id,
                sessionId: sessionId,
                playerId: playerId,
                actionType: actionType,
                outcome: outcome,
                clockMs: clockMs,
                rinkZone: rinkZone,
                note: note,
                clientEventId: clientEventId,
                deviceId: deviceId,
                createdAt: createdAt,
                updatedAt: updatedAt,
                version: version,
                voidedAt: voidedAt,
                voidReason: voidReason,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable(table),
                  $$MatchActionsTableReferences(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback:
              ({
                sessionId = false,
                playerId = false,
                shootDetailsRefs = false,
              }) {
                return PrefetchHooks(
                  db: db,
                  explicitlyWatchedTables: [
                    if (shootDetailsRefs) db.shootDetails,
                  ],
                  addJoins:
                      <
                        T extends TableManagerState<
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic
                        >
                      >(state) {
                        if (sessionId) {
                          state =
                              state.withJoin(
                                    currentTable: table,
                                    currentColumn: table.sessionId,
                                    referencedTable:
                                        $$MatchActionsTableReferences
                                            ._sessionIdTable(db),
                                    referencedColumn:
                                        $$MatchActionsTableReferences
                                            ._sessionIdTable(db)
                                            .id,
                                  )
                                  as T;
                        }
                        if (playerId) {
                          state =
                              state.withJoin(
                                    currentTable: table,
                                    currentColumn: table.playerId,
                                    referencedTable:
                                        $$MatchActionsTableReferences
                                            ._playerIdTable(db),
                                    referencedColumn:
                                        $$MatchActionsTableReferences
                                            ._playerIdTable(db)
                                            .id,
                                  )
                                  as T;
                        }

                        return state;
                      },
                  getPrefetchedDataCallback: (items) async {
                    return [
                      if (shootDetailsRefs)
                        await $_getPrefetchedData<
                          MatchAction,
                          $MatchActionsTable,
                          ShootDetail
                        >(
                          currentTable: table,
                          referencedTable: $$MatchActionsTableReferences
                              ._shootDetailsRefsTable(db),
                          managerFromTypedResult: (p0) =>
                              $$MatchActionsTableReferences(
                                db,
                                table,
                                p0,
                              ).shootDetailsRefs,
                          referencedItemsForCurrentItem:
                              (item, referencedItems) => referencedItems.where(
                                (e) => e.actionId == item.id,
                              ),
                          typedResults: items,
                        ),
                    ];
                  },
                );
              },
        ),
      );
}

typedef $$MatchActionsTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $MatchActionsTable,
      MatchAction,
      $$MatchActionsTableFilterComposer,
      $$MatchActionsTableOrderingComposer,
      $$MatchActionsTableAnnotationComposer,
      $$MatchActionsTableCreateCompanionBuilder,
      $$MatchActionsTableUpdateCompanionBuilder,
      (MatchAction, $$MatchActionsTableReferences),
      MatchAction,
      PrefetchHooks Function({
        bool sessionId,
        bool playerId,
        bool shootDetailsRefs,
      })
    >;
typedef $$ShootDetailsTableCreateCompanionBuilder =
    ShootDetailsCompanion Function({
      required String actionId,
      required String targetZone,
      required bool isGoal,
      Value<bool?> goalieTouched,
      Value<int> rowid,
    });
typedef $$ShootDetailsTableUpdateCompanionBuilder =
    ShootDetailsCompanion Function({
      Value<String> actionId,
      Value<String> targetZone,
      Value<bool> isGoal,
      Value<bool?> goalieTouched,
      Value<int> rowid,
    });

final class $$ShootDetailsTableReferences
    extends BaseReferences<_$AppDatabase, $ShootDetailsTable, ShootDetail> {
  $$ShootDetailsTableReferences(super.$_db, super.$_table, super.$_typedResult);

  static $MatchActionsTable _actionIdTable(_$AppDatabase db) => db.matchActions
      .createAlias('shoot_details__action_id__match_actions__id');

  $$MatchActionsTableProcessedTableManager get actionId {
    final $_column = $_itemColumn<String>('action_id')!;

    final manager = $$MatchActionsTableTableManager(
      $_db,
      $_db.matchActions,
    ).filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_actionIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: [item]),
    );
  }
}

class $$ShootDetailsTableFilterComposer
    extends Composer<_$AppDatabase, $ShootDetailsTable> {
  $$ShootDetailsTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get targetZone => $composableBuilder(
    column: $table.targetZone,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<bool> get isGoal => $composableBuilder(
    column: $table.isGoal,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<bool> get goalieTouched => $composableBuilder(
    column: $table.goalieTouched,
    builder: (column) => ColumnFilters(column),
  );

  $$MatchActionsTableFilterComposer get actionId {
    final $$MatchActionsTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.actionId,
      referencedTable: $db.matchActions,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$MatchActionsTableFilterComposer(
            $db: $db,
            $table: $db.matchActions,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$ShootDetailsTableOrderingComposer
    extends Composer<_$AppDatabase, $ShootDetailsTable> {
  $$ShootDetailsTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get targetZone => $composableBuilder(
    column: $table.targetZone,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<bool> get isGoal => $composableBuilder(
    column: $table.isGoal,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<bool> get goalieTouched => $composableBuilder(
    column: $table.goalieTouched,
    builder: (column) => ColumnOrderings(column),
  );

  $$MatchActionsTableOrderingComposer get actionId {
    final $$MatchActionsTableOrderingComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.actionId,
      referencedTable: $db.matchActions,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$MatchActionsTableOrderingComposer(
            $db: $db,
            $table: $db.matchActions,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$ShootDetailsTableAnnotationComposer
    extends Composer<_$AppDatabase, $ShootDetailsTable> {
  $$ShootDetailsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get targetZone => $composableBuilder(
    column: $table.targetZone,
    builder: (column) => column,
  );

  GeneratedColumn<bool> get isGoal =>
      $composableBuilder(column: $table.isGoal, builder: (column) => column);

  GeneratedColumn<bool> get goalieTouched => $composableBuilder(
    column: $table.goalieTouched,
    builder: (column) => column,
  );

  $$MatchActionsTableAnnotationComposer get actionId {
    final $$MatchActionsTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.actionId,
      referencedTable: $db.matchActions,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$MatchActionsTableAnnotationComposer(
            $db: $db,
            $table: $db.matchActions,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$ShootDetailsTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $ShootDetailsTable,
          ShootDetail,
          $$ShootDetailsTableFilterComposer,
          $$ShootDetailsTableOrderingComposer,
          $$ShootDetailsTableAnnotationComposer,
          $$ShootDetailsTableCreateCompanionBuilder,
          $$ShootDetailsTableUpdateCompanionBuilder,
          (ShootDetail, $$ShootDetailsTableReferences),
          ShootDetail,
          PrefetchHooks Function({bool actionId})
        > {
  $$ShootDetailsTableTableManager(_$AppDatabase db, $ShootDetailsTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$ShootDetailsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$ShootDetailsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$ShootDetailsTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<String> actionId = const Value.absent(),
                Value<String> targetZone = const Value.absent(),
                Value<bool> isGoal = const Value.absent(),
                Value<bool?> goalieTouched = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => ShootDetailsCompanion(
                actionId: actionId,
                targetZone: targetZone,
                isGoal: isGoal,
                goalieTouched: goalieTouched,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String actionId,
                required String targetZone,
                required bool isGoal,
                Value<bool?> goalieTouched = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => ShootDetailsCompanion.insert(
                actionId: actionId,
                targetZone: targetZone,
                isGoal: isGoal,
                goalieTouched: goalieTouched,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable(table),
                  $$ShootDetailsTableReferences(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback: ({actionId = false}) {
            return PrefetchHooks(
              db: db,
              explicitlyWatchedTables: [],
              addJoins:
                  <
                    T extends TableManagerState<
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic
                    >
                  >(state) {
                    if (actionId) {
                      state =
                          state.withJoin(
                                currentTable: table,
                                currentColumn: table.actionId,
                                referencedTable: $$ShootDetailsTableReferences
                                    ._actionIdTable(db),
                                referencedColumn: $$ShootDetailsTableReferences
                                    ._actionIdTable(db)
                                    .id,
                              )
                              as T;
                    }

                    return state;
                  },
              getPrefetchedDataCallback: (items) async {
                return [];
              },
            );
          },
        ),
      );
}

typedef $$ShootDetailsTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $ShootDetailsTable,
      ShootDetail,
      $$ShootDetailsTableFilterComposer,
      $$ShootDetailsTableOrderingComposer,
      $$ShootDetailsTableAnnotationComposer,
      $$ShootDetailsTableCreateCompanionBuilder,
      $$ShootDetailsTableUpdateCompanionBuilder,
      (ShootDetail, $$ShootDetailsTableReferences),
      ShootDetail,
      PrefetchHooks Function({bool actionId})
    >;
typedef $$GoalkeeperActionsTableCreateCompanionBuilder =
    GoalkeeperActionsCompanion Function({
      required String id,
      required String sessionId,
      required String goalkeeperId,
      required String actionType,
      required int clockMs,
      Value<String?> rinkZone,
      Value<String?> targetZone,
      Value<String?> note,
      required String clientEventId,
      required String deviceId,
      required DateTime createdAt,
      required DateTime updatedAt,
      Value<int> version,
      Value<DateTime?> voidedAt,
      Value<String?> voidReason,
      Value<int> rowid,
    });
typedef $$GoalkeeperActionsTableUpdateCompanionBuilder =
    GoalkeeperActionsCompanion Function({
      Value<String> id,
      Value<String> sessionId,
      Value<String> goalkeeperId,
      Value<String> actionType,
      Value<int> clockMs,
      Value<String?> rinkZone,
      Value<String?> targetZone,
      Value<String?> note,
      Value<String> clientEventId,
      Value<String> deviceId,
      Value<DateTime> createdAt,
      Value<DateTime> updatedAt,
      Value<int> version,
      Value<DateTime?> voidedAt,
      Value<String?> voidReason,
      Value<int> rowid,
    });

final class $$GoalkeeperActionsTableReferences
    extends
        BaseReferences<
          _$AppDatabase,
          $GoalkeeperActionsTable,
          GoalkeeperAction
        > {
  $$GoalkeeperActionsTableReferences(
    super.$_db,
    super.$_table,
    super.$_typedResult,
  );

  static $TournamentSessionsTable _sessionIdTable(_$AppDatabase db) => db
      .tournamentSessions
      .createAlias('goalkeeper_actions__session_id__tournament_sessions__id');

  $$TournamentSessionsTableProcessedTableManager get sessionId {
    final $_column = $_itemColumn<String>('session_id')!;

    final manager = $$TournamentSessionsTableTableManager(
      $_db,
      $_db.tournamentSessions,
    ).filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_sessionIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: [item]),
    );
  }

  static $PlayersTable _goalkeeperIdTable(_$AppDatabase db) =>
      db.players.createAlias('goalkeeper_actions__goalkeeper_id__players__id');

  $$PlayersTableProcessedTableManager get goalkeeperId {
    final $_column = $_itemColumn<String>('goalkeeper_id')!;

    final manager = $$PlayersTableTableManager(
      $_db,
      $_db.players,
    ).filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_goalkeeperIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: [item]),
    );
  }
}

class $$GoalkeeperActionsTableFilterComposer
    extends Composer<_$AppDatabase, $GoalkeeperActionsTable> {
  $$GoalkeeperActionsTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get actionType => $composableBuilder(
    column: $table.actionType,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get clockMs => $composableBuilder(
    column: $table.clockMs,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get rinkZone => $composableBuilder(
    column: $table.rinkZone,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get targetZone => $composableBuilder(
    column: $table.targetZone,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get note => $composableBuilder(
    column: $table.note,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get clientEventId => $composableBuilder(
    column: $table.clientEventId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get deviceId => $composableBuilder(
    column: $table.deviceId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get updatedAt => $composableBuilder(
    column: $table.updatedAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get version => $composableBuilder(
    column: $table.version,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get voidedAt => $composableBuilder(
    column: $table.voidedAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get voidReason => $composableBuilder(
    column: $table.voidReason,
    builder: (column) => ColumnFilters(column),
  );

  $$TournamentSessionsTableFilterComposer get sessionId {
    final $$TournamentSessionsTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.sessionId,
      referencedTable: $db.tournamentSessions,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$TournamentSessionsTableFilterComposer(
            $db: $db,
            $table: $db.tournamentSessions,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  $$PlayersTableFilterComposer get goalkeeperId {
    final $$PlayersTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.goalkeeperId,
      referencedTable: $db.players,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$PlayersTableFilterComposer(
            $db: $db,
            $table: $db.players,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$GoalkeeperActionsTableOrderingComposer
    extends Composer<_$AppDatabase, $GoalkeeperActionsTable> {
  $$GoalkeeperActionsTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get actionType => $composableBuilder(
    column: $table.actionType,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get clockMs => $composableBuilder(
    column: $table.clockMs,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get rinkZone => $composableBuilder(
    column: $table.rinkZone,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get targetZone => $composableBuilder(
    column: $table.targetZone,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get note => $composableBuilder(
    column: $table.note,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get clientEventId => $composableBuilder(
    column: $table.clientEventId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get deviceId => $composableBuilder(
    column: $table.deviceId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get updatedAt => $composableBuilder(
    column: $table.updatedAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get version => $composableBuilder(
    column: $table.version,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get voidedAt => $composableBuilder(
    column: $table.voidedAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get voidReason => $composableBuilder(
    column: $table.voidReason,
    builder: (column) => ColumnOrderings(column),
  );

  $$TournamentSessionsTableOrderingComposer get sessionId {
    final $$TournamentSessionsTableOrderingComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.sessionId,
      referencedTable: $db.tournamentSessions,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$TournamentSessionsTableOrderingComposer(
            $db: $db,
            $table: $db.tournamentSessions,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  $$PlayersTableOrderingComposer get goalkeeperId {
    final $$PlayersTableOrderingComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.goalkeeperId,
      referencedTable: $db.players,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$PlayersTableOrderingComposer(
            $db: $db,
            $table: $db.players,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$GoalkeeperActionsTableAnnotationComposer
    extends Composer<_$AppDatabase, $GoalkeeperActionsTable> {
  $$GoalkeeperActionsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get actionType => $composableBuilder(
    column: $table.actionType,
    builder: (column) => column,
  );

  GeneratedColumn<int> get clockMs =>
      $composableBuilder(column: $table.clockMs, builder: (column) => column);

  GeneratedColumn<String> get rinkZone =>
      $composableBuilder(column: $table.rinkZone, builder: (column) => column);

  GeneratedColumn<String> get targetZone => $composableBuilder(
    column: $table.targetZone,
    builder: (column) => column,
  );

  GeneratedColumn<String> get note =>
      $composableBuilder(column: $table.note, builder: (column) => column);

  GeneratedColumn<String> get clientEventId => $composableBuilder(
    column: $table.clientEventId,
    builder: (column) => column,
  );

  GeneratedColumn<String> get deviceId =>
      $composableBuilder(column: $table.deviceId, builder: (column) => column);

  GeneratedColumn<DateTime> get createdAt =>
      $composableBuilder(column: $table.createdAt, builder: (column) => column);

  GeneratedColumn<DateTime> get updatedAt =>
      $composableBuilder(column: $table.updatedAt, builder: (column) => column);

  GeneratedColumn<int> get version =>
      $composableBuilder(column: $table.version, builder: (column) => column);

  GeneratedColumn<DateTime> get voidedAt =>
      $composableBuilder(column: $table.voidedAt, builder: (column) => column);

  GeneratedColumn<String> get voidReason => $composableBuilder(
    column: $table.voidReason,
    builder: (column) => column,
  );

  $$TournamentSessionsTableAnnotationComposer get sessionId {
    final $$TournamentSessionsTableAnnotationComposer composer =
        $composerBuilder(
          composer: this,
          getCurrentColumn: (t) => t.sessionId,
          referencedTable: $db.tournamentSessions,
          getReferencedColumn: (t) => t.id,
          builder:
              (
                joinBuilder, {
                $addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer,
              }) => $$TournamentSessionsTableAnnotationComposer(
                $db: $db,
                $table: $db.tournamentSessions,
                $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
                joinBuilder: joinBuilder,
                $removeJoinBuilderFromRootComposer:
                    $removeJoinBuilderFromRootComposer,
              ),
        );
    return composer;
  }

  $$PlayersTableAnnotationComposer get goalkeeperId {
    final $$PlayersTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.goalkeeperId,
      referencedTable: $db.players,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$PlayersTableAnnotationComposer(
            $db: $db,
            $table: $db.players,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$GoalkeeperActionsTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $GoalkeeperActionsTable,
          GoalkeeperAction,
          $$GoalkeeperActionsTableFilterComposer,
          $$GoalkeeperActionsTableOrderingComposer,
          $$GoalkeeperActionsTableAnnotationComposer,
          $$GoalkeeperActionsTableCreateCompanionBuilder,
          $$GoalkeeperActionsTableUpdateCompanionBuilder,
          (GoalkeeperAction, $$GoalkeeperActionsTableReferences),
          GoalkeeperAction,
          PrefetchHooks Function({bool sessionId, bool goalkeeperId})
        > {
  $$GoalkeeperActionsTableTableManager(
    _$AppDatabase db,
    $GoalkeeperActionsTable table,
  ) : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$GoalkeeperActionsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$GoalkeeperActionsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$GoalkeeperActionsTableAnnotationComposer(
                $db: db,
                $table: table,
              ),
          updateCompanionCallback:
              ({
                Value<String> id = const Value.absent(),
                Value<String> sessionId = const Value.absent(),
                Value<String> goalkeeperId = const Value.absent(),
                Value<String> actionType = const Value.absent(),
                Value<int> clockMs = const Value.absent(),
                Value<String?> rinkZone = const Value.absent(),
                Value<String?> targetZone = const Value.absent(),
                Value<String?> note = const Value.absent(),
                Value<String> clientEventId = const Value.absent(),
                Value<String> deviceId = const Value.absent(),
                Value<DateTime> createdAt = const Value.absent(),
                Value<DateTime> updatedAt = const Value.absent(),
                Value<int> version = const Value.absent(),
                Value<DateTime?> voidedAt = const Value.absent(),
                Value<String?> voidReason = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => GoalkeeperActionsCompanion(
                id: id,
                sessionId: sessionId,
                goalkeeperId: goalkeeperId,
                actionType: actionType,
                clockMs: clockMs,
                rinkZone: rinkZone,
                targetZone: targetZone,
                note: note,
                clientEventId: clientEventId,
                deviceId: deviceId,
                createdAt: createdAt,
                updatedAt: updatedAt,
                version: version,
                voidedAt: voidedAt,
                voidReason: voidReason,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String id,
                required String sessionId,
                required String goalkeeperId,
                required String actionType,
                required int clockMs,
                Value<String?> rinkZone = const Value.absent(),
                Value<String?> targetZone = const Value.absent(),
                Value<String?> note = const Value.absent(),
                required String clientEventId,
                required String deviceId,
                required DateTime createdAt,
                required DateTime updatedAt,
                Value<int> version = const Value.absent(),
                Value<DateTime?> voidedAt = const Value.absent(),
                Value<String?> voidReason = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => GoalkeeperActionsCompanion.insert(
                id: id,
                sessionId: sessionId,
                goalkeeperId: goalkeeperId,
                actionType: actionType,
                clockMs: clockMs,
                rinkZone: rinkZone,
                targetZone: targetZone,
                note: note,
                clientEventId: clientEventId,
                deviceId: deviceId,
                createdAt: createdAt,
                updatedAt: updatedAt,
                version: version,
                voidedAt: voidedAt,
                voidReason: voidReason,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable(table),
                  $$GoalkeeperActionsTableReferences(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback: ({sessionId = false, goalkeeperId = false}) {
            return PrefetchHooks(
              db: db,
              explicitlyWatchedTables: [],
              addJoins:
                  <
                    T extends TableManagerState<
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic
                    >
                  >(state) {
                    if (sessionId) {
                      state =
                          state.withJoin(
                                currentTable: table,
                                currentColumn: table.sessionId,
                                referencedTable:
                                    $$GoalkeeperActionsTableReferences
                                        ._sessionIdTable(db),
                                referencedColumn:
                                    $$GoalkeeperActionsTableReferences
                                        ._sessionIdTable(db)
                                        .id,
                              )
                              as T;
                    }
                    if (goalkeeperId) {
                      state =
                          state.withJoin(
                                currentTable: table,
                                currentColumn: table.goalkeeperId,
                                referencedTable:
                                    $$GoalkeeperActionsTableReferences
                                        ._goalkeeperIdTable(db),
                                referencedColumn:
                                    $$GoalkeeperActionsTableReferences
                                        ._goalkeeperIdTable(db)
                                        .id,
                              )
                              as T;
                    }

                    return state;
                  },
              getPrefetchedDataCallback: (items) async {
                return [];
              },
            );
          },
        ),
      );
}

typedef $$GoalkeeperActionsTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $GoalkeeperActionsTable,
      GoalkeeperAction,
      $$GoalkeeperActionsTableFilterComposer,
      $$GoalkeeperActionsTableOrderingComposer,
      $$GoalkeeperActionsTableAnnotationComposer,
      $$GoalkeeperActionsTableCreateCompanionBuilder,
      $$GoalkeeperActionsTableUpdateCompanionBuilder,
      (GoalkeeperAction, $$GoalkeeperActionsTableReferences),
      GoalkeeperAction,
      PrefetchHooks Function({bool sessionId, bool goalkeeperId})
    >;
typedef $$SyncQueueTableCreateCompanionBuilder =
    SyncQueueCompanion Function({
      required String id,
      required String entityType,
      required String entityId,
      Value<String> operation,
      required String payloadJson,
      Value<String> state,
      Value<int> attempts,
      Value<DateTime?> nextAttemptAt,
      Value<String?> lastError,
      required DateTime createdAt,
      required DateTime updatedAt,
      Value<int> rowid,
    });
typedef $$SyncQueueTableUpdateCompanionBuilder =
    SyncQueueCompanion Function({
      Value<String> id,
      Value<String> entityType,
      Value<String> entityId,
      Value<String> operation,
      Value<String> payloadJson,
      Value<String> state,
      Value<int> attempts,
      Value<DateTime?> nextAttemptAt,
      Value<String?> lastError,
      Value<DateTime> createdAt,
      Value<DateTime> updatedAt,
      Value<int> rowid,
    });

class $$SyncQueueTableFilterComposer
    extends Composer<_$AppDatabase, $SyncQueueTable> {
  $$SyncQueueTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get entityType => $composableBuilder(
    column: $table.entityType,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get entityId => $composableBuilder(
    column: $table.entityId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get operation => $composableBuilder(
    column: $table.operation,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get payloadJson => $composableBuilder(
    column: $table.payloadJson,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get state => $composableBuilder(
    column: $table.state,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get attempts => $composableBuilder(
    column: $table.attempts,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get nextAttemptAt => $composableBuilder(
    column: $table.nextAttemptAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get lastError => $composableBuilder(
    column: $table.lastError,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get updatedAt => $composableBuilder(
    column: $table.updatedAt,
    builder: (column) => ColumnFilters(column),
  );
}

class $$SyncQueueTableOrderingComposer
    extends Composer<_$AppDatabase, $SyncQueueTable> {
  $$SyncQueueTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get entityType => $composableBuilder(
    column: $table.entityType,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get entityId => $composableBuilder(
    column: $table.entityId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get operation => $composableBuilder(
    column: $table.operation,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get payloadJson => $composableBuilder(
    column: $table.payloadJson,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get state => $composableBuilder(
    column: $table.state,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get attempts => $composableBuilder(
    column: $table.attempts,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get nextAttemptAt => $composableBuilder(
    column: $table.nextAttemptAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get lastError => $composableBuilder(
    column: $table.lastError,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get updatedAt => $composableBuilder(
    column: $table.updatedAt,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$SyncQueueTableAnnotationComposer
    extends Composer<_$AppDatabase, $SyncQueueTable> {
  $$SyncQueueTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get entityType => $composableBuilder(
    column: $table.entityType,
    builder: (column) => column,
  );

  GeneratedColumn<String> get entityId =>
      $composableBuilder(column: $table.entityId, builder: (column) => column);

  GeneratedColumn<String> get operation =>
      $composableBuilder(column: $table.operation, builder: (column) => column);

  GeneratedColumn<String> get payloadJson => $composableBuilder(
    column: $table.payloadJson,
    builder: (column) => column,
  );

  GeneratedColumn<String> get state =>
      $composableBuilder(column: $table.state, builder: (column) => column);

  GeneratedColumn<int> get attempts =>
      $composableBuilder(column: $table.attempts, builder: (column) => column);

  GeneratedColumn<DateTime> get nextAttemptAt => $composableBuilder(
    column: $table.nextAttemptAt,
    builder: (column) => column,
  );

  GeneratedColumn<String> get lastError =>
      $composableBuilder(column: $table.lastError, builder: (column) => column);

  GeneratedColumn<DateTime> get createdAt =>
      $composableBuilder(column: $table.createdAt, builder: (column) => column);

  GeneratedColumn<DateTime> get updatedAt =>
      $composableBuilder(column: $table.updatedAt, builder: (column) => column);
}

class $$SyncQueueTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $SyncQueueTable,
          SyncQueueData,
          $$SyncQueueTableFilterComposer,
          $$SyncQueueTableOrderingComposer,
          $$SyncQueueTableAnnotationComposer,
          $$SyncQueueTableCreateCompanionBuilder,
          $$SyncQueueTableUpdateCompanionBuilder,
          (
            SyncQueueData,
            BaseReferences<_$AppDatabase, $SyncQueueTable, SyncQueueData>,
          ),
          SyncQueueData,
          PrefetchHooks Function()
        > {
  $$SyncQueueTableTableManager(_$AppDatabase db, $SyncQueueTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$SyncQueueTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$SyncQueueTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$SyncQueueTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<String> id = const Value.absent(),
                Value<String> entityType = const Value.absent(),
                Value<String> entityId = const Value.absent(),
                Value<String> operation = const Value.absent(),
                Value<String> payloadJson = const Value.absent(),
                Value<String> state = const Value.absent(),
                Value<int> attempts = const Value.absent(),
                Value<DateTime?> nextAttemptAt = const Value.absent(),
                Value<String?> lastError = const Value.absent(),
                Value<DateTime> createdAt = const Value.absent(),
                Value<DateTime> updatedAt = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => SyncQueueCompanion(
                id: id,
                entityType: entityType,
                entityId: entityId,
                operation: operation,
                payloadJson: payloadJson,
                state: state,
                attempts: attempts,
                nextAttemptAt: nextAttemptAt,
                lastError: lastError,
                createdAt: createdAt,
                updatedAt: updatedAt,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String id,
                required String entityType,
                required String entityId,
                Value<String> operation = const Value.absent(),
                required String payloadJson,
                Value<String> state = const Value.absent(),
                Value<int> attempts = const Value.absent(),
                Value<DateTime?> nextAttemptAt = const Value.absent(),
                Value<String?> lastError = const Value.absent(),
                required DateTime createdAt,
                required DateTime updatedAt,
                Value<int> rowid = const Value.absent(),
              }) => SyncQueueCompanion.insert(
                id: id,
                entityType: entityType,
                entityId: entityId,
                operation: operation,
                payloadJson: payloadJson,
                state: state,
                attempts: attempts,
                nextAttemptAt: nextAttemptAt,
                lastError: lastError,
                createdAt: createdAt,
                updatedAt: updatedAt,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$SyncQueueTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $SyncQueueTable,
      SyncQueueData,
      $$SyncQueueTableFilterComposer,
      $$SyncQueueTableOrderingComposer,
      $$SyncQueueTableAnnotationComposer,
      $$SyncQueueTableCreateCompanionBuilder,
      $$SyncQueueTableUpdateCompanionBuilder,
      (
        SyncQueueData,
        BaseReferences<_$AppDatabase, $SyncQueueTable, SyncQueueData>,
      ),
      SyncQueueData,
      PrefetchHooks Function()
    >;

class $AppDatabaseManager {
  final _$AppDatabase _db;
  $AppDatabaseManager(this._db);
  $$CoachesTableTableManager get coaches =>
      $$CoachesTableTableManager(_db, _db.coaches);
  $$TeamsTableTableManager get teams =>
      $$TeamsTableTableManager(_db, _db.teams);
  $$PlayersTableTableManager get players =>
      $$PlayersTableTableManager(_db, _db.players);
  $$TournamentSessionsTableTableManager get tournamentSessions =>
      $$TournamentSessionsTableTableManager(_db, _db.tournamentSessions);
  $$SessionPlayersTableTableManager get sessionPlayers =>
      $$SessionPlayersTableTableManager(_db, _db.sessionPlayers);
  $$MatchActionsTableTableManager get matchActions =>
      $$MatchActionsTableTableManager(_db, _db.matchActions);
  $$ShootDetailsTableTableManager get shootDetails =>
      $$ShootDetailsTableTableManager(_db, _db.shootDetails);
  $$GoalkeeperActionsTableTableManager get goalkeeperActions =>
      $$GoalkeeperActionsTableTableManager(_db, _db.goalkeeperActions);
  $$SyncQueueTableTableManager get syncQueue =>
      $$SyncQueueTableTableManager(_db, _db.syncQueue);
}
