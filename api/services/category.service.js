const { category } = require("../models/category.model");
const MONGO_DB_CONFIG = require("../config/app.config");

const createCategory = async (params, callback) => {
  if (!params.categoryName) {
    return callback(
      {
        message: "Category Name Required",
      },
      ""
    );
  }

  const model = new category(params);
  model
    .save()
    .then((response) => {
      return callback(null, response);
    })
    .catch((error) => {
      return callback(error);
    });
};

const getCategories = async (params, callback) => {
  const categoryName = params.categoryName;

  const condition = categoryName
    ? {
        categoryName: { $regex: new RegExp(categoryName), $options: "i" },
      }
    : {};

  let perPage = Math.abs(params.pageSize) || MONGO_DB_CONFIG.pageSize;
  let page = (Math.abs(params.page) || 1) - 1;

  /* 
    only categoryName category Image will be fetched
    .find(condition, ["categoryName", "categoryImage"])
  */

  category
    .find(condition)
    .limit(perPage)
    .skip(perPage * page) // exlude already showed data
    .then((response) => {
      return callback(null, response);
    })
    .catch((error) => {
      return callback(error);
    });
};

const getCategoryById = async (params, callback) => {
  const categoryId = params.categoryId;

  category
    .findById(categoryId)
    .then((response) => {
      if (!response) callback("Not found category with id " + categoryId);
      else return callback(null, response);
    })
    .catch((error) => {
      return callback(error);
    });
};

const updateCategory = async (params, callback) => {
  const categoryId = params.categoryId;

  category
    .findByIdAndUpdate(categoryId, params, {
      useFindAndModify: false,
      new: true,
    })
    .then((response) => {
      if (!response) callback("Not found category with id " + categoryId);
      else callback(null, response);
    })
    .catch((error) => {
      return callback(error);
    });
};

const deleteCategory = async (params, callback) => {
  const categoryId = params.categoryId;

  category
    .findByIdAndDelete(categoryId)
    .then((response) => {
      if (!response) callback("Not found category with id " + categoryId);
      else return callback(null, response);
    })
    .catch((error) => {
      return callback(error);
    });
};

module.exports = {
  createCategory,
  getCategories,
  getCategoryById,
  updateCategory,
  deleteCategory,
};
