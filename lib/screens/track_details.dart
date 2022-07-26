import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:http/http.dart' as http;
import 'package:music/bloc/app_cubit.dart';
import 'package:music/bloc/connection_cubit.dart';
import 'package:music/database/sql_helper.dart';
import 'package:music/models/track_model.dart';
import 'package:music/screens/no_network_screen.dart';
import 'package:music/services/network.dart';

class TrackDetails extends StatefulWidget {
  final TrackModel trackModel;
  const TrackDetails({Key? key, required this.trackModel}) : super(key: key);

  @override
  State<TrackDetails> createState() => _TrackDetailsState();
}

class _TrackDetailsState extends State<TrackDetails> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final blocProvider = BlocProvider.of<AppCubit>(context);
    final List<TrackModel> favourite = blocProvider.favourite;

    return BlocConsumer<ConnectionCubit, ConnectionStatus>(
        listener: (context, state) {
      if (state == ConnectionStatus.notConnected) {
        ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Internet Connection Lost')));
      } else if (state == ConnectionStatus.connected) {
        ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Connected To Internet')));
      }
    }, builder: ((context, state) {
      if (state == ConnectionStatus.connected) {
        return Scaffold(
          appBar: AppBar(
            leading: GestureDetector(
              onTap: () {
                Navigator.pop(context);
              },
              child: const Icon(Icons.arrow_back),
            ),
            title: const Text('Track Details'),
          ),
          body: SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      const Expanded(
                        child: Text(
                          'Name',
                          style: TextStyle(
                              fontWeight: FontWeight.bold, fontSize: 18),
                        ),
                      ),
                      Expanded(
                          flex: 2,
                          child: Text(widget.trackModel.trackName,
                              style: const TextStyle(fontSize: 18)))
                    ],
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  Row(
                    children: [
                      const Expanded(
                        child: Text(
                          'Artist',
                          style: TextStyle(
                              fontWeight: FontWeight.bold, fontSize: 18),
                        ),
                      ),
                      Expanded(
                          flex: 2,
                          child: Text(widget.trackModel.artistName,
                              style: const TextStyle(fontSize: 18)))
                    ],
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  Row(
                    children: [
                      const Expanded(
                        child: Text(
                          'Album Name',
                          style: TextStyle(
                              fontWeight: FontWeight.bold, fontSize: 18),
                        ),
                      ),
                      Expanded(
                          flex: 2,
                          child: Text(widget.trackModel.albumName,
                              style: const TextStyle(fontSize: 18)))
                    ],
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  Row(
                    children: [
                      const Expanded(
                        child: Text(
                          'Explicit',
                          style: TextStyle(
                              fontWeight: FontWeight.bold, fontSize: 18),
                        ),
                      ),
                      Expanded(
                          flex: 2,
                          child: Text(
                              widget.trackModel.explicit == 0
                                  ? 'False'
                                  : 'True',
                              style: const TextStyle(fontSize: 18)))
                    ],
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  Row(
                    children: [
                      const Expanded(
                        child: Text(
                          'Rating',
                          style: TextStyle(
                              fontWeight: FontWeight.bold, fontSize: 18),
                        ),
                      ),
                      Expanded(
                          flex: 2,
                          child: Text(widget.trackModel.rating.toString(),
                              style: const TextStyle(fontSize: 18)))
                    ],
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  Text(favourite.contains(widget.trackModel).toString()),
                  if (!favourite.contains(widget.trackModel))
                    GestureDetector(
                      onTap: () async {
                        await SQLHelper.addTrack(widget.trackModel);
                        blocProvider.addFavourite(widget.trackModel);
                        setState(() {});
                      },
                      child: Container(
                        margin: const EdgeInsets.symmetric(horizontal: 40),
                        decoration: const BoxDecoration(
                            color: Colors.blue,
                            borderRadius:
                                BorderRadius.all(Radius.circular(10))),
                        child: Padding(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 16, vertical: 8),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: const [
                              Icon(
                                Icons.favorite,
                                color: Colors.red,
                              ),
                              SizedBox(
                                width: 10,
                              ),
                              Text(
                                'Add To Favourite',
                                style: TextStyle(
                                    color: Colors.white,
                                    fontWeight: FontWeight.bold),
                              )
                            ],
                          ),
                        ),
                      ),
                    ),
                  if (favourite.contains(widget.trackModel))
                    GestureDetector(
                      onTap: () async {
                        await SQLHelper.deleteItem(widget.trackModel.trackId);
                        blocProvider.deleteFavourite(widget.trackModel);
                        setState(() {});
                      },
                      child: Container(
                        margin: const EdgeInsets.symmetric(horizontal: 40),
                        decoration: BoxDecoration(
                            color: Colors.grey.withOpacity(0.3),
                            borderRadius:
                                const BorderRadius.all(Radius.circular(10))),
                        child: Padding(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 16, vertical: 8),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: const [
                              Icon(
                                Icons.favorite,
                                color: Colors.red,
                              ),
                              SizedBox(
                                width: 10,
                              ),
                              Text(
                                'Remove',
                                style: TextStyle(
                                    color: Colors.red,
                                    fontWeight: FontWeight.bold),
                              )
                            ],
                          ),
                        ),
                      ),
                    ),
                  const SizedBox(
                    height: 20,
                  ),
                  const Center(
                    child: Text(
                      'Lyrics',
                      style:
                          TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
                    ),
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  FutureBuilder<http.Response>(
                      future: getLyrics(widget.trackModel.trackId.toString()),
                      builder: ((context, snapshot) {
                        if (!snapshot.hasData) {
                          return const Center(
                            child: CircularProgressIndicator(),
                          );
                        }
                        if (snapshot.data!.statusCode == 200) {
                          final Map<String, dynamic> body =
                              jsonDecode(snapshot.data!.body);

                          return Text(
                              body['message']['body']['lyrics']['lyrics_body']
                                  .toString(),
                              style: const TextStyle(fontSize: 18));
                        } else {
                          return const Center(
                            child: Text('No Lyrics Found Some Error Occured'),
                          );
                        }
                      }))
                ],
              ),
            ),
          ),
        );
      } else if (state == ConnectionStatus.notConnected) {
        return const NoNetworkScreen();
      } else {
        return const Center(
          child: CircularProgressIndicator(),
        );
      }
    }));
  }
}
