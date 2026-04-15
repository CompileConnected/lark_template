import 'package:go_router/go_router.dart';

import '../../features/notes/presentation/pages/notes_page.dart';
{{#db_debugger_drift_db_viewer}}import '../../features/notes/presentation/pages/db_viewer_page.dart';{{/db_debugger_drift_db_viewer}}

final appRouter = GoRouter(
  routes: [
    GoRoute(
      path: '/',
      builder: (context, state) => const NotesPage(),
    ),
    {{#db_debugger_drift_db_viewer}}GoRoute(
      path: '/db-viewer',
      builder: (context, state) => const DbViewerPage(),
    ),{{/db_debugger_drift_db_viewer}}
  ],
);
