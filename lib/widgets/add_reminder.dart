import 'package:flutter/material.dart';

class AddNotification extends StatelessWidget {
  const AddNotification({super.key});

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      content: Form(
        key: GlobalKey<FormState>(),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            Row(
              children: [
                const Text(
                  'Reminder',
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const Spacer(),
                IconButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                  icon: const Icon(Icons.close),
                ),
              ],
            ),
            TextFormField(
              key: const ValueKey('title'),
              validator: (value) {
                if (value!.isEmpty) {
                  return 'Please enter a title';
                }
                return null;
              },
              textCapitalization: TextCapitalization.sentences,
              onChanged: (value) => {
                // print(value),
              },
              decoration: const InputDecoration(labelText: 'Title'),
            ),
            const SizedBox(height: 10),
            TextFormField(
              key: const ValueKey('description'),
              textCapitalization: TextCapitalization.sentences,
              minLines: 1,
              maxLines: 5,
              onChanged: (value) => {
                // print(value),
              },
              decoration: const InputDecoration(labelText: 'Description'),
            ),
            const SizedBox(height: 10),
            TextFormField(
              key: const ValueKey('date'),
              textCapitalization: TextCapitalization.sentences,
              onChanged: (value) => {
                // print(value),
              },
              decoration: const InputDecoration(labelText: 'Date'),
            ),
            const SizedBox(height: 10),
            TextFormField(
              key: const ValueKey('time'),
              textCapitalization: TextCapitalization.sentences,
              onChanged: (value) => {
                // print(value),
              },
              decoration: const InputDecoration(labelText: 'Time'),
            ),
            const SizedBox(height: 10),
            TextFormField(
              key: const ValueKey('repeat'),
              textCapitalization: TextCapitalization.sentences,
              onChanged: (value) => {
                // print(value),
              },
              decoration: const InputDecoration(labelText: 'Repeat'),
            ),
            const SizedBox(height: 10),
            TextFormField(
              key: const ValueKey('category'),
              textCapitalization: TextCapitalization.sentences,
              onChanged: (value) => {
                // print(value),
              },
              decoration: const InputDecoration(labelText: 'Category'),
            ),
            const SizedBox(height: 10),
            TextFormField(
              key: const ValueKey('priority'),
              textCapitalization: TextCapitalization.sentences,
              onChanged: (value) => {
                // print(value),
              },
              decoration: const InputDecoration(labelText: 'Priority'),
            ),
            const SizedBox(height: 10),
            TextFormField(
              key: const ValueKey('notes'),
              textCapitalization: TextCapitalization.sentences,
              minLines: 1,
              maxLines: 5,
              onChanged: (value) => {
                // print(value),
              },
              decoration: const InputDecoration(labelText: 'Notes'),
            ),
            const SizedBox(height: 10),
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                ElevatedButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                  child: const Text('Cancel'),
                ),
                const SizedBox(width: 10),
                ElevatedButton(
                  onPressed: () {
                    // print('Save');
                  },
                  child: const Text('Save'),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
