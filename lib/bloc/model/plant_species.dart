class PlantSpecies {
  static const String MAP_KEY_NAME = 'name';
  static const String MAP_KEY_DEFAULT_IMAGE = 'defaultImage';
  static const String MAP_KEY_WATERING_FREQUENCY = 'wateringFrequency';
  static const String MAP_KEY_FEEDING_FREQUENCY = 'feedingFrequency';
  static const String MAP_KEY_REPOTTING_FREQUENCY = 'rePottingFrequency';
  final String id;
  final String name;
  final String defaultImage;
  final Duration wateringFrequency;
  final Duration feedingFrequency;
  final Duration rePottingFrequency;

  const PlantSpecies(this.id, this.name, this.defaultImage,
      this.wateringFrequency, this.feedingFrequency, this.rePottingFrequency);

  static PlantSpecies fromData(Map<String, dynamic> data, String id) =>
      PlantSpecies(
          id,
          data[MAP_KEY_NAME],
          data[MAP_KEY_DEFAULT_IMAGE],
          Duration(days: data[MAP_KEY_WATERING_FREQUENCY]),
          Duration(days: data[MAP_KEY_FEEDING_FREQUENCY]),
          Duration(days: data[MAP_KEY_REPOTTING_FREQUENCY]));

  Map<String, dynamic> toMap() {
    final dataMap = Map<String, dynamic>.from({});
    dataMap.putIfAbsent(MAP_KEY_NAME, () => name);
    dataMap.putIfAbsent(MAP_KEY_DEFAULT_IMAGE, () => defaultImage);
    dataMap.putIfAbsent(
        MAP_KEY_WATERING_FREQUENCY, () => wateringFrequency.inDays);
    dataMap.putIfAbsent(
        MAP_KEY_FEEDING_FREQUENCY, () => feedingFrequency.inDays);
    dataMap.putIfAbsent(
        MAP_KEY_REPOTTING_FREQUENCY, () => rePottingFrequency.inDays);
    return dataMap;
  }

  static const PARSLEY = PlantSpecies(
      '0',
      'Parsley',
      'https://www.kidsdogardening.com/wp-content/uploads/2020/02/Parsley-in-pot-1536x1025.jpeg',
      Duration(days: 2),
      Duration(days: 90),
      Duration(days: 365));
  static const BASIL = PlantSpecies(
      '1',
      'Basil',
      'https://cdn.shopify.com/s/files/1/0022/5338/9887/products/Basil_plant_in_terracotta_pot_2000x.jpg',
      Duration(days: 2),
      Duration(days: 90),
      Duration(days: 365));
  static const FITTONIA = PlantSpecies(
      '2',
      'Fittonia',
      'https://cdn.shopify.com/s/files/1/0109/7996/7072/products/48157-04-BAKIE_20190719150740_960x960_crop_center.jpg',
      Duration(days: 2),
      Duration(days: 90),
      Duration(days: 365));
  static const PHILODENDRON = PlantSpecies(
      '3',
      'Philodendron',
      'https://cdn.shopify.com/s/files/1/0109/7996/7072/products/46787-01-BAKIE_20190221111731_f58132aa-7b3d-4626-9d40-eaa8f2e8aeac_960x960_crop_center.jpg',
      Duration(days: 2),
      Duration(days: 90),
      Duration(days: 365));
  static const MONKEY_LEAF = PlantSpecies(
      '4',
      'Monkey Leaf',
      'https://cdn.shopify.com/s/files/1/0109/7996/7072/products/77674-04-BAKIE_20200203131817_960x960_crop_center.jpg',
      Duration(days: 2),
      Duration(days: 90),
      Duration(days: 365));
}
