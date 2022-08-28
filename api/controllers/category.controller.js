const categoryService = require("../services/category.service");
const upload = require("../middlewares/category.upload");

exports.create = (req, res, next) => {
  upload(req, res, (err) => {
    if (err) next(err);
    else {
      const path = req.file ? req.file.path.replace(/\\/g, "/") : "";

      const model = {
        categoryName: req.body.categoryName,
        categoryDescription: req.body.categoryDescription,
        categoryImage: path ? "/" + path : "",
      };

      /* 
        ("/" + path)
        /uploads/categories/1661692221719-ice-cream.jpeg

      */

      categoryService.createCategory(model, (error, results) => {
        if (error) return next(error);
        else
          return res.status(200).send({
            message: "Success",
            data: results,
          });
      });
    }
  });
};

exports.findAll = (req, res, next) => {
  const model = {
    categoryName: req.query.categoryName,
    pageSize: req.query.pageSize,
    page: req.query.page,
  };

  categoryService.getCategories(model, (error, results) => {
    if (error) return next(error);
    else
      return res.status(200).send({
        message: "Success",
        data: results,
      });
  });
};

exports.findOne = (req, res, next) => {
  const model = {
    categoryId: req.params.categoryId,
  };

  categoryService.getCategoryById(model, (error, results) => {
    if (error) return next(error);
    else
      return res.status(200).send({
        message: "Success",
        data: results,
      });
  });
};

exports.update = (req, res, next) => {
  upload(req, res, (err) => {
    if (err) next(err);
    else {
      const path = !req.file ? req.file.path.replace(/\\/g, "/") : "";

      const model = {
        categoryId: req.params.categoryId,
        categoryName: req.body.categoryName,
        categoryDescription: req.body.categoryDescription,
        categoryImage: !path ? "/" + path : "",
      };

      categoryService.updateCategory(model, (error, results) => {
        if (error) return next(error);
        else
          return res.status(200).send({
            message: "Success",
            data: results,
          });
      });
    }
  });
};

exports.delete = (req, res, next) => {
  const model = {
    categoryId: req.params.categoryId,
  };

  categoryService.deleteCategory(model, (error, results) => {
    if (error) return next(error);
    else
      return res.status(200).send({
        message: "Success",
        data: results,
      });
  });
};
