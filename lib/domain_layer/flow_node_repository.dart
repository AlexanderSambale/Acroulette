import 'package:acroulette/helper/import_export/import.dart';
import 'package:acroulette/helper/io/assets.dart';
import 'package:acroulette/models/flow_node.dart';
import 'package:acroulette/storage_provider.dart';

class FlowNodeRepository {
  final StorageProvider storageProvider;
  late List<FlowNode> flows = [];

  FlowNodeRepository(this.storageProvider);

  Future<void> initialize() async {
    if (await storageProvider.flowNodeBox.count() == 0) {
      String data = await loadAsset('models/AcrouletteBasisFlows.json');
      await importFlowNodes(data, this);
    }

    flows = await storageProvider.flowNodeBox.findAllFlowNodes();
  }

  Future<int> putFlowNode(FlowNode flow) async {
    int id = await storageProvider.flowNodeBox.put(flow);
    flows.add(flow);
    return id;
  }

  Future<void> removeFlowNode(FlowNode flow) async {
    if (flow.id == null) {
      throw Exception('flow id is null!');
    }
    await storageProvider.flowNodeBox.remove(flow.id!);
    flows.remove(flow);
  }

  bool flowExists(String label) {
    bool contains = false;
    for (var flow in flows) {
      if (flow.name == label) {
        return true;
      }
    }
    return contains;
  }

  Future<List<String>> flowPositions(int flowIndex) async {
    FlowNode? flow = await storageProvider.flowNodeBox.findById(flowIndex);
    if (flow == null) {
      return [];
    } else {
      return flow.positions;
    }
  }

  Future<List<int>> putAll(List<FlowNode> objects) async {
    return await storageProvider.flowNodeBox.putAll(objects);
  }
}
