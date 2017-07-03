var express = require('express');
var router = express.Router();
var SystemPart = require('../model/system-part');

router.get('/:name', function (req, res, next) {
  var query =
    SystemPart.findOne({
      name: req.params.name
    });
  query.exec(function (err, result) {
    if (err) return next(err);
    if (!result) return next({
      status: 404
    });
    return res.json(result)
  })
});


router.post('/', function (req, res, next) {
  var query = SystemPart.findOne({
    name: req.body.name
  });

  query.exec(function (err, result) {
    if (err) next(err);

    if (result) {
      res.status(409);
      res.send("System part with given name already exists")
    } else {
      new SystemPart(req.body).save(function (err, spart) {
        if (err) next(err);
        res.json(spart);
      })
    }

  })
});

router.get('/:name/health', function (req, res, next) {
  var query =
    SystemPart.findOne({
      name: req.params.name
    });
  query.select('health');
  query.exec(function (err, result) {
    if (err) return next(err);
    if (!result) return next({
      status: 404
    });
    return res.json(result.health)
  })
});


module.exports = router;
