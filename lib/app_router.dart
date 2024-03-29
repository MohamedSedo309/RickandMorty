import 'package:flutter/material.dart';
import 'package:rick_and_morty_bloc/bussiness_logic/cubit/characters_cubit.dart';
import 'package:rick_and_morty_bloc/constants/strings.dart';
import 'package:rick_and_morty_bloc/data/repositories/characters_repo.dart';
import 'package:rick_and_morty_bloc/data/web_services/characters_web_services.dart';
import 'package:rick_and_morty_bloc/presentation/screens/character_details_screen.dart';
import 'package:rick_and_morty_bloc/presentation/screens/characters_srcreen.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'data/models/character.dart';

class App_Router {
  late Characters_Repo characters_repo;
  late CharactersCubit charactersCubit;

  App_Router() {
    characters_repo = Characters_Repo(Characters_WebServices());
    charactersCubit = CharactersCubit(characters_repo);
  }

  // ignore: body_might_complete_normally_nullable
  Route? generateRoute(RouteSettings settings) {
    switch (settings.name) {
      case (characters_srcreen):
        return MaterialPageRoute(
          builder: (_) => BlocProvider(
            create: (BuildContext context) => charactersCubit,
            child: const CharactersScreen(),
          ),
        );
      case (character_details_screen):
        final character = settings.arguments as Character;
        return MaterialPageRoute(
          builder: (_) => BlocProvider(
            create: (BuildContext context) => charactersCubit,
            child: CharactersDetailsScreen(
              character: character,
            ),
          ),
        );
    }
  }
}
