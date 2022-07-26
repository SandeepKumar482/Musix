import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:music/bloc/app_cubit.dart';
import 'package:music/models/track_model.dart';
import 'package:music/screens/track_details.dart';

class FavouriteTile extends StatelessWidget {
  final TrackModel trackModel;
  final VoidCallback onDelete;
  const FavouriteTile({
    Key? key,
    required this.trackModel,
    required this.onDelete
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final blocProvider = BlocProvider.of<AppCubit>(context);
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          boxShadow: [
            BoxShadow(
                color: Colors.black.withOpacity(0.3),
                spreadRadius: 2,
                blurRadius: 2)
          ],
          borderRadius: const BorderRadius.all(
            Radius.circular(5),
          ),
        ),
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: GestureDetector(
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: ((context) {
                    return TrackDetails(trackModel: trackModel);
                  }),
                ),
              );
            },
            child: Row(
              children: [
                const Padding(
                  padding: EdgeInsets.all(8.0),
                  child: Icon(
                    Icons.music_note,
                    color: Colors.blue,
                  ),
                ),
                Expanded(
                  flex: 2,
                  child: Padding(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 4, vertical: 0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          trackModel.trackName,
                          style: const TextStyle(fontWeight: FontWeight.bold),
                        ),
                        Text(
                          trackModel.albumName,
                          style: const TextStyle(color: Colors.grey),
                        )
                      ],
                    ),
                  ),
                ),
                Expanded(
                    flex: 1,
                    child: Padding(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 4, vertical: 0),
                      child: Text(
                        trackModel.artistName,
                        style: const TextStyle(fontWeight: FontWeight.bold),
                      ),
                    )),
                GestureDetector(
                  onTap: onDelete,
                  child: const Padding(
                    padding: EdgeInsets.all(8.0),
                    child: Icon(
                      Icons.delete,
                      color: Colors.red,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
