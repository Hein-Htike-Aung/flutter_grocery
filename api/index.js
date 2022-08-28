const express = require("express");
const app = express();
const mongoose = require("mongoose");
const { MONGO_DB_CONFIG } = require("./config/app.config");
const errors = require("./middlewares/errors.js");
// const swaggerUi = require("swagger-ui-express"),
//   swaggerDocument = require("./swagger.json");

mongoose.Promise = global.Promise;

mongoose.connect(MONGO_DB_CONFIG.DB).then(
  () => {
    console.log("Database connected");
  },
  (errors) => {
    console.log("Database can't be connected: " + errors);
  }
);

app.use(express.json());
app.use("/uploads", express.static("uploads"));
app.use("/api", require("./routes/app.routes"));
app.use(errors.errorHandler);
// app.use("/api-docs", swaggerUi.serve, swaggerUi.setup(swaggerDocument));

app.listen(process.env.port || 4000, () => {
  console.log("Api is running");
});
