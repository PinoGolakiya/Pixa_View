import 'package:get/get.dart';
import 'package:dio/dio.dart';

import '../core/model/image_data_view_model.dart';

class GalleryController extends GetxController {
  var images = <ImageData>[].obs;
  var isLoading = false.obs;
  var searchTerm = ''.obs;
  var page = 1.obs;

  final Dio _dio = Dio();
  /// Pixabay API Key
  final String _apiKey = '39349985-041ac7352a3b05e3057679d40';

  @override
  void onInit() {
    super.onInit();
    loadImages();
  }

  /// Fetch Pixabay API data
  Future<void> loadImages() async {
    if (isLoading.value) return;
    isLoading.value = true;

    try {
      final response = await _dio.get(
        'https://pixabay.com/api/',
        queryParameters: {
          'key': _apiKey,
          'q': searchTerm.value,
          'page': page.value,
          'per_page': 20,
        },
      );
      final data = response.data['hits'] as List;
      if (data.isNotEmpty) {
        images.addAll(data.map((item) => ImageData.fromJson(item)).toList());
        page.value++;
      }
    } catch (e) {
      print(e);
    } finally {
      isLoading.value = false;
      update();
    }
  }

  /// Search images
  void searchImages(String query) {
    searchTerm.value = query;
    page.value = 1;
    images.clear();
    loadImages();
  }
}

