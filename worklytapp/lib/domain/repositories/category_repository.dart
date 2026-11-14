import 'package:worklyapp/domain/entities/category.dart';

abstract class CategoryRepository {
  Future<List<Category>> getCategories();
}
