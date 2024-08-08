import 'package:acroulette/helper/node_helper.dart';
import 'package:acroulette/models/dao/flow_node_dao.dart';
import 'package:acroulette/models/dao/settings_pair_dao.dart';
import 'package:acroulette/models/database.dart';

class StorageProvider {
  late final AppDatabase store;

  late final SettingsPairDao settingsBox;
  late final NodeHelper nodeBox;
  late final FlowNodeDao flowNodeBox;

  StorageProvider._create(this.store) {
    settingsBox = store.settingsPairDao;
    flowNodeBox = store.flowNodeDao;
    nodeBox = NodeHelper(
      store.nodeDao,
      store.nodeNodeDao,
      store.nodeWithoutParentDao,
      store,
    );
  }

  /// Create an instance of StorageProvider to use throughout the app.
  static Future<StorageProvider> create(AppDatabase? store) async {
    StorageProvider storageProvider;
    if (store == null) {
      AppDatabase newStore =
          await $FloorAppDatabase.databaseBuilder('app_database.db').build();
      storageProvider = StorageProvider._create(newStore);
    } else {
      storageProvider = StorageProvider._create(store);
    }
    return storageProvider;
  }
}
