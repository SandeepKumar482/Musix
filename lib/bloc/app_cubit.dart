import 'dart:convert';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:http/http.dart' as http;
import 'package:music/database/sql_helper.dart';
import 'package:music/models/track_model.dart';
import 'package:music/services/network.dart';

enum AppState { loading, error, done }

class AppCubit extends Cubit<AppState> {
  final List<TrackModel> trackList = [];
  final List<TrackModel> favourite = [];

  AppCubit() : super(AppState.loading) {
    getTrackList();
    emit(AppState.loading);
  }

  void getTrackList() async {
    emit(AppState.loading);
    final http.Response result = await getTrackListFromAPI();
    if (result.statusCode == 200) {
      final Map<String, dynamic> body = jsonDecode(result.body);
      final List list = body['message']['body']['track_list'] as List;
      for (var track in list) {
        trackList.add(trackModelFromJSON(track['track']));
      }
      getFavourite();
    } else {
      emit(AppState.error);
    }
  }

  void getFavourite() async {
    final result = await SQLHelper.getItems();
    for (var data in result) {
      favourite.add(TrackModel(
          trackId: data['trackId'],
          trackName: data['trackName'],
          albumName: data['albumName'],
          artistName: data['artistName'],
          rating: data['rating'],
          explicit: data['explicit']));

    }

    emit(AppState.done);
  }

  void addFavourite(TrackModel trackModel) {
    favourite.add(trackModel);
    emit(AppState.done);
  }

  void deleteFavourite(TrackModel trackModel) {
    favourite.remove(trackModel);
    emit(AppState.done);
  }
}
