const express = require("express");
const bodyParser = require("body-parser");
const cors = require("cors");

const path = __dirname + "/app/views/";

const app = express();

app.use(express.static(path));

var corsOptions = {
  origin: "*",
  credentials: false,
};

app.use(cors(corsOptions));

// parse requests of content-type - application/json
app.use(bodyParser.json());

// parse requests of content-type - application/x-www-form-urlencoded
app.use(bodyParser.urlencoded({ extended: true }));

const db = require("./app/models");

db.sequelize.sync();
// // drop the table if it already exists
// db.sequelize.sync({ force: true }).then(() => {
//   console.log("Drop and re-sync db.");
// });

app.get("/", function (req, res) {
  res.sendFile(path + "index.html");
});

require("./app/routes/turorial.routes")(app);

// set port, listen for requests
const PORT = process.env.PORT || 8080;
app.listen(PORT, () => {
  console.log(`Todo App is running on port ${PORT}.`);
});
