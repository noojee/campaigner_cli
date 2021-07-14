#! /usr/bin/env dcli

import 'dart:io';

import 'package:args/args.dart';

// ignore: prefer_relative_imports
import 'package:dcli/dcli.dart' hide Settings;
import 'settings.dart';

/// dcli script generated by:
/// dcli create sendsms.dart
///
/// See
/// https://pub.dev/packages/dcli#-installing-tab-
///
/// For details on installing dcli.
///

void main(List<String> args) {
  var name = ask('name:', required: true);

  var settings = Settings.load();
  var smsApiKey = settings.smsApiKey;
  var smsSecret = settings.smsSecret;
  var defaultMobile = settings.defaultMobile;

  var mobile = ask('mobile:',
      defaultValue: defaultMobile,
      required: true,
      validator: Ask.regExp('614[0-9][0-9][0-9][0-9][0-9][0-9][0-9][0-9]',
          error: 'You must enter a 11 digit mobile no. staring with 614'));

  var message = ask('message', required: true);

  // """curl --location -g --request GET 'https://api.transmitsms.com/send-sms.json?message=Hi {$name},$message&reply_callback=https://www.myserver.com/processreply.php?myparameter=myvalue&to=1234567890'"""
  //     .run;

  var uri = Uri.encodeFull(
      'https://api.transmitsms.com/send-sms.json?message=Hi $name,$message&to=$mobile');

  final curl =
      '''curl -u '$smsApiKey:$smsSecret' --location -g --request GET "$uri"''';
  print(curl);
  curl.run;
}

/// Show useage.
void showUsage(ArgParser parser) {
  print('Usage: sendsms.dart -v -prompt <a questions>');
  print(parser.usage);
  exit(1);
}
