import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:music/bloc/app_cubit.dart';
import 'package:music/bloc/connection_cubit.dart';
import 'package:music/screens/error_screen.dart';
import 'package:music/screens/home.dart';
import 'package:music/screens/loading_screen.dart';
import 'package:music/screens/no_network_screen.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
        providers: [
          BlocProvider(create: ((context) => AppCubit())),
          BlocProvider(create: ((context) => ConnectionCubit()))
        ],
        child: MaterialApp(
          debugShowCheckedModeBanner: false,
          title: 'Music App',
          home: BlocBuilder<ConnectionCubit, ConnectionStatus>(
              builder: (context, state) {
            switch (state) {
              case ConnectionStatus.checking:
                return const Loading();
              case ConnectionStatus.connected:
                return BlocBuilder<AppCubit, AppState>(
                    builder: ((context, state) {
                  switch (state) {
                    case AppState.loading:
                      return const Loading();
                    case AppState.error:
                      return const ErrorScreen();

                    case AppState.done:
                      return const Home();
                  }
                }));
              case ConnectionStatus.notConnected:
                return const NoNetworkScreen();
            }
          }),
        ));
  }
}
