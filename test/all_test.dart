import 'package:angel_framework/angel_framework.dart';
import 'package:angel_configuration/angel_configuration.dart';
import 'package:file/local.dart';
import 'package:test/test.dart';
import 'transformer.dart' as transformer;

main() async {
  // Note: Set ANGEL_ENV to 'development'
  var app = new Angel();
  var fileSystem = const LocalFileSystem();

  await app.configure(configuration(
    fileSystem,
    directoryPath: './test/config',
  ));

  test('can load based on ANGEL_ENV', () async {
    expect(app.configuration['hello'], equals('world'));
    expect(app.configuration['foo']['version'], equals('bar'));
  });

  test('will load default.yaml if exists', () {
    expect(app.configuration["set_via"], equals("default"));
  });

  test('will load .env if exists', () {
    expect(app.configuration['artist'], 'Timberlake');
    expect(app.configuration['angel'], {'framework': 'cool'});
  });

  test('non-existent environment defaults to null', () {
    expect(app.configuration.keys, contains('must_be_null'));
    expect(app.configuration['must_be_null'], null);
  });

  test('can override ANGEL_ENV', () async {
    await app.configure(configuration(fileSystem,
        directoryPath: './test/config', overrideEnvironmentName: 'override'));
    expect(app.configuration['hello'], equals('goodbye'));
    expect(app.configuration['foo']['version'], equals('baz'));
  });

  test('merges configuration', () async {
    await app.configure(configuration(fileSystem,
        directoryPath: './test/config', overrideEnvironmentName: 'override'));
    expect(app.configuration['merge'], {'map': true, 'hello': 'goodbye'});
  });

  group("transformer", transformer.main);
}
