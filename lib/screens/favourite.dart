import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:music/bloc/app_cubit.dart';
import 'package:music/database/sql_helper.dart';
import 'package:music/models/track_model.dart';
import 'package:music/widgets/favourite_tile.dart';

class Favourite extends StatefulWidget {
  const Favourite({Key? key}) : super(key: key);

  @override
  State<Favourite> createState() => _FavouriteState();
}

class _FavouriteState extends State<Favourite> {
  @override
  Widget build(BuildContext context) {
    final blocProvider = BlocProvider.of<AppCubit>(context);
    final List<TrackModel> trakList = blocProvider.favourite;

    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: ListView.builder(
          itemCount: trakList.length,
          itemBuilder: ((context, index) {
            return FavouriteTile(
              trackModel: trakList[index],
              onDelete: () async {
                await SQLHelper.deleteItem(trakList[index].trackId);
                blocProvider.deleteFavourite(trakList[index]);
                setState(() {});
              },
            );
          })),
    );
  }
}
