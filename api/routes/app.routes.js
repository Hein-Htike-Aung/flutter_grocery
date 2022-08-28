const categoryController = require("../controllers/category.controller");
const productController = require("../controllers/product.controller");
const express = require("express");

const router = express.Router();

router.post("/category", categoryController.create);
router.get("/category", categoryController.findAll);
router.get("/category/:categoryId", categoryController.findOne);
router.patch("/category/:categoryId", categoryController.update);
router.delete("/category/:categoryId", categoryController.delete);

router.post("/product", productController.create);
router.get("/product", productController.findAll);
router.get("/product/:productId", productController.findOne);
router.patch("/product/:productId", productController.update);
router.delete("/product/:productId", productController.delete);

module.exports = router;
