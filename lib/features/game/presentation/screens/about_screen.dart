import 'package:flutter/material.dart';

class AboutScreen extends StatelessWidget {
  const AboutScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const SizedBox(height: 24),
            Center(
              child: CircleAvatar(
                radius: 56,
                backgroundColor: theme.colorScheme.primaryContainer,
                child: Icon(
                  Icons.casino,
                  size: 56,
                  color: theme.colorScheme.onPrimaryContainer,
                ),
              ),
            ),
            const SizedBox(height: 24),
            Center(
              child: Text(
                'Score Beloty 2.0',
                style: theme.textTheme.headlineSmall,
              ),
            ),
            const SizedBox(height: 8),
            Center(
              child: Text(
                'Compteur de scores pour la belote malgache.',
                style: theme.textTheme.bodyMedium,
                textAlign: TextAlign.center,
              ),
            ),
            const SizedBox(height: 32),
            const Card(
              child: ListTile(
                leading: Icon(Icons.info_outline),
                title: Text('Version'),
                subtitle: Text('2.0.0'),
              ),
            ),
            const Card(
              child: ListTile(
                leading: Icon(Icons.code),
                title: Text('Développé par'),
                subtitle: Text('Solvers 2018'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
