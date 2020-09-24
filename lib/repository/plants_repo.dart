import 'dart:async';
import 'dart:io';
import 'package:plant_diary/bloc/model/image.dart';
import 'package:plant_diary/bloc/model/plant.dart';
import 'package:plant_diary/bloc/model/plant_species.dart';
import 'package:uuid/uuid.dart';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_storage/firebase_storage.dart';

class PlantsRepo {
  static const USER_ID = 'cC0ZgWvF3azNLZJQcj98';
  static const SPECIES_PATH = '/species';
  static const USER_PLANTS_PATH = '/users/$USER_ID/plants';

  Future<List<PlantSpecies>> plantSpeciesList() async {
    return FirebaseFirestore.instance
        .collection(SPECIES_PATH)
        .get()
        .then((snapshot) {
      return Future.value(snapshot.docs
          .map((doc) => PlantSpecies.fromData(doc.data(), doc.id))
          .toList());
    });
  }

  Future<bool> postSpecies(PlantSpecies species) async {
    return FirebaseFirestore.instance
        .collection(SPECIES_PATH)
        .add(species.toMap())
        .then((docRef) => docRef != null);
  }

  Future<Map<String, PlantSpecies>> plantSpeciesMap() async {
      return FirebaseFirestore.instance
        .collection('/species')
        .get()
        .then((snapshot) {
      return Future.value(Map.fromIterable(snapshot.docs,
          key: (doc) => doc.reference.path,
          value: (doc) => PlantSpecies.fromData(doc.data(), doc.id)));
    });
  }

  Stream<List<PlantSpecies>> plantSpeciesStream() {
    Firebase.initializeApp();
    return FirebaseFirestore.instance
        .collection('/species')
        .snapshots()
        .map((collection) => collection.docs.map((speciesDoc) {
              return PlantSpecies.fromData(speciesDoc.data(), speciesDoc.id);
            }).toList());
  }

  Future<PlantSpecies> plantSpecies(String pathReference) async {
      return FirebaseFirestore.instance.doc(pathReference).get().then((doc) {
      return Future.value(PlantSpecies.fromData(doc.data(), doc.id));
    });
  }

  Stream<List<Plant>> plantListStream(
      Map<String, PlantSpecies> plantSpeciesMap) {
    Firebase.initializeApp();
    return FirebaseFirestore.instance
        .collection('/users/$USER_ID/plants')
        .snapshots()
        .map((collection) => collection.docs.map((plantDoc) {
              return Plant.fromData(plantDoc.data(), plantDoc.id,
                  plantSpeciesMap[plantDoc.data()['species'].path]);
            }).toList());
  }

  Stream<Plant> plantStream(
      String plantId, Map<String, PlantSpecies> plantSpeciesMap) {
    Firebase.initializeApp();
    return FirebaseFirestore.instance
        .doc('/users/$USER_ID/plants/$plantId')
        .snapshots()
        .map((plantDoc) => Plant.fromData(plantDoc.data(), plantDoc.id,
            plantSpeciesMap[plantDoc.data()['species'].path]));
  }

  Stream<List<PlantImage>> plantImagesStream(String plantId) {
    Firebase.initializeApp();
    final imageCollectionPath = '/users/$USER_ID/plants/$plantId/images';
    print('Getting stream for: $imageCollectionPath');
    return FirebaseFirestore.instance
        .collection(imageCollectionPath)
        .snapshots()
        .map((collection) {
      print(
          'Collection loaded, number of images: ${collection.docs?.length ?? 0}');
      return collection.docs.map((doc) {
        final PlantImage plantImage = PlantImage.fromData(
          doc.data(),
          doc.id,
        );
        print('Image url: ${plantImage.url}}');
        return plantImage;
      }).toList();
    });
  }

  Future<void> updatePlant(
      Map<String, dynamic> newValuesMap, String plantId) async {
      return FirebaseFirestore.instance
        .doc('/users/$USER_ID/plants/$plantId')
        .update(newValuesMap);
  }

  Future<bool> postPlant(Plant newPlant) async {
      final species =
        (await FirebaseFirestore.instance.collection(SPECIES_PATH).get())
            .docs
            .firstWhere((element) => element.id == newPlant.species.id);

    return FirebaseFirestore.instance
        .collection(USER_PLANTS_PATH)
        .add(newPlant.toMap()..putIfAbsent('species', () => species.reference))
        .then((docRef) => docRef != null);
  }

  Future<void> deletePlant(Plant plant) async {
      return FirebaseFirestore.instance
        .collection(USER_PLANTS_PATH)
        .doc(plant.id)
        .delete();
  }

  Future<StorageReference> uploadPhoto(
    String path,
    String plantId,
    void Function(StorageTaskEvent) onData,
  ) async {
    final uuid = Uuid();
    File file = File(path);
    final StorageReference storageReference = FirebaseStorage()
        .ref()
        .child('/users/$USER_ID/plants/${uuid.v1().toString()}');
    final StorageUploadTask uploadTask =
        storageReference.putData(file.readAsBytesSync());

    final StreamSubscription<StorageTaskEvent> streamSubscription =
        uploadTask.events.listen(onData, onError: (error, stacktrace) {
      print('Error on image upload! :$error');
    }, onDone: () {
      print('Done image upload!');
    });
    final StorageTaskSnapshot snapshot = await uploadTask.onComplete;
    streamSubscription.cancel();
    var reference = snapshot.ref;
    final String imageUrl = await reference.getDownloadURL();
    final String filePath = reference.path;
    await FirebaseFirestore.instance
        .collection('$USER_PLANTS_PATH/$plantId/images')
        .add(PlantImage.newPlantImage(imageUrl, filePath).toMap())
        .then((docRef) =>
            {print('Image reference successfully added ${docRef.id}')});
    return reference;
  }

  Future<bool> deletePhoto(
    String plantId,
    String plantImageId,
    String plantImageFilePath,
  ) async {
    var imageReferencePath = '$USER_PLANTS_PATH/$plantId/images/$plantImageId';
    try {
      await FirebaseFirestore.instance
          .doc(imageReferencePath)
          .delete()
          .then((value) {
        print(
            'Image reference removed from the plant successfully: $imageReferencePath');
      });
    } catch (error) {
      print('Error on Image reference removal: $imageReferencePath');
      print('Error: $error');
      return false;
    }
    try {
      await FirebaseStorage().ref().child(plantImageFilePath).delete();
      print('Image deleted successfully: $plantImageFilePath');
    } catch (error) {
      print('Error on Image deletion: $plantImageFilePath');
      print('Error: $error');
      return false;
    }

    return true;
  }
}
