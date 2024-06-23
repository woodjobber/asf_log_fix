import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:json_fix/string_to_json.dart';
import 'package:json_fix/version_info.dart';
import 'package:json_shrink_widget/json_shrink_widget.dart';
import 'package:url_launcher/url_launcher_string.dart';

class BeautyJsonPage extends StatefulWidget {
  const BeautyJsonPage({super.key});

  @override
  State<BeautyJsonPage> createState() => _BeautyJsonPageState();
}

class _BeautyJsonPageState extends State<BeautyJsonPage> {
  TextEditingController controller = TextEditingController();
  String? jsonData;
  bool errorEnable = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.primary,
        title: const Text(
          'ASF控制台Json日志修复器',
          style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.only(left: 16, right: 16, top: 16),
              child: SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Row(
                    children: [
                      ElevatedButton(
                        onPressed: () {
                          controller.text = '';
                          jsonData = null;
                          errorEnable = false;
                          setState(() {});
                        },
                        child: const Text('🗑️清空'),
                      ),
                      const SizedBox(
                        width: 10,
                      ),
                      ElevatedButton(
                        onPressed: () {
                          jsonData = null;
                          errorEnable = false;
                          setState(() {});
                        },
                        child: const Text('🔄恢复'),
                      ),
                      const SizedBox(
                        width: 10,
                      ),
                      ElevatedButton(
                        onPressed: () {
                          if (jsonData != null &&
                              jsonData is String &&
                              jsonData!.isNotEmpty) {
                            Clipboard.setData(ClipboardData(text: jsonData!));
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                content: Text('复制成功'),
                              ),
                            );
                            return;
                          }
                          if (controller.text.isEmpty || errorEnable) {
                            return;
                          }
                          Clipboard.setData(
                              ClipboardData(text: controller.text));
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                              content: Text('复制成功'),
                            ),
                          );
                          Clipboard.setData(
                              ClipboardData(text: controller.text));
                        },
                        child: const Text('🖨️复制'),
                      ),
                      const SizedBox(
                        width: 10,
                      ),
                      ElevatedButton(
                        onPressed: () {
                          errorEnable = false;
                          if (controller.text.isEmpty) return;
                          // \[.*?\]flutter:\s?|\[.*?\]flutter[^:]+:\s?|\[.*?\]I/flutter:\s?|\[.*?]I/flutter(:?.*?):\s?|flutter:\s?|flutter(?:.*?):\s?|flutter:\s?|I/flutter(?:.*?):\s?
                          // \[.*?\] flutter[^:]*:\s*|\[.*?\] .*\/flutter[^:]*:\s*|.*\/flutter[^:]*:\s*|.*flutter[^:]*:\s*
                          //
                          // Pattern regex = RegExp(
                          //     r'\[.{0,16}\]\s?I?/?flutter(?:.*?):\s?|I?/?flutter(?:[^\[:\]]*?):\s?');
                          RegExp regex = RegExp(
                              r'\[.{0,16}\]\s?I?/?flutter.*?:\s?|I?/?flutter[^:\[\]]*:\s?');
                          var oldText = controller.text;
                          var jsonText = controller.text.replaceAll(regex, '');
                          if (regex.hasMatch(jsonText)) {
                            jsonText =
                                jsonText.replaceAll(RegExp(r'[\r\n]'), '');
                          }
                          controller.text = oldText;
                          try {
                            var d = jsonDecode(jsonText);
                            if (d is! Map && d is! List) {
                              errorEnable = true;
                            }
                          } catch (e) {
                            try {
                              var map = jsonText.toJson();
                              if (map.isEmpty) {
                                errorEnable = true;
                              } else {
                                errorEnable = false;
                                jsonText = jsonEncode(map);
                              }
                            } catch (e) {
                              errorEnable = true;
                              if (kDebugMode) {
                                print(e);
                              }
                            }
                          }
                          if (!errorEnable) {
                            jsonData = jsonText;
                          } else {
                            jsonData = '';
                          }
                          setState(() {});
                        },
                        child: const Text(
                          '🔨智能修复',
                          style: TextStyle(
                              color: Colors.red, fontWeight: FontWeight.bold),
                        ),
                      ),
                      const SizedBox(
                        width: 10,
                      ),
                      ElevatedButton(
                        onPressed: () {
                          try {
                            if (jsonData != null &&
                                jsonData is String &&
                                jsonData!.isNotEmpty) {
                              return;
                            }
                            if (controller.text.isEmpty || errorEnable) {
                              return;
                            }
                            var jsonObject = json.decode(controller.text);
                            controller.text = const JsonEncoder.withIndent('  ')
                                .convert(jsonObject);
                            setState(() {});
                          } catch (_) {
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                content: Text('Json格式不正确'),
                              ),
                            );
                          }
                        },
                        child: const Text('🖌️美化格式'),
                      ),
                      const SizedBox(
                        width: 10,
                      ),
                      ElevatedButton(
                        onPressed: () {
                          launchUrlString('https://www.json.cn/jsononline/');
                        },
                        child: const Text('📑打开json.cn'),
                      ),
                      const SizedBox(
                        width: 10,
                      ),
                      ElevatedButton(
                        onPressed: () {
                          launchUrlString('https://chatgpt.com/');
                        },
                        child: const Text('📑打开ChatGPT'),
                      ),
                    ],
                  ),
                ),
              ),
            ),
            if (jsonData != null)
              Expanded(
                child: errorEnable == true
                    ? const Center(
                        child: Text(
                        '⚠修复失败~',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 40,
                          color: Colors.red,
                        ),
                      ))
                    : Padding(
                        padding: const EdgeInsets.all(32.0),
                        child: Container(
                          decoration: BoxDecoration(
                            color: Colors.white,
                            border: Border.all(color: Colors.grey),
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: SingleChildScrollView(
                            physics: const AlwaysScrollableScrollPhysics(),
                            child: Container(
                              padding: const EdgeInsets.all(16.0),
                              width: double.infinity,
                              child: Align(
                                alignment: Alignment.topLeft,
                                child: SelectionArea(
                                  child: JsonShrinkWidget(
                                    json: jsonData,
                                    style: const JsonShrinkStyle.light(
                                      textStyle: TextStyle(
                                          color: Colors.green,
                                          fontWeight: FontWeight.bold),
                                      boolStyle: TextStyle(
                                        color: Colors.orangeAccent,
                                        fontWeight: FontWeight.bold,
                                      ),
                                      keyStyle: TextStyle(
                                          color: Colors.purple,
                                          fontWeight: FontWeight.bold),
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),
              ),
            if (jsonData == null)
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.all(32.0),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(8),
                    child: Container(
                      decoration: BoxDecoration(
                        color: Colors.transparent,
                        borderRadius: BorderRadius.circular(8),
                        border: Border.all(color: Colors.grey),
                      ),
                      child: SingleChildScrollView(
                        child: Container(
                          padding: const EdgeInsets.all(16.0),
                          width: double.infinity,
                          child: TextField(
                            controller: controller,
                            maxLines: null,
                            minLines: 16,
                            decoration: const InputDecoration(
                              hintText: '请输入控制台Flutter Json日志...',
                              contentPadding: EdgeInsets.all(16),
                              border: InputBorder.none,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            const Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                SizedBox(),
                Padding(
                  padding: EdgeInsets.all(10.0),
                  child: Text(
                    'Copyright © 2024 Soer, Inc.',
                    style: TextStyle(
                      color: Colors.grey,
                      fontSize: 12,
                    ),
                  ),
                ),
                Padding(
                  padding: EdgeInsets.all(10.0),
                  child: Text(
                    'v${WebVersionInfo.name}(${WebVersionInfo.build})',
                    style: TextStyle(
                      color: Colors.grey,
                      fontSize: 12,
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
