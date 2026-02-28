import 'package:earnwise_app/core/constants/constants.dart';
import 'package:earnwise_app/presentation/features/conversations/views/pending_calls_view.dart';
import 'package:earnwise_app/presentation/features/conversations/views/upcoming_calls_view.dart';
import 'package:earnwise_app/presentation/styles/textstyle.dart';
import 'package:flutter/material.dart';

class ViewUpcomingCallsScreen extends StatefulWidget {
  const ViewUpcomingCallsScreen({super.key});

  @override
  State<ViewUpcomingCallsScreen> createState() => _ViewUpcomingCallsScreenState();
}

class _ViewUpcomingCallsScreenState extends State<ViewUpcomingCallsScreen> {
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      top: false,
      bottom: true,
      child: Scaffold(
        appBar: AppBar(
          centerTitle: true,
          title: Text(
            "All Upcoming Calls",
            style: TextStyles.largeBold
          ),
        ),
        body: Padding(
          padding: EdgeInsets.only(bottom: config.sh(10)),
          child: UpcomingCallsView(
            isExpertView: true,
          ),
        )
      ),
    );
  }
}