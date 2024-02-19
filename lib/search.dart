import 'dart:convert';
import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:http/http.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'RecipeView.dart';
import 'model_search.dart';

class Search extends StatefulWidget {
  String query;
  Search(this.query);

  @override
  _SearchState createState() => _SearchState();
}

class _SearchState extends State<Search> {
  bool isLoading = true;
  List<RecipeModel> recipeList = <RecipeModel>[];
  TextEditingController searchController = TextEditingController();
  Color boxColor = Color.fromARGB(255, 34, 34, 34).withOpacity(1);

  // Default color for the "Recipe not found" box
  Color buttonColor = const Color.fromARGB(
      255, 250, 250, 250); // Default color for the OK button text

  void _performSearch() {
    if ((searchController.text).replaceAll(" ", "") != "") {
      setState(() {
        isLoading = true;
        recipeList.clear();
      });
      getRecipes(searchController.text);
    }
  }

  getRecipes(String query) async {
    String? apiKey = dotenv.env['APIKEY'];
    String? apiId = dotenv.env['ID'];
    String url =
        "https://api.edamam.com/search?q=$query&app_id=${apiId}&app_key=${apiKey}";

    Response response = await get(Uri.parse(url));
    Map data = jsonDecode(response.body);
    setState(() {
      data["hits"].forEach((element) {
        RecipeModel recipeModel = RecipeModel.fromMap(element["recipe"]);
        recipeList.add(recipeModel);
        isLoading = false;
        log(recipeList.toString());
      });
    });

    if (recipeList.isEmpty) {
      showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            backgroundColor: boxColor,
            title: Text(
              "Recipe not found",
              style: TextStyle(color: Colors.white),
            ),
            content: Text(
              "Sorry, no recipes found for your search.",
              style: TextStyle(color: Colors.white),
            ),
            actions: [
              TextButton(
                onPressed: () {
                  Navigator.of(context).pop();
                  _navigateBack();
                },
                child: Text(
                  "OK",
                  style: TextStyle(color: buttonColor),
                ),
              ),
            ],
          );
        },
      );
    }

    recipeList.forEach((Recipe) {
      print(Recipe.applabel);
      print(Recipe.appcalories);
    });
  }

  void _navigateBack() {
    Navigator.of(context).pop();
    Navigator.of(context).maybePop();
  }

  @override
  void initState() {
    super.initState();
    getRecipes(widget.query);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          Container(
            width: MediaQuery.of(context).size.width,
            height: MediaQuery.of(context).size.height,
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [
                 ],
              ),
            ),
          ),
          RawKeyboardListener(
            focusNode: FocusNode(),
            onKey: (RawKeyEvent event) {
              if (event is RawKeyDownEvent &&
                  event.logicalKey == LogicalKeyboardKey.enter) {
                _performSearch();
              }
            },
            child: SingleChildScrollView(
              child: Column(
                children: [
                  SafeArea(
                    child: Container(
                      padding: EdgeInsets.symmetric(horizontal: 0),
                      margin:
                          EdgeInsets.symmetric(horizontal: 25, vertical: 20),
                      decoration: BoxDecoration(
                        color: Color.fromARGB(255, 214, 213, 213),
                        borderRadius: BorderRadius.circular(24),
                      ),
                      child: Row(
                        children: [
                          Expanded(
                            child: TextField(
                              controller: searchController,
                              decoration: InputDecoration(
                                border: InputBorder.none,
                                hintText: "Let's Cook Something!",
                                contentPadding:
                                    EdgeInsets.fromLTRB(20, 0, 0, 4),
                              ),
                            ),
                          ),
                          TextButton(
                            onPressed: () {
                              _performSearch();
                            },
                            child: Container(
                              padding: EdgeInsets.fromLTRB(15, 6, 15, 8),
                              decoration: BoxDecoration(
                                color: Color.fromARGB(255, 54, 54, 54)
                                    .withOpacity(1),
                                borderRadius: BorderRadius.circular(24),
                              ),
                              child: Center(
                                child: Text(
                                  'Search',
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 16,
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  Container(
                    child: isLoading
                        ? CircularProgressIndicator(valueColor: AlwaysStoppedAnimation<Color>(const Color.fromARGB(255, 31, 31, 31)))
                        : ListView.builder(
                            physics: NeverScrollableScrollPhysics(),
                            shrinkWrap: true,
                            itemCount: recipeList.length,
                            itemBuilder: (context, index) {
                              return InkWell(
                                onTap: () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) => RecipeView(
                                        recipeList[index].appurl,
                                      ),
                                    ),
                                  );
                                },
                                child: Card(
                                  margin: EdgeInsets.all(20),
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(10),
                                  ),
                                  elevation: 0.0,
                                  child: Stack(
                                    children: [
                                      ClipRRect(
                                        borderRadius:
                                            BorderRadius.circular(10.0),
                                        child: Image.network(
                                          recipeList[index].appimgUrl,
                                          fit: BoxFit.cover,
                                          width: double.infinity,
                                          height: 200,
                                        ),
                                      ),
                                      Positioned(
                                        left: 0,
                                        right: 0,
                                        bottom: 0,
                                        child: Container(
                                          padding: EdgeInsets.symmetric(
                                            vertical: 5,
                                            horizontal: 10,
                                          ),
                                          decoration: BoxDecoration(
                                            borderRadius: BorderRadius.only(
                                              bottomLeft: Radius.circular(24),
                                              bottomRight: Radius.circular(24),
                                            ),
                                            color: Color.fromARGB(
                                                66, 119, 119, 119),
                                          ),
                                          child: Text(
                                            recipeList[index].applabel,
                                            style: TextStyle(
                                              color: Colors.white,
                                              fontSize: 20,
                                            ),
                                          ),
                                        ),
                                      ),
                                      Positioned(
                                        top: 8,
                                        right: 9,
                                        height: 40,
                                        width: 80,
                                        child: Container(
                                            decoration: BoxDecoration(
                                                color: Colors.white,
                                                borderRadius: BorderRadius.only(
                                                    topRight:
                                                        Radius.circular(17),
                                                    topLeft:
                                                        Radius.circular(17),
                                                    bottomRight:
                                                        Radius.circular(17),
                                                    bottomLeft:
                                                        Radius.circular(17))),
                                          child: Center(
                                            child: Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.center,
                                              children: [
                                                Icon(
                                                  Icons.local_fire_department,
                                                  size: 15,
                                                ),
                                                Text(
                                                  recipeList[index]
                                                              .appcalories
                                                              .toString()
                                                              .length >=
                                                          6
                                                      ? recipeList[index]
                                                          .appcalories
                                                          .toString()
                                                          .substring(0, 6)
                                                      : recipeList[index]
                                                          .appcalories
                                                          .toString(),
                                                ),
                                              ],
                                            ),
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              );
                            },
                          ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
