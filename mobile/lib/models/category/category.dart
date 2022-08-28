import 'package:freezed_annotation/freezed_annotation.dart';

import '../../config.dart';

part 'category.freezed.dart';
part 'category.g.dart';

// Transform json to List
List<Category> categoriesFromJson(dynamic str) => List<Category>.from(
      (str).map(
        (e) => Category.fromJson(e),
      ),
    );

@freezed
abstract class Category with _$Category {
  // with mixin
  factory Category(
      // factory constructor
      {
    required String categoryName,
    required String categoryImage,
    required String categoryId,
  }) = _Category;

  factory Category.fromJson(Map<String, dynamic> json) =>
      _$CategoryFromJson(json);
}

// get full image path of th Category
extension CategoryExt on Category {
  String get fullImagePath => Config.imageURL + categoryImage;
}

/* 
  dynamic: can change TYPE of the variable, & can change VALUE of the variable later in code. 
  var: can't change TYPE of the variable, but can change the VALUE of the variable later in code
*/
