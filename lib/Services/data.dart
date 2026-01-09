
import '../models/category_model.dart';

List<CategoryModel> getCategories() {
  List<CategoryModel> categoryList = [];

  categoryList.add(CategoryModel(
    categoryName: "General",
    imageUrl: "lib/Assets/General.png",
  ));
  categoryList.add(CategoryModel(
    categoryName: "Business",
    imageUrl: "lib/Assets/Business.png",
  ));
  categoryList.add(CategoryModel(
    categoryName: "Technology",
    imageUrl:"lib/Assets/Technology.png",
));
  categoryList.add(CategoryModel(
    categoryName: "Sports",
    imageUrl: "lib/Assets/sports.png",
  ));
  categoryList.add(CategoryModel(
    categoryName: "Entertainment",
    imageUrl: "lib/Assets/Entertainment.png",
  ));

  return categoryList;
}
