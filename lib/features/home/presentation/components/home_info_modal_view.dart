import 'package:flutter/material.dart';

class HomeInfoModalView extends StatelessWidget {
  const HomeInfoModalView({super.key});

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.all(16),
      color: Colors.amber.shade100,
      child: const Padding(
        padding: EdgeInsets.all(16),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Icon(Icons.info_outline),
            SizedBox(width: 12),
            Expanded(
              child: Text(
                'Сейчас список хранится только на этом устройстве.\n\n'
                    'Создайте или вступите в семью, чтобы делиться списком покупок '
                    'и синхронизировать изменения между всеми участниками.',
              ),
            ),
          ],
        ),
      ),
    );
  }
}