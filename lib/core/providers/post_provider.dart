import 'package:earnwise_app/core/di/di.dart';
import 'package:earnwise_app/core/utils/navigator.dart';
import 'package:earnwise_app/core/utils/toast.dart';
import 'package:earnwise_app/domain/dto/create_post_dto.dart';
import 'package:earnwise_app/domain/models/comment_model.dart';
import 'package:earnwise_app/domain/models/post_model.dart';
import 'package:earnwise_app/domain/repositories/post_repository.dart';
import 'package:earnwise_app/main.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/legacy.dart';

final postNotifier = ChangeNotifierProvider((ref) => PostProvider());

class PostProvider extends ChangeNotifier {
  late final PostRepository postRepository;

  PostProvider() {
    postRepository = di.get();
  }

  bool _isLoading = false;
  bool get isLoading => _isLoading;

  List<PostModel> _posts = [];
  List<PostModel> get posts => _posts;

  List<CommentModel> _comments = [];
  List<CommentModel> get comments => _comments;

  bool _isPostCommentsLoading = false;
  bool get isPostCommentsLoading => _isPostCommentsLoading;

  bool _isRecommendedPostsLoading = false;
  bool get isRecommendedPostsLoading => _isRecommendedPostsLoading;

  List<PostModel> _recommendedPosts = [];
  List<PostModel> get recommendedPosts => _recommendedPosts;

  Future<void> getRecommendedPosts() async {
    _isRecommendedPostsLoading = true;
    notifyListeners();

    final result = await postRepository.getRecommendedPosts();
    result.fold(
      (success) {
        _isRecommendedPostsLoading = false;
        _recommendedPosts = success;
        notifyListeners();
      },
      (failure) {
        _isRecommendedPostsLoading = false;
        _recommendedPosts = [];
        notifyListeners();
        logger.e("Get recommended posts failed: $failure");
        showErrorToast(failure);
      }
    );
  }

  Future<void> getMyPosts() async {
    _isLoading = true;
    notifyListeners();

    final result = await postRepository.getMyPosts();
    result.fold(
      (success) {
        _isLoading = false;
        _posts = success;
        notifyListeners();
      },
      (failure) {
        _isLoading = false;
        notifyListeners();
        logger.e("Get my posts failed: $failure");
        showErrorToast(failure);
      }
    );
  }

  Future<void> getPostComments({required String postId}) async {
    _comments = [];
    _isPostCommentsLoading = true;
    notifyListeners();

    final result = await postRepository.getPostComments(postId: postId);
    result.fold(
      (success) {
        _comments = success;
        _isPostCommentsLoading = false;
        notifyListeners();
      },
      (failure) {
        _isPostCommentsLoading = false;
        _comments = [];
        notifyListeners();
        logger.e("Get post comments failed: $failure");
        showErrorToast(failure);
      }
    );
  }

  Future<void> createPost({required CreatePostDto createPostDto}) async {
    _isLoading = true;
    notifyListeners();

    final result = await postRepository.createPost(createPostDto: createPostDto);
    result.fold(
      (success) async {
        getMyPosts();
        _isLoading = false;
        notifyListeners();
        pop();
        showSuccessToast("Post created successfully");
      },
      (failure) {
        _isLoading = false;
        notifyListeners();
        logger.e("Create post failed: $failure");
        showErrorToast(failure);
      }
    );
  }

  Future<void> commentOnPost({required String postId, required String comment}) async {
    _isLoading = true;
    notifyListeners();

    final result = await postRepository.commentOnPost(postId: postId, comment: comment);
    result.fold(
      (success) {
        _isLoading = false;
        notifyListeners();
        
        _comments.add(CommentModel.fromJson(success.data['data']));
        final postIndex = _posts.indexWhere((post) => post.id == postId);
        if (postIndex != -1) {
          final currentCount = _posts[postIndex].commentsCount ?? 0;
          _posts[postIndex].commentsCount = currentCount + 1;
          notifyListeners();
        }
        showSuccessToast("Comment added successfully");

      },
      (failure) {
        _isLoading = false;
        notifyListeners();
        logger.e("Comment on post failed: $failure");
        showErrorToast(failure);
      }
    );
  }
}