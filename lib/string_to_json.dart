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
          key = key.substring(1);
        }
        key = key.trim().replaceAll(RegExp(r'\"|\x20'), '');

        // Assign key-value pair to the map
        String pattern = r'^[0-9]+$';
        bool hasMatch = RegExp(pattern).hasMatch(value ?? '');
        String pattern2 = r'^[+-]?(\d*\.\d+|\d+\.\d*)$';
        bool hasMatch2 = RegExp(pattern2).hasMatch(value ?? '');
        if (hasMatch || hasMatch2) {
          if (hasMatch2) {
            RegExp trailingZeros = RegExp(r'^[0-9]+.0+$');
            if (trailingZeros.hasMatch(value!)) {
              jsonMap[key] = double.parse(value).ceilToDouble();
            } else {
              jsonMap[key] = double.tryParse(value);
            }
          } else {
            jsonMap[key] = int.tryParse(value ?? '');
          }
        } else if (value == 'true' || value == 'false') {
          jsonMap[key] = value == 'true';
        } else if (value == 'null') {
          jsonMap[key] = null;
        } else {
          jsonMap[key] = value?.replaceAll(RegExp(r'^[/"]|[/"]$'), '');
        }
      }
    }
    return jsonMap;
  }
}
