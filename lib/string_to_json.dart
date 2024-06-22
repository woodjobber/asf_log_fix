extension StringToJson on String {
  Map<String, dynamic> toJson() {
    String input = this;
    // Remove unnecessary headers and split key-value pairs
    List<String> pairs = input.split(',');

    // Initialize an empty map to store key-value pairs
    Map<String, dynamic> jsonMap = {};

    // Process each pair to extract key and value
    for (String pair in pairs) {
      int separatorIndex = pair.indexOf(':');
      if (separatorIndex != -1) {
        String key = pair.substring(0, separatorIndex).trim();
        String? value;
        value = pair.substring(separatorIndex + 1).trim();
        if (value == 'null') {
          value = null;
        }
        // Remove leading and trailing braces if present
        if (value != null && value.endsWith('}')) {
          value = value.substring(0, value.length - 1);
        }
        if (key.startsWith('{')) {
          key = key.substring(1, key.length - 1);
        }
        // Assign key-value pair to the map
        jsonMap[key] = value;
      }
    }
    return jsonMap;
  }
}
