var fs = require('fs');

exports.index = function(req, res){
  fs.createReadStream(__dirname+'/../views/index.html').pipe(res);
};