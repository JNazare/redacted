var words = fs.readFileSync("../blacklist.txt", "utf-8").split(/\n/);



exports.convert = function(req, res){
	var input = req.text;
	var output_words = input.split(/\s+/).map(function(word){
		if (words.indexOf(word.toLowerCase().replace(/\W/g, "")) > -1){
			return "redacted";
		}else{
			return word;
		}
	});

	var out_string = output_words.join(" ");

	res.send(out_string);

}