import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:music/bloc/connection_cubit.dart';
import 'package:music/screens/music.dart';
import 'package:music/screens/favourite.dart';
import 'package:music/screens/no_network_screen.dart';

class Home extends StatefulWidget {
  const Home({Key? key}) : super(key: key);

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  int index = 0;
  List<Widget> pages = [const Music(), const Favourite()];

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<ConnectionCubit, ConnectionStatus>(
      listener: (context, state) {
        if (state == ConnectionStatus.notConnected) {
          ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text('Internet Connection Lost')));
        } else if (state == ConnectionStatus.connected) {
          ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text('Connected To Internet')));
        }
      },
      builder: ((context, state) {
        if (state == ConnectionStatus.connected) {
          return Scaffold(
            appBar: AppBar(
              automaticallyImplyLeading: false,
              title: Center(
                child: Text(index == 0 ? 'Trending Track' : 'Favourites'),
              ),
            ),
            bottomNavigationBar: BottomNavigationBar(
                currentIndex: index,
                onTap: (value) {
                  setState(() {
                    index = value;
                  });
                },
                items: const [
                  BottomNavigationBarItem(
                      icon: Icon(Icons.music_note), label: 'Music'),
                  BottomNavigationBarItem(
                      icon: Icon(
                        Icons.favorite,
                      ),
                      label: 'Favourites')
                ]),
            body: SafeArea(child: pages[index]),
          );
        } else if (state == ConnectionStatus.notConnected) {
          return const NoNetworkScreen();
        } else {
          return Container();
        }
      }),
    );
  }
}
