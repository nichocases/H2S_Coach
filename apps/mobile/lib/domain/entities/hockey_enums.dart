enum PlayerRole {
  skater('SKATER'),
  goalkeeper('GOALKEEPER')
  ;

  const PlayerRole(this.storageValue);

  final String storageValue;

  static PlayerRole fromStorage(String value) {
    return PlayerRole.values.singleWhere((role) => role.storageValue == value);
  }
}

enum SessionStatus {
  draft('DRAFT'),
  inProgress('IN_PROGRESS'),
  paused('PAUSED'),
  finished('FINISHED')
  ;

  const SessionStatus(this.storageValue);

  final String storageValue;

  static SessionStatus fromStorage(String value) {
    return SessionStatus.values.singleWhere(
      (status) => status.storageValue == value,
    );
  }
}

enum PlayerActionType {
  pass('PASS'),
  failPass('FAIL_PASS'),
  assist('ASSIST'),
  shoot('SHOOT')
  ;

  const PlayerActionType(this.storageValue);

  final String storageValue;

  static PlayerActionType fromStorage(String value) {
    return PlayerActionType.values.singleWhere(
      (action) => action.storageValue == value,
    );
  }
}

enum ShotResult {
  goal('GOAL'),
  missed('MISSED'),
  hitKeeper('HIT_KEEPER'),
  blocked('BLOCKED')
  ;

  const ShotResult(this.storageValue);

  final String storageValue;

  static ShotResult fromStorage(String value) {
    return ShotResult.values.singleWhere(
      (result) => result.storageValue == value,
    );
  }
}

enum GoalTargetZone {
  topLeft('TOP_LEFT'),
  topMiddle('TOP_MIDDLE'),
  topRight('TOP_RIGHT'),
  bottomLeft('BOTTOM_LEFT'),
  bottomMiddle('BOTTOM_MIDDLE'),
  bottomRight('BOTTOM_RIGHT')
  ;

  const GoalTargetZone(this.storageValue);

  final String storageValue;

  static GoalTargetZone fromStorage(String value) {
    return GoalTargetZone.values.singleWhere(
      (zone) => zone.storageValue == value,
    );
  }
}

enum KeeperSide {
  glove('GLOVE'),
  pad('PAD'),
  unknown('UNKNOWN')
  ;

  const KeeperSide(this.storageValue);

  final String storageValue;

  static KeeperSide fromStorage(String value) {
    return KeeperSide.values.singleWhere((side) => side.storageValue == value);
  }
}

enum GoalkeeperActionResult {
  save('SAVE'),
  goalAllowed('GOAL_ALLOWED')
  ;

  const GoalkeeperActionResult(this.storageValue);

  final String storageValue;

  static GoalkeeperActionResult fromStorage(String value) {
    return GoalkeeperActionResult.values.singleWhere(
      (result) => result.storageValue == value,
    );
  }
}

enum ShotOriginZone {
  zone1('ZONE_1'),
  zone2('ZONE_2'),
  zone3('ZONE_3'),
  zone4('ZONE_4')
  ;

  const ShotOriginZone(this.storageValue);

  final String storageValue;

  static ShotOriginZone fromStorage(String value) {
    return ShotOriginZone.values.singleWhere(
      (zone) => zone.storageValue == value,
    );
  }
}

enum SyncEntityType {
  coach('coach'),
  team('team'),
  player('player'),
  tournamentSession('tournament_session'),
  sessionPlayer('session_player'),
  matchAction('match_action'),
  goalkeeperAction('goalkeeper_action')
  ;

  const SyncEntityType(this.storageValue);

  final String storageValue;
}

enum SyncOperation {
  upsert('UPSERT')
  ;

  const SyncOperation(this.storageValue);

  final String storageValue;
}

enum SyncState {
  pending('PENDING'),
  syncing('SYNCING'),
  synced('SYNCED'),
  failed('FAILED')
  ;

  const SyncState(this.storageValue);

  final String storageValue;
}
