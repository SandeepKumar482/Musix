import 'package:http/http.dart' as http;

const String apiKey = '7df83d7673c0f204b6a547e53f49e1e3';

Future<http.Response> getTrackListFromAPI() async {
  final result = await http.get(Uri.parse(
      'https://api.musixmatch.com/ws/1.1/chart.tracks.get?apikey=$apiKey'));

  return result;
}

Future<http.Response> getLyrics(String id) async {
  final result = await http.get(Uri.parse(
      'https://api.musixmatch.com/ws/1.1/track.lyrics.get?track_id=$id&apikey=$apiKey'));

  return result;
}
