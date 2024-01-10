import 'dart:convert';
import 'dart:developer' as developer;
import 'dart:math';
import 'package:flutter/material.dart';
import 'package:foodie/model.dart';
import 'package:http/http.dart' as http;
import 'search.dart';
import 'RecipeView.dart';

class Home extends StatefulWidget {
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  bool isLoading = true;
  List<RecipeModel> recipeList =  <RecipeModel>[];
  TextEditingController searchController = new TextEditingController();
  List reciptCatList = [{"imgUrl": "https://images.unsplash.com/photo-1593560704563-f176a2eb61db", "heading": "Chilli Food"},{"imgUrl": "https://media.cnn.com/api/v1/images/stellar/prod/181127114455-41-50-sweets-travel-baklava.jpg?q=w_1015,c_fill/f_webp", "heading": "Sweet Food"},{"imgUrl": "https://ik.imagekit.io/awwybhhmo/satellite_images/chinese/gray/about_us/2.jpg?tr=w-3840", "heading": "Chinese"},{"imgUrl": "https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcQjJFSBiVMAdY6SLyYF-MkAmjo7dM9IjLl-DQ&usqp=CAU", "heading": "Continental"}];
  getRecipes(String query) async {
    String url = "https://api.edamam.com/search?q=$query&app_id=ae4b4abd&app_key=b32132bf1ea12ffcff35179b063cfea6";
    http.Response response = await http.get(Uri.parse(url));
    Map data = jsonDecode(response.body);
    setState(() {
      data["hits"].forEach((element) {
        RecipeModel recipeModel = new RecipeModel();
        recipeModel = RecipeModel.fromMap(element["recipe"]);
        recipeList.add(recipeModel);
        setState(() {
          isLoading = false;
        });
        developer.log(recipeList.toString());
      });
    });
    recipeList.forEach((Recipe) {
      print(Recipe.applabel);
      print(Recipe.appcalories);
    });
  }
  void fetchRandomRecipe() {
    // Define a list of dishes or cuisines you want to display randomly
    List<String> dishes = [
      "Biryani",
      "Pizza",
      "Pasta",
      "Burger",
      "Chicken",
      "Shawarma"
      // Add more dishes as needed
    ];

    // Get a random dish from the list
    String randomDish = dishes[Random().nextInt(dishes.length)];

    getRecipes(randomDish);
  }

  @override
  void initState() {
    fetchRandomRecipe();
    // TODO: implement initState
    super.initState();
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
                    Color(0xff213A50),
                    Color(0xff071938)
                  ]
              ),
            ),
          ),
          SingleChildScrollView(
            child: Column(
              children: [


                //Search Bar
                SafeArea(
                  child: Container(
                    //Search Wala Container

                    padding: EdgeInsets.symmetric(horizontal: 8),
                    margin: EdgeInsets.symmetric(horizontal: 24, vertical: 20),
                    decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(24)),
                    child: Row(
                      children: [
                        GestureDetector(
                          onTap: () {
                            if((searchController.text).replaceAll(" ", "") == "")
                            {
                              print("Blank search");
                            }else{
                              Navigator.push(context, MaterialPageRoute(builder: (context) => Search(searchController.text)));
                            }

                          },
                          child: Container(
                            child: Icon(
                              Icons.search,
                              color: Colors.blueAccent,
                            ),
                            margin: EdgeInsets.fromLTRB(3, 0, 7, 0),
                          ),
                        ),
                        Expanded(
                          child: TextField(
                            controller: searchController,
                            onSubmitted: (String value) {
                              if (value.replaceAll(" ", "") == "") {
                                print("Blank search");
                              } else {
                                // Navigate to the Search page with the entered text
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => Search(searchController.text),
                                  ),
                                );
                              }
                            },
                            decoration: InputDecoration(
                                border: InputBorder.none, hintText: "Let's Cook Something!"),
                          ),
                        )
                      ],
                    ),
                  ),
                ),
                Container(
                  padding: EdgeInsets.symmetric(horizontal: 20),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text("WHAT DO YOU WANT TO COOK TODAY?", style: TextStyle(fontSize: 33, color: Colors.white),),
                      SizedBox(height: 10,),
                      Text("Let's Cook Something New!", style: TextStyle(fontSize: 20,color: Colors.white),)
                    ],
                  ),
                ),

                Container(
                    child: isLoading ? CircularProgressIndicator() :
                    ListView.builder(
                      physics: NeverScrollableScrollPhysics(),
                        shrinkWrap: true,
                        itemCount: recipeList.length,
                        itemBuilder: (context, index){
    return InkWell(
    onTap: () {
      Navigator.push(context, MaterialPageRoute(builder: (context) => RecipeView(recipeList[index].appurl)));
    },
    child: Card(
    margin: EdgeInsets.all(10),
    shape: RoundedRectangleBorder(
    borderRadius: BorderRadius.circular(10.6)),
    elevation: 0.0,
    child: Stack(
    children: [
    ClipRRect(
    borderRadius: BorderRadius.circular(10.0),
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
    vertical: 5, horizontal: 10),
    decoration:
    BoxDecoration(color: Colors.black54),
    child: Text(
      recipeList[index].applabel,
    style: TextStyle(
    color: Colors.white, fontSize: 20),
    ),
    )),
    Positioned(
    right: 0,
    child:Container(
    decoration: BoxDecoration(
    color: Colors.white,
    borderRadius: BorderRadius.only(
    topRight: Radius.circular(10),
    bottomLeft: Radius.circular(10)

    )
    ),

    height: 50,
    width: 100,
    child: Center(
    child: Row(
    mainAxisAlignment: MainAxisAlignment.center,
    children: [
    Icon(Icons.local_fire_department),
    Text(recipeList[index].appcalories.toString().substring(0,6), style: TextStyle(fontSize: 18,fontWeight: FontWeight.bold),),
    ],
    ),
    ),
    ))
    ],
    ),
    ),
    );
    })
                ),
                SizedBox(height: 25,),
                Text("Search Categories!", style: TextStyle(fontSize: 25,color: Colors.white)),
                Container(
                  height: 130,
                  child: ListView.builder( itemCount: reciptCatList.length, shrinkWrap: true,
                      scrollDirection: Axis.horizontal,
                      itemBuilder: (context, index){

                        return Container(
                            child: InkWell(
                              onTap: () {
                                Navigator.push(context, MaterialPageRoute(builder: (context) => Search(reciptCatList[index]["heading"])));
                              },
                              child: Card(
                                  margin: EdgeInsets.all(20),
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(18),
                                  ),
                                  elevation: 0.0,
                                  child:Stack(
                                    children: [
                                      ClipRRect(
                                          borderRadius: BorderRadius.circular(18.0),
                                          child: Image.network(reciptCatList[index]["imgUrl"], fit: BoxFit.cover,
                                            width: 200,
                                            height: 250,)
                                      ),
                                      Positioned(
                                          left: 0,
                                          right: 0,
                                          bottom: 0,
                                          top: 0,
                                          child: Container(
                                              padding: EdgeInsets.symmetric(
                                                  vertical: 5, horizontal: 10),
                                              decoration: BoxDecoration(
                                                  color: Colors.black26),
                                              child: Column(
                                                mainAxisAlignment: MainAxisAlignment.center,
                                                children: [
                                                  Text(
                                                    reciptCatList[index]["heading"],
                                                    style: TextStyle(
                                                        color: Colors.white,
                                                        fontSize: 28),
                                                  ),
                                                ],
                                              ))),
                                    ],
                                  )
                              ),
                            )
                        );
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