import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:final_thriving_together/Theme_provider.dart';

class TeamMember {
  final String nameKey;
  final String roleKey;
  final String imagePath;

  TeamMember({
    required this.nameKey,
    required this.roleKey,
    required this.imagePath,
  });
}

class MeetTheTeam extends StatelessWidget {
  final List<TeamMember> teamMembers = [
    TeamMember(
      nameKey: 'mariam',
      roleKey: 'Web',
      imagePath: 'assets/images/Mariam.jpg',
    ),
    TeamMember(
      nameKey: 'yostena',
      roleKey: 'Web',
      imagePath: 'assets/images/Yostena.jpg',
    ),
    TeamMember(
      nameKey: 'karin',
      roleKey: 'Flutter',
      imagePath: 'assets/images/karin.jpg',
    ),
    TeamMember(
      nameKey: 'hazem',
      roleKey: 'AI',
      imagePath: 'assets/images/hazem.jpg',
    ),
    TeamMember(
      nameKey: 'yassa',
      roleKey: 'BackEnd',
      imagePath: 'assets/images/Yassa.jpg',
    ),
    TeamMember(
      nameKey: 'zeyad',
      roleKey: 'Flutter',
      imagePath: 'assets/images/Zeyad.jpg',
    ),
  ];

  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context);
    final appLocalizations = AppLocalizations.of(context)!;
    final isPortrait = MediaQuery.of(context).orientation == Orientation.portrait;

    return Scaffold(
      backgroundColor: themeProvider.isDarkMode ? Colors.black : Color(0xFF4070F4),
      appBar: AppBar(
        title: Text(
          appLocalizations.team,
          style: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 24,
            letterSpacing: 1.2,
          ),
        ),
        centerTitle: true,
        backgroundColor: themeProvider.isDarkMode ? Colors.black : Color(0xFF4070F4),
        elevation: 0,
        flexibleSpace: Container(
          decoration: BoxDecoration(
            gradient: themeProvider.isDarkMode
                ? LinearGradient(
              colors: [Colors.black, Colors.grey[900]!],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            )
                : LinearGradient(
              colors: [Color(0xFF4070F4), Color(0xFF5B8DF5)],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
          ),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: GridView.builder(
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: isPortrait ? 1 : 2,
            crossAxisSpacing: 20.0,
            mainAxisSpacing: 20.0,
            childAspectRatio: isPortrait ? 0.8 : 0.9,
          ),
          itemCount: teamMembers.length,
          itemBuilder: (context, index) {
            return AnimatedTeamMemberCard(
              member: teamMembers[index],
              appLocalizations: appLocalizations,
              index: index,
              themeProvider: themeProvider,
            );
          },
        ),
      ),
    );
  }
}

class AnimatedTeamMemberCard extends StatefulWidget {
  final TeamMember member;
  final AppLocalizations appLocalizations;
  final int index;
  final ThemeProvider themeProvider;

  const AnimatedTeamMemberCard({
    required this.member,
    required this.appLocalizations,
    required this.index,
    required this.themeProvider,
  });

  @override
  _AnimatedTeamMemberCardState createState() => _AnimatedTeamMemberCardState();
}

class _AnimatedTeamMemberCardState extends State<AnimatedTeamMemberCard>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _scaleAnimation;
  late Animation<double> _opacityAnimation;
  bool _isHovered = false;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: Duration(milliseconds: 500 + (widget.index * 100)),
    );

    _scaleAnimation = Tween<double>(begin: 0.95, end: 1.0).animate(
      CurvedAnimation(
        parent: _controller,
        curve: Curves.easeOutBack,
      ),
    );

    _opacityAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _controller,
        curve: Curves.easeIn,
      ),
    );

    // Start animation after a small delay based on index for staggered effect
    Future.delayed(Duration(milliseconds: widget.index * 100), () {
      if (mounted) {
        _controller.forward();
      }
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  String _getLocalizedName(String key) {
    switch (key) {
      case 'mariam':
        return widget.appLocalizations.mariam_team;
      case 'yostena':
        return widget.appLocalizations.yostena_team;
      case 'karin':
        return widget.appLocalizations.karin_team;
      case 'hazem':
        return widget.appLocalizations.hazem_team;
      case 'yassa':
        return widget.appLocalizations.yassa_team;
      case 'zeyad':
        return widget.appLocalizations.zeyad_team;
      default:
        return key;
    }
  }

  String _getLocalizedRole(String key) {
    switch (key) {
      case 'Web':
        return widget.appLocalizations.web_team;
      case 'Flutter':
        return widget.appLocalizations.flutter_team;
      case 'AI':
        return widget.appLocalizations.ai_team;
      case 'BackEnd':
        return widget.appLocalizations.back_team;
      default:
        return key;
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return MouseRegion(
      onEnter: (_) => setState(() => _isHovered = true),
      onExit: (_) => setState(() => _isHovered = false),
      child: AnimatedBuilder(
        animation: _controller,
        builder: (context, child) {
          return Transform.scale(
            scale: _isHovered ? 1.03 : _scaleAnimation.value,
            child: Opacity(
              opacity: _opacityAnimation.value,
              child: child,
            ),
          );
        },
        child: Card(
          elevation: _isHovered ? 8 : 4,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          color: widget.themeProvider.isDarkMode
              ? Colors.grey[900]
              : Colors.white,
          shadowColor: widget.themeProvider.isDarkMode
              ? Colors.blueGrey[800]
              : Colors.blue[200],
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              // Team member image with animated border
              Padding(
                padding: const EdgeInsets.all(12.0),
                child: AnimatedContainer(
                  duration: Duration(milliseconds: 300),
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    border: Border.all(
                      color: _isHovered
                          ? widget.themeProvider.isDarkMode
                          ? Colors.blue[400]!
                          : Color(0xFF4070F4)
                          : Colors.transparent,
                      width: _isHovered ? 3 : 0,
                    ),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.1),
                        blurRadius: 10,
                        spreadRadius: 2,
                        offset: Offset(0, 4),
                      )
                    ],
                  ),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(100),
                    child: Image.asset(
                      widget.member.imagePath,
                      height: 150,
                      width: 150,
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
              ),

              // Animated divider
              AnimatedContainer(
                duration: Duration(milliseconds: 300),
                width: _isHovered ? 120 : 80,
                height: 2,
                margin: EdgeInsets.symmetric(vertical: 8),
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [
                      widget.themeProvider.isDarkMode
                          ? Colors.blue[400]!
                          : Color(0xFF4070F4),
                      widget.themeProvider.isDarkMode
                          ? Colors.blue[200]!
                          : Colors.lightBlue[200]!,
                    ],
                  ),
                  borderRadius: BorderRadius.circular(2),
                ),
              ),

              // Team member name with fancy text
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16.0),
                child: Text(
                  _getLocalizedName(widget.member.nameKey),
                  style: theme.textTheme.titleLarge?.copyWith(
                    fontWeight: FontWeight.bold,
                    color: widget.themeProvider.isDarkMode
                        ? Colors.white
                        : Colors.black,
                    letterSpacing: 0.5,
                    shadows: _isHovered
                        ? [
                      Shadow(
                        color: widget.themeProvider.isDarkMode
                            ? Colors.blue[400]!.withOpacity(0.3)
                            : Color(0xFF4070F4).withOpacity(0.3),
                        blurRadius: 10,
                        offset: Offset(0, 2),
                      )
                    ]
                        : null,
                  ),
                  textAlign: TextAlign.center,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ),

              // Team member role with animated styling
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: AnimatedDefaultTextStyle(
                  duration: Duration(milliseconds: 300),
                  style: theme.textTheme.titleMedium!.copyWith(
                    color: _isHovered
                        ? (widget.themeProvider.isDarkMode
                        ? Colors.blue[200]
                        : Color(0xFF5B8DF5))
                        : (widget.themeProvider.isDarkMode
                        ? Colors.grey[400]
                        : Colors.grey[600]),
                    fontWeight: _isHovered ? FontWeight.w600 : FontWeight.normal,
                    fontStyle: _isHovered ? FontStyle.italic : FontStyle.normal,
                  ),
                  child: Text(
                    _getLocalizedRole(widget.member.roleKey),
                    textAlign: TextAlign.center,
                  ),
                ),
              ),

              // Animated "View Profile" button
              /*AnimatedContainer(
                duration: Duration(milliseconds: 300),
                margin: EdgeInsets.only(top: 8, bottom: 16),
                padding: EdgeInsets.symmetric(horizontal: 24, vertical: 8),
                decoration: BoxDecoration(
                  gradient: _isHovered
                      ? LinearGradient(
                    colors: [
                      widget.themeProvider.isDarkMode
                          ? Colors.blue[700]!
                          : Color(0xFF4070F4),
                      widget.themeProvider.isDarkMode
                          ? Colors.blue[500]!
                          : Color(0xFF5B8DF5),
                    ],
                  )
                      : null,
                  color: _isHovered
                      ? null
                      : (widget.themeProvider.isDarkMode
                      ? Colors.grey[800]
                      : Colors.grey[100]),
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(
                    color: widget.themeProvider.isDarkMode
                        ? Colors.blue[400]!
                        : Color(0xFF4070F4),
                    width: _isHovered ? 0 : 1,
                  ),
                ),
                child: Text(
                  widget.appLocalizations.view_profile,
                  style: TextStyle(
                    color: _isHovered
                        ? Colors.white
                        : (widget.themeProvider.isDarkMode
                        ? Colors.blue[200]
                        : Color(0xFF4070F4)),
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),*/
            ],
          ),
        ),
      ),
    );
  }
}