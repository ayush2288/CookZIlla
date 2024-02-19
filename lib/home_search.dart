import 'dart:convert';
import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:http/http.dart';
import 'dart:math' as ran;
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:llm_chatbot_openai/main.dart';

import 'RecipeView.dart';
import 'model_search.dart';
import 'search.dart';

void main() async {
  await dotenv.load();
  runApp(MyApp());
}

class Home extends StatefulWidget {
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  ScrollController _scrollController = ScrollController();
  bool isLoading = true;
  List<RecipeModel> recipeList = <RecipeModel>[];
  TextEditingController searchController = TextEditingController();

  List reciptCatList = [
    {
      "imgUrl":
          "https://images.unsplash.com/photo-1515516969-d4008cc6241a?q=80&w=987&auto=format&fit=crop&ixlib=rb-4.0.3&ixid=M3wxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8fA%3D%3D",
      "heading": "Chilli Food"
    },
    {
      "imgUrl":
          "https://images.unsplash.com/photo-1501443762994-82bd5dace89a?q=80&w=1170&auto=format&fit=crop&ixlib=rb-4.0.3&ixid=M3wxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8fA%3D%3D",
      "heading": "IceCream"
    },
    {
      "imgUrl":
          "https://images.unsplash.com/photo-1551024506-0bccd828d307?q=80&w=1064&auto=format&fit=crop&ixlib=rb-4.0.3&ixid=M3wxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8fA%3D%3D",
      "heading": "Dessert"
    },
    {
      "imgUrl":
          "https://images.unsplash.com/photo-1571066811602-716837d681de?q=80&w=1136&auto=format&fit=crop&ixlib=rb-4.0.3&ixid=M3wxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8fA%3D%3D",
      "heading": "Pizza"
    },
    {
      "imgUrl":
          "https://images.unsplash.com/photo-1596649299486-4cdea56fd59d?q=80&w=987&auto=format&fit=crop&ixlib=rb-4.0.3&ixid=M3wxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8fA%3D%3D",
      "heading": "Burger"
    },
    {
      "imgUrl":
          "https://images.unsplash.com/photo-1625220194771-7ebdea0b70b9?q=80&w=1170&auto=format&fit=crop&ixlib=rb-4.0.3&ixid=M3wxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8fA%3D%3D",
      "heading": "Momos"
    },
    {
      "imgUrl":
          "https://images.unsplash.com/photo-1528735602780-2552fd46c7af?q=80&w=1173&auto=format&fit=crop&ixlib=rb-4.0.3&ixid=M3wxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8fA%3D%3D",
      "heading": "Sandwich"
    },
    {
      "imgUrl":
          "https://images.unsplash.com/photo-1589302168068-964664d93dc0?q=80&w=987&auto=format&fit=crop&ixlib=rb-4.0.3&ixid=M3wxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8fA%3D%3D",
      "heading": "Biryani"
    },
    {
      "imgUrl":
          "https://images.unsplash.com/photo-1585032226651-759b368d7246?q=80&w=992&auto=format&fit=crop&ixlib=rb-4.0.3&ixid=M3wxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8fA%3D%3D",
      "heading": "Noodles"
    },
    {
      "imgUrl":
          "https://images.unsplash.com/photo-1582454235987-1e597bafcf58?q=80&w=987&auto=format&fit=crop&ixlib=rb-4.0.3&ixid=M3wxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8fA%3D%3D",
      "heading": "Rolls"
    },
    {
      "imgUrl":
          "https://images.unsplash.com/photo-1512058564366-18510be2db19?q=80&w=1172&auto=format&fit=crop&ixlib=rb-4.0.3&ixid=M3wxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8fA%3D%3D",
      "heading": "Rice"
    },
    {
      "imgUrl":
          "https://images.unsplash.com/photo-1694849789325-914b71ab4075?q=80&w=1074&auto=format&fit=crop&ixlib=rb-4.0.3&ixid=M3wxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8fA%3D%3D",
      "heading": "Dosa"
    },
    {
      "imgUrl":
          "https://images.unsplash.com/photo-1630383249896-424e482df921?q=80&w=980&auto=format&fit=crop&ixlib=rb-4.0.3&ixid=M3wxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8fA%3D%3D",
      "heading": "Idli"
    },
    {
      "imgUrl":
          "https://images.unsplash.com/photo-1662116765994-1e4200c43589?q=80&w=1032&auto=format&fit=crop&ixlib=rb-4.0.3&ixid=M3wxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8fA%3D%3D",
      "heading": "Shawarma"
    },
    {
      "imgUrl":
          "https://images.unsplash.com/photo-1608219994488-cc269412b3e4?q=80&w=987&auto=format&fit=crop&ixlib=rb-4.0.3&ixid=M3wxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8fA%3D%3D",
      "heading": "Fries"
    },
    {
      "imgUrl":
          "https://images.unsplash.com/photo-1601050690597-df0568f70950?q=80&w=1170&auto=format&fit=crop&ixlib=rb-4.0.3&ixid=M3wxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8fA%3D%3D",
      "heading": "Samosa"
    },
    {
      "imgUrl":
          "https://images.unsplash.com/photo-1620791144170-8a443bf37a33?q=80&w=1064&auto=format&fit=crop&ixlib=rb-4.0.3&ixid=M3wxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8fA%3D%3D",
      "heading": "Soup"
    },
    {
      "imgUrl":
          "https://images.unsplash.com/photo-1567620832903-9fc6debc209f?q=80&w=960&auto=format&fit=crop&ixlib=rb-4.0.3&ixid=M3wxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8fA%3D%3D",
      "heading": "Chicken"
    },
    {
      "imgUrl":
          "https://images.unsplash.com/photo-1611312410928-bdcb480e6239?q=80&w=971&auto=format&fit=crop&ixlib=rb-4.0.3&ixid=M3wxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8fA%3D%3D",
      "heading": "Chai"
    },
    {
      "imgUrl":
          "https://images.unsplash.com/photo-1541167760496-1628856ab772?q=80&w=1037&auto=format&fit=crop&ixlib=rb-4.0.3&ixid=M3wxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8fA%3D%3D",
      "heading": "Coffee"
    },
    {
      "imgUrl":
          "https://images.unsplash.com/photo-1578020226954-96c7a7fcf94c?q=80&w=1035&auto=format&fit=crop&ixlib=rb-4.0.3&ixid=M3wxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8fA%3D%3D",
      "heading": "Fish"
    },
    {
      "imgUrl":
          "https://images.unsplash.com/photo-1591465619385-1ef36826b8bd?q=80&w=1170&auto=format&fit=crop&ixlib=rb-4.0.3&ixid=M3wxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8fA%3D%3D",
      "heading": "Kachori"
    },
    {
      "imgUrl":
          "https://images.unsplash.com/photo-1596560548464-f010549b84d7?q=80&w=1170&auto=format&fit=crop&ixlib=rb-4.0.3&ixid=M3wxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8fA%3D%3D",
      "heading": "Fried rice"
    },
    {
      "imgUrl":
          "https://images.unsplash.com/photo-1602351447937-745cb720612f?dpr=1&h=200&w=120&auto=format&fit=crop&q=60&ixid=M3wxMjA3fDB8MXxzZWFyY2h8MTB8fGNha2V8ZW58MHx8fHwxNzA4MTE2MTgxfDA&ixlib=rb-4.0.3",
      "heading": "Cake"
    },
    {
      "imgUrl":
          "https://images.unsplash.com/photo-1555126634-323283e090fa?dpr=1&h=200&w=120&auto=format&fit=crop&q=60&ixid=M3wxMjA3fDB8MXxzZWFyY2h8OHx8Y2hpbmVzZSUyMGZvb2R8ZW58MHx8fHwxNzA4MTM3ODI1fDA&ixlib=rb-4.0.3",
      "heading": "Chinese"
    },
    {
      "imgUrl":
          "https://images.unsplash.com/photo-1476718406336-bb5a9690ee2a?dpr=1&h=200&w=120&auto=format&fit=crop&q=60&ixid=M3wxMjA3fDB8MXxhbGx8fHx8fHx8fHwxNzA4MTgzODUxfA&ixlib=rb-4.0.3",
      "heading": "Soup"
    },
    {
      "imgUrl":
          "https://images.unsplash.com/photo-1604068549290-dea0e4a305ca?dpr=1&h=200&w=120&auto=format&fit=crop&q=60&ixid=M3wxMjA3fDB8MXxzZWFyY2h8MTF8fGl0YWxpYW4lMjBmb29kfGVufDB8fHx8MTcwODE0MjkwNXww&ixlib=rb-4.0.3",
      "heading": "Italian"
    },
    {
      "imgUrl":
          "https://images.unsplash.com/photo-1607330289024-1535c6b4e1c1?dpr=1&h=200&w=120&auto=format&fit=crop&q=60&ixid=M3wxMjA3fDB8MXxzZWFyY2h8NHx8dGhhaSUyMGZvb2R8ZW58MHx8fHwxNzA4MTg1MjYwfDA&ixlib=rb-4.0.3",
      "heading": "Thai"
    },
  
  ];
  getRecipes(String query) async {
    String? apiKey = dotenv.env['APIKEY'];
    String? apiId = dotenv.env['ID'];
    String url =
        "https://api.edamam.com/search?q=$query&app_id=${apiId}&app_key=${apiKey}";

    try {
      Response response = await get(Uri.parse(url));
      if (response.statusCode == 200) {
        Map data = jsonDecode(response.body);
        List<RecipeModel> newRecipeList = [];

        data["hits"].forEach((element) {
          RecipeModel recipeModel = RecipeModel();
          recipeModel = RecipeModel.fromMap(element["recipe"]);
          newRecipeList.add(recipeModel);
        });

        setState(() {
          recipeList = List.from(newRecipeList);
          isLoading = false;
        });

        recipeList.forEach((Recipe) {
          print(Recipe.applabel);
          print(Recipe.appcalories);
        });
      } else {
        print("Error: ${response.statusCode}");
      }
    } catch (e) {
      print("Error: $e");
    }
  }

  List<String> items = [
    'momos',
    'Chilli Food',
    'IceCream',
    
    'Burger',
    'Sandwich',
    'Noodles',
    'Rolls',
    'Dosa',
    'Shawarma',
    'Fries',
    'Soup',
    'Chai',
    'Kachori',
    'fried rice',
    'cake',
    'paneer',
    'chinese',
    'manchurian',
    'soup',
    'waffles',
    'italian',
    'thai',
    'maxican',
    'indian',
  ];

  @override
  void initState() {
    _initializeRecipes();

    _scrollController.addListener(() {
      if (_scrollController.position.pixels ==
          _scrollController.position.maxScrollExtent) {
        // Fetch more recipes or perform any necessary action
      }
    });
  }

  void _initializeRecipes() async {
    if (items.isNotEmpty) {
      final randomIndex = ran.Random().nextInt(items.length);
      if (randomIndex >= 0 && randomIndex < items.lmength) {
        await getRecipes(
            items[randnomIndex]); // Wait for the asynchronous operation
        setState(() {
          isLoading = false;
        });
      } else {
        // Handle the case when the random index is out of bounds.
        print("Random index is out of bounds.");
      }
    }
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
              gradient: LinearGradient(colors: []),
            ),
          ),

          /*
      // * InWell - Tap,DoubleTaP,etc.
      // * Gesture Detector
      // *
      // * Hover - Color
      // * Tap - Splash
      // *
      // * Getsure -
      // * Swipe,'
      // *
      // * Card - elevation background color,radius child
      // *
      // * ClipRRect - Frame - Photo Rectangle
      // *
      // * ClipPath - Custom CLips
      // *
      * positioned  - Stack - topleft , top,down,left - 2.2
     
          SingleChildScrollView(
            child: Column(
              children: [
                //Search Bar
                SafeArea(
                  child: Container(
                    padding: EdgeInsets.symmetric(horizontal: 10),
                    margin: EdgeInsets.symmetric(horizontal: 25, vertical: 20),
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
                                    EdgeInsets.fromLTRB(13, 0, 0, 4)),
                          ),
                        ),
                        GestureDetector(
                          onTap: () {
                            if ((searchController.text).replaceAll(" ", "") ==
                                "") {
                              print("Blank search");
                            } else {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) =>
                                      Search(searchController.text),
                                ),
                              );
                            }
                          },
                          child: Container(
                            padding: EdgeInsets.fromLTRB(15, 4, 15, 7),
                            decoration: BoxDecoration(
                              color: Color.fromARGB(255, 43, 43, 43)
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
                           

                Container(
                  padding: EdgeInsets.symmetric(horizontal: 20),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "HEY CHEF, WHAT ARE WE GOING TO COOK TODAY?",
                        style: GoogleFonts.poppins(
                            fontSize: 40,
                            fontWeight: FontWeight.w800,
                            color: Colors.black),
                      ),
                      SizedBox(
                        height: 10,
                      ),
                      Text(
                        "Let's Cook Something New!",
                        style: TextStyle(fontSize: 20, color: Colors.black),
                      )
                    ],
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
                                              recipeList[index].appurl)));
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
                                              BorderRadius.circular(20),
                                          child: Image.network(
                                            recipeList[index].appimgUrl,
                                            fit: BoxFit.cover,
                                            width: double.infinity,
                                            height: 200,
                                          )),
                                      Positioned(
                                          left: 0,
                                          right: 0,
                                          bottom: 0,
                                          child: Container(
                                              padding: EdgeInsets.symmetric(
                                                  vertical: 5, horizontal: 10),
                                              decoration: BoxDecoration(
                                                  borderRadius:
                                                      BorderRadius.only(
                                                    bottomLeft:
                                                        Radius.circular(20),
                                                    bottomRight:
                                                        Radius.circular(20),
                                                    topLeft: Radius.circular(0),
                                                    topRight:
                                                        Radius.circular(0),
                                                  ),
                                                  color: Color.fromARGB(
                                                      66, 0, 0, 0)),
                                              child: Text(
                                                recipeList[index].applabel,
                                                style: TextStyle(
                                                    color: Colors.white,
                                                    fontSize: 20),
                                              ))),
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
                                                  Text(recipeList[index]
                                                      .appcalories
                                                      .toString()
                                                      .substring(0, 6)),
                                                ],
                                              ),
                                            )),
                                      )
                                    ],
                                  ),
                                ),
                              );
                            })),

                Container(
                  height: 100,
                  child: ListView.builder(
                      itemCount: reciptCatList.length,
                      shrinkWrap: true,
                      scrollDirection: Axis.horizontal,
                      itemBuilder: (context, index) {
                        return Container(
                            child: InkWell(
                          onTap: () {
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => Search(
                                        reciptCatList[index]["heading"])));
                          },
                          child: Card(
                              margin: EdgeInsets.all(20),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(15),
                              ),
                              elevation: 0.0,
                              child: Stack(
                                children: [
                                  ClipRRect(
                                      borderRadius: BorderRadius.circular(18.0),
                                      child: Image.network(
                                        reciptCatList[index]["imgUrl"],
                                        fit: BoxFit.cover,
                                        width: 200,
                                        height: 250,
                                      )),
                                  Positioned(
                                    
                                      child: Container(
                                          padding: EdgeInsets.symmetric(
                                              vertical: 5, horizontal: 10),
                                          decoration: BoxDecoration(
                                              borderRadius:
                                                  BorderRadius.circular(18),
                                              color:
                                                  Color.fromARGB(95, 3, 3, 1)),
                                          child: Column(
                                            mainAxisAlignment:
                                                MainAxisAlignment.center,
                                            children: [
                                              T
                                          ))),
                                ],
                              )),
                        ));
                      }),
                )
              ],
            ),
          ),
        ],
      ),
    );
  }
}
