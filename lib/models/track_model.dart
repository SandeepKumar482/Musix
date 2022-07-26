class TrackModel {
  final int trackId;
  final String trackName;
  final String albumName;
  final String artistName;
  final int rating;
  final int explicit;

  TrackModel(
      {required this.trackId,
      required this.trackName,
      required this.albumName,
      required this.artistName,
      required this.rating,
      required this.explicit});

  Map<String, dynamic> toMap() {
    return {
      'trackId': trackId,
      'trackName': trackName,
      'albumName': albumName,
      'artistName': artistName,
      'rating': rating,
      'explicit': explicit
    };
  }
}

TrackModel trackModelFromJSON(Map<String, dynamic> data) {
  return TrackModel(
      trackId: data['track_id'],
      trackName: data['track_name'],
      albumName: data['album_name'],
      artistName: data['artist_name'],
      rating: data['track_rating'],
      explicit: data['explicit']);
}
