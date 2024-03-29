import 'package:rick_and_morty_bloc/data/models/char_quoets.dart';
import 'package:rick_and_morty_bloc/data/models/character.dart';
import 'package:rick_and_morty_bloc/data/web_services/characters_web_services.dart';

class Characters_Repo {
  final Characters_WebServices characters_webServices;

  Characters_Repo(this.characters_webServices);

  Future<List<Character>> getAllCharacters() async {
    final characters = await characters_webServices.getAllCharacters();
    return characters
        .map((character) => Character.fromjson(character))
        .toList();
  }

  Future<List<Char_Quote>> getRandomQuote() async {
    final quote = await characters_webServices.getRandomQuote();
    return quote.map((e) => Char_Quote.fromjson(e)).toList();
  }
}
