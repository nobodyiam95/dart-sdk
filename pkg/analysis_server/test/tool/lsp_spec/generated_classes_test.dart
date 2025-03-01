// Copyright (c) 2020, the Dart project authors. Please see the AUTHORS file
// for details. All rights reserved. Use of this source code is governed by a
// BSD-style license that can be found in the LICENSE file.

import 'package:analysis_server/lsp_protocol/protocol.dart';
import 'package:test/test.dart';

void main() {
  group('generated classes', () {
    test('can be checked for equality', () {
      final a = TextDocumentIdentifier(uri: Uri.file('/a'));
      final b = TextDocumentIdentifier(uri: Uri.file('/a'));

      expect(a, equals(b));
      expect(a.hashCode, equals(b.hashCode));
    });

    test('with list fields can be checked for equality', () {
      final a = CodeActionLiteralSupportCodeActionKind(
        valueSet: [CodeActionKind.QuickFix],
      );
      final b = CodeActionLiteralSupportCodeActionKind(
        valueSet: [CodeActionKind.QuickFix],
      );

      expect(a, equals(b));
      expect(a.hashCode, equals(b.hashCode));
    });

    test('with aliased list fields can be checked for equality', () {
      final a = TextDocumentRegistrationOptions(documentSelector: [
        TextDocumentFilterWithScheme(language: 'dart', scheme: 'file')
      ]);
      final b = TextDocumentRegistrationOptions(documentSelector: [
        TextDocumentFilterWithScheme(language: 'dart', scheme: 'file')
      ]);

      expect(a, equals(b));
      expect(a.hashCode, equals(b.hashCode));
    });

    test('with map fields can be checked for equality', () {
      final a = WorkspaceEdit(changes: {
        Uri.file('/a'): [
          TextEdit(
              range: Range(
                  start: Position(line: 0, character: 0),
                  end: Position(line: 0, character: 0)),
              newText: 'a')
        ]
      });
      final b = WorkspaceEdit(changes: {
        Uri.file('/a'): [
          TextEdit(
              range: Range(
                  start: Position(line: 0, character: 0),
                  end: Position(line: 0, character: 0)),
              newText: 'a')
        ]
      });

      expect(a, equals(b));
      expect(a.hashCode, equals(b.hashCode));
    });

    test('with unions of lists can be checked for equality', () {
      final a = Either2<List<String>, List<int>>.t1(['test']);
      final b = Either2<List<String>, List<int>>.t1(['test']);

      expect(a, equals(b));
      expect(a.hashCode, equals(b.hashCode));
    });

    test('with union fields can be checked for equality', () {
      final a = SignatureInformation(
          label: 'a',
          documentation: Either2<MarkupContent, String>.t2('a'),
          parameters: []);
      final b = SignatureInformation(
          label: 'a',
          documentation: Either2<MarkupContent, String>.t2('a'),
          parameters: []);

      expect(a, equals(b));
      expect(a.hashCode, equals(b.hashCode));
    });

    test('consider subclasses when checking for equality', () {
      final a = TextDocumentRegistrationOptions(documentSelector: [
        TextDocumentFilterWithScheme(language: 'dart', scheme: 'file')
      ]);
      final b = TextDocumentSaveRegistrationOptions(
          includeText: true,
          documentSelector: [
            TextDocumentFilterWithScheme(language: 'dart', scheme: 'file')
          ]);

      expect(a, isNot(equals(b)));
      expect(b, isNot(equals(a)));
    });
  });
}
