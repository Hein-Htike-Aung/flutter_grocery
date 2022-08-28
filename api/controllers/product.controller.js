const productService = require("../services/product.service");
const upload = require("../middlewares/product.upload");

exports.create = (req, res, next) => {
  upload(req, res, (err) => {
    if (err) next(err);
    else {
      const path = req.file ? req.file.path.replace(/\\/g, "/") : "";

      const model = {
        productName: req.body.productName,
        category: req.body.category,
        productShortDescription: req.body.productShortDescription,
        productDescription: req.body.productDescription,
        productPrice: req.body.productPrice,
        productSalePrice: req.body.productSalePrice,
        productSKU: req.body.productSKU,
        productType: req.body.productType,
        stockStatus: req.body.stockStatus,
        productImage: path ? "/" + path : "",
      };

      productService.createProduct(model, (err, results) => {
        if (err) return next(err);
        else {
          return res.status(200).send({
            message: "Success",
            data: results,
          });
        }
      });
    }
  });
};

exports.findAll = (req, res, next) => {
  const model = {
    productName: req.query.productName,
    categoryId: req.query.categoryId,
    pageSize: req.query.pageSize,
    page: req.query.page,
    sort: req.query.sort,
  };

  productService.getProducts(model, (err, results) => {
    if (err) return next(err);
    else {
      return res.status(200).send({
        message: "Success",
        data: results,
      });
    }
  });
};

exports.findOne = (req, res, next) => {
  const model = {
    productId: req.params.productId,
  };

  productService.getProductById(model, (err, results) => {
    if (err) return next(err);
    else {
      return res.status(200).send({
        message: "Success",
        data: results,
      });
    }
  });
};

exports.update = (req, res, next) => {
  upload(req, res, (err) => {
    if (err) next(err);
    else {
      const path = req.file ? req.file.path.replace(/\\/g, "/") : "";

      const model = {
        productId: req.params.productId,
        productName: req.body.productName,
        category: req.body.category,
        productShortDescription: req.body.productShortDescription,
        productDescription: req.body.productDescription,
        productPrice: req.body.productPrice,
        productSalePrice: req.body.productSalePrice,
        productSKU: req.body.productSKU,
        productType: req.body.productType,
        stockStatus: req.body.stockStatus,
        productImage: path ? "/" + path : "",
      };

      productService.updateProduct(model, (err, results) => {
        if (err) return next(err);
        else {
          return res.status(200).send({
            message: "Success",
            data: results,
          });
        }
      });
    }
  });
};

exports.delete = (req, res, next) => {
  const model = {
    productId: req.params.productId,
  };

  productService.deleteProduct(model, (err, results) => {
    if (err) return next(err);
    else {
      return res.status(200).send({
        message: "Success",
        data: results,
      });
    }
  });
};
