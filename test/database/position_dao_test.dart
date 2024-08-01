import 'package:acroulette/models/database.dart';
import 'package:acroulette/models/entities/position.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('position_dao', () {
    late AppDatabase database;

    setUp(() async {
      database = await $FloorAppDatabase.inMemoryDatabaseBuilder().build();
    });

    tearDown(() async {
      await database.close();
    });

    test('count 0', () async {
      int? count = await database.positionDao.count();
      int expected = 0;
      expect(count, expected);
    });

    test('create Position', () async {
      Position position = Position(null, 'position');
      await database.positionDao.put(position);
      int? count = await database.positionDao.count();
      int expected = 1;
      expect(count, expected);
    });

    test('create Positions', () async {
      List<Position> positions = [
        Position(null, 'position1'),
        Position(null, 'position2'),
        Position(null, 'position3'),
      ];
      await database.positionDao.putAll(positions);
      int? count = await database.positionDao.count();
      int expected = 3;
      expect(count, expected);
    });

    test('clear Positions', () async {
      List<Position> positions = [
        Position(null, 'position1'),
        Position(null, 'position2'),
        Position(null, 'position3'),
      ];
      await database.positionDao.putAll(positions);
      int? count = await database.positionDao.count();
      int expected = 3;
      expect(count, expected);
      await database.positionDao.clear();
      count = await database.positionDao.count();
      expected = 0;
      expect(count, expected);
    });

    test('find Position by Name', () async {
      String name = 'position2';
      List<Position> positions = [
        Position(null, 'position1'),
        Position(null, name),
        Position(null, 'position3'),
      ];
      await database.positionDao.putAll(positions);
      Position? position = await database.positionDao.findByName(name);
      expect(position?.name, name);
    });

    test('find all positions', () async {
      List<Position> positions = [
        Position(null, 'position1'),
        Position(null, 'position2'),
        Position(null, 'position3'),
      ];
      await database.positionDao.putAll(positions);
      List<Position?> positions2 = await database.positionDao.findAll();
      expect(positions2[0]?.name, positions[0].name);
      expect(positions2[1]?.name, positions[1].name);
      expect(positions2[2]?.name, positions[2].name);
    });
  });
}
