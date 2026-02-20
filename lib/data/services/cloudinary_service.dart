import 'package:cloudinary_public/cloudinary_public.dart';
import 'package:earnwise_app/main.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

class CloudinaryService {
  static final cloudinary = CloudinaryPublic(
    dotenv.env['CLOUDINARY_CLOUD_NAME'] ?? "", 
    dotenv.env['CLOUDINARY_UPLOAD_PRESET'] ?? "", 
    cache: false
  );

  static Future<String?> uploadImage({String? imagePath}) async {
    try {
      CloudinaryResponse response = await cloudinary.uploadFile(
        CloudinaryFile.fromFile(imagePath!, resourceType: CloudinaryResourceType.Image)
      );
      
      return response.secureUrl;
    } on CloudinaryException catch (e) {
      logger.e(e.message);
      return null;
    }
  } 

  static Future<String?> uploadAudio({String? audioPath}) async {
    try {
      CloudinaryResponse response = await cloudinary.uploadFile(
        CloudinaryFile.fromFile(audioPath!, folder: "audio_files")
      );
      return response.secureUrl;
    } on CloudinaryException catch (e) {
      logger.e(e.message);
      return null;
    }
  }
}