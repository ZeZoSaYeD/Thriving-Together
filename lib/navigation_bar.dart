import 'package:final_thriving_together/pages/home_page.dart';
import 'package:final_thriving_together/pages/loading_screen.dart';
import 'package:final_thriving_together/pages/articles_page.dart';
import 'package:final_thriving_together/pages/diagnoses_page.dart';
import 'package:final_thriving_together/pages/exams_page.dart';
import 'package:final_thriving_together/pages/Settings.dart';
import 'package:final_thriving_together/pages/meet_team.dart';
import 'package:flutter/material.dart';
import 'package:final_thriving_together/Theme_provider.dart';
import 'package:provider/provider.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class Navigationbar extends StatelessWidget {
  final int currentIndex; // Pass the current index from the parent widget

  const Navigationbar({super.key, required this.currentIndex});

  Future<void> _navigateWithLoading(BuildContext context, Widget targetPage) async {
    // Show loading screen
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => LoadingScreen()),
    );

    // Simulate a delay (e.g., fetching data or preparing the target page)
    await Future.delayed(Duration(seconds: 2));

    // Navigate to the target page
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (context) => targetPage),
    );
  }

  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context);
        final appLocalizations = AppLocalizations.of(context)!;
    return BottomNavigationBar(
      type: BottomNavigationBarType.fixed, // Ensure all labels are visible
      backgroundColor: themeProvider.isDarkMode ? Colors.black : Color(0xFF4070F4), // Set the background color for the entire bar
      selectedItemColor: Colors.white, // Color for the selected item
      unselectedItemColor: Colors.white.withOpacity(0.6), // Color for unselected items
      currentIndex: currentIndex, // Use the current index passed from the parent
      onTap: (index) {
        // Navigate to the corresponding page with loading screen
        switch (index) {
          case 0:
            _navigateWithLoading(context, HomePage(username:'zeyad',password: '12345')); // Replace HomePage() with your actual home page widget
            break;
          case 1:
            _navigateWithLoading(context, Articlespage()); // Replace ArticlesPage() with your actual articles page widget
            break;
          case 2:
            _navigateWithLoading(context, Diagnosespage()); // Replace DiagnosesPage() with your actual diagnoses page widget
            break;
          case 3:
            _navigateWithLoading(context, Examspage()); // Replace ExamsPage() with your actual exams page widget
            break;
          case 4:
            _navigateWithLoading(context, SettingsPage()); // Replace SettingsPage() with your actual settings page widget
            break;
          case 5 :
            _navigateWithLoading(context, MeetTheTeam());
        }
      },
      items:  [
        BottomNavigationBarItem(
          icon: Icon(Icons.home),
          label: appLocalizations.homePageTitle,
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.article),
          label: appLocalizations.articlesPageTitle,
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.medical_services),
          label: appLocalizations.diagnosesPageTitle,
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.school),
          label: appLocalizations.exams,
        ),
        /*BottomNavigationBarItem(
            icon: Icon(Icons.people),
        label: appLocalizations.meet_the_team_title),
        */
        BottomNavigationBarItem(
          icon: Icon(Icons.settings),
          label: appLocalizations.settingsPageTitle,
        ),
      ],
    );
  }
}