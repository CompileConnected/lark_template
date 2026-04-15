{{#ui_toolkit_material}}import 'package:flutter/material.dart';{{/ui_toolkit_material}}
{{#ui_toolkit_shadcn}}import 'package:shadcn_flutter/shadcn_flutter.dart';{{/ui_toolkit_shadcn}}
{{#state_management_riverpod}}import 'package:flutter_riverpod/flutter_riverpod.dart';{{/state_management_riverpod}}
{{#state_management_provider}}import 'package:provider/provider.dart';{{/state_management_provider}}
{{#state_management_bloc}}import 'package:flutter_bloc/flutter_bloc.dart';{{/state_management_bloc}}
{{#state_management_getx}}import 'package:get/get.dart';{{/state_management_getx}}
{{#state_management_mobx}}import 'package:flutter_mobx/flutter_mobx.dart';{{/state_management_mobx}}
{{#state_management_signals}}import 'package:signals_flutter/signals_flutter.dart';{{/state_management_signals}}
{{#di_get_it}}import '../../../../core/di/injection.dart';{{/di_get_it}}
{{#di_injectable}}import '../../../../core/di/injection.dart';{{/di_injectable}}

import '../../domain/entities/note.dart';
import '../../domain/repositories/note_repository.dart';
import '../../domain/repositories/note_repository_impl.dart';
import '../../data/datasources/note_local_source.dart';
import '../../data/datasources/note_remote_source.dart';
import '../widgets/note_card.dart';
{{#state_management_none}}import 'notes_notifier.dart';{{/state_management_none}}
{{#state_management_provider}}import '../notifiers/notes_notifier.dart';{{/state_management_provider}}
{{#state_management_riverpod}}import '../providers/notes_provider.dart';{{/state_management_riverpod}}
{{#state_management_bloc}}import '../bloc/notes_bloc.dart';{{/state_management_bloc}}
{{#state_management_getx}}import '../controllers/notes_controller.dart';{{/state_management_getx}}
{{#state_management_mobx}}import '../stores/notes_store.dart';{{/state_management_mobx}}
{{#state_management_signals}}import '../signals/notes_signal.dart';{{/state_management_signals}}
import 'note_detail_page.dart';

{{#state_management_riverpod}}
class NotesPage extends ConsumerWidget {
  const NotesPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final notesAsync = ref.watch(notesProvider);

    return {{#ui_toolkit_material}}Scaffold(
      appBar: AppBar(title: const Text('Notes')),
      floatingActionButton: FloatingActionButton(
        onPressed: () => _navigateToDetail(context),
        child: const Icon(Icons.add),
      ),
      body: notesAsync.when(
        data: (notes) => notes.isEmpty
            ? const Center(child: Text('No notes yet'))
            : ListView.builder(
                itemCount: notes.length,
                itemBuilder: (context, index) => NoteCard(
                  note: notes[index],
                  onTap: () => _navigateToDetail(context, note: notes[index]),
                ),
              ),
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (error, _) => Center(child: Text('Error: $error')),
      ),
    );{{/ui_toolkit_material}}{{#ui_toolkit_shadcn}}Scaffold(
      appBar: AppBar(title: const Text('Notes')),
      floatingActionButton: FloatingActionButton(
        onPressed: () => _navigateToDetail(context),
        child: const Icon(Icons.add),
      ),
      body: notesAsync.when(
        data: (notes) => notes.isEmpty
            ? const Center(child: Text('No notes yet'))
            : ListView.builder(
                itemCount: notes.length,
                itemBuilder: (context, index) => NoteCard(
                  note: notes[index],
                  onTap: () => _navigateToDetail(context, note: notes[index]),
                ),
              ),
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (error, _) => Center(child: Text('Error: $error')),
      ),
    );{{/ui_toolkit_shadcn}}
  }

  void _navigateToDetail(BuildContext context, {Note? note}) {
    context.push('/detail${note != null ? '/${note.id}' : ''}');
  }
}
{{/state_management_riverpod}}

{{#state_management_bloc}}
class NotesPage extends StatelessWidget {
  const NotesPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => NotesBloc({{#di_get_it}}repository: getIt<NoteRepository>(){{/di_get_it}}{{#di_injectable}}repository: getIt<NoteRepository>(){{/di_injectable}}{{^di_get_it}}{{^di_injectable}}repository: NoteRepositoryImpl(
        remoteSource: NoteRemoteSourceImpl(),
        localSource: NoteLocalSourceImpl(),
      ){{/di_injectable}}{{/di_get_it}})..add(LoadNotes()),
      child: {{#ui_toolkit_material}}Scaffold(
        appBar: AppBar(title: const Text('Notes')),
        floatingActionButton: FloatingActionButton(
          onPressed: () => _navigateToDetail(context),
          child: const Icon(Icons.add),
        ),
        body: BlocBuilder<NotesBloc, NotesState>(
          builder: (context, state) {
            if (state.isLoading) {
              return const Center(child: CircularProgressIndicator());
            }
            if (state.error != null) {
              return Center(child: Text('Error: ${state.error}'));
            }
            final notes = state.notes;
            if (notes.isEmpty) {
              return const Center(child: Text('No notes yet'));
            }
            return ListView.builder(
              itemCount: notes.length,
              itemBuilder: (context, index) => NoteCard(
                note: notes[index],
                onTap: () => _navigateToDetail(context, note: notes[index]),
              ),
            );
          },
        ),
      ){{/ui_toolkit_material}}{{#ui_toolkit_shadcn}}Scaffold(
        appBar: AppBar(title: const Text('Notes')),
        floatingActionButton: FloatingActionButton(
          onPressed: () => _navigateToDetail(context),
          child: const Icon(Icons.add),
        ),
        body: BlocBuilder<NotesBloc, NotesState>(
          builder: (context, state) {
            if (state.isLoading) {
              return const Center(child: CircularProgressIndicator());
            }
            if (state.error != null) {
              return Center(child: Text('Error: ${state.error}'));
            }
            final notes = state.notes;
            if (notes.isEmpty) {
              return const Center(child: Text('No notes yet'));
            }
            return ListView.builder(
              itemCount: notes.length,
              itemBuilder: (context, index) => NoteCard(
                note: notes[index],
                onTap: () => _navigateToDetail(context, note: notes[index]),
              ),
            );
          },
        ),
      ){{/ui_toolkit_shadcn}},
    );
  }

  void _navigateToDetail(BuildContext context, {Note? note}) {
    context.push('/detail${note != null ? '/${note.id}' : ''}');
  }
}
{{/state_management_bloc}}

{{#state_management_provider}}
class NotesPage extends StatelessWidget {
  const NotesPage({super.key});

  @override
  Widget build(BuildContext context) {
    return {{#ui_toolkit_material}}Scaffold(
      appBar: AppBar(title: const Text('Notes')),
      floatingActionButton: FloatingActionButton(
        onPressed: () => _navigateToDetail(context),
        child: const Icon(Icons.add),
      ),
      body: Consumer<NotesNotifier>(
        builder: (context, notifier, _) {
          if (notifier.isLoading) {
            return const Center(child: CircularProgressIndicator());
          }
          if (notifier.error != null) {
            return Center(child: Text('Error: ${notifier.error}'));
          }
          final notes = notifier.notes;
          if (notes.isEmpty) {
            return const Center(child: Text('No notes yet'));
          }
          return ListView.builder(
            itemCount: notes.length,
            itemBuilder: (context, index) => NoteCard(
              note: notes[index],
              onTap: () => _navigateToDetail(context, note: notes[index]),
            ),
          );
        },
      ),
    );{{/ui_toolkit_material}}{{#ui_toolkit_shadcn}}Scaffold(
      appBar: AppBar(title: const Text('Notes')),
      floatingActionButton: FloatingActionButton(
        onPressed: () => _navigateToDetail(context),
        child: const Icon(Icons.add),
      ),
      body: Consumer<NotesNotifier>(
        builder: (context, notifier, _) {
          if (notifier.isLoading) {
            return const Center(child: CircularProgressIndicator());
          }
          if (notifier.error != null) {
            return Center(child: Text('Error: ${notifier.error}'));
          }
          final notes = notifier.notes;
          if (notes.isEmpty) {
            return const Center(child: Text('No notes yet'));
          }
          return ListView.builder(
            itemCount: notes.length,
            itemBuilder: (context, index) => NoteCard(
              note: notes[index],
              onTap: () => _navigateToDetail(context, note: notes[index]),
            ),
          );
        },
      ),
    );{{/ui_toolkit_shadcn}}
  }

  void _navigateToDetail(BuildContext context, {Note? note}) {
    context.push('/detail${note != null ? '/${note.id}' : ''}');
  }
}
{{/state_management_provider}}

{{#state_management_getx}}
class NotesPage extends StatelessWidget {
  const NotesPage({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(NotesController());

    return {{#ui_toolkit_material}}Scaffold(
      appBar: AppBar(title: const Text('Notes')),
      floatingActionButton: FloatingActionButton(
        onPressed: () => Get.to(() => const NoteDetailPage()),
        child: const Icon(Icons.add),
      ),
      body: Obx(() {
        if (controller.isLoading.value) {
          return const Center(child: CircularProgressIndicator());
        }
        if (controller.error.value.isNotEmpty) {
          return Center(child: Text('Error: ${controller.error.value}'));
        }
        final notes = controller.notes;
        if (notes.isEmpty) {
          return const Center(child: Text('No notes yet'));
        }
        return ListView.builder(
          itemCount: notes.length,
          itemBuilder: (context, index) => NoteCard(
            note: notes[index],
            onTap: () => Get.to(() => NoteDetailPage(note: notes[index])),
          ),
        );
      }),
    );{{/ui_toolkit_material}}{{#ui_toolkit_shadcn}}Scaffold(
      appBar: AppBar(title: const Text('Notes')),
      floatingActionButton: FloatingActionButton(
        onPressed: () => Get.to(() => const NoteDetailPage()),
        child: const Icon(Icons.add),
      ),
      body: Obx(() {
        if (controller.isLoading.value) {
          return const Center(child: CircularProgressIndicator());
        }
        if (controller.error.value.isNotEmpty) {
          return Center(child: Text('Error: ${controller.error.value}'));
        }
        final notes = controller.notes;
        if (notes.isEmpty) {
          return const Center(child: Text('No notes yet'));
        }
        return ListView.builder(
          itemCount: notes.length,
          itemBuilder: (context, index) => NoteCard(
            note: notes[index],
            onTap: () => Get.to(() => NoteDetailPage(note: notes[index])),
          ),
        );
      }),
    );{{/ui_toolkit_shadcn}}
  }
}
{{/state_management_getx}}

{{#state_management_mobx}}
class NotesPage extends StatefulWidget {
  const NotesPage({super.key});

  @override
  State<NotesPage> createState() => _NotesPageState();
}

class _NotesPageState extends State<NotesPage> {
  final _store = NotesStore();

  @override
  void initState() {
    super.initState();
    _store.loadNotes();
  }

  @override
  Widget build(BuildContext context) {
    return {{#ui_toolkit_material}}Scaffold(
      appBar: AppBar(title: const Text('Notes')),
      floatingActionButton: FloatingActionButton(
        onPressed: () => _navigateToDetail(context),
        child: const Icon(Icons.add),
      ),
      body: Observer(builder: (_) {
        if (_store.isLoading) {
          return const Center(child: CircularProgressIndicator());
        }
        if (_store.error != null) {
          return Center(child: Text('Error: ${_store.error}'));
        }
        final notes = _store.notes;
        if (notes.isEmpty) {
          return const Center(child: Text('No notes yet'));
        }
        return ListView.builder(
          itemCount: notes.length,
          itemBuilder: (context, index) => NoteCard(
            note: notes[index],
            onTap: () => _navigateToDetail(context, note: notes[index]),
          ),
        );
      }),
    );{{/ui_toolkit_material}}{{#ui_toolkit_shadcn}}Scaffold(
      appBar: AppBar(title: const Text('Notes')),
      floatingActionButton: FloatingActionButton(
        onPressed: () => _navigateToDetail(context),
        child: const Icon(Icons.add),
      ),
      body: Observer(builder: (_) {
        if (_store.isLoading) {
          return const Center(child: CircularProgressIndicator());
        }
        if (_store.error != null) {
          return Center(child: Text('Error: ${_store.error}'));
        }
        final notes = _store.notes;
        if (notes.isEmpty) {
          return const Center(child: Text('No notes yet'));
        }
        return ListView.builder(
          itemCount: notes.length,
          itemBuilder: (context, index) => NoteCard(
            note: notes[index],
            onTap: () => _navigateToDetail(context, note: notes[index]),
          ),
        );
      }),
    );{{/ui_toolkit_shadcn}}
  }

  void _navigateToDetail(BuildContext context, {Note? note}) {
    context.push('/detail${note != null ? '/${note.id}' : ''}');
  }
}
{{/state_management_mobx}}

{{#state_management_signals}}
class NotesPage extends StatelessWidget {
  const NotesPage({super.key});

  @override
  Widget build(BuildContext context) {
    return {{#ui_toolkit_material}}Scaffold(
      appBar: AppBar(title: const Text('Notes')),
      floatingActionButton: FloatingActionButton(
        onPressed: () => _navigateToDetail(context),
        child: const Icon(Icons.add),
      ),
      body: Watch((context) {
        if (notesLoading.value) {
          return const Center(child: CircularProgressIndicator());
        }
        if (notesError.value != null) {
          return Center(child: Text('Error: ${notesError.value}'));
        }
        final notes = notesList.value;
        if (notes.isEmpty) {
          return const Center(child: Text('No notes yet'));
        }
        return ListView.builder(
          itemCount: notes.length,
          itemBuilder: (context, index) => NoteCard(
            note: notes[index],
            onTap: () => _navigateToDetail(context, note: notes[index]),
          ),
        );
      }),
    );{{/ui_toolkit_material}}{{#ui_toolkit_shadcn}}Scaffold(
      appBar: AppBar(title: const Text('Notes')),
      floatingActionButton: FloatingActionButton(
        onPressed: () => _navigateToDetail(context),
        child: const Icon(Icons.add),
      ),
      body: Watch((context) {
        if (notesLoading.value) {
          return const Center(child: CircularProgressIndicator());
        }
        if (notesError.value != null) {
          return Center(child: Text('Error: ${notesError.value}'));
        }
        final notes = notesList.value;
        if (notes.isEmpty) {
          return const Center(child: Text('No notes yet'));
        }
        return ListView.builder(
          itemCount: notes.length,
          itemBuilder: (context, index) => NoteCard(
            note: notes[index],
            onTap: () => _navigateToDetail(context, note: notes[index]),
          ),
        );
      }),
    );{{/ui_toolkit_shadcn}}
  }

  void _navigateToDetail(BuildContext context, {Note? note}) {
    context.push('/detail${note != null ? '/${note.id}' : ''}');
  }
}
{{/state_management_signals}}

{{#state_management_none}}
class NotesPage extends StatefulWidget {
  const NotesPage({super.key});

  @override
  State<NotesPage> createState() => _NotesPageState();
}

class _NotesPageState extends State<NotesPage> {
  final _notifier = NotesNotifier();
  final _repository = NoteRepositoryImpl(
    remoteSource: NoteRemoteSourceImpl(),
    localSource: NoteLocalSourceImpl(),
  );

  @override
  void initState() {
    super.initState();
    _loadNotes();
  }

  Future<void> _loadNotes() async {
    setState(() => _notifier.isLoading = true);
    try {
      final notes = await _repository.getNotes();
      setState(() {
        _notifier.notes = notes;
        _notifier.isLoading = false;
      });
    } catch (e) {
      setState(() {
        _notifier.error = e.toString();
        _notifier.isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return {{#ui_toolkit_material}}Scaffold(
      appBar: AppBar(title: const Text('Notes')),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          await Navigator.of(context).push(
            MaterialPageRoute(builder: (_) => const NoteDetailPage()),
          );
          _loadNotes();
        },
        child: const Icon(Icons.add),
      ),
      body: _notifier.isLoading
          ? const Center(child: CircularProgressIndicator())
          : _notifier.error != null
              ? Center(child: Text('Error: ${_notifier.error}'))
              : _notifier.notes.isEmpty
                  ? const Center(child: Text('No notes yet'))
                  : RefreshIndicator(
                      onRefresh: _loadNotes,
                      child: ListView.builder(
                        itemCount: _notifier.notes.length,
                        itemBuilder: (context, index) => NoteCard(
                          note: _notifier.notes[index],
                          onTap: () async {
                            await Navigator.of(context).push(
                              MaterialPageRoute(
                                builder: (_) => NoteDetailPage(note: _notifier.notes[index]),
                              ),
                            );
                            _loadNotes();
                          },
                        ),
                      ),
                    ),
    );{{/ui_toolkit_material}}{{#ui_toolkit_shadcn}}Scaffold(
      appBar: AppBar(title: const Text('Notes')),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          await Navigator.of(context).push(
            MaterialPageRoute(builder: (_) => const NoteDetailPage()),
          );
          _loadNotes();
        },
        child: const Icon(Icons.add),
      ),
      body: _notifier.isLoading
          ? const Center(child: CircularProgressIndicator())
          : _notifier.error != null
              ? Center(child: Text('Error: ${_notifier.error}'))
              : _notifier.notes.isEmpty
                  ? const Center(child: Text('No notes yet'))
                  : ListView.builder(
                      itemCount: _notifier.notes.length,
                      itemBuilder: (context, index) => NoteCard(
                        note: _notifier.notes[index],
                        onTap: () async {
                          await Navigator.of(context).push(
                            MaterialPageRoute(
                              builder: (_) => NoteDetailPage(note: _notifier.notes[index]),
                            ),
                          );
                          _loadNotes();
                        },
                      ),
                    ),
    );{{/ui_toolkit_shadcn}}
  }
}
{{/state_management_none}}


