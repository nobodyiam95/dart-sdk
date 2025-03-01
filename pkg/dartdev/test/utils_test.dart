// Copyright (c) 2020, the Dart project authors. Please see the AUTHORS file
// for details. All rights reserved. Use of this source code is governed by a
// BSD-style license that can be found in the LICENSE file.

import 'dart:convert';
import 'dart:io';

import 'package:dartdev/src/utils.dart';
import 'package:path/path.dart' as path;
import 'package:test/test.dart';

void main() {
  group('pluralize', () {
    test('zero', () {
      expect(pluralize('cat', 0), 'cats');
    });

    test('one', () {
      expect(pluralize('cat', 1), 'cat');
    });

    test('many', () {
      expect(pluralize('cat', 2), 'cats');
    });
  });

  group('relativePath', () {
    test('direct', () {
      var dir = Directory('foo');
      expect(relativePath('path', dir), 'path');
    });

    test('nested', () {
      var dir = Directory('foo');
      expect(relativePath(path.join(dir.absolute.path, 'path'), dir), 'path');
    });
  });

  group('trimEnd', () {
    test('null suffix', () {
      expect(trimEnd('string', null), 'string');
    });

    test('suffix empty', () {
      expect(trimEnd('string', ''), 'string');
    });

    test('suffix miss', () {
      expect(trimEnd('string', 'suf'), 'string');
    });

    test('suffix hit', () {
      expect(trimEnd('string', 'ring'), 'st');
    });
  });

  group('castStringKeyedMap', () {
    test('fails', () {
      dynamic contents = json.decode(_packageData);
      List<dynamic> packages = contents['packages'];
      try {
        // ignore: unused_local_variable
        List<Map<String, dynamic>> mappedPackages =
            packages as List<Map<String, dynamic>>;
        fail('expected implicit cast to fail');
      } on TypeError {
        // TypeError is expected
      }
    });

    test('succeeds', () {
      dynamic contents = json.decode(_packageData);
      List<dynamic> packages = contents['packages'];
      List<Map<String, dynamic>> mappedPackages =
          packages.map<Map<String, dynamic>>(castStringKeyedMap).toList();
      expect(mappedPackages, isList);
    });
  });

  group('FileSystemEntityExtension', () {
    test('isDartFile', () {
      expect(File('foo.dart').isDartFile, isTrue);
      expect(Directory('foo.dartt').isDartFile, isFalse);
      expect(File('foo.dartt').isDartFile, isFalse);
      expect(File('foo.darrt').isDartFile, isFalse);
      expect(File('bar.bart').isDartFile, isFalse);
      expect(File('bazdart').isDartFile, isFalse);
    });

    test('name', () {
      expect(Directory('').name, '');
      expect(Directory('dirName').name, 'dirName');
      expect(Directory('dirName${path.separator}').name, 'dirName');
      expect(File('').name, '');
      expect(File('foo.dart').name, 'foo.dart');
      expect(File('${path.separator}foo.dart').name, 'foo.dart');
      expect(File('bar.bart').name, 'bar.bart');
    });
  });

  group('wrapText', () {
    test('oneLine_wordLongerThanLine', () {
      expect(wrapText('http://long-url', width: 10), equals('http://long-url'));
    });

    test('singleLine', () {
      expect(wrapText('one two', width: 10), equals('one two'));
    });

    test('singleLine_exactLength', () {
      expect(wrapText('one twoooo', width: 10), equals('one twoooo'));
    });

    test('singleLine_exactLength_minusOne', () {
      expect(wrapText('one twooo', width: 10), equals('one twooo'));
    });

    test('singleLine_exactLength_plusOne', () {
      expect(wrapText('one twooooo', width: 10), equals('one\ntwooooo'));
    });

    test('twoLines_exactLength', () {
      expect(wrapText('one two three four', width: 10),
          equals('one two\nthree four'));
    });

    test('twoLines_exactLength_minusOne', () {
      expect(wrapText('one two three fou', width: 10),
          equals('one two\nthree fou'));
    });

    test('twoLines_exactLength_plusOne', () {
      expect(wrapText('one two three fourr', width: 10),
          equals('one two\nthree\nfourr'));
    });

    test('twoLines_lastLineEndsWithSpace', () {
      expect(wrapText('one two three ', width: 10), equals('one two\nthree '));
    });

    test('twoLines_multipleSpacesAtSplit', () {
      expect(
          wrapText('one two.  Three', width: 10), equals('one two. \nThree'));
    });

    test('twoLines_noSpaceLastLine', () {
      expect(wrapText('one two three', width: 10), equals('one two\nthree'));
    });

    test('twoLines_wordLongerThanLine_firstLine', () {
      expect(wrapText('http://long-url word', width: 10),
          equals('http://long-url\nword'));
    });

    test('twoLines_wordLongerThanLine_lastLine', () {
      expect(wrapText('word http://long-url', width: 10),
          equals('word\nhttp://long-url'));
    });
  });

  group('MarkdownTable', () {
    test('generate', () {
      const numbers = ['zero', 'one', 'two', 'three', 'four'];

      var table = MarkdownTable();
      table.startRow()
        ..cell('Number')
        ..cell('Value')
        ..cell('Words');
      for (var foo in [1, 2, 3, 4]) {
        table.startRow()
          ..cell(numbers[foo])
          ..cell(foo.toStringAsFixed(1), right: true)
          ..cell('bar ' * foo);
      }
      var result = table.finish();
      expect(result, equals('''
| Number | Value | Words            |
| ------ | ----- | ---------------- |
| one    |   1.0 | bar              |
| two    |   2.0 | bar bar          |
| three  |   3.0 | bar bar bar      |
| four   |   4.0 | bar bar bar bar  |
'''));
    });
  });
}

const String _packageData = '''{
  "configVersion": 2,
  "packages": [
    {
      "name": "lints",
      "rootUri": "file:///Users/.../.pub-cache/hosted/pub.dartlang.org/lints-1.0.1",
      "packageUri": "lib/",
      "languageVersion": "2.1"
    },
    {
      "name": "args",
      "rootUri": "../",
      "packageUri": "lib/",
      "languageVersion": "2.3"
    }
  ],
  "generated": "2020-03-01T03:38:14.906205Z",
  "generator": "pub",
  "generatorVersion": "2.8.0-dev.10.0"
}
''';
