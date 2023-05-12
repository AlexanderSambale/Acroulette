import 'package:acroulette/models/flow_node.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  test('convert FlowNode to String and back', () {
    var ninjaStar = FlowNode('ninja star',
        ['ninja side star', 'reverse bird', 'ninja side star', 'buddha']);
    var ninjaStarAsJsonString = ninjaStar.toString();
    var ninjaStarTransformed = FlowNode.createFromString(ninjaStarAsJsonString);
    expect(ninjaStarTransformed.name, ninjaStar.name);
    expect(ninjaStarTransformed.positions, ninjaStar.positions);
  });
}
