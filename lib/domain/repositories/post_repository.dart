import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';
import 'package:earnwise_app/domain/dto/create_post_dto.dart';
import 'package:earnwise_app/domain/models/comment_model.dart';
import 'package:earnwise_app/domain/models/post_model.dart';

abstract class PostRepository {
  Future<Either<List<PostModel>, String>> getMyPosts();
  Future<Either<List<PostModel>, String>> getRecommendedPosts();
  Future<Either<List<CommentModel>, String>> getPostComments({required String postId});
  Future<Either<Response, String>> createPost({required CreatePostDto createPostDto});
  Future<Either<Response, String>> commentOnPost({required String postId, required String comment});
}