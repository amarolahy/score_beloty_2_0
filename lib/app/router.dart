import 'package:go_router/go_router.dart';

import '../features/game/presentation/screens/about_screen.dart';
import '../features/game/presentation/screens/choose_contract_screen.dart';
import '../features/game/presentation/screens/current_deal_screen.dart';
import '../features/game/presentation/screens/deals_history_screen.dart';
import '../features/game/presentation/screens/game_info_screen.dart';
import '../features/game/presentation/screens/game_over_screen.dart';
import '../features/game/presentation/screens/games_history_screen.dart';
import '../features/game/presentation/screens/home_shell.dart';
import '../features/game/presentation/screens/new_game_screen.dart';

class AppRoutes {
  static const String newGame = '/new-game';
  static const String chooseContract = '/choose-contract';
  static const String currentDeal = '/current-deal';
  static const String gamesHistory = '/games-history';
  static const String about = '/about';
  static const String gameOver = '/game-over';
  static const String dealsHistory = '/deals-history';
  static const String gameInfo = '/game-info';
}

GoRouter buildRouter() {
  return GoRouter(
    initialLocation: AppRoutes.newGame,
    routes: [
      ShellRoute(
        builder: (context, state, child) => HomeShell(child: child),
        routes: [
          GoRoute(
            path: AppRoutes.newGame,
            pageBuilder: (context, state) =>
                const NoTransitionPage(child: NewGameScreen()),
          ),
          GoRoute(
            path: AppRoutes.chooseContract,
            pageBuilder: (context, state) =>
                const NoTransitionPage(child: ChooseContractScreen()),
          ),
          GoRoute(
            path: AppRoutes.currentDeal,
            pageBuilder: (context, state) =>
                const NoTransitionPage(child: CurrentDealScreen()),
          ),
          GoRoute(
            path: AppRoutes.gamesHistory,
            pageBuilder: (context, state) =>
                const NoTransitionPage(child: GamesHistoryScreen()),
          ),
          GoRoute(
            path: AppRoutes.about,
            pageBuilder: (context, state) =>
                const NoTransitionPage(child: AboutScreen()),
          ),
        ],
      ),
      GoRoute(
        path: '/game-info',
        builder: (context, state) => const GameInfoScreen(),
      ),
      GoRoute(
        path: '/game-over',
        builder: (context, state) => const GameOverScreen(),
      ),
      GoRoute(
        path: '/deals-history',
        builder: (context, state) => const DealsHistoryScreen(),
      ),
    ],
  );
}
