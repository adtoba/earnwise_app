import 'package:earnwise_app/core/constants/constants.dart';
import 'package:earnwise_app/domain/models/review_model.dart';
import 'package:earnwise_app/presentation/features/home/widgets/review_item.dart';
import 'package:earnwise_app/presentation/styles/palette.dart';
import 'package:flutter/material.dart';

class AllReviewsScreen extends StatefulWidget {
  const AllReviewsScreen({super.key, required this.reviews});

  final List<ReviewModel> reviews;

  @override
  State<AllReviewsScreen> createState() => _AllReviewsScreenState();
}

class _AllReviewsScreenState extends State<AllReviewsScreen> {
  @override
  Widget build(BuildContext context) {
    var brightness = Theme.of(context).brightness;
    bool isDarkMode = brightness == Brightness.dark;
    
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: true,
      ),
      body: ListView.separated(
        padding: EdgeInsets.symmetric(horizontal: config.sw(16), vertical: config.sh(16)),
        itemBuilder: (c, i) => ReviewItem(
          fullName: widget.reviews[i].fullName ?? "",
          rating: widget.reviews[i].rating ?? 0,
          comment: widget.reviews[i].comment ?? "",
          createdAt: widget.reviews[i].createdAt ?? "",
        ), 
        separatorBuilder: (c, i) => Divider(height: config.sh(20), color: isDarkMode ? Palette.borderDark : Palette.borderLight), 
        itemCount: widget.reviews.length
      ),
    );
  }
}