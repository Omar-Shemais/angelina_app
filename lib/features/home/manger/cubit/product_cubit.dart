import 'package:angelina_app/features/home/data/model/product_model.dart';
import 'package:angelina_app/features/home/data/repo/product_repo.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

part 'product_state.dart';

class ProductCubit extends Cubit<ProductState> {
  final ProductRepository repository;

  int _page = 1;
  final int _perPage = 10;
  bool _hasMore = true;
  final List<ProductModel> _allProducts = [];
  final bool _isLoaded = false;

  ProductCubit(this.repository) : super(ProductInitial());

  Future<void> fetchInitialProducts() async {
    if (_isLoaded) return;
    emit(ProductLoading());
    _page = 1;
    _hasMore = true;
    _allProducts.clear();
    await _fetchProducts();
  }

  Future<void> loadMoreProducts() async {
    if (_hasMore && state is ProductSuccess) {
      final currentState = state as ProductSuccess;

      emit(currentState.copyWith(isLoadingMore: true));

      _page++;
      try {
        final products = await repository.fetchProducts(
          page: _page,
          perPage: _perPage,
        );
        if (products.length < _perPage) _hasMore = false;

        _allProducts.addAll(products);

        emit(
          ProductSuccess(
            List<ProductModel>.from(_allProducts),
            hasMore: _hasMore,
            isLoadingMore: false,
          ),
        );
      } catch (e) {
        emit(ProductFailure(e.toString()));
      }
    }
  }

  Future<void> _fetchProducts() async {
    try {
      final products = await repository.fetchProducts(
        page: _page,
        perPage: _perPage,
      );
      if (products.length < _perPage) _hasMore = false;

      _allProducts.addAll(products);
      emit(
        ProductSuccess(
          List<ProductModel>.from(_allProducts),
          hasMore: _hasMore,
          isLoadingMore: false,
        ),
      );
    } catch (e) {
      emit(ProductFailure(e.toString()));
    }
  }

  Future<void> fetchProductsForCategory(int categoryId) async {
    emit(ProductLoading());
    try {
      final products = await repository.fetchProductsByCategory(
        categoryId: categoryId,
        page: 1,
        perPage: _perPage,
      );
      final hasMore = products.length == _perPage;
      emit(ProductSuccess(products, hasMore: hasMore, isLoadingMore: false));
    } catch (e) {
      emit(ProductFailure(e.toString()));
    }
  }
}
