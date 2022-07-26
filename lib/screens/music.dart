import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:music/bloc/app_cubit.dart';
import 'package:music/models/track_model.dart';
import 'package:music/widgets/track_tile.dart';

class Music extends StatelessWidget {
  const Music({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final List<TrackModel> trakList =
        BlocProvider.of<AppCubit>(context).trackList;

    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: ListView.builder(
          itemCount: trakList.length,
          itemBuilder: ((context, index) {
            return TrackTile(
              trackModel: trakList[index],
            );
          })),
    );
  }
}
