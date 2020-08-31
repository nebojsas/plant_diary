import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:plant_diary/bloc/plants_state.dart';

class PlantsRepo {
  static const USER_ID = 'cC0ZgWvF3azNLZJQcj98';
  static const SPECIES_PATH = '/species';
  static const USER_PLANTS_PATH = '/users/$USER_ID/plants';

  Future<List<PlantSpecies>> plantSpeciesList() async {
    await Firebase.initializeApp();
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
    await Firebase.initializeApp();
    return FirebaseFirestore.instance
        .collection(SPECIES_PATH)
        .add(species.toMap())
        .then((docRef) => docRef != null);
  }

  Future<Map<String, PlantSpecies>> plantSpeciesMap() async {
    await Firebase.initializeApp();
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
    await Firebase.initializeApp();
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

  Future<void> updatePlant(
      Map<String, dynamic> newValuesMap, String plantId) async {
    await Firebase.initializeApp();
    return FirebaseFirestore.instance
        .doc('/users/$USER_ID/plants/$plantId')
        .update(newValuesMap);
  }

  Future<bool> postPlant(Plant newPlant) async {
    await Firebase.initializeApp();
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
    await Firebase.initializeApp();
    return FirebaseFirestore.instance
        .collection(USER_PLANTS_PATH).doc(plant.id).delete();
  }
}
