/**
 * Application configuration
 */
var devConfig = {
  database: 'mongodb://localhost/sbz'
};

var prodConfig = {
  database: 'mongodb://mongodb/sbz'
};

function configuration() {
  switch (process.env.NODE_ENV) {
    case 'development':
      return devConfig;
    case 'production':
      return prodConfig;
    default:
      return devConfig;
  }
}


module.exports = configuration();
