import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';
import 'package:rick_and_morty_bloc/data/models/char_quoets.dart';
import 'package:rick_and_morty_bloc/data/repositories/characters_repo.dart';

import '../../data/models/character.dart';

part 'characters_state.dart';

class CharactersCubit extends Cubit<CharactersState> {
  final Characters_Repo characterRepo;
  List<Character> characters = [];
  CharactersCubit(this.characterRepo) : super(CharactersInitial());

  List<Character> getAllCharacters() {
    characterRepo.getAllCharacters().then((characters) {
      emit(CharactersLoaded(characters));
      this.characters = characters;
    });

    return characters;
  }

  void getQuote() {
    characterRepo.getRandomQuote().then((value) {
      emit(QuoteLoaded(value.first.quote));
    });
  }
}
