import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:intl/intl.dart' as intl;

import 'app_localizations_en.dart';
import 'app_localizations_fr.dart';
import 'app_localizations_mg.dart';

// ignore_for_file: type=lint

/// Callers can lookup localized strings with an instance of AppLocalizations
/// returned by `AppLocalizations.of(context)`.
///
/// Applications need to include `AppLocalizations.delegate()` in their app's
/// `localizationDelegates` list, and the locales they support in the app's
/// `supportedLocales` list. For example:
///
/// ```dart
/// import 'generated/app_localizations.dart';
///
/// return MaterialApp(
///   localizationsDelegates: AppLocalizations.localizationsDelegates,
///   supportedLocales: AppLocalizations.supportedLocales,
///   home: MyApplicationHome(),
/// );
/// ```
///
/// ## Update pubspec.yaml
///
/// Please make sure to update your pubspec.yaml to include the following
/// packages:
///
/// ```yaml
/// dependencies:
///   # Internationalization support.
///   flutter_localizations:
///     sdk: flutter
///   intl: any # Use the pinned version from flutter_localizations
///
///   # Rest of dependencies
/// ```
///
/// ## iOS Applications
///
/// iOS applications define key application metadata, including supported
/// locales, in an Info.plist file that is built into the application bundle.
/// To configure the locales supported by your app, you’ll need to edit this
/// file.
///
/// First, open your project’s ios/Runner.xcworkspace Xcode workspace file.
/// Then, in the Project Navigator, open the Info.plist file under the Runner
/// project’s Runner folder.
///
/// Next, select the Information Property List item, select Add Item from the
/// Editor menu, then select Localizations from the pop-up menu.
///
/// Select and expand the newly-created Localizations item then, for each
/// locale your application supports, add a new item and select the locale
/// you wish to add from the pop-up menu in the Value field. This list should
/// be consistent with the languages listed in the AppLocalizations.supportedLocales
/// property.
abstract class AppLocalizations {
  AppLocalizations(String locale)
    : localeName = intl.Intl.canonicalizedLocale(locale.toString());

  final String localeName;

  static AppLocalizations of(BuildContext context) {
    return Localizations.of<AppLocalizations>(context, AppLocalizations)!;
  }

  static const LocalizationsDelegate<AppLocalizations> delegate =
      _AppLocalizationsDelegate();

  /// A list of this localizations delegate along with the default localizations
  /// delegates.
  ///
  /// Returns a list of localizations delegates containing this delegate along with
  /// GlobalMaterialLocalizations.delegate, GlobalCupertinoLocalizations.delegate,
  /// and GlobalWidgetsLocalizations.delegate.
  ///
  /// Additional delegates can be added by appending to this list in
  /// MaterialApp. This list does not have to be used at all if a custom list
  /// of delegates is preferred or required.
  static const List<LocalizationsDelegate<dynamic>> localizationsDelegates =
      <LocalizationsDelegate<dynamic>>[
        delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
      ];

  /// A list of this localizations delegate's supported locales.
  static const List<Locale> supportedLocales = <Locale>[
    Locale('en'),
    Locale('fr'),
    Locale('mg'),
  ];

  /// Application name shown in the AppBar and About screen.
  ///
  /// In fr, this message translates to:
  /// **'Score Beloty'**
  String get appTitle;

  /// Subtitle shown below the logo on the About screen.
  ///
  /// In fr, this message translates to:
  /// **'Compteur de scores pour la belote malgache.'**
  String get appSubtitle;

  /// No description provided for @newGame.
  ///
  /// In fr, this message translates to:
  /// **'Nouvelle partie'**
  String get newGame;

  /// No description provided for @history.
  ///
  /// In fr, this message translates to:
  /// **'Historique'**
  String get history;

  /// No description provided for @about.
  ///
  /// In fr, this message translates to:
  /// **'À propos'**
  String get about;

  /// No description provided for @language.
  ///
  /// In fr, this message translates to:
  /// **'Langue'**
  String get language;

  /// No description provided for @newGameTitle.
  ///
  /// In fr, this message translates to:
  /// **'Nouvelle partie'**
  String get newGameTitle;

  /// No description provided for @newGameSubtitle.
  ///
  /// In fr, this message translates to:
  /// **'Saisissez les joueurs et les scores de départ.'**
  String get newGameSubtitle;

  /// No description provided for @ourTeam.
  ///
  /// In fr, this message translates to:
  /// **'Notre équipe'**
  String get ourTeam;

  /// No description provided for @theirTeam.
  ///
  /// In fr, this message translates to:
  /// **'Équipe adverse'**
  String get theirTeam;

  /// No description provided for @player1.
  ///
  /// In fr, this message translates to:
  /// **'Joueur 1'**
  String get player1;

  /// No description provided for @player2.
  ///
  /// In fr, this message translates to:
  /// **'Joueur 2'**
  String get player2;

  /// No description provided for @initialScore.
  ///
  /// In fr, this message translates to:
  /// **'Score initial'**
  String get initialScore;

  /// No description provided for @requiredField.
  ///
  /// In fr, this message translates to:
  /// **'Champ obligatoire'**
  String get requiredField;

  /// No description provided for @invalidScore.
  ///
  /// In fr, this message translates to:
  /// **'Score invalide'**
  String get invalidScore;

  /// No description provided for @advancedRules.
  ///
  /// In fr, this message translates to:
  /// **'Règles avancées'**
  String get advancedRules;

  /// No description provided for @defaultRules.
  ///
  /// In fr, this message translates to:
  /// **'Réglages par défaut'**
  String get defaultRules;

  /// No description provided for @customRules.
  ///
  /// In fr, this message translates to:
  /// **'Personnalisé'**
  String get customRules;

  /// No description provided for @startButton.
  ///
  /// In fr, this message translates to:
  /// **'COMMENCER'**
  String get startButton;

  /// No description provided for @ruleFinalScore.
  ///
  /// In fr, this message translates to:
  /// **'Score cible'**
  String get ruleFinalScore;

  /// No description provided for @ruleSplitAllTrumps.
  ///
  /// In fr, this message translates to:
  /// **'Partage autorisé (TA)'**
  String get ruleSplitAllTrumps;

  /// No description provided for @ruleSplitNoTrumps.
  ///
  /// In fr, this message translates to:
  /// **'Partage autorisé (SA)'**
  String get ruleSplitNoTrumps;

  /// No description provided for @ruleSplitSuit.
  ///
  /// In fr, this message translates to:
  /// **'Partage autorisé (Couleur)'**
  String get ruleSplitSuit;

  /// No description provided for @ruleContinueOnTie.
  ///
  /// In fr, this message translates to:
  /// **'Miara miakatra (continuer sur égalité)'**
  String get ruleContinueOnTie;

  /// No description provided for @ruleStepsOnTie.
  ///
  /// In fr, this message translates to:
  /// **'Palier en cas d\'égalité'**
  String get ruleStepsOnTie;

  /// No description provided for @rulePointIfError.
  ///
  /// In fr, this message translates to:
  /// **'Points si erreur'**
  String get rulePointIfError;

  /// No description provided for @rulePointOnError.
  ///
  /// In fr, this message translates to:
  /// **'Points attribués sur erreur'**
  String get rulePointOnError;

  /// No description provided for @ruleWinIfCapotByDefense.
  ///
  /// In fr, this message translates to:
  /// **'Gagner si capot par la défense'**
  String get ruleWinIfCapotByDefense;

  /// No description provided for @ruleRedoubleNoTrumps.
  ///
  /// In fr, this message translates to:
  /// **'Surcontré sans atout'**
  String get ruleRedoubleNoTrumps;

  /// No description provided for @ruleStake.
  ///
  /// In fr, this message translates to:
  /// **'Système de goûter activé'**
  String get ruleStake;

  /// No description provided for @ruleStakeAmount.
  ///
  /// In fr, this message translates to:
  /// **'Mise (Ar)'**
  String get ruleStakeAmount;

  /// No description provided for @ruleStakeDoubledOnCapot.
  ///
  /// In fr, this message translates to:
  /// **'Doubler la mise sur capot'**
  String get ruleStakeDoubledOnCapot;

  /// No description provided for @contractLabel.
  ///
  /// In fr, this message translates to:
  /// **'Contrat'**
  String get contractLabel;

  /// No description provided for @bidLabel.
  ///
  /// In fr, this message translates to:
  /// **'Enchère'**
  String get bidLabel;

  /// No description provided for @capotLabel.
  ///
  /// In fr, this message translates to:
  /// **'Capot'**
  String get capotLabel;

  /// No description provided for @contractAllTrumps.
  ///
  /// In fr, this message translates to:
  /// **'Tout atout'**
  String get contractAllTrumps;

  /// No description provided for @contractNoTrumps.
  ///
  /// In fr, this message translates to:
  /// **'Sans atout'**
  String get contractNoTrumps;

  /// No description provided for @contractSpades.
  ///
  /// In fr, this message translates to:
  /// **'Pique'**
  String get contractSpades;

  /// No description provided for @contractHearts.
  ///
  /// In fr, this message translates to:
  /// **'Cœur'**
  String get contractHearts;

  /// No description provided for @contractDiamonds.
  ///
  /// In fr, this message translates to:
  /// **'Carreau'**
  String get contractDiamonds;

  /// No description provided for @contractClubs.
  ///
  /// In fr, this message translates to:
  /// **'Trèfle'**
  String get contractClubs;

  /// No description provided for @contractError.
  ///
  /// In fr, this message translates to:
  /// **'Erreur'**
  String get contractError;

  /// No description provided for @contractShortAllTrumps.
  ///
  /// In fr, this message translates to:
  /// **'TA'**
  String get contractShortAllTrumps;

  /// No description provided for @contractShortNoTrumps.
  ///
  /// In fr, this message translates to:
  /// **'SA'**
  String get contractShortNoTrumps;

  /// No description provided for @contractShortSpades.
  ///
  /// In fr, this message translates to:
  /// **'Pique'**
  String get contractShortSpades;

  /// No description provided for @contractShortHearts.
  ///
  /// In fr, this message translates to:
  /// **'Cœur'**
  String get contractShortHearts;

  /// No description provided for @contractShortDiamonds.
  ///
  /// In fr, this message translates to:
  /// **'Carreau'**
  String get contractShortDiamonds;

  /// No description provided for @contractShortClubs.
  ///
  /// In fr, this message translates to:
  /// **'Trèfle'**
  String get contractShortClubs;

  /// No description provided for @contractShortError.
  ///
  /// In fr, this message translates to:
  /// **'—'**
  String get contractShortError;

  /// No description provided for @bidPass.
  ///
  /// In fr, this message translates to:
  /// **'Bonne'**
  String get bidPass;

  /// No description provided for @bidDouble.
  ///
  /// In fr, this message translates to:
  /// **'Contré'**
  String get bidDouble;

  /// No description provided for @bidRedouble.
  ///
  /// In fr, this message translates to:
  /// **'Surcontré'**
  String get bidRedouble;

  /// No description provided for @capotNone.
  ///
  /// In fr, this message translates to:
  /// **'Aucun'**
  String get capotNone;

  /// No description provided for @capotCapot.
  ///
  /// In fr, this message translates to:
  /// **'Capot'**
  String get capotCapot;

  /// No description provided for @capotByDefense.
  ///
  /// In fr, this message translates to:
  /// **'Capot défense'**
  String get capotByDefense;

  /// No description provided for @calculatedStake.
  ///
  /// In fr, this message translates to:
  /// **'Mise calculée'**
  String get calculatedStake;

  /// No description provided for @splitAllowed.
  ///
  /// In fr, this message translates to:
  /// **'Partage autorisé'**
  String get splitAllowed;

  /// Displayed total for a deal. Plural-agnostic in French.
  ///
  /// In fr, this message translates to:
  /// **'{points} points'**
  String pointsUnit(int points);

  /// No description provided for @startDealButton.
  ///
  /// In fr, this message translates to:
  /// **'COMMENCER LA DONNE'**
  String get startDealButton;

  /// No description provided for @cancelLastDealButton.
  ///
  /// In fr, this message translates to:
  /// **'Annuler la dernière donne'**
  String get cancelLastDealButton;

  /// No description provided for @cancelLastDealDialogTitle.
  ///
  /// In fr, this message translates to:
  /// **'Annuler la dernière donne'**
  String get cancelLastDealDialogTitle;

  /// No description provided for @cancelLastDealDialogMessage.
  ///
  /// In fr, this message translates to:
  /// **'La donne précédente sera supprimée. Continuer ?'**
  String get cancelLastDealDialogMessage;

  /// No description provided for @backAction.
  ///
  /// In fr, this message translates to:
  /// **'Retour'**
  String get backAction;

  /// No description provided for @cancelAction.
  ///
  /// In fr, this message translates to:
  /// **'Annuler'**
  String get cancelAction;

  /// No description provided for @okAction.
  ///
  /// In fr, this message translates to:
  /// **'OK'**
  String get okAction;

  /// No description provided for @noCurrentGame.
  ///
  /// In fr, this message translates to:
  /// **'Aucune partie en cours'**
  String get noCurrentGame;

  /// No description provided for @target.
  ///
  /// In fr, this message translates to:
  /// **'Cible : {score}'**
  String target(int score);

  /// No description provided for @dealResultTitle.
  ///
  /// In fr, this message translates to:
  /// **'Résultat de la donne'**
  String get dealResultTitle;

  /// No description provided for @win.
  ///
  /// In fr, this message translates to:
  /// **'On a gagné'**
  String get win;

  /// No description provided for @lose.
  ///
  /// In fr, this message translates to:
  /// **'Ils ont gagné'**
  String get lose;

  /// No description provided for @splitResult.
  ///
  /// In fr, this message translates to:
  /// **'Partage'**
  String get splitResult;

  /// No description provided for @dispute.
  ///
  /// In fr, this message translates to:
  /// **'Litige'**
  String get dispute;

  /// No description provided for @splitSubtitle.
  ///
  /// In fr, this message translates to:
  /// **'Saisir les scores manuellement'**
  String get splitSubtitle;

  /// No description provided for @disputeSubtitle.
  ///
  /// In fr, this message translates to:
  /// **'Chaque camp conserve ses points'**
  String get disputeSubtitle;

  /// No description provided for @noCurrentDeal.
  ///
  /// In fr, this message translates to:
  /// **'Aucune donne en cours. Démarrez-en une nouvelle.'**
  String get noCurrentDeal;

  /// No description provided for @chooseContractButton.
  ///
  /// In fr, this message translates to:
  /// **'Choisir un contrat'**
  String get chooseContractButton;

  /// Positive point delta appended to the win/lose result.
  ///
  /// In fr, this message translates to:
  /// **'+{points} points'**
  String pointsDelta(int points);

  /// No description provided for @splitTitle.
  ///
  /// In fr, this message translates to:
  /// **'Partage'**
  String get splitTitle;

  /// No description provided for @contractWithLabel.
  ///
  /// In fr, this message translates to:
  /// **'Contrat : {contract}'**
  String contractWithLabel(String contract);

  /// No description provided for @expectedTotalLabel.
  ///
  /// In fr, this message translates to:
  /// **'Somme attendue : {total} • Maximum par équipe : {max}'**
  String expectedTotalLabel(int total, int max);

  /// No description provided for @ourScoreLabel.
  ///
  /// In fr, this message translates to:
  /// **'Notre score'**
  String get ourScoreLabel;

  /// No description provided for @theirScoreLabel.
  ///
  /// In fr, this message translates to:
  /// **'Leur score'**
  String get theirScoreLabel;

  /// No description provided for @invertTooltip.
  ///
  /// In fr, this message translates to:
  /// **'Inverser'**
  String get invertTooltip;

  /// No description provided for @invalidValues.
  ///
  /// In fr, this message translates to:
  /// **'Valeurs invalides'**
  String get invalidValues;

  /// No description provided for @sumMustBeLabel.
  ///
  /// In fr, this message translates to:
  /// **'La somme doit valoir {expected} (saisie : {actual})'**
  String sumMustBeLabel(int expected, int actual);

  /// No description provided for @maxPerTeamLabel.
  ///
  /// In fr, this message translates to:
  /// **'Maximum par équipe : {max} points'**
  String maxPerTeamLabel(int max);

  /// No description provided for @validate.
  ///
  /// In fr, this message translates to:
  /// **'VALIDER'**
  String get validate;

  /// No description provided for @dealsHistoryTitle.
  ///
  /// In fr, this message translates to:
  /// **'Historique des donnes'**
  String get dealsHistoryTitle;

  /// No description provided for @noDealsRecorded.
  ///
  /// In fr, this message translates to:
  /// **'Aucune donne enregistrée pour cette partie.'**
  String get noDealsRecorded;

  /// No description provided for @noGameInProgress.
  ///
  /// In fr, this message translates to:
  /// **'Aucune partie en cours.'**
  String get noGameInProgress;

  /// No description provided for @backTooltip.
  ///
  /// In fr, this message translates to:
  /// **'Retour'**
  String get backTooltip;

  /// No description provided for @resultWon.
  ///
  /// In fr, this message translates to:
  /// **'On a gagné'**
  String get resultWon;

  /// No description provided for @resultLost.
  ///
  /// In fr, this message translates to:
  /// **'Ils ont gagné'**
  String get resultLost;

  /// No description provided for @resultSplit.
  ///
  /// In fr, this message translates to:
  /// **'Partage'**
  String get resultSplit;

  /// No description provided for @resultDispute.
  ///
  /// In fr, this message translates to:
  /// **'Litige'**
  String get resultDispute;

  /// No description provided for @resultPending.
  ///
  /// In fr, this message translates to:
  /// **'En cours'**
  String get resultPending;

  /// No description provided for @tieTooltip.
  ///
  /// In fr, this message translates to:
  /// **'Égalité appliquée (miara miakatra)'**
  String get tieTooltip;

  /// No description provided for @dealSubtitle.
  ///
  /// In fr, this message translates to:
  /// **'{date} • {result} • {ours} - {theirs}'**
  String dealSubtitle(String date, String result, int ours, int theirs);

  /// No description provided for @infoTitle.
  ///
  /// In fr, this message translates to:
  /// **'Informations'**
  String get infoTitle;

  /// No description provided for @startTime.
  ///
  /// In fr, this message translates to:
  /// **'Début'**
  String get startTime;

  /// No description provided for @dealsCountLabel.
  ///
  /// In fr, this message translates to:
  /// **'Donnes'**
  String get dealsCountLabel;

  /// No description provided for @dealsCount.
  ///
  /// In fr, this message translates to:
  /// **'{count, plural, =0{Aucune donne} =1{1 donne} other{{count} donnes}}'**
  String dealsCount(int count);

  /// No description provided for @ourTeamInfo.
  ///
  /// In fr, this message translates to:
  /// **'Notre équipe'**
  String get ourTeamInfo;

  /// No description provided for @theirTeamInfo.
  ///
  /// In fr, this message translates to:
  /// **'Équipe adverse'**
  String get theirTeamInfo;

  /// No description provided for @ourInitialScore.
  ///
  /// In fr, this message translates to:
  /// **'Score initial (nous)'**
  String get ourInitialScore;

  /// No description provided for @theirInitialScore.
  ///
  /// In fr, this message translates to:
  /// **'Score initial (eux)'**
  String get theirInitialScore;

  /// No description provided for @targetScore.
  ///
  /// In fr, this message translates to:
  /// **'Score cible'**
  String get targetScore;

  /// No description provided for @activeRules.
  ///
  /// In fr, this message translates to:
  /// **'Règles actives'**
  String get activeRules;

  /// No description provided for @yesLabel.
  ///
  /// In fr, this message translates to:
  /// **'Oui'**
  String get yesLabel;

  /// No description provided for @noLabel.
  ///
  /// In fr, this message translates to:
  /// **'Non'**
  String get noLabel;

  /// No description provided for @stakeAmountLabel.
  ///
  /// In fr, this message translates to:
  /// **'Oui ({amount} Ar)'**
  String stakeAmountLabel(int amount);

  /// No description provided for @gameOverTitle.
  ///
  /// In fr, this message translates to:
  /// **'Fin de partie'**
  String get gameOverTitle;

  /// No description provided for @noFinishedGame.
  ///
  /// In fr, this message translates to:
  /// **'Aucune partie terminée.'**
  String get noFinishedGame;

  /// No description provided for @winner.
  ///
  /// In fr, this message translates to:
  /// **'Vainqueur'**
  String get winner;

  /// No description provided for @draw.
  ///
  /// In fr, this message translates to:
  /// **'Match nul'**
  String get draw;

  /// No description provided for @gameDate.
  ///
  /// In fr, this message translates to:
  /// **'Date de la partie'**
  String get gameDate;

  /// No description provided for @historyButton.
  ///
  /// In fr, this message translates to:
  /// **'HISTORIQUE DES DONNES'**
  String get historyButton;

  /// No description provided for @replayButton.
  ///
  /// In fr, this message translates to:
  /// **'REJOUER'**
  String get replayButton;

  /// No description provided for @newGameButton.
  ///
  /// In fr, this message translates to:
  /// **'NOUVELLE PARTIE'**
  String get newGameButton;

  /// No description provided for @gamesHistoryTitle.
  ///
  /// In fr, this message translates to:
  /// **'Historique'**
  String get gamesHistoryTitle;

  /// No description provided for @emptyGames.
  ///
  /// In fr, this message translates to:
  /// **'Aucune partie'**
  String get emptyGames;

  /// No description provided for @emptyGamesSubtitle.
  ///
  /// In fr, this message translates to:
  /// **'Démarrez une nouvelle partie pour la voir ici.'**
  String get emptyGamesSubtitle;

  /// No description provided for @gameSummary.
  ///
  /// In fr, this message translates to:
  /// **'Score {our} - {their} • {count, plural, =0{0 donne} =1{1 donne} other{{count} donnes}}'**
  String gameSummary(int our, int their, int count);

  /// No description provided for @historyLoadError.
  ///
  /// In fr, this message translates to:
  /// **'Impossible de charger l\'historique'**
  String get historyLoadError;

  /// No description provided for @historyStorageError.
  ///
  /// In fr, this message translates to:
  /// **'Stockage indisponible'**
  String get historyStorageError;

  /// No description provided for @retryAction.
  ///
  /// In fr, this message translates to:
  /// **'Réessayer'**
  String get retryAction;

  /// No description provided for @version.
  ///
  /// In fr, this message translates to:
  /// **'Version'**
  String get version;

  /// No description provided for @versionValue.
  ///
  /// In fr, this message translates to:
  /// **'2.0.0'**
  String get versionValue;

  /// No description provided for @developer.
  ///
  /// In fr, this message translates to:
  /// **'Développé par'**
  String get developer;

  /// No description provided for @developerValue.
  ///
  /// In fr, this message translates to:
  /// **'Solvers 2018'**
  String get developerValue;
}

class _AppLocalizationsDelegate
    extends LocalizationsDelegate<AppLocalizations> {
  const _AppLocalizationsDelegate();

  @override
  Future<AppLocalizations> load(Locale locale) {
    return SynchronousFuture<AppLocalizations>(lookupAppLocalizations(locale));
  }

  @override
  bool isSupported(Locale locale) =>
      <String>['en', 'fr', 'mg'].contains(locale.languageCode);

  @override
  bool shouldReload(_AppLocalizationsDelegate old) => false;
}

AppLocalizations lookupAppLocalizations(Locale locale) {
  // Lookup logic when only language code is specified.
  switch (locale.languageCode) {
    case 'en':
      return AppLocalizationsEn();
    case 'fr':
      return AppLocalizationsFr();
    case 'mg':
      return AppLocalizationsMg();
  }

  throw FlutterError(
    'AppLocalizations.delegate failed to load unsupported locale "$locale". This is likely '
    'an issue with the localizations generation tool. Please file an issue '
    'on GitHub with a reproducible sample app and the gen-l10n configuration '
    'that was used.',
  );
}
