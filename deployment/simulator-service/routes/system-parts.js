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

/**
 * Simulate restarting of system part
 */
router.get('/:name/restart', function (req, res, next) {
  var query =
    SystemPart.findOne({
      name: req.params.name
    });

  query.exec(function (err, result) {
    if (err) return next(err);
    if (!result) return next({
      status: 404
    });

    result.health.status = "ok";
    result.save(function (err, part) {
      if (err) return next(err);
      res.json(part);
    })
  });
});

/**
 * Simulate crashing of system part
 */
router.get('/:name/crash', function (req, res, next) {
  var query =
    SystemPart.findOne({
      name: req.params.name
    });

  query.exec(function (err, result) {
    if (err) return next(err);
    if (!result) return next({
      status: 404
    });

    result.health.status = "error";
    result.save(function (err, part) {
      if (err) return next(err);
      res.json(part);
    })
  });
});

/**
 * Change status of system part
 */
router.patch('/:name', function (req, res, next) {
  var query = SystemPart.findOne({
    name: req.params.name
  });

  query.exec(function (err, result) {
    if (err) return next(err);
    if (!result) return next({
      status: 404
    });

    if (req.body.cpu) {
      result.health.cpu = req.body.cpu;
    }

    if (req.body.disk) {
      result.health.disk = req.body.disk;
    }

    if (req.body.status) {
      result.health.status = req.body.status;
    }

    result.save(function (err, part) {
      if (err) return next(err);
      res.json(part);
    });

  });
});


module.exports = router;
