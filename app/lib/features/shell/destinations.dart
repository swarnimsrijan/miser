import 'package:material_ui/material_ui.dart';

class AppDestination {
  const AppDestination(this.path, this.label, this.icon, this.selectedIcon);

  final String path;
  final String label;
  final IconData icon;
  final IconData selectedIcon;
}

const homeDest = AppDestination('/', 'Home', Icons.dashboard_outlined, Icons.dashboard);
const accountsDest = AppDestination(
    '/accounts', 'Accounts', Icons.account_balance_outlined, Icons.account_balance);
const uploadDest =
    AppDestination('/upload', 'Upload', Icons.upload_file_outlined, Icons.upload_file);
const transactionsDest = AppDestination(
    '/transactions', 'Transactions', Icons.receipt_long_outlined, Icons.receipt_long);
const budgetsDest =
    AppDestination('/budgets', 'Budgets', Icons.pie_chart_outline, Icons.pie_chart);
const goalsDest = AppDestination('/goals', 'Goals', Icons.flag_outlined, Icons.flag);
const plannerDest =
    AppDestination('/planner', 'Planner', Icons.insights_outlined, Icons.insights);
const recurringDest =
    AppDestination('/recurring', 'Recurring', Icons.autorenew_outlined, Icons.autorenew);
const profileDest =
    AppDestination('/profile', 'Profile', Icons.person_outline, Icons.person);
const moreDest = AppDestination('/more', 'More', Icons.more_horiz, Icons.more_horiz);

/// Everything, shown on the navigation rail (tablet / web).
const allDestinations = [
  homeDest,
  accountsDest,
  uploadDest,
  transactionsDest,
  budgetsDest,
  goalsDest,
  plannerDest,
  recurringDest,
  profileDest,
];

/// Bottom navigation on phones; the rest live under "More".
const phoneDestinations = [homeDest, transactionsDest, uploadDest, budgetsDest, moreDest];
const moreDestinations = [accountsDest, goalsDest, plannerDest, recurringDest, profileDest];

/// Width at which we switch from a bottom bar to a navigation rail.
const railBreakpoint = 840.0;
