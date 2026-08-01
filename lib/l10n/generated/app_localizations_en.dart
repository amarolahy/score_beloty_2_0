// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for English (`en`).
class AppLocalizationsEn extends AppLocalizations {
  AppLocalizationsEn([String locale = 'en']) : super(locale);

  @override
  String get appTitle => 'Score Beloty';

  @override
  String get appSubtitle => 'Score tracker for the Malagasy belote game.';

  @override
  String get newGame => 'New game';

  @override
  String get history => 'History';

  @override
  String get about => 'About';

  @override
  String get language => 'Language';

  @override
  String get newGameTitle => 'New game';

  @override
  String get newGameSubtitle => 'Enter the players and the starting scores.';

  @override
  String get ourTeam => 'Our team';

  @override
  String get theirTeam => 'Opponents';

  @override
  String get player1 => 'Player 1';

  @override
  String get player2 => 'Player 2';

  @override
  String get initialScore => 'Starting score';

  @override
  String get requiredField => 'Required field';

  @override
  String get invalidScore => 'Invalid score';

  @override
  String get advancedRules => 'Advanced rules';

  @override
  String get defaultRules => 'Default settings';

  @override
  String get customRules => 'Custom';

  @override
  String get startButton => 'START';

  @override
  String get ruleFinalScore => 'Target score';

  @override
  String get ruleSplitAllTrumps => 'Split allowed (All trumps)';

  @override
  String get ruleSplitNoTrumps => 'Split allowed (No trumps)';

  @override
  String get ruleSplitSuit => 'Split allowed (Suit)';

  @override
  String get ruleContinueOnTie => 'Miara miakatra (continue on tie)';

  @override
  String get ruleStepsOnTie => 'Tie step';

  @override
  String get rulePointIfError => 'Points on error';

  @override
  String get rulePointOnError => 'Points awarded on error';

  @override
  String get ruleWinIfCapotByDefense => 'Win if defense scores capot';

  @override
  String get ruleRedoubleNoTrumps => 'Redouble without trump';

  @override
  String get ruleStake => 'Side stake enabled';

  @override
  String get ruleStakeAmount => 'Stake amount (Ar)';

  @override
  String get ruleStakeDoubledOnCapot => 'Double the stake on capot';

  @override
  String get contractLabel => 'Contract';

  @override
  String get bidLabel => 'Bid';

  @override
  String get capotLabel => 'Capot';

  @override
  String get contractAllTrumps => 'All trumps';

  @override
  String get contractNoTrumps => 'No trumps';

  @override
  String get contractSpades => 'Spades';

  @override
  String get contractHearts => 'Hearts';

  @override
  String get contractDiamonds => 'Diamonds';

  @override
  String get contractClubs => 'Clubs';

  @override
  String get contractError => 'Error';

  @override
  String get contractShortAllTrumps => 'AT';

  @override
  String get contractShortNoTrumps => 'NT';

  @override
  String get contractShortSpades => 'Spades';

  @override
  String get contractShortHearts => 'Hearts';

  @override
  String get contractShortDiamonds => 'Diamonds';

  @override
  String get contractShortClubs => 'Clubs';

  @override
  String get contractShortError => '—';

  @override
  String get bidPass => 'Pass';

  @override
  String get bidDouble => 'Double';

  @override
  String get bidRedouble => 'Redouble';

  @override
  String get capotNone => 'None';

  @override
  String get capotCapot => 'Capot';

  @override
  String get capotByDefense => 'Capot by defense';

  @override
  String get calculatedStake => 'Calculated stake';

  @override
  String get splitAllowed => 'Split allowed';

  @override
  String pointsUnit(int points) {
    return '$points points';
  }

  @override
  String get startDealButton => 'START THE DEAL';

  @override
  String get cancelLastDealButton => 'Cancel last deal';

  @override
  String get cancelLastDealDialogTitle => 'Cancel the last deal';

  @override
  String get cancelLastDealDialogMessage =>
      'The previous deal will be removed. Continue?';

  @override
  String get backAction => 'Back';

  @override
  String get cancelAction => 'Cancel';

  @override
  String get okAction => 'OK';

  @override
  String get noCurrentGame => 'No game in progress';

  @override
  String target(int score) {
    return 'Target: $score';
  }

  @override
  String get dealResultTitle => 'Deal outcome';

  @override
  String get win => 'We won';

  @override
  String get lose => 'They won';

  @override
  String get splitResult => 'Split';

  @override
  String get dispute => 'Dispute';

  @override
  String get splitSubtitle => 'Enter the scores manually';

  @override
  String get disputeSubtitle => 'Both sides keep their points';

  @override
  String get noCurrentDeal => 'No deal in progress. Start a new one.';

  @override
  String get chooseContractButton => 'Pick a contract';

  @override
  String pointsDelta(int points) {
    return '+$points points';
  }

  @override
  String get splitTitle => 'Split';

  @override
  String contractWithLabel(String contract) {
    return 'Contract: $contract';
  }

  @override
  String expectedTotalLabel(int total, int max) {
    return 'Expected total: $total • Max per team: $max';
  }

  @override
  String get ourScoreLabel => 'Our score';

  @override
  String get theirScoreLabel => 'Their score';

  @override
  String get invertTooltip => 'Swap';

  @override
  String get invalidValues => 'Invalid values';

  @override
  String sumMustBeLabel(int expected, int actual) {
    return 'The sum must be $expected (entered: $actual)';
  }

  @override
  String maxPerTeamLabel(int max) {
    return 'Max per team: $max points';
  }

  @override
  String get validate => 'VALIDATE';

  @override
  String get dealsHistoryTitle => 'Deals history';

  @override
  String get noDealsRecorded => 'No deals recorded for this game.';

  @override
  String get noGameInProgress => 'No game in progress.';

  @override
  String get backTooltip => 'Back';

  @override
  String get resultWon => 'We won';

  @override
  String get resultLost => 'They won';

  @override
  String get resultSplit => 'Split';

  @override
  String get resultDispute => 'Dispute';

  @override
  String get resultPending => 'Pending';

  @override
  String get tieTooltip => 'Tie applied (miara miakatra)';

  @override
  String dealSubtitle(String date, String result, int ours, int theirs) {
    return '$date • $result • $ours - $theirs';
  }

  @override
  String get infoTitle => 'Information';

  @override
  String get startTime => 'Started';

  @override
  String get dealsCountLabel => 'Deals';

  @override
  String dealsCount(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count deals',
      one: '1 deal',
      zero: 'No deals',
    );
    return '$_temp0';
  }

  @override
  String get ourTeamInfo => 'Our team';

  @override
  String get theirTeamInfo => 'Opponents';

  @override
  String get ourInitialScore => 'Starting score (us)';

  @override
  String get theirInitialScore => 'Starting score (them)';

  @override
  String get targetScore => 'Target score';

  @override
  String get activeRules => 'Active rules';

  @override
  String get yesLabel => 'Yes';

  @override
  String get noLabel => 'No';

  @override
  String stakeAmountLabel(int amount) {
    return 'Yes ($amount Ar)';
  }

  @override
  String get gameOverTitle => 'Game over';

  @override
  String get noFinishedGame => 'No finished game.';

  @override
  String get winner => 'Winner';

  @override
  String get draw => 'Draw';

  @override
  String get gameDate => 'Game date';

  @override
  String get historyButton => 'DEALS HISTORY';

  @override
  String get replayButton => 'PLAY AGAIN';

  @override
  String get newGameButton => 'NEW GAME';

  @override
  String get gamesHistoryTitle => 'History';

  @override
  String get emptyGames => 'No games yet';

  @override
  String get emptyGamesSubtitle => 'Start a new game to see it here.';

  @override
  String gameSummary(int our, int their, int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count deals',
      one: '1 deal',
      zero: '0 deals',
    );
    return 'Score $our - $their • $_temp0';
  }

  @override
  String get historyLoadError => 'Unable to load history';

  @override
  String get historyStorageError => 'Storage unavailable';

  @override
  String get retryAction => 'Retry';

  @override
  String get version => 'Version';

  @override
  String get versionValue => '2.0.0';

  @override
  String get developer => 'Developed by';

  @override
  String get developerValue => 'Solvers 2018';
}
