import 'dart:async';

import 'package:flutter/widgets.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:inline_hockey_coach/features/sync/application/sync_providers.dart';

class SyncBootstrap extends ConsumerStatefulWidget {
  const SyncBootstrap({required this.child, super.key});

  final Widget child;

  @override
  ConsumerState<SyncBootstrap> createState() => _SyncBootstrapState();
}

class _SyncBootstrapState extends ConsumerState<SyncBootstrap> {
  @override
  void initState() {
    super.initState();
    unawaited(
      Future<void>.microtask(() => ref.read(syncControllerProvider).start()),
    );
  }

  @override
  Widget build(BuildContext context) => widget.child;
}
