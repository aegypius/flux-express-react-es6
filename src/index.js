// jshint esnext:true
import express from "express";
import lr      from "connect-livereload";
import path    from "path";

var app = express();

app.set('port', process.env.PORT || 3333);
app.set('view engine', "jade");
app.set('views', path.join(__dirname, '../views'));
app.use(express.static(path.join(__dirname, '../public')));

if (app.get('env') !== "production") {
  app.use(lr({port: 35729}));
}

app.get('/', function (req, res) {
  res.render("index", {
  });
});

app.listen(app.get('port'), () => console.log(`server started on ${app.get('port')}`));

export default app;
