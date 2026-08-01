// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for French (`fr`).
class AppLocalizationsFr extends AppLocalizations {
  AppLocalizationsFr([String locale = 'fr']) : super(locale);

  @override
  String get appTitle => 'Score Beloty';

  @override
  String get appSubtitle => 'Compteur de scores pour la belote malgache.';

  @override
  String get newGame => 'Nouvelle partie';

  @override
  String get history => 'Historique';

  @override
  String get about => 'À propos';

  @override
  String get language => 'Langue';

  @override
  String get newGameTitle => 'Nouvelle partie';

  @override
  String get newGameSubtitle =>
      'Saisissez les joueurs et les scores de départ.';

  @override
  String get ourTeam => 'Notre équipe';

  @override
  String get theirTeam => 'Équipe adverse';

  @override
  String get player1 => 'Joueur 1';

  @override
  String get player2 => 'Joueur 2';

  @override
  String get initialScore => 'Score initial';

  @override
  String get requiredField => 'Champ obligatoire';

  @override
  String get invalidScore => 'Score invalide';

  @override
  String get advancedRules => 'Règles avancées';

  @override
  String get defaultRules => 'Réglages par défaut';

  @override
  String get customRules => 'Personnalisé';

  @override
  String get startButton => 'COMMENCER';

  @override
  String get ruleFinalScore => 'Score cible';

  @override
  String get ruleSplitAllTrumps => 'Partage autorisé (TA)';

  @override
  String get ruleSplitNoTrumps => 'Partage autorisé (SA)';

  @override
  String get ruleSplitColor => 'Partage autorisé (Couleur)';

  @override
  String get ruleContinueOnTie => 'Miara miakatra (continuer sur égalité)';

  @override
  String get ruleStepsOnTie => 'Palier en cas d\'égalité';

  @override
  String get rulePointIfError => 'Points si erreur';

  @override
  String get rulePointOnError => 'Points attribués sur erreur';

  @override
  String get ruleWinIfCapotInside => 'Gagner si capot dedans';

  @override
  String get ruleRedoubleNoTrumps => 'Surcontré sans atout';

  @override
  String get ruleBet => 'Système de goûter activé';

  @override
  String get ruleBetAmount => 'Mise (Ar)';

  @override
  String get ruleDoubleAmountOnCapotScore => 'Doubler la mise sur capot';

  @override
  String get contractLabel => 'Contrat';

  @override
  String get bidLabel => 'Enchère';

  @override
  String get capotLabel => 'Capot';

  @override
  String get contractAllTrumps => 'Tout atout';

  @override
  String get contractNoTrumps => 'Sans atout';

  @override
  String get contractSpades => 'Pique';

  @override
  String get contractHearts => 'Cœur';

  @override
  String get contractDiamonds => 'Carreau';

  @override
  String get contractClubs => 'Trèfle';

  @override
  String get contractError => 'Erreur';

  @override
  String get contractShortAllTrumps => 'TA';

  @override
  String get contractShortNoTrumps => 'SA';

  @override
  String get contractShortSpades => 'Pique';

  @override
  String get contractShortHearts => 'Cœur';

  @override
  String get contractShortDiamonds => 'Carreau';

  @override
  String get contractShortClubs => 'Trèfle';

  @override
  String get contractShortError => '—';

  @override
  String get bidPass => 'Passe';

  @override
  String get bidDouble => 'Contré';

  @override
  String get bidRedouble => 'Surcontré';

  @override
  String get capotNone => 'Aucun';

  @override
  String get capotCapot => 'Capot';

  @override
  String get capotInside => 'Dedans';

  @override
  String get calculatedStake => 'Mise calculée';

  @override
  String get splitAllowed => 'Partage autorisé';

  @override
  String pointsUnit(int points) {
    return '$points points';
  }

  @override
  String get startDealButton => 'COMMENCER LA DONNE';

  @override
  String get cancelLastDealButton => 'Annuler la dernière donne';

  @override
  String get cancelLastDealDialogTitle => 'Annuler la dernière donne';

  @override
  String get cancelLastDealDialogMessage =>
      'La donne précédente sera supprimée. Continuer ?';

  @override
  String get backAction => 'Retour';

  @override
  String get cancelAction => 'Annuler';

  @override
  String get okAction => 'OK';

  @override
  String get noCurrentGame => 'Aucune partie en cours';

  @override
  String target(int score) {
    return 'Cible : $score';
  }

  @override
  String get dealResultTitle => 'Résultat de la donne';

  @override
  String get win => 'On a gagné';

  @override
  String get lose => 'Ils ont gagné';

  @override
  String get splitResult => 'Partage';

  @override
  String get litigation => 'Litige';

  @override
  String get splitSubtitle => 'Saisir les scores manuellement';

  @override
  String get litigationSubtitle => 'Chaque camp conserve ses points';

  @override
  String get noCurrentDeal =>
      'Aucune donne en cours. Démarrez-en une nouvelle.';

  @override
  String get chooseContractButton => 'Choisir un contrat';

  @override
  String pointsDelta(int points) {
    return '+$points points';
  }

  @override
  String get splitTitle => 'Partage';

  @override
  String contractWithLabel(String contract) {
    return 'Contrat : $contract';
  }

  @override
  String expectedTotalLabel(int total, int max) {
    return 'Somme attendue : $total • Maximum par équipe : $max';
  }

  @override
  String get ourScoreLabel => 'Notre score';

  @override
  String get theirScoreLabel => 'Leur score';

  @override
  String get invertTooltip => 'Inverser';

  @override
  String get invalidValues => 'Valeurs invalides';

  @override
  String sumMustBeLabel(int expected, int actual) {
    return 'La somme doit valoir $expected (saisie : $actual)';
  }

  @override
  String maxPerTeamLabel(int max) {
    return 'Maximum par équipe : $max points';
  }

  @override
  String get validate => 'VALIDER';

  @override
  String get dealsHistoryTitle => 'Historique des donnes';

  @override
  String get noDealsRecorded => 'Aucune donne enregistrée pour cette partie.';

  @override
  String get noGameInProgress => 'Aucune partie en cours.';

  @override
  String get backTooltip => 'Retour';

  @override
  String get resultWon => 'On a gagné';

  @override
  String get resultLost => 'Ils ont gagné';

  @override
  String get resultSplit => 'Partage';

  @override
  String get resultLitigation => 'Litige';

  @override
  String get resultPending => 'En cours';

  @override
  String get tieTooltip => 'Égalité appliquée (miara miakatra)';

  @override
  String dealSubtitle(String date, String result, int ours, int theirs) {
    return '$date • $result • $ours - $theirs';
  }

  @override
  String get infoTitle => 'Informations';

  @override
  String get startTime => 'Début';

  @override
  String get dealsCountLabel => 'Donnes';

  @override
  String dealsCount(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count donnes',
      one: '1 donne',
      zero: 'Aucune donne',
    );
    return '$_temp0';
  }

  @override
  String get ourTeamInfo => 'Notre équipe';

  @override
  String get theirTeamInfo => 'Équipe adverse';

  @override
  String get ourInitialScore => 'Score initial (nous)';

  @override
  String get theirInitialScore => 'Score initial (eux)';

  @override
  String get targetScore => 'Score cible';

  @override
  String get activeRules => 'Règles actives';

  @override
  String get yesLabel => 'Oui';

  @override
  String get noLabel => 'Non';

  @override
  String betAmountLabel(int amount) {
    return 'Oui ($amount Ar)';
  }

  @override
  String get gameOverTitle => 'Fin de partie';

  @override
  String get noFinishedGame => 'Aucune partie terminée.';

  @override
  String get winner => 'Vainqueur';

  @override
  String get draw => 'Match nul';

  @override
  String get gameDate => 'Date de la partie';

  @override
  String get historyButton => 'HISTORIQUE DES DONNES';

  @override
  String get replayButton => 'REJOUER';

  @override
  String get newGameButton => 'NOUVELLE PARTIE';

  @override
  String get gamesHistoryTitle => 'Historique';

  @override
  String get emptyGames => 'Aucune partie';

  @override
  String get emptyGamesSubtitle =>
      'Démarrez une nouvelle partie pour la voir ici.';

  @override
  String gameSummary(int our, int their, int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count donnes',
      one: '1 donne',
      zero: '0 donne',
    );
    return 'Score $our - $their • $_temp0';
  }

  @override
  String get historyLoadError => 'Impossible de charger l\'historique';

  @override
  String get historyStorageError => 'Stockage indisponible';

  @override
  String get retryAction => 'Réessayer';

  @override
  String get version => 'Version';

  @override
  String get versionValue => '2.0.0';

  @override
  String get developer => 'Développé par';

  @override
  String get developerValue => 'Solvers 2018';
}
