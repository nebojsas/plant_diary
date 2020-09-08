class PlantImage {
  static const String MAP_KEY_URL = 'url';

  final String id;
  final String url;

  PlantImage(this.id, this.url);

  static PlantImage fromData(Map<String, dynamic> data, String id) =>
      PlantImage(id, data[MAP_KEY_URL]);

  Map<String, dynamic> toMap() {
    final dataMap = Map<String, dynamic>.from({});
    dataMap.putIfAbsent(MAP_KEY_URL, () => url);
    return dataMap;
  }
}
