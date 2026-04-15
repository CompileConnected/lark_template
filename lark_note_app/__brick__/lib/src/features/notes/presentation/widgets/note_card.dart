{{#ui_toolkit_material}}import 'package:flutter/material.dart';{{/ui_toolkit_material}}
{{#ui_toolkit_shadcn}}import 'package:shadcn_flutter/shadcn_flutter.dart';{{/ui_toolkit_shadcn}}

import '../../domain/entities/note.dart';

class NoteCard extends StatelessWidget {
  final Note note;
  final VoidCallback onTap;

  const NoteCard({super.key, required this.note, required this.onTap});

  @override
  Widget build(BuildContext context) {
    {{#ui_toolkit_material}}return Card(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
      child: ListTile(
        title: Text(note.title, maxLines: 1, overflow: TextOverflow.ellipsis),
        subtitle: Text(note.content, maxLines: 2, overflow: TextOverflow.ellipsis),
        trailing: Text(
          '${note.updatedAt.day}/${note.updatedAt.month}/${note.updatedAt.year}',
          style: Theme.of(context).textTheme.bodySmall,
        ),
        onTap: onTap,
      ),
    );{{/ui_toolkit_material}}
    {{#ui_toolkit_shadcn}}return Card(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
      child: ListTile(
        title: Text(note.title, maxLines: 1, overflow: TextOverflow.ellipsis),
        subtitle: Text(note.content, maxLines: 2, overflow: TextOverflow.ellipsis),
        trailing: Text(
          '${note.updatedAt.day}/${note.updatedAt.month}/${note.updatedAt.year}',
          style: Theme.of(context).textTheme.bodySmall,
        ),
        onTap: onTap,
      ),
    );{{/ui_toolkit_shadcn}}
  }
}
