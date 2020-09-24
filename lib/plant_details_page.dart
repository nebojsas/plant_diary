import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_picker/image_picker.dart';
import 'package:plant_diary/bloc/image_bloc.dart';
import 'package:plant_diary/bloc/model/image.dart';
import 'package:plant_diary/bloc/model/plant.dart';
import 'package:plant_diary/fullscreen_gallery_page.dart';
import 'package:plant_diary/colors.dart';

import 'bloc/plants_bloc.dart';
import 'bloc/plants_state.dart';

import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';

class PlantDetailsPage extends StatefulWidget {
  final String plantId;

  const PlantDetailsPage({
    Key key,
    this.plantId,
  }) : super(key: key);

  @override
  _PlantDetailsPageState createState() => _PlantDetailsPageState();
}

class _PlantDetailsPageState extends State<PlantDetailsPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey.shade100,
      body: BlocBuilder<PlantsBloc, PlantsState>(
        builder: (context, state) {
          print('PlantDetailsPage: state=$state');
          if (state is PlantsStateInit) return Container();
          if (state is PlantsStateLoading) return CircularProgressIndicator();
          if (state is PlantsStateLoaded) {
            return StreamBuilder(
              stream: context.bloc<PlantsBloc>().plantStream(widget.plantId),
              builder: (BuildContext context, AsyncSnapshot<Plant> snapshot) {
                if (snapshot.hasData) {
                  final plant = snapshot.data;
                  print('PlantDetailsPage: ${plant.id}');
                  return CustomScrollView(
                    slivers: [
                      PlantSliverAppBar(plant: plant),
                      SliverSection(title: 'Care'),
                      SliverParameterActionList(plant: plant),
                      SliverSection(title: 'Photos'),
                      SliverToBoxAdapter(
                        child: StreamBuilder<List<PlantImage>>(
                          stream: context
                              .bloc<PlantsBloc>()
                              .plantsRepo
                              .plantImagesStream(plant.id),
                          builder: (BuildContext context,
                              AsyncSnapshot<List<PlantImage>> asyncSnapshot) {
                            print('Snapshot: $asyncSnapshot');
                            if (!asyncSnapshot.hasData) return Placeholder();
                            return Container(
                                padding: EdgeInsets.all(16),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.end,
                                  mainAxisSize: MainAxisSize.max,
                                  children: [
                                    FloatingActionButton.extended(
                                      heroTag: null,
                                      icon: Icon(MdiIcons.camera),
                                      label: Text('Camera'),
                                      onPressed: () {
                                        ImagePicker()
                                            .getImage(
                                                source: ImageSource.camera)
                                            .then((pickedFile) {
                                          print(
                                              'Photo taken at: ${pickedFile.path}');
                                          context.bloc<ImageBloc>().addImage(
                                              pickedFile.path, plant.id);
                                        });
                                      },
                                    ),
                                    FloatingActionButton.extended(
                                      heroTag: null,
                                      icon: Icon(MdiIcons.imageAlbum),
                                      label: Text('File'),
                                      onPressed: () {
                                        ImagePicker()
                                            .getImage(
                                                source: ImageSource.gallery)
                                            .then((pickedFile) {
                                          print(
                                              'Photo taken at: ${pickedFile.path}');
                                          context.bloc<ImageBloc>().addImage(
                                              pickedFile.path, plant.id);
                                        });
                                      },
                                    ),
                                  ],
                                ));
                          },
                        ),
                      ),
                      SliverHorizontalListPhotoGallery(plant: plant),
                      SliverFillRemaining(
                        child: Container(),
                        fillOverscroll: true,
                      ),
                    ],
                  );
                } else {
                  return CircularProgressIndicator();
                }
              },
            );
          } else {
            return Container();
          }
        },
      ),
    );
  }
}

class PlantSliverAppBar extends StatelessWidget {
  const PlantSliverAppBar({
    Key key,
    @required this.plant,
  }) : super(key: key);

  final Plant plant;

  @override
  Widget build(BuildContext context) {
    return SliverAppBar(
      actions: [
        BlocConsumer<PlantsBloc, PlantsState>(
          builder: (context, state) => IconButton(
            icon: Icon(Icons.delete),
            onPressed: () {
              context.bloc<PlantsBloc>().removePlant(plant);
              Navigator.pop(context);
            },
          ),
          listener: (context, state) => {},
        ),
      ],
      expandedHeight: 250.0,
      pinned: true,
      floating: true,
      snap: true,
      flexibleSpace: FlexibleSpaceBar(
          title: Text('${plant.name}',
              style: TextStyle(
                color: Colors.white,
              )),
          background: Container(
            foregroundDecoration: BoxDecoration(
                gradient: LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    colors: [
                  Colors.black38,
                  Colors.transparent,
                  Colors.black38
                ],
                    stops: [
                  0.1,
                  0.5,
                  0.9
                ])),
            child: plant.profileImageUrl?.isNotEmpty != null
                ? Image.network(
                    plant.profileImageUrl,
                    fit: BoxFit.cover,
                  )
                : plant.species.defaultImage?.isNotEmpty != null
                    ? Image.network(
                        plant.species.defaultImage,
                        fit: BoxFit.cover,
                      )
                    : Image.asset(
                        'assets/default_plant.png',
                        fit: BoxFit.contain,
                      ),
          )),
    );
  }
}

class SliverSection extends StatelessWidget {
  const SliverSection({
    Key key,
    @required this.title,
  }) : super(key: key);

  final String title;

  @override
  Widget build(BuildContext context) {
    // return SliverPersistentHeader(delegate: SliverPlantHeaderDelegate(title), pinned: true,);
    return SliverToBoxAdapter(
      child: Container(
          padding: EdgeInsets.all(16),
          child: Text(
            title,
            style: TextStyle(color: PDColors.PRIMARY),
          )),
    );
  }
}

class SliverPlantHeaderDelegate extends SliverPersistentHeaderDelegate {
  final String title;

  SliverPlantHeaderDelegate(this.title);
  @override
  Widget build(
      BuildContext context, double shrinkOffset, bool overlapsContent) {
    return Container(
        color: Colors.white,
        padding: EdgeInsets.all(16),
        child: Text(
          title,
          style: TextStyle(color: PDColors.PRIMARY),
        ));
  }

  @override
  double get maxExtent => 100;

  @override
  double get minExtent => 100;

  @override
  bool shouldRebuild(SliverPersistentHeaderDelegate oldDelegate) => true;
}

class SliverParameterActionList extends StatelessWidget {
  const SliverParameterActionList({
    Key key,
    @required this.plant,
  }) : super(key: key);

  final Plant plant;
  static const String UNKNOWN = 'unknown';

  @override
  Widget build(BuildContext context) {
    return SliverList(
        delegate: SliverChildListDelegate.fixed([
      Card(
        child: ListTile(
          contentPadding: EdgeInsets.symmetric(horizontal: 16),
          title:
              Text(plant.isHappy() ? 'Plant is happy.' : 'Plant is unhappy.'),
          trailing: IconButton(
            icon: plant.isHappy()
                ? Icon(
                    Icons.mood,
                    color: Colors.green,
                  )
                : Icon(
                    Icons.mood_bad,
                    color: Colors.red,
                  ),
            color: !plant.needsWatering() ? Colors.green : Colors.red,
            onPressed: null,
          ),
        ),
      ),
      ListTile(
        contentPadding: EdgeInsets.symmetric(horizontal: 16),
        title: Text(
            '${plant.lastTimeWatered?.difference(DateTime.now())?.abs()?.inDays ?? UNKNOWN} day(s) ago.'),
        leading: Icon(
          MdiIcons.water,
          color: !plant.needsWatering() ? Colors.green : Colors.red,
        ),
        trailing: FloatingActionButton.extended(
          heroTag: null,
          label: Text('Water'),
          icon: Icon(MdiIcons.waterPump),
          onPressed: () {
            context.bloc<PlantsBloc>().waterPlant(plant);
          },
        ),
      ),
      ListTile(
        contentPadding: EdgeInsets.symmetric(horizontal: 16),
        title: Text(
            '${plant.lastTimeFed?.difference(DateTime.now())?.abs()?.inDays ?? UNKNOWN} day(s) ago.'),
        leading: Icon(
          MdiIcons.seed,
          color: !plant.needsFeeding() ? Colors.green : Colors.red,
        ),
        trailing: FloatingActionButton.extended(
          heroTag: null,
          label: Text('Feed'),
          icon: Icon(MdiIcons.seed),
          onPressed: () {
            context.bloc<PlantsBloc>().feedPlant(plant);
          },
        ),
      ),
      ListTile(
        contentPadding: EdgeInsets.symmetric(horizontal: 16, vertical: 4),
        title: Text(
            '${plant.lastTimeRePotted?.difference(DateTime.now())?.abs()?.inDays ?? UNKNOWN} day(s) ago.'),
        leading: Icon(
          MdiIcons.archive,
          color: !plant.needsRePotting() ? Colors.green : Colors.red,
        ),
        trailing: FloatingActionButton.extended(
          heroTag: null,
          label: Text('Repot'),
          icon: Icon(MdiIcons.archiveArrowUpOutline),
          onPressed: () {
            context.bloc<PlantsBloc>().rePotPlant(plant);
          },
        ),
      ),
    ]));
  }
}

class SliverHorizontalListPhotoGallery extends StatelessWidget {
  const SliverHorizontalListPhotoGallery({
    Key key,
    @required this.plant,
  }) : super(key: key);

  final Plant plant;

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<List<PlantImage>>(
      stream: context.bloc<PlantsBloc>().plantsRepo.plantImagesStream(plant.id),
      builder: (BuildContext context,
          AsyncSnapshot<List<PlantImage>> asyncSnapshot) {
        print('Snapshot: $asyncSnapshot');
        if (!asyncSnapshot.hasData)
          return SliverToBoxAdapter(
            child: Placeholder(),
          );

        return SliverPadding(
          sliver: SliverGrid(
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 4,
            ),
            delegate: SliverChildListDelegate.fixed(asyncSnapshot.data
                .map(
                  (plantImage) => InkResponse(
                    child: Card(
                      elevation: 2,
                      margin: EdgeInsets.all(4),
                      child: Container(
                        padding: EdgeInsets.all(2),
                        child: Hero(
                          tag: plantImage.id,
                          child: CachedNetworkImage(
                            placeholder: (context, url) =>
                                CircularProgressIndicator(),
                            imageUrl: plantImage.url,
                            fit: BoxFit.cover,
                          ),
                        ),
                      ),
                    ),
                    onTap: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (BuildContext context) =>
                                  FullscreenGalleryPage(plant,
                                      initialImage: plantImage)));
                    },
                  ),
                )
                .toList()),
          ),
          padding: EdgeInsets.all(8),
        );
        // return Container(
        //   alignment: Alignment.centerLeft,
        //   height: 96,
        //   child: ListView.builder(
        //     shrinkWrap: true,
        //     itemCount:
        //     scrollDirection: Axis.horizontal,
        //     itemBuilder: (context, index) {
        //   if (index == 0) {
        //     return FloatingActionButton(
        //       heroTag: null,
        //       child: Icon(MdiIcons.fileUpload),
        //       backgroundColor:
        //           !plant.needsRePotting() ? Colors.green : Colors.red,
        //       onPressed: () {
        //         ImagePicker()
        //             .getImage(source: ImageSource.camera)
        //             .then((pickedFile) {
        //           print('Photo taken at: ${pickedFile.path}');
        //           context
        //               .bloc<ImageBloc>()
        //               .addImage(pickedFile.path, plant.id);
        //         });
        //       },
        //     );
        //   }
        //   return AspectRatio(
        //     aspectRatio: 1,
        //     child: Container(
        //       child: Card(
        //         elevation: 4,
        //         margin: EdgeInsets.all(8),
        //         child: Image.network(
        //           asyncSnapshot.data[index - 1],
        //           fit: BoxFit.cover,
        //         ),
        //       ),
        //     ),
        //   );
        // },
        //   ),
        // );
        // } else {
        //   return Container();
        // }
        // BlocBuilder<ImageBloc, ImageState>(
        //     builder: (context, state) {
        //   if (state is ImageStateUploading)
        //     return Text('Uploading...');
        //   if (state is ImageStateUploaded)
        //     return Image.network(state.imageUrl);
        //   return FloatingActionButton(
        //     child: Icon(MdiIcons.fileUpload),
        //     backgroundColor: !plant.needsRePotting()
        //         ? Colors.green
        //         : Colors.red,
        //     onPressed: () {
        //       ImagePicker()
        //           .getImage(source: ImageSource.camera)
        //           .then((pickedFile) {
        //         print(
        //             'Photo taken at: ${pickedFile.path}');
        //         context.bloc<ImageBloc>().addImage(
        //             pickedFile.path, plant.id);
        //       });
        //     },
        //   );
        // }),
        // ListView(

        //   scrollDirection: Axis.horizontal,
        //   children: [],
        // ),
      },
    );
  }
}
