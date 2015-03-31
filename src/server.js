import express     from "express";
import lr          from "connect-livereload";
import path        from "path";
import engines     from "consolidate";

var app = express();

app.set('port', process.env.PORT || 3333);

// Views
app.engine('js', engines.react);
app.engine('jade', engines.jade);
app.set('view engine', "js");
app.set('views', [
  path.join(__dirname, 'components'),
  path.join(__dirname, '../views')
]);

// Static handling
app.use(express.static(path.join(__dirname, '../public')));

if (app.get('env') !== "production") {
  app.use(lr({port: 35729}));
}

app.get('/', function (req, res) {
  engines.react(path.join(__dirname, "components/app"), { renderer : "server" }, function (err, content) {
    res.render("layout.jade", {
      content: content
    });
  });
});

export default app;
