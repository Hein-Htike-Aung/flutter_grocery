const { product } = require("../models/product.model");
const { category } = require("../models/category.model");
const { MONGO_DB_CONFIG } = require("../config/app.config");

const createProduct = async (params, callback) => {
  if (!params.productName) {
    return callback({
      message: "product name required",
    });
  }
  if (!params.category) {
    return callback({
      message: "category required",
    });
  }

  const productModel = new product(params);

  productModel
    .save()
    .then((response) => {
      return callback(null, response);
    })
    .catch((err) => {
      return callback(err);
    });
};

const getProducts = async (params, callback) => {
  const productName = params.productName;
  const categoryId = params.categoryId;
  let condition = {};

  if (productName) {
    condition["productName"] = {
      $regex: new RegExp(productName),
      $options: "i",
    };
  }

  if (categoryId) {
    condition["categoryId"] = categoryId;
  }

  let perPage = Math.abs(params.pageSize) || MONGO_DB_CONFIG.PAGE_SIZE;
  let page = (Math.abs(params.page) || 1) - 1;

  product
    .find(condition)
    .sort(params.sort)
    .populate("category", ["cateogryName", "categoryImage"]) // will fetch category object
    .limit(perPage)
    .skip(perPage * page)
    .then((resp) => callback(null, resp))
    .catch((err) => callback(err));
};

const getProductById = async (params, callback) => {
  const productId = params.productId;

  product
    .findById(productId)
    .populate("category", ["cateogryName", "categoryImage"])
    .then((resp) => callback(null, resp))
    .catch((err) => callback(err));
};

const updateProduct = async (params, callback) => {
  const productId = params.productId;

  product
    .findByIdAndUpdate(productId, params, {
      useFindAndModify: false,
      new: true,
    })
    .then((resp) => {
      if (!resp) callback(`cannot update product with id ${productId}`);
      else callback(null, resp);
    })
    .catch((err) => callback(err));
};

const deleteProduct = async (params, callback) => {
  const productId = params.productId;

  product
    .findByIdAndDelete(productId)
    .then((resp) => {
      if (!resp) callback(`cannot delete product with id ${productId}`);
      else callback(null, resp);
    })
    .catch((err) => callback(err));
};

module.exports = {
  createProduct,
  getProducts,
  getProductById,
  updateProduct,
  deleteProduct,
};
