function repeat (str, n) {
	return Array(n + 1).join('\n').split('').map(function () { return str; }).join("");
}

function censor (words, input, callback) {
	words.forEach(function (w) {
		var re = new RegExp("\\b"+w+"\\b", 'gi');
		input = input.replace(re, repeat("█", w.length));
	});
	callback(input);
}


var words;

$( document ).ready(function() {

	$.get('/api/list', function(res){
		words = res.list;
	});


	$("#styled").keyup( function(){
		console.log(words);
		censor(words, $("#styled").val(), function(newText){
			$("#styled").val(newText);
		});
	});

	$("#button").click(function(){
		$.post( '/api/convert', {text:$("#textarea").val()} , function(res){
			$("#redacted").text(res);
			$("#main").fadeOut(400, function(){
				$("#text").fadeIn(400);
			});
		});
	});

	$("#retry").click(function(){
		$("#text").fadeOut(400, function(){
				$("#main").fadeIn(400);
			});
	});


	


});