{{#ui_toolkit_material}}import 'package:flutter/material.dart';{{/ui_toolkit_material}}
{{#ui_toolkit_shadcn}}import 'package:shadcn_flutter/shadcn_flutter.dart';{{/ui_toolkit_shadcn}}
{{#state_management_riverpod}}import 'package:flutter_riverpod/flutter_riverpod.dart';{{/state_management_riverpod}}
{{#state_management_bloc}}import 'package:flutter_bloc/flutter_bloc.dart';{{/state_management_bloc}}
{{#state_management_getx}}import 'package:get/get.dart';{{/state_management_getx}}
{{#di_get_it}}import '../../../../core/di/injection.dart';{{/di_get_it}}
{{#di_injectable}}import '../../../../core/di/injection.dart';{{/di_injectable}}

import '../../domain/entities/note.dart';
import '../../domain/repositories/note_repository.dart';
import '../../domain/repositories/note_repository_impl.dart';
import '../../data/datasources/note_local_source.dart';
import '../../data/datasources/note_remote_source.dart';
{{#state_management_riverpod}}import '../providers/notes_provider.dart';{{/state_management_riverpod}}
{{#state_management_bloc}}import '../bloc/notes_bloc.dart';{{/state_management_bloc}}

class NoteDetailPage extends StatefulWidget {
  final Note? note;

  const NoteDetailPage({super.key, this.note});

  @override
  State<NoteDetailPage> createState() => _NoteDetailPageState();
}

class _NoteDetailPageState extends State<NoteDetailPage> {
  late final TextEditingController _titleController;
  late final TextEditingController _contentController;

  @override
  void initState() {
    super.initState();
    _titleController = TextEditingController(text: widget.note?.title ?? '');
    _contentController = TextEditingController(text: widget.note?.content ?? '');
  }

  @override
  void dispose() {
    _titleController.dispose();
    _contentController.dispose();
    super.dispose();
  }

  {{#state_management_riverpod}}
  void _save(WidgetRef ref) async {
    final repository = ref.read(noteRepositoryProvider);
    final note = widget.note?.copyWith(
      title: _titleController.text,
      content: _contentController.text,
      updatedAt: DateTime.now(),
    ) ?? Note(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      title: _titleController.text,
      content: _contentController.text,
      createdAt: DateTime.now(),
      updatedAt: DateTime.now(),
    );

    if (widget.note != null) {
      await repository.updateNote(note);
    } else {
      await repository.createNote(note);
    }
    if (mounted) {
      ref.invalidate(notesProvider);
      context.pop();
    }
  }
  {{/state_management_riverpod}}

  {{^state_management_riverpod}}
  Future<void> _save() async {
    {{#di_get_it}}final repository = getIt<NoteRepository>();{{/di_get_it}}
    {{#di_injectable}}final repository = getIt<NoteRepository>();{{/di_injectable}}
    {{^di_get_it}}{{^di_injectable}}final repository = NoteRepositoryImpl(
      remoteSource: NoteRemoteSourceImpl(),
      localSource: NoteLocalSourceImpl(),
    );{{/di_injectable}}{{/di_get_it}}

    final note = widget.note?.copyWith(
      title: _titleController.text,
      content: _contentController.text,
      updatedAt: DateTime.now(),
    ) ?? Note(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      title: _titleController.text,
      content: _contentController.text,
      createdAt: DateTime.now(),
      updatedAt: DateTime.now(),
    );

    if (widget.note != null) {
      await repository.updateNote(note);
    } else {
      await repository.createNote(note);
    }
    if (mounted) {
      {{#state_management_getx}}Get.back();{{/state_management_getx}}
      {{^state_management_getx}}Navigator.of(context).pop();{{/state_management_getx}}
    }
  }
  {{/state_management_riverpod}}

  {{#state_management_bloc}}
  void _saveWithBloc() {
    final bloc = context.read<NotesBloc>();
    final note = widget.note?.copyWith(
      title: _titleController.text,
      content: _contentController.text,
      updatedAt: DateTime.now(),
    ) ?? Note(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      title: _titleController.text,
      content: _contentController.text,
      createdAt: DateTime.now(),
      updatedAt: DateTime.now(),
    );

    if (widget.note != null) {
      bloc.add(UpdateNote(note));
    } else {
      bloc.add(CreateNote(note));
    }
    Navigator.of(context).pop();
  }
  {{/state_management_bloc}}

  @override
  Widget build(BuildContext context) {
    {{#state_management_riverpod}}
    return Consumer(builder: (context, ref, _) {
      return _buildScaffold(() => _save(ref));
    });
    {{/state_management_riverpod}}
    {{^state_management_riverpod}}
    {{#state_management_bloc}}
    return _buildScaffold(_saveWithBloc);
    {{/state_management_bloc}}
    {{^state_management_bloc}}
    return _buildScaffold(_save);
    {{/state_management_bloc}}
    {{/state_management_riverpod}}
  }

  Widget _buildScaffold(VoidCallback onSave) {
    return {{#ui_toolkit_material}}Scaffold(
      appBar: AppBar(
        title: Text(widget.note != null ? 'Edit Note' : 'New Note'),
        actions: [
          IconButton(
            icon: const Icon(Icons.save),
            onPressed: onSave,
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            TextField(
              controller: _titleController,
              decoration: const InputDecoration(
                labelText: 'Title',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 16),
            Expanded(
              child: TextField(
                controller: _contentController,
                decoration: const InputDecoration(
                  labelText: 'Content',
                  border: OutlineInputBorder(),
                  alignLabelWithHint: true,
                ),
                maxLines: null,
                expands: true,
              ),
            ),
          ],
        ),
      ),
    );{{/ui_toolkit_material}}{{#ui_toolkit_shadcn}}Scaffold(
      appBar: AppBar(
        title: Text(widget.note != null ? 'Edit Note' : 'New Note'),
        actions: [
          IconButton(
            icon: const Icon(Icons.save),
            onPressed: onSave,
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            TextField(
              controller: _titleController,
              decoration: const InputDecoration(
                labelText: 'Title',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 16),
            Expanded(
              child: TextField(
                controller: _contentController,
                decoration: const InputDecoration(
                  labelText: 'Content',
                  border: OutlineInputBorder(),
                  alignLabelWithHint: true,
                ),
                maxLines: null,
                expands: true,
              ),
            ),
          ],
        ),
      ),
    );{{/ui_toolkit_shadcn}}
  }
}
