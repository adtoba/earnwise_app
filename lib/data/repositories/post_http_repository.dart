import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';
import 'package:earnwise_app/core/constants/endpoints.dart';
import 'package:earnwise_app/core/utils/error_util.dart';
import 'package:earnwise_app/data/services/api_service.dart';
import 'package:earnwise_app/domain/dto/create_post_dto.dart';
import 'package:earnwise_app/domain/models/comment_model.dart';
import 'package:earnwise_app/domain/models/post_model.dart';
import 'package:earnwise_app/domain/repositories/post_repository.dart';
import 'package:earnwise_app/main.dart';

class PostHttpRepository extends ApiService implements PostRepository {
  @override
  Future<Either<List<PostModel>, String>> getMyPosts() async {
    try {
      final response = await http.get(Endpoints.posts);
      return left((response.data["data"] as List<dynamic>).map((e) => PostModel.fromJson(e)).toList());
    } on DioException catch (e) {
      String error = ErrorUtil.parseDioError(e);
      return right(error);
    } catch (e) {
      return right(e.toString());
    }
  }

  @override
  Future<Either<List<PostModel>, String>> getRecommendedPosts() async {
    try {
      final response = await http.get("${Endpoints.posts}/recommended");
      return left((response.data["data"] as List<dynamic>).map((e) => PostModel.fromJson(e)).toList());
    } on DioException catch (e) {
      String error = ErrorUtil.parseDioError(e);
      return right(error);
    } catch (e) {
      return right(e.toString());
    }
  }

  @override
  Future<Either<List<CommentModel>, String>> getPostComments({required String postId}) async {
    try {
      final response = await http.get(Endpoints.postComments(postId));
      return left((response.data["data"] as List<dynamic>).map((e) => CommentModel.fromJson(e)).toList());
    } on DioException catch (e) {
      String error = ErrorUtil.parseDioError(e);
      return right(error);
    } catch (e) {
      return right(e.toString());
    }
  }
  
  @override
  Future<Either<Response, String>> createPost({required CreatePostDto createPostDto}) async {
    try {
      final response = await http.post(Endpoints.posts, data: createPostDto.toJson());
      return left(response);
    } on DioException catch (e) {
      String error = ErrorUtil.parseDioError(e);
      return right(error);
    } catch (e) {
      return right(e.toString());
    }
  }

  @override
  Future<Either<Response, String>> commentOnPost({required String postId, required String comment}) async {
    try {
      final response = await http.post("/posts/comments", data: {
        "post_id": postId,
        "comment": comment,
      });
      return left(response);
    } on DioException catch (e) {
      String error = ErrorUtil.parseDioError(e);
      return right(error);
    } catch (e) {
      return right(e.toString());
    }
  }
}