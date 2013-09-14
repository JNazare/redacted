var fs = require('fs');

function repeat (str, n) {
	return Array(n + 1).join('\n').split('').map(function () { return str; });
}

var words = fs.readFileSync("blacklist.txt", "utf-8").split(/\n/);

exports.convert = function(req, res){
	var input = req.body.text;
	words.forEach(function (w) {
		var re = new RegExp("\\b"+w+"\\b", 'g');
		console.log(re);
		input = input.replace(re, repeat(w,"█"));
	});
	res.send(input);
}