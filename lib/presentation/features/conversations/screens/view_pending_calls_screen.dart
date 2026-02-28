import 'package:earnwise_app/core/constants/constants.dart';
import 'package:earnwise_app/presentation/features/conversations/views/pending_calls_view.dart';
import 'package:earnwise_app/presentation/styles/textstyle.dart';
import 'package:flutter/material.dart';

class ViewPendingCallsScreen extends StatefulWidget {
  const ViewPendingCallsScreen({super.key});

  @override
  State<ViewPendingCallsScreen> createState() => _ViewPendingCallsScreenState();
}

class _ViewPendingCallsScreenState extends State<ViewPendingCallsScreen> {
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      top: false,
      bottom: true,
      child: Scaffold(
        appBar: AppBar(
          centerTitle: true,
          title: Text(
            "All Pending Calls",
            style: TextStyles.largeBold
          ),
        ),
        body: Padding(
          padding: EdgeInsets.only(bottom: config.sh(10)),
          child: PendingCallsView(
            isExpertView: true,
          ),
        )
      ),
    );
  }
}