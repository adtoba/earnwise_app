import 'package:earnwise_app/core/di/di.dart';
import 'package:earnwise_app/core/utils/toast.dart';
import 'package:earnwise_app/domain/models/review_model.dart';
import 'package:earnwise_app/domain/repositories/review_repository.dart';
import 'package:earnwise_app/main.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/legacy.dart';

final reviewNotifier = ChangeNotifierProvider((ref) => ReviewProvider());

class ReviewProvider extends ChangeNotifier{
  late final ReviewRepository reviewRepository;

  ReviewProvider() {
    reviewRepository = di.get();
  }

  bool _isLoading = false;
  bool get isLoading => _isLoading;

  bool _isExpertReviewsLoading = false;
  bool get isExpertReviewsLoading => _isExpertReviewsLoading;

  List<ReviewModel> _myReviews = [];
  List<ReviewModel> get myReviews => _myReviews;

  List<ReviewModel> _expertReviews = [];
  List<ReviewModel> get expertReviews => _expertReviews;

  Future<void> getExpertReviews({required String expertId}) async {
    _isExpertReviewsLoading = true;
    notifyListeners();

    final result = await reviewRepository.getExpertReviews(expertId: expertId);
    result.fold(
      (success) {
        _isExpertReviewsLoading = false;
        _expertReviews = (success.data["data"] as List<dynamic>).map((e) => ReviewModel.fromJson(e)).toList();
        notifyListeners();
      },
      (failure) {
        _isExpertReviewsLoading = false;
        notifyListeners();
        logger.e("Get expert reviews failed: $failure");
        showErrorToast(failure);
      }
    );
  }

  Future<void> addReview({required String expertId, required String userId, required String comment, required String fullName, required double rating}) async {
    _isLoading = true;
    notifyListeners();

    final result = await reviewRepository.addReview(
      expertId: expertId, 
      userId: userId, 
      comment: comment, 
      fullName: fullName, 
      rating: rating
    );
    result.fold(
      (success) {
        _isLoading = false;
        notifyListeners();
        showSuccessToast("Review added successfully");
      },
      (failure) {
        _isLoading = false;
        notifyListeners();
        logger.e("Add review failed: $failure");
        showErrorToast(failure);
      }
    );
  }

  Future<void> getMyReviews() async {
    _isLoading = true;
    notifyListeners();

    final result = await reviewRepository.getMyReviews();
    result.fold(
      (success) {
        _isLoading = false;
        _myReviews = (success.data["data"] as List<dynamic>).map((e) => ReviewModel.fromJson(e)).toList();
        notifyListeners();
      },
      (failure) {
        _isLoading = false;
        notifyListeners();
        logger.e("Get my reviews failed: $failure");
        showErrorToast(failure);
      }
    );
  }
}