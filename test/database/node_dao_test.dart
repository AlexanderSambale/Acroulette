import 'package:acroulette/models/database.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('node_dao', () {
    late AppDatabase database;

    setUp(() async {
      database = await $FloorAppDatabase.inMemoryDatabaseBuilder().build();
    });

    tearDown(() async {
      await database.close();
    });
    test('count 0', () async {
      int? count = await database.nodeDao.count();
      int expected = 0;
      expect(count, expected);
    });

    test('count 1', () {});
  });
}
