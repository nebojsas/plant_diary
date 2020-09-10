class PlantImage {
  static const String MAP_KEY_URL = 'url';
  static const String MAP_KEY_FILE_PATH = 'filePath';

  final String id;
  final String url;
  final String filePath;

  PlantImage(this.id, this.url, this.filePath);

  static PlantImage newPlantImage(String url, String filePath) =>
      PlantImage('', url, filePath);

  static PlantImage fromData(Map<String, dynamic> data, String id) =>
      PlantImage(id, data[MAP_KEY_URL], data[MAP_KEY_FILE_PATH]);

  Map<String, dynamic> toMap() {
    final dataMap = Map<String, dynamic>.from({});
    dataMap.putIfAbsent(MAP_KEY_URL, () => url);
    dataMap.putIfAbsent(MAP_KEY_FILE_PATH, () => filePath);
    return dataMap;
  }
}
