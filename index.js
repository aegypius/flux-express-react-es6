module.exports = lib = require('./lib');

if (require.main) {
  var server = lib.server;

  server.listen(server.get('port'), function () {
    console.log('server started on %j', server.get('port'));
  });
}
