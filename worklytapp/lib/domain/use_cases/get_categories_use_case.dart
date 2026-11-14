import 'package:worklyapp/domain/entities/category.dart';
import 'package:worklyapp/domain/repositories/category_repository.dart';

class GetCategoriesUseCase {
  const GetCategoriesUseCase(this.repository);
  final CategoryRepository repository;
  Future<List<Category>> execute() => repository.getCategories();
}
