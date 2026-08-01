import 'package:flutter/material.dart';

import '../../../../l10n/generated/app_localizations.dart';
import 'home_shell.dart';

class AboutScreen extends StatelessWidget {
  const AboutScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final l10n = AppLocalizations.of(context);
    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const SizedBox(height: 24),
            Center(
              child: ClipRRect(
                borderRadius: BorderRadius.circular(24),
                child: Image.asset(
                  HomeShell.logoAsset,
                  width: 144,
                  height: 144,
                  fit: BoxFit.cover,
                ),
              ),
            ),
            const SizedBox(height: 24),
            Center(
              child: Text(
                '${l10n.appTitle} 2.0',
                style: theme.textTheme.headlineSmall,
              ),
            ),
            const SizedBox(height: 8),
            Center(
              child: Text(
                l10n.appSubtitle,
                style: theme.textTheme.bodyMedium,
                textAlign: TextAlign.center,
              ),
            ),
            const SizedBox(height: 32),
            Card(
              child: ListTile(
                leading: const Icon(Icons.info_outline),
                title: Text(l10n.version),
                subtitle: Text(l10n.versionValue),
              ),
            ),
            Card(
              child: ListTile(
                leading: const Icon(Icons.code),
                title: Text(l10n.developer),
                subtitle: Text(l10n.developerValue),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
