import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:foodapp/FoodDetailPage.dart';
import 'package:http/http.dart' as http;


class FoodListPage extends StatefulWidget {
  final String category;

  const FoodListPage({required this.category});

  @override
  _FoodListPageState createState() => _FoodListPageState();
}

class _FoodListPageState extends State<FoodListPage> {
  List foods = [];

  @override
  void initState() {
    super.initState();
    fetchFoodsByCategory();
  }

  Future<void> fetchFoodsByCategory() async {
    final response = await http.get(Uri.parse(
        'http://www.themealdb.com/api/json/v1/1/filter.php?c=${widget.category}'));

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      setState(() {
        foods = data['meals'];
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Menu Makanan'),
      ),
      body: GridView.builder(
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 3,
          childAspectRatio: 0.7,
        ),
        itemCount: foods.length,
        itemBuilder: (ctx, index) {
          return GestureDetector(
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => FoodDetailPage(
                    foodId: foods[index]['idMeal'],
                  ),
                ),
              );
            },
            child: Card(
              child: Column(
                children: [
                  Expanded(
                    child: Image.network(
                      foods[index]['strMealThumb'],
                      fit: BoxFit.cover,
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Text(
                      foods[index]['strMeal'],
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}