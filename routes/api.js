var fs = require('fs');

var words = fs.readFileSync("blacklist.txt", "utf-8").split(/\n/);

exports.convert = function(req, res){
	var input = req.body.text;
	words.forEach(function (w) {
		var re = new RegExp("\\b"+w+"\\b", 'g');
		console.log(re);
		input = input.replace(re, '[redacted]');
	});
	res.send(input);
}