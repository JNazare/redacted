var fs = require('fs');

var words = fs.readFileSync("blacklist.txt", "utf-8").split(/\n/);

exports.convert = function(req, res){
	var input = req.text;
	words.some(function (w) {
		input = input.replace(w, '#');
	})
	res.send(input);

}