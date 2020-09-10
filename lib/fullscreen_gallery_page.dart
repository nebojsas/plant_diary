import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:plant_diary/bloc/image_bloc.dart';
import 'package:plant_diary/bloc/model/image.dart';
import 'package:plant_diary/bloc/model/plant.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:plant_diary/bloc/plants_bloc.dart';

class FullscreenGalleryPage extends StatefulWidget {
  FullscreenGalleryPage(this.plant, {this.initialImage});

  final Plant plant;
  final PlantImage initialImage;

  @override
  _FullscreenGalleryPageState createState() =>
      _FullscreenGalleryPageState(plant, initialImage: initialImage);
}

class _FullscreenGalleryPageState extends State<FullscreenGalleryPage> {
  final Plant plant;
  final PlantImage initialImage;

  _FullscreenGalleryPageState(this.plant, {this.initialImage});

  @override
  Widget build(Object context) {
    return BlocBuilder<ImageBloc, ImageState>(builder: (context, state) {
      return StreamBuilder(
        stream:
            context.bloc<ImageBloc>().plantsRepo.plantImagesStream(plant.id),
        builder: (context, asyncSnapshot) {
          if (!asyncSnapshot.hasData)
            return Center(child: CircularProgressIndicator());
          final List<PlantImage> images = asyncSnapshot.data;
          final int initialIndex =
              images.indexWhere((element) => element.id == initialImage?.id);
          final controller = PageController(initialPage: initialIndex);
          return Scaffold(
            backgroundColor: Colors.black,
            appBar: AppBar(
              backgroundColor: Colors.transparent,
              actions: [
                IconButton(
                    icon: Icon(MdiIcons.deleteOutline), onPressed: () {
                      context.bloc<ImageBloc>().deletePhoto(plant.id, images[controller.page.toInt()].id, images[controller.page.toInt()].filePath);
                      Navigator.of(context).pop();
                    }),
                IconButton(
                    icon: Icon(MdiIcons.flowerTulipOutline), onPressed: () {
                      context.bloc<PlantsBloc>().updatePlantProfileImage(plant, images[controller.page.toInt()].url);
                    }),
              ],
            ),
            body: PageView.builder(
              itemCount: images.length,
              controller: controller,
              itemBuilder: (context, index) => Hero(
                tag: images[index].id,
                child: CachedNetworkImage(
                  placeholder: (context, url) => CircularProgressIndicator(),
                  imageUrl: images[index].url,
                  fit: BoxFit.fitWidth,
                ),
              ),
            ),
          );
        },
      );
    });
  }
}
