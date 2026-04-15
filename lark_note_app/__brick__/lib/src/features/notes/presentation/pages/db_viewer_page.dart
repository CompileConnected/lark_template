{{#db_debugger_drift_db_viewer}}{{#ui_toolkit_material}}import 'package:flutter/material.dart';{{/ui_toolkit_material}}
{{#ui_toolkit_shadcn}}import 'package:shadcn_flutter/shadcn_flutter.dart';{{/ui_toolkit_shadcn}}
import 'package:drift_db_viewer/drift_db_viewer.dart';
{{#di_get_it}}import '../../../../core/di/injection.dart';{{/di_get_it}}
import '../../../../core/storage/local_storage_service.dart';

class DbViewerPage extends StatelessWidget {
  const DbViewerPage({super.key});

  @override
  Widget build(BuildContext context) {
    {{#di_get_it}}final db = getIt<LocalStorageService>();{{/di_get_it}}
    {{^di_get_it}}final db = LocalStorageService();{{/di_get_it}}
    return Scaffold(
      appBar: AppBar(title: const Text('Database Viewer')),
      body: DriftDbViewer(db: db),
    );
  }
}
{{/db_debugger_drift_db_viewer}}
