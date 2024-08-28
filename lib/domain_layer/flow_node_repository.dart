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

  Future<int> createFlow(FlowNode flow) async {
    int id = await storageProvider.flowNodeBox.create(flow);
    flows.add(flow);
    return id;
  }

  Future<void> editFlow(FlowNode flow) async {
    await storageProvider.flowNodeBox.updateFlowNode(flow);
    flows = await storageProvider.flowNodeBox.findAllFlowNodes();
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

  List<String> flowPositions(int flowIndex) {
    try {
      FlowNode flow = flows.where((flow) => flow.id == flowIndex).single;
      return flow.positions;
    } catch (e) {
      return [];
    }
  }

  Future<List<int>> putAll(List<FlowNode> objects) async {
    return await storageProvider.flowNodeBox.putAll(objects);
  }
}
