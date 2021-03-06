#! /usr/bin/env dcli

import 'dart:io';

import 'package:args/args.dart';

// ignore: prefer_relative_imports
import 'package:dcli/dcli.dart' hide Settings;
import 'package:dcli/src/util/parser.dart';

import 'package:noojee_campaigner_cli/noojee_campaigner_cli.dart';

/// dcli script generated by:
/// dcli create inject.dart
///
/// See
/// https://pub.dev/packages/dcli#-installing-tab-
///
/// For details on installing dcli.
///

void main(List<String> args) {
  var settings = Settings.load();
  var apiKey = settings.apiKey;
  var url = settings.url;
  var uri = Uri.encodeFull(
      '$url/servicemanager/rest/CampaignAPI/getCampaignTemplateList?apiKey=$apiKey');

  print(uri);

  withTempFile((jsonFile) {
    fetch(url: uri, saveToPath: jsonFile);
    print(read(jsonFile).toParagraph());
    var lines = read(jsonFile).toList();
    final jsonMap = Parser(lines).jsonDecode() as Map<String, dynamic>;

    final code = jsonMap['code'] as int;
    if (code != 0) {
      printerr(red(jsonMap['message'] as String));
      exit(1);
    }


    for (var entity in jsonMap['entities']) {
      print('id: ${entity['id']} name: "${entity['name']}"');
    }
  }, create: false);
}

/// Show useage.
void showUsage(ArgParser parser) {
  print('Usage: template_list.dart');
  print(parser.usage);
  exit(1);
}
