#! /usr/bin/env dcli

import 'dart:io';

import 'package:args/args.dart';

// ignore: prefer_relative_imports
import 'package:dcli/dcli.dart' hide Settings;
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
  var name = ask('name:', required: true, defaultValue: 'Brett');
  var streetAddress =
      ask('Address:', required: true, defaultValue: '1 Burke St');
  var suburb = ask('Suburb:', required: true, defaultValue: 'Melbourne');

  var postCode = ask('Postcode:', required: true, defaultValue: '3000');

  var state = menu(
      prompt: 'State',
      options: [
        'Vic',
        'Nsw',
        'Qld',
      ],
      defaultOption: 'Vic');

  var mobile = ask('mobile:',
      defaultValue: '0438428038',
      required: true,
      validator: Ask.regExp('04[0-9][0-9][0-9][0-9][0-9][0-9][0-9][0-9]',
          error: 'You must enter a 11 digit mobile no. staring with 04'));

  var message = ask('message', required: true, defaultValue: 'A test message');

  var window = menu(
      prompt: 'Window Type',
      options: [
        'Sliding',
        'Awning',
      ],
      defaultOption: 'Sliding');

  final settings = Settings.load();
  var url = settings.url;
  // """curl --location -g --request GET 'https://api.transmitsms.com/send-sms.json?message=Hi {$name},$message&reply_callback=https://www.myserver.com/processreply.php?myparameter=myvalue&to=1234567890'"""
  //     .run;
  var templateid = ask('template:', defaultValue: '72');
  var campaignId = ask('campaign:', defaultValue: '128');
  var allocationid = ask('allocation:', defaultValue: '113');
  var apiKey = settings.apiKey;
  var uri = Uri.encodeFull(
          '''$url/servicemanager/rest/CampaignAPI/updateLeadFast?apiKey=$apiKey&fTemplateId=$templateid&fCampaignId=$campaignId&fAllocationId=$allocationid&apiKey=$apiKey''')
      .replaceAll('\n', '');

  ///print(uri);

  final fields =
      '{"njLeadId":"111688", "njDisposition":"Fax", "Mobile":"$mobile", "Name":"$name","StreetAddress":"$streetAddress"'
      ', "Suburb": "$suburb", "State":"$state", "PostCode":"$postCode", "WindowType":"$window", "message":"$message"}';

  // final fields2 =
  //     '{"Name":"$name","StreetAddress":"$streetAddress", "City": "$suburb", "State":"$state", "PostCode":"$postCode", "Mobile":"$mobile", "message":"$message"}';

  final curl =
      """curl -v -H "Accept: application/json" -H "Content-Type: application/json" -X POST -d '$fields' '$uri'""";

  // print(curl.replaceAll('\n', ''));
  curl.start(progress: Progress.print());
}

/// Show useage.
void showUsage(ArgParser parser) {
  print('Usage: inject.dart -v -prompt <a questions>');
  print(parser.usage);
  exit(1);
}
