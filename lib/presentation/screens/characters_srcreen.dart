import 'package:flutter/material.dart';
import 'package:rick_and_morty_bloc/bussiness_logic/cubit/characters_cubit.dart';
import 'package:rick_and_morty_bloc/constants/colors.dart';

import '../../data/models/character.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../widgets/character_Item.dart';
import 'package:flutter_offline/flutter_offline.dart';

class CharactersScreen extends StatefulWidget {
  const CharactersScreen({super.key});

  @override
  State<CharactersScreen> createState() => _CharactersScreenState();
}

class _CharactersScreenState extends State<CharactersScreen> {
  List<Character> allCharacters = [];
  List<Character> searchedCharacters = [];
  bool isSearch = false;
  final searchTextController = TextEditingController();

  Widget buildSearchfield() {
    return TextField(
      controller: searchTextController,
      cursorColor: MyColors.myGrey,
      decoration: const InputDecoration(
        hintText: "Find a character...",
        border: InputBorder.none,
        hintStyle: TextStyle(color: MyColors.myGrey),
      ),
      onChanged: (searchedChar) {
        createSearchedList(searchedChar);
      },
    );
  }

  void createSearchedList(String searchedChar) {
    searchedCharacters = allCharacters
        .where((element) => element.name.toLowerCase().startsWith(searchedChar))
        .toList();
    setState(() {});
  }

  List<Widget> buildSearchAppbarItems() {
    if (isSearch) {
      return [
        IconButton(
          onPressed: () {
            clearSearch();
            Navigator.pop(context);
          },
          icon: const Icon(
            Icons.clear,
            color: MyColors.myGrey,
          ),
        ),
      ];
    } else {
      return [
        IconButton(
          onPressed: () {
            startseach();
          },
          icon: const Icon(
            Icons.search,
            color: MyColors.myGrey,
          ),
        ),
      ];
    }
  }

  void startseach() {
    ModalRoute.of(context)!
        .addLocalHistoryEntry(LocalHistoryEntry(onRemove: stopSearch));
    setState(() {
      isSearch = true;
    });
  }

  void stopSearch() {
    clearSearch();
    setState(() {
      isSearch = false;
    });
  }

  void clearSearch() {
    setState(() {
      searchTextController.clear();
    });
  }

  Widget buildAppbarTitle() {
    return const Text(
      "Characters",
      style: TextStyle(color: MyColors.myGrey),
    );
  }

  @override
  void initState() {
    super.initState();
    BlocProvider.of<CharactersCubit>(context).getAllCharacters();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: MyColors.myGreen,
        leading: isSearch
            ? const BackButton(
                color: MyColors.myGrey,
              )
            : SizedBox(),
        title: isSearch ? buildSearchfield() : buildAppbarTitle(),
        actions: buildSearchAppbarItems(),
      ),
      body: OfflineBuilder(
        connectivityBuilder: (
          BuildContext context,
          ConnectivityResult connectivity,
          Widget child,
        ) {
          final bool connected = connectivity != ConnectivityResult.none;
          if (connected) {
            return buidBlocWedgit();
          } else {
            return buildNoInternetWidget();
          }
        },
        child: showLoadingIndecator(),
      ),
    );
  }

  Widget buildNoInternetWidget() {
    return Center(
      child: Container(
        color: MyColors.myWhite,
        child: Column(
          children: [
            const SizedBox(
              height: 20,
            ),
            const Text(
              "Can`t Connect!",
              style: TextStyle(fontSize: 22, color: MyColors.myGrey),
            ),
            const Text(
              "Check the internet...",
              style: TextStyle(fontSize: 22, color: MyColors.myGrey),
            ),
            const SizedBox(
              height: 40,
            ),
            Image.asset("assets/images/no_internet.jpg"),
          ],
        ),
      ),
    );
  }

  Widget buidBlocWedgit() {
    return BlocBuilder<CharactersCubit, CharactersState>(
      builder: (context, state) {
        if (state is CharactersLoaded) {
          allCharacters = state.characters;
          return buildLoadedListWidgets();
        } else {
          return showLoadingIndecator();
        }
      },
    );
  }

  Widget showLoadingIndecator() {
    return const Center(
      child: CircularProgressIndicator(
        color: MyColors.myGreen,
      ),
    );
  }

  Widget buildLoadedListWidgets() {
    return SingleChildScrollView(
      child: Container(
        color: MyColors.myGrey,
        child: Column(
          children: [
            buildCharacterslist(),
          ],
        ),
      ),
    );
  }

  Widget buildCharacterslist() {
    return GridView.builder(
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        childAspectRatio: 2 / 3,
        crossAxisSpacing: 1,
        mainAxisSpacing: 1,
      ),
      shrinkWrap: true,
      physics: const ClampingScrollPhysics(),
      padding: EdgeInsets.zero,
      itemCount: searchTextController.text.isEmpty
          ? allCharacters.length
          : searchedCharacters.length,
      itemBuilder: (ctx, index) {
        return CharacterItem(
          character: searchTextController.text.isEmpty
              ? allCharacters[index]
              : searchedCharacters[index],
        );
      },
    );
  }
}
