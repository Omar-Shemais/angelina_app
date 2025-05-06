import 'package:angelina_app/features/home/data/model/product_model.dart';
import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';
part 'favorite_state.dart';

class FavoriteCubit extends Cubit<FavoriteState> {
  FavoriteCubit() : super(FavoriteInitial());

  List<ProductModel> _favorites = [];
  List<ProductModel> _filteredFavorites = [];

  List<ProductModel> get favorites =>
      _filteredFavorites.isEmpty ? _favorites : _filteredFavorites;

  // Load favorites when app starts
  Future<void> loadFavorites() async {
    emit(FavoriteLoading());
    final prefs = await SharedPreferences.getInstance();
    List<String> favoritesStringList =
        prefs.getStringList('favorite_products') ?? [];
    _favorites =
        favoritesStringList
            .map((e) => ProductModel.fromJson(jsonDecode(e)))
            .toList();
    _filteredFavorites = List.from(_favorites);
    emit(FavoriteLoaded(_favorites));
  }

  // Add or Remove favorite
  Future<void> toggleFavorite(ProductModel product) async {
    final prefs = await SharedPreferences.getInstance();
    List<String> favoritesStringList =
        prefs.getStringList('favorite_products') ?? [];

    final isExist = _favorites.any((element) => element.id == product.id);

    if (isExist) {
      // Remove
      _favorites.removeWhere((element) => element.id == product.id);
      favoritesStringList.removeWhere((element) {
        final map = jsonDecode(element);
        return map['id'] == product.id;
      });
    } else {
      // Add
      _favorites.add(product);
      favoritesStringList.add(jsonEncode(product.toJson()));
    }

    await prefs.setStringList('favorite_products', favoritesStringList);
    emit(FavoriteLoaded(_favorites));
  }

  // Check if product is favorite
  bool isFavorite(ProductModel product) {
    return _favorites.any((element) => element.id == product.id);
  }

  // Filter favorites based on search query
  void searchFavorites(String query) {
    if (query.isEmpty) {
      _filteredFavorites = List.from(_favorites);
    } else {
      _filteredFavorites =
          _favorites
              .where(
                (product) =>
                    product.name.toLowerCase().contains(query.toLowerCase()),
              )
              .toList();
    }
    emit(FavoriteLoaded(_filteredFavorites));
  }
}
