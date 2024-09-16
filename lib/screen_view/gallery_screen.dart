import 'dart:async'; // Import this for Timer

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:get/get.dart';
import 'package:pixa_view/core/utils/app_colors.dart';
import 'package:pixa_view/core/utils/app_strings.dart';

import '../controller/gallery_controller.dart';
import 'image_detail_screen.dart';

class GalleryScreen extends StatefulWidget {
  @override
  _GalleryScreenState createState() => _GalleryScreenState();
}

class _GalleryScreenState extends State<GalleryScreen> {
  final GalleryController _controller = Get.put(GalleryController());
  final TextEditingController _searchController = TextEditingController();
  Timer? _debounce;
  final ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(_scrollListener);
  }

  void _onSearchChanged(String value) {
    if (_debounce?.isActive ?? false) _debounce?.cancel();
    _debounce = Timer(const Duration(milliseconds: 500), () {
      _controller.searchImages(value);
    });
  }

  /// Scroll to new data load
  void _scrollListener() {
    if (_scrollController.position.pixels ==
        _scrollController.position.maxScrollExtent) {
      _controller.loadImages();
    }
  }

  @override
  Widget build(BuildContext context) {
    return GetBuilder(
        init: GalleryController(),
        builder: (controller) {
          return Scaffold(
            appBar: AppBar(
              title: const Text(
                AppStrings.pixabayGallery,
                style: TextStyle(
                  color: AppColors.whiteColor,
                  fontSize: 17,
                ),
              ),
              centerTitle: true,
              bottom: PreferredSize(
                preferredSize: const Size.fromHeight(50),
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: TextField(
                    controller: _searchController,
                    decoration: InputDecoration(
                      border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10)),
                      hintText: AppStrings.searchImage,
                    ),
                    onChanged: _onSearchChanged,
                  ),
                ),
              ),
            ),
            body: _controller.isLoading.value
                ? const Center(child: CircularProgressIndicator())
                : Obx(() {
                    // Combine image list and loading indicator
                    final items = List<Widget>.from(
                      _controller.images.map((image) {
                        return Padding(
                          padding: const EdgeInsets.only(
                              left: 5, right: 5, bottom: 5, top: 10),
                          child: GestureDetector(
                            onTap: () {
                              Navigator.of(context).push(
                                PageRouteBuilder(
                                  pageBuilder:
                                      (context, animation, secondaryAnimation) {
                                    return FadeTransition(
                                      opacity: animation,
                                      child: ImageDetailScreen(image: image),
                                    );
                                  },
                                ),
                              );
                            },
                            child: Card(
                              elevation: 4,
                              color: AppColors.whiteColor.withOpacity(0.2),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(15),
                              ),
                              margin: const EdgeInsets.all(4),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  ClipRRect(
                                    borderRadius: const BorderRadius.only(
                                      topLeft: Radius.circular(15),
                                      topRight: Radius.circular(15),
                                    ),
                                    child: CachedNetworkImage(
                                      imageUrl: image.imageUrl,
                                      fit: BoxFit.cover,
                                      height: 150,
                                      width: double.infinity,
                                      placeholder: (context, url) =>
                                          const Center(
                                              child:
                                                  CircularProgressIndicator()),
                                      errorWidget: (context, url, error) =>
                                          const Icon(Icons.error),
                                    ),
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: Text(
                                        '${image.likes} ${AppStrings.likes}'),
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.only(
                                        left: 8.0, bottom: 8.0),
                                    child: Text(
                                        '${image.views} ${AppStrings.views}'),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        );
                      }),
                    );

                    return MasonryGridView.count(
                      crossAxisCount: 2,
                      controller: _scrollController,
                      itemCount: items.length,
                      itemBuilder: (context, index) {
                        return items[index];
                      },
                    );
                  }),
          );
        });
  }

  @override
  void dispose() {
    _debounce?.cancel();
    _searchController.dispose();
    _scrollController.dispose();
    super.dispose();
  }
}
