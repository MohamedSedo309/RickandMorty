import 'package:flutter/material.dart';
import 'package:rick_and_morty_bloc/bussiness_logic/cubit/characters_cubit.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:animated_text_kit/animated_text_kit.dart';
import '../../constants/colors.dart';
import '../../data/models/character.dart';

class CharactersDetailsScreen extends StatelessWidget {
  final Character character;

  CharactersDetailsScreen({super.key, required this.character});

  late List<String> episods_List = [];

  @override
  Widget build(BuildContext context) {
    episods_List = getList(character.appearence);
    BlocProvider.of<CharactersCubit>(context).getQuote();
    return Scaffold(
      backgroundColor: MyColors.myGrey,
      body: WillPopScope(
        onWillPop: () async {
          BlocProvider.of<CharactersCubit>(context).getAllCharacters();
          return true;
        },
        child: CustomScrollView(
          slivers: [
            buildSliverAppBar(),
            SliverList(
              delegate: SliverChildListDelegate(
                [
                  Container(
                    margin: const EdgeInsets.fromLTRB(14, 14, 14, 0),
                    padding: const EdgeInsets.all(8),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        buildCharacterInfo("Name: ", character.name),
                        buildCharacterInfoDevider(280),
                        buildCharacterInfo("Type: ", character.type),
                        buildCharacterInfoDevider(270),
                        buildCharacterInfo("Status: ", character.status),
                        buildCharacterInfoDevider(280),
                        buildCharacterInfo(
                            "Episods: ", episods_List.join(" / ")),
                        buildCharacterInfoDevider(230),
                        buildCharacterInfo("Origin: ", character.origin),
                        buildCharacterInfoDevider(280),
                        const SizedBox(
                          height: 25,
                        ),
                        BlocBuilder<CharactersCubit, CharactersState>(
                            builder: (context, state) {
                          return checkIfQuoteLoaded(state);
                        }),
                      ],
                    ),
                  ),
                  const SizedBox(
                    height: 500,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  SliverAppBar buildSliverAppBar() {
    return SliverAppBar(
      expandedHeight: 600,
      pinned: true,
      stretch: true,
      backgroundColor: MyColors.myGrey,
      flexibleSpace: FlexibleSpaceBar(
        centerTitle: true,
        title: Text(
          character.name,
          style: const TextStyle(
            color: MyColors.myGreen,
            shadows: [
              Shadow(
                color: Colors.black,
                offset: Offset(2.0, 2.0),
                blurRadius: 3.0,
              ),
            ],
          ),
          //textAlign: TextAlign.center,
        ),
        background: Hero(
          tag: character.id,
          child: Image.network(
            character.image,
            fit: BoxFit.cover,
          ),
        ),
      ),
    );
  }

  RichText buildCharacterInfo(String title, String value) {
    return RichText(
      maxLines: 1,
      overflow: TextOverflow.ellipsis,
      text: TextSpan(children: [
        TextSpan(
          text: title,
          style: const TextStyle(
            fontWeight: FontWeight.bold,
            color: MyColors.myWhite,
            fontSize: 24,
          ),
        ),
        TextSpan(
          text: value,
          style: const TextStyle(
            color: MyColors.myWhite,
            fontSize: 22,
          ),
        ),
      ]),
    );
  }

  Divider buildCharacterInfoDevider(double end) {
    return Divider(
      color: MyColors.myGreen,
      height: 40,
      endIndent: end,
      thickness: 4,
    );
  }

  List<String> getList(List<dynamic> episodeList) {
    List<String> episodeNumbers = [];

    episodeList.forEach((episodeUrl) {
      String episodeNumber = episodeUrl.split('/').last;
      episodeNumbers.add(episodeNumber);
    });

    return episodeNumbers;
  }

  Widget checkIfQuoteLoaded(CharactersState state) {
    if (state is QuoteLoaded) {
      return displayRandomQuoteORemptySpace(state);
    } else {
      return showLoading();
    }
  }

  Widget displayRandomQuoteORemptySpace(QuoteLoaded state) {
    var quote = (state).quote;
    if (quote.isNotEmpty) {
      return Center(
          child: DefaultTextStyle(
        style: const TextStyle(
          fontSize: 22,
          color: MyColors.myWhite,
          shadows: [
            Shadow(
                blurRadius: 7, color: MyColors.myGreen, offset: Offset(0, 0)),
          ],
        ),
        textAlign: TextAlign.center,
        child: AnimatedTextKit(
          repeatForever: true,
          animatedTexts: [
            FlickerAnimatedText(quote),
          ],
        ),
      ));
    } else {
      return Container();
    }
  }

  Widget showLoading() {
    return const Center(
      child: CircularProgressIndicator(
        color: MyColors.myGreen,
      ),
    );
  }
}
