import 'package:final_thriving_together/pages/meet_team.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:final_thriving_together/Theme_provider.dart';
import 'loading_screen.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';


class SettingsPage extends StatefulWidget {
  const SettingsPage({super.key});
  // ignore: unused_element
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
  _SettingsPageState createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
  
  //String _selectedLanguage = 'English';

  //final List<String> _languages = ['English', 'Arabic'];
  

  void _logout() {
    // Add your logout logic here
    Navigator.pushReplacementNamed(context, '/login'); // Redirect to login page
  }

  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context);
    final appLocalizations = AppLocalizations.of(context)!;
    return Scaffold(
      appBar: AppBar(
        title: Text(appLocalizations.settingsPageTitle),
        centerTitle: true,
        backgroundColor: themeProvider.isDarkMode ? Colors.grey[900] : Color(0xFF4070F4),
      ),
      body: ListView(
        padding: const EdgeInsets.all(16.0),
        children: [
          // Profile Settings
          // Theme (Dark Mode)
          SwitchListTile(
            title: Text(appLocalizations.darkMode),
            value: themeProvider.isDarkMode,
            onChanged: (value) {
              themeProvider.toggleTheme(value);
              // Add logic to switch between light and dark themes
            },
            secondary: const Icon(Icons.dark_mode, color: Color(0xFF4070F4)),
          ),

          const Divider(),

          // Language
          ListTile(
          leading: Icon(Icons.language, color: Color(0xFF4070F4)),
          title: Text(appLocalizations.language),
          trailing: DropdownButton<Locale>(
            value: themeProvider.currentLocale,
            onChanged: (Locale? newLocale) {
              themeProvider.setLocale(newLocale!);
            },
            items: [
              DropdownMenuItem(
                value: Locale('en'),
                child: Text('English'),
              ),
              DropdownMenuItem(
                value: Locale('ar'),
                child: Text('العربية'),
              ),
            ],
          ),
        ),
          const Divider(),
          //Meet The Team Page
          ListTile(
            leading: Icon(Icons.people , color:Color(0xFF4070F4)),
            title: Text(appLocalizations.meet_the_team_title),
            onTap: (){
              Navigator.push(context, MaterialPageRoute(builder: (context) => MeetTheTeam()));
            },
          ),
          const Divider(),
          // Logout
          ListTile(
            leading: const Icon(Icons.logout, color: Colors.red),
            title: Text(appLocalizations.logout, style: TextStyle(color: Colors.red)),
            onTap:_logout,
          ),
        ],
      ),
    );
  }
}