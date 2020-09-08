import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:plant_diary/bloc/model/image.dart';

class FullscreenGalleryPage extends StatefulWidget {
  FullscreenGalleryPage(this.data, {this.initialImage});

  final List<PlantImage> data;
  final PlantImage initialImage;

  @override
  _FullscreenGalleryPageState createState() =>
      _FullscreenGalleryPageState(data, initialImage: initialImage);
}

class _FullscreenGalleryPageState extends State<FullscreenGalleryPage> {
  final List<PlantImage> data;
  final PlantImage initialImage;

  _FullscreenGalleryPageState(this.data, {this.initialImage});

  @override
  Widget build(Object context) {
    final int initialIndex =
        data.indexWhere((element) => element.id == initialImage?.id);
    return PageView.builder(
      itemCount: data.length,
      controller: PageController(initialPage: initialIndex),
      itemBuilder: (context, index) => CachedNetworkImage(
        placeholder: (context, url) => CircularProgressIndicator(),
        imageUrl: data[index].url,
        fit: BoxFit.cover,
      ),
    );
  }
}
