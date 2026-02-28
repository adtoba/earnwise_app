import 'package:earnwise_app/core/providers/review_provider.dart';
import 'package:earnwise_app/core/utils/spacer.dart';
import 'package:earnwise_app/presentation/styles/palette.dart';
import 'package:earnwise_app/presentation/styles/textstyle.dart';
import 'package:earnwise_app/presentation/widgets/primary_button.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';

class RateExpertScreen extends ConsumerStatefulWidget {
  const RateExpertScreen({
    super.key,
    this.expertName,
    this.userName,
    this.expertAvatarUrl,
    this.expertId,
    this.userId,
  });

  final String? expertName;
  final String? userName;
  final String? expertAvatarUrl;
  final String? expertId;
  final String? userId;

  @override
  ConsumerState<RateExpertScreen> createState() => _RateExpertScreenState();
}

class _RateExpertScreenState extends ConsumerState<RateExpertScreen> {
  final TextEditingController _reviewController = TextEditingController();
  double _rating = 0;

  @override
  void dispose() {
    _reviewController.dispose();
    super.dispose();
  }

  bool get _canSubmit =>
      _rating > 0 && _reviewController.text.trim().isNotEmpty;

  @override
  Widget build(BuildContext context) {
    final reviewProvider = ref.watch(reviewNotifier);
    final theme = Theme.of(context);
    final name = widget.expertName ?? 'Expert';

    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Rate your call',
          style: TextStyles.largeBold,
        ),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              CircleAvatar(
                radius: 40,
                backgroundColor: theme.colorScheme.surfaceVariant,
                backgroundImage: widget.expertAvatarUrl?.isNotEmpty == true
                    ? NetworkImage(widget.expertAvatarUrl!)
                    : null,
                child: widget.expertAvatarUrl?.isNotEmpty == true
                    ? null
                    : Text(
                        name.isNotEmpty ? name[0] : 'E',
                        style: theme.textTheme.titleLarge,
                      ),
              ),
              const SizedBox(height: 16),
              Text(
                'How was your session with $name?',
                textAlign: TextAlign.center,
                style: TextStyles.largeBold,
              ),
              const SizedBox(height: 8),
              Text(
                'Your feedback helps improve the experience.',
                textAlign: TextAlign.center,
                style: TextStyles.mediumRegular
              ),
              const SizedBox(height: 24),
              RatingBar.builder(
                initialRating: _rating,
                minRating: 1,
                allowHalfRating: true,
                itemSize: 36,
                itemPadding: const EdgeInsets.symmetric(horizontal: 4),
                itemBuilder: (context, _) => Icon(
                  Icons.star_rounded,
                  color: Palette.ratingStar,
                ),
                onRatingUpdate: (value) {
                  setState(() => _rating = value);
                },
              ),
              const SizedBox(height: 24),
              Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  'Write a review',
                  style: TextStyles.mediumSemiBold,
                ),
              ),
              YMargin(8),
              TextField(
                controller: _reviewController,
                maxLines: 5,
                maxLength: 300,
                onChanged: (_) => setState(() {}),
                decoration: InputDecoration(
                  hintText: 'Share what went well or what can be improved...',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
              ),
              YMargin(20),
              PrimaryButton(
                onPressed: () {
                  if(_canSubmit) {
                    final review = _reviewController.text.trim();
                    reviewProvider.addReview(
                      expertId: widget.expertId ?? "",
                      userId: widget.userId ?? "",
                      comment: review,
                      fullName: name,
                      rating: _rating,
                    );
                  }
                },
                text: 'Submit rating',
              ),
            ],
          ),
        ),
      ),
    );
  }
}
