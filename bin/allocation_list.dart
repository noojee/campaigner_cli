#! /usr/bin/env dcli

import 'dart:io';

import 'package:args/args.dart';

// ignore: prefer_relative_imports
import 'package:dcli/dcli.dart' hide Settings;
import 'package:dcli/src/util/parser.dart';


import 'package:campaigner/campaigner.dart';

/// dcli script generated by:
/// dcli create inject.dart
///
/// See
/// https://pub.dev/packages/dcli#-installing-tab-
///
/// For details on installing dcli.
///

void main(List<String> args) {
  var parser = ArgParser();
  parser.addOption('template',
      abbr: 't', help: 'Campaign Template ID', mandatory: true);
  parser.addOption('campaign', abbr: 'c', help: 'Campaign ID', mandatory: true);

  ArgResults parsed;

  try {
    parsed = parser.parse(args);
  } on FormatException catch (e) {
    printerr(red(e.message));
    showUsage(parser);
    exit(1);
  }

  var templateId = int.tryParse(parsed['template'] as String);
  if (templateId == null) {
    printerr(red('The template must be an integer'));
    showUsage(parser);
  }

  var campaignId = int.tryParse(parsed['campaign'] as String);
  if (campaignId == null) {
    printerr(red('The campaign must be an integer'));
    showUsage(parser);
  }

  var settings = Settings.load();
  var apiKey = settings.apiKey;
  var url = settings.url;
  var uri = Uri.encodeFull(
      '$url/servicemanager/rest/CampaignAPI/getAllocationList?apiKey=$apiKey&fTemplateId=$templateId&fCampaignId=$campaignId');

  withTempFile((jsonFile) {
    fetch(url: uri, saveToPath: jsonFile);
    var lines = read(jsonFile).toList();
    final jsonMap = Parser(lines).jsonDecode() as Map<String, dynamic>;

    for (var entity in jsonMap['entities']) {
      print('id: ${entity['id']} name: "${entity['name']}"');
    }
  }, create: false);
}

/// Show useage.
void showUsage(ArgParser parser) {
  print('Usage: allocation_list.dart -t <templateid> -c <campaignid>');
  print(parser.usage);
  exit(1);
}