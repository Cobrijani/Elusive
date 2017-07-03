var mongoose = require('mongoose');
var Schema = mongoose.Schema;

var systemPartSchema = new Schema({
  name: {
    type: String,
    required: true
  },
  health: {
    status: String,
    cpu: String,
    disk: String
  },
  createdAt: Date,
  updatedAt: Date
});

systemPartSchema.pre('save', function (next) {
  var currentDate = new Date();
  this.updatedAt = currentDate;
  if (!this.createdAt) {
    this.createdAt = currentDate;
  }
  next();
});


var SystemPart = mongoose.model('SystemPart', systemPartSchema);
module.exports = SystemPart;
