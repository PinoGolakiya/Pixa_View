class ImageData {
  final String imageUrl;
  final int likes;
  final int views;

  ImageData({
    required this.imageUrl,
    required this.likes,
    required this.views,
  });

  factory ImageData.fromJson(Map<String, dynamic> json) {
    return ImageData(
      imageUrl: json['webformatURL'],
      likes: json['likes'],
      views: json['views'],
    );
  }
}
