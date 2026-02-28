import 'package:earnwise_app/presentation/features/conversations/screens/expert_conversations_screen.dart';
import 'package:earnwise_app/presentation/features/home/screens/expert_home_screen.dart';
import 'package:earnwise_app/presentation/features/settings/screens/expert_settings_screen.dart';
import 'package:earnwise_app/presentation/features/expert/screens/expert_posts_screen.dart';
import 'package:earnwise_app/presentation/styles/textstyle.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class ExpertDashboardScreen extends StatefulWidget {
  const ExpertDashboardScreen({super.key});

  @override
  State<ExpertDashboardScreen> createState() => _ExpertDashboardScreenState();
}

class _ExpertDashboardScreenState extends State<ExpertDashboardScreen> {

  final PageController _pageController = PageController();

  int _currentIndex = 0;

  void _onPageChanged(int index) {
    setState(() {
      _currentIndex = index;
    });
    _pageController.jumpToPage(index);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: PageView(
        onPageChanged: _onPageChanged,
        controller: _pageController,
        physics: const NeverScrollableScrollPhysics(),
        children: [
          ExpertHomeScreen(),
          ExpertConversationsScreen(),
          ExpertPostsScreen(),
          ExpertSettingsScreen(),
        ],
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentIndex,
        onTap: _onPageChanged,
        showSelectedLabels: true,
        showUnselectedLabels: true,
        selectedLabelStyle: TextStyles.mediumRegular,
        unselectedLabelStyle: TextStyles.mediumRegular,
        items: [
          BottomNavigationBarItem(
            icon: Icon(FontAwesomeIcons.house, size: 20,),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: Icon(FontAwesomeIcons.message, size: 20,),
            label: 'Connects',
          ),
          BottomNavigationBarItem(
            icon: Icon(FontAwesomeIcons.penToSquare, size: 20,),
            label: 'Posts',
          ),
          BottomNavigationBarItem(
            icon: Icon(FontAwesomeIcons.user, size: 20,),
            label: 'Settings',
          ),
        ],
      ),
    );
  }
}