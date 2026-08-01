// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Malagasy (`mg`).
class AppLocalizationsMg extends AppLocalizations {
  AppLocalizationsMg([String locale = 'mg']) : super(locale);

  @override
  String get appTitle => 'Score Beloty';

  @override
  String get appSubtitle =>
      'Fandraketana ny isa rehefa milalao ny belote malagasy.';

  @override
  String get newGame => 'Lalao vaovao';

  @override
  String get history => 'Ny lalao teo aloha';

  @override
  String get about => 'Momba anay';

  @override
  String get language => 'Fiteny';

  @override
  String get newGameTitle => 'Lalao vaovao';

  @override
  String get newGameSubtitle => 'Ampidiro ny mpilalao sy ny isa fanombohana.';

  @override
  String get ourTeam => 'Ekipantsika';

  @override
  String get theirTeam => 'Ekipan\'ny mpilalao hafa';

  @override
  String get player1 => 'Mpilalao 1';

  @override
  String get player2 => 'Mpilalao 2';

  @override
  String get initialScore => 'Isa fanombohana';

  @override
  String get requiredField => 'Tsy maintsy fenoina';

  @override
  String get invalidScore => 'Isa tsy mety';

  @override
  String get advancedRules => 'Fitsipika manokana';

  @override
  String get defaultRules => 'Fitsipika mahazatra';

  @override
  String get customRules => 'Namboarina';

  @override
  String get startButton => 'ATOMBOHY';

  @override
  String get ruleFinalScore => 'Isa kendrena';

  @override
  String get ruleSplitAllTrumps => 'Afaka mizara (TA)';

  @override
  String get ruleSplitNoTrumps => 'Afaka mizara (SA)';

  @override
  String get ruleSplitColor => 'Afaka mizara (Loko)';

  @override
  String get ruleContinueOnTie => 'Miara miakatra (tohizo raha mitovy)';

  @override
  String get ruleStepsOnTie => 'Fisondrotana raha mitovy';

  @override
  String get rulePointIfError => 'Isa raha misy fahadisoana';

  @override
  String get rulePointOnError => 'Isa omena amin\'ny fahadisoana';

  @override
  String get ruleWinIfCapotInside => 'Maharesy raha capot dedans';

  @override
  String get ruleRedoubleNoTrumps => 'Afaka miantso Sans A surcontré';

  @override
  String get ruleBet => 'Asio goûter kely';

  @override
  String get ruleBetAmount => 'Vola apetraka (Ar)';

  @override
  String get ruleDoubleAmountOnCapotScore => 'Mandoa double raha capot';

  @override
  String get contractLabel => 'Kontratra';

  @override
  String get bidLabel => 'Tsenam-barotra';

  @override
  String get capotLabel => 'Capot';

  @override
  String get contractAllTrumps => 'Tout A';

  @override
  String get contractNoTrumps => 'Sans A';

  @override
  String get contractSpades => 'Pique';

  @override
  String get contractHearts => 'Cœur';

  @override
  String get contractDiamonds => 'Carreau';

  @override
  String get contractClubs => 'Trèfle';

  @override
  String get contractError => 'Fahadisoana';

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
  String get bidPass => 'Bonne';

  @override
  String get bidDouble => 'Contré';

  @override
  String get bidRedouble => 'Surcontré';

  @override
  String get capotNone => 'Tsy misy';

  @override
  String get capotCapot => 'Capot';

  @override
  String get capotInside => 'Capot Dedans';

  @override
  String get calculatedStake => 'Vola voakajy';

  @override
  String get splitAllowed => 'Afaka mizara';

  @override
  String pointsUnit(int points) {
    return '$points isa';
  }

  @override
  String get startDealButton => 'ATOMBOHY NY LALAO';

  @override
  String get cancelLastDealButton => 'Atsaharo ny donne farany';

  @override
  String get cancelLastDealDialogTitle => 'Atsaharo ny donne farany';

  @override
  String get cancelLastDealDialogMessage =>
      'Hovonoina ny donne teo aloha. Tohizo ve?';

  @override
  String get backAction => 'Miverina';

  @override
  String get cancelAction => 'Atsaharo';

  @override
  String get okAction => 'OK';

  @override
  String get noCurrentGame => 'Tsy misy lalao ankehitriny';

  @override
  String target(int score) {
    return 'Kendrena: $score';
  }

  @override
  String get dealResultTitle => 'Vokatra ny donne';

  @override
  String get win => 'Naharesy isika';

  @override
  String get lose => 'Naharesy izy ireo';

  @override
  String get splitResult => 'Fizarana';

  @override
  String get litigation => 'Adim-panahy';

  @override
  String get splitSubtitle => 'Ampidiro ny isa amin\'ny tanana';

  @override
  String get litigationSubtitle => 'Ny ekipa tsirairay mitahiry ny isa avy';

  @override
  String get noCurrentDeal => 'Tsy misy donne ankehitriny. Atombohy vaovao.';

  @override
  String get chooseContractButton => 'Fidio kontratra';

  @override
  String pointsDelta(int points) {
    return '+$points isa';
  }

  @override
  String get splitTitle => 'Fizarana';

  @override
  String contractWithLabel(String contract) {
    return 'Kontratra: $contract';
  }

  @override
  String expectedTotalLabel(int total, int max) {
    return 'Vintana tokony ho: $total • Isa ambony indrindra isaky ny ekipa: $max';
  }

  @override
  String get ourScoreLabel => 'Isa antsika';

  @override
  String get theirScoreLabel => 'Isa azy ireo';

  @override
  String get invertTooltip => 'Ampifaninana';

  @override
  String get invalidValues => 'Isa tsy mety';

  @override
  String sumMustBeLabel(int expected, int actual) {
    return 'Tokony ho $expected ny fitambaran\'ny isa (nampidirina: $actual)';
  }

  @override
  String maxPerTeamLabel(int max) {
    return 'Isa ambony indrindra isaky ny ekipa: $max isa';
  }

  @override
  String get validate => 'HAMARINO';

  @override
  String get dealsHistoryTitle => 'Tantaran\'ny donne';

  @override
  String get noDealsRecorded =>
      'Tsy misy donne voatahiry ho an\'ity lalao ity.';

  @override
  String get noGameInProgress => 'Tsy misy lalao ankehitriny.';

  @override
  String get backTooltip => 'Miverina';

  @override
  String get resultWon => 'Naharesy isika';

  @override
  String get resultLost => 'Naharesy izy ireo';

  @override
  String get resultSplit => 'Fizarana';

  @override
  String get resultLitigation => 'Adim-panahy';

  @override
  String get resultPending => 'Mbola ao';

  @override
  String get tieTooltip => 'Mitovy ampiharina (miara miakatra)';

  @override
  String dealSubtitle(String date, String result, int ours, int theirs) {
    return '$date • $result • $ours - $theirs';
  }

  @override
  String get infoTitle => 'Fampahalalana';

  @override
  String get startTime => 'Nanomboka';

  @override
  String get dealsCountLabel => 'Donne';

  @override
  String dealsCount(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count donne',
      one: 'Donne 1',
      zero: 'Tsy misy donne',
    );
    return '$_temp0';
  }

  @override
  String get ourTeamInfo => 'Ekipantsika';

  @override
  String get theirTeamInfo => 'Ekipan\'ny fahavalo';

  @override
  String get ourInitialScore => 'Isa fanombohana (isika)';

  @override
  String get theirInitialScore => 'Isa fanombohana (izy ireo)';

  @override
  String get targetScore => 'Isa kendrena';

  @override
  String get activeRules => 'Fitsipika miasa';

  @override
  String get yesLabel => 'Eny';

  @override
  String get noLabel => 'Tsia';

  @override
  String betAmountLabel(int amount) {
    return 'Eny ($amount Ar)';
  }

  @override
  String get gameOverTitle => 'Tapitra ny lalao';

  @override
  String get noFinishedGame => 'Tsy misy lalao vita.';

  @override
  String get winner => 'Mpandresy';

  @override
  String get draw => 'Mitovy';

  @override
  String get gameDate => 'Andron\'ny lalao';

  @override
  String get historyButton => 'TATARAN\'NY DONNE';

  @override
  String get replayButton => 'MILALAO INDRAY';

  @override
  String get newGameButton => 'LALAO VAOVAO';

  @override
  String get gamesHistoryTitle => 'Tantaran\'ny lalao';

  @override
  String get emptyGames => 'Tsy misy lalao';

  @override
  String get emptyGamesSubtitle =>
      'Atombohy lalao vaovao mba hahitana azy eto.';

  @override
  String gameSummary(int our, int their, int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count donne',
      one: '1 donne',
      zero: '0 donne',
    );
    return 'Isa $our - $their • $_temp0';
  }

  @override
  String get version => 'Version';

  @override
  String get versionValue => '2.0.0';

  @override
  String get developer => 'Namboarin\'ny';

  @override
  String get developerValue => 'Solvers 2018';
}
