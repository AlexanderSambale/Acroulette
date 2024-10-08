import 'package:acroulette/bloc/flow_administration/flow_administration_bloc.dart';
import 'package:acroulette/domain_layer/flow_node_repository.dart';
import 'package:acroulette/widgets/dialogs/flow_dialog/create_flow_dialog.dart';
import 'package:acroulette/widgets/flows/flow_view.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class Flows extends StatelessWidget {
  const Flows({super.key});

  @override
  Widget build(BuildContext context) {
    FlowNodeRepository flowNodeRepository = context.read<FlowNodeRepository>();

    return BlocProvider(
        create: (_) => FlowAdministrationBloc(flowNodeRepository),
        child: BlocBuilder<FlowAdministrationBloc, BaseFlowAdministrationState>(
            buildWhen: (previous, current) =>
                current is FlowAdministrationState,
            builder: (BuildContext context, state) {
              FlowAdministrationBloc bloc =
                  context.read<FlowAdministrationBloc>();
              return Stack(children: [
                ListView.builder(
                  shrinkWrap: true,
                  itemCount: flowNodeRepository.flows.length,
                  itemBuilder: (context, index) {
                    return Padding(
                      padding: const EdgeInsets.only(right: 10.0),
                      child: FlowView(
                        flow: flowNodeRepository.flows[index],
                        toggleExpand: bloc.toggleExpand,
                        deletePosture: bloc.deletePosture,
                        deleteFlow: bloc.deleteFlow,
                        onEditClick: bloc.onEditClick,
                        onEditFlowClick: bloc.onEditFlowClick,
                        validator: bloc.validatorFlow,
                        onSavePostureClick: bloc.onSavePostureClick,
                      ),
                    );
                  },
                ),
                Align(
                    alignment: Alignment.bottomCenter,
                    child: SizedBox(
                      child: ElevatedButton(
                          child: const Icon(Icons.add_circle_rounded),
                          onPressed: () {
                            showDialog(
                                context: context,
                                barrierDismissible: false,
                                builder: (BuildContext context) {
                                  return CreateFlow(
                                    onSaveClick: bloc.onSaveFlowClick,
                                    validator: bloc.validatorFlow,
                                  );
                                }).then((exit) {
                              if (exit) return;
                            });
                          }),
                    ))
              ]);
            }));
  }
}
