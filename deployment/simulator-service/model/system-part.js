var mongoose = require('mongoose');
var Schema = mongoose.Schema;

var systemPartSchema = new Schema({
  name: {
    type: String,
    required: true
  },
  health: {
    status: {
      type: String,
      enum: ['ok', 'error'],
      required: true
    },
    cpu: {
      type: Number,
      min: 0,
      max: 1,
      required: true
    },
    disk: {
      type: Number,
      min: 0,
      max: 1,
      required: true
    }
  },
  allowedIps: [String],
  blacklistedIps: [String],
  allowedPorts: [Number],
  restrictedPorts: [Number],
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
