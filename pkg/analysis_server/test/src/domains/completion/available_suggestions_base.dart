// Copyright (c) 2019, the Dart project authors. Please see the AUTHORS file
// for details. All rights reserved. Use of this source code is governed by a
// BSD-style license that can be found in the LICENSE file.

import 'dart:convert';

import 'package:analysis_server/protocol/protocol_constants.dart';
import 'package:analysis_server/src/protocol_server.dart';
import 'package:analyzer/file_system/file_system.dart';
import 'package:test/test.dart';
import 'package:test_reflective_loader/test_reflective_loader.dart';

import '../../../analysis_server_base.dart';
import '../../../constants.dart';

@reflectiveTest
class AvailableSuggestionsBase extends PubPackageAnalysisServerTest {
  final Map<int, AvailableSuggestionSet> idToSetMap = {};
  final Map<String, AvailableSuggestionSet> uriToSetMap = {};
  final Map<String, CompletionResultsParams> idToSuggestions = {};
  final Map<File, ExistingImports> fileToExistingImports = {};

  void assertJsonText(Object object, String expected) {
    expected = expected.trimRight();
    var actual = JsonEncoder.withIndent('  ').convert(object);
    if (actual != expected) {
      print('-----');
      print(actual);
      print('-----');
    }
    expect(actual, expected);
  }

  String jsonOfPath(String path) {
    path = convertPath(path);
    return json.encode(path);
  }

  @override
  void processNotification(Notification notification) {
    super.processNotification(notification);
    if (notification.event == COMPLETION_NOTIFICATION_AVAILABLE_SUGGESTIONS) {
      var params = CompletionAvailableSuggestionsParams.fromNotification(
        notification,
      );
      for (var set in params.changedLibraries!) {
        idToSetMap[set.id] = set;
        uriToSetMap[set.uri] = set;
      }
      for (var id in params.removedLibraries!) {
        var set = idToSetMap.remove(id);
        uriToSetMap.remove(set?.uri);
      }
    } else if (notification.event == COMPLETION_RESULTS) {
      var params = CompletionResultsParams.fromNotification(notification);
      idToSuggestions[params.id] = params;
    } else if (notification.event == COMPLETION_NOTIFICATION_EXISTING_IMPORTS) {
      var params = CompletionExistingImportsParams.fromNotification(
        notification,
      );
      fileToExistingImports[getFile(params.file)] = params.imports;
    } else if (notification.event == SERVER_NOTIFICATION_ERROR) {
      fail('${notification.toJson()}');
    }
  }

  /// Remove the set with the given [uri].
  /// The set must be already received.
  void removeSet(String uri) {
    var set = uriToSetMap.remove(uri)!;
    idToSetMap.remove(set.id);
  }

  @override
  Future<void> setUp() async {
    super.setUp();

    newPubspecYamlFile(testPackageRootPath, '');
    writeTestPackageConfig();
    await setRoots(included: [workspaceRootPath], excluded: []);

    await handleSuccessfulRequest(
      CompletionSetSubscriptionsParams([
        CompletionService.AVAILABLE_SUGGESTION_SETS,
      ]).toRequest('0'),
    );
  }

  Future<CompletionResultsParams> waitForGetSuggestions(String id) async {
    while (true) {
      var result = idToSuggestions[id];
      if (result != null) {
        return result;
      }
      await Future.delayed(const Duration(milliseconds: 1));
    }
  }

  Future<AvailableSuggestionSet> waitForSetWithUri(String uri) async {
    while (true) {
      var result = uriToSetMap[uri];
      if (result != null) {
        return result;
      }
      await Future.delayed(const Duration(milliseconds: 1));
    }
  }

  Future<void> waitForSetWithUriRemoved(String uri) async {
    while (true) {
      var result = uriToSetMap[uri];
      if (result == null) {
        return;
      }
      await Future.delayed(const Duration(milliseconds: 1));
    }
  }
}
