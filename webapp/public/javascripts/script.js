var words;

function repeat (str, n) {
	return Array(n + 1).join('\n').split('').map(function () { return str; }).join("");
};

function censor (words, input, callback) {
	console.log(input);
	words.forEach(function (w) {
		var re = new RegExp("\\b"+w+"\\b", 'gim');
		input = input.replace(re, '<span class="block">$&</span>'); //repeat("▓", w.length));
	});
	callback(input.replace(/\n/g, "</br>"));
};



$( document ).ready(function() {

	$.get('/api/list', function(res){
		words = res.list;
	});

	$("#styled").click(function(){
		$("#styled").attr('data-placeholder', "");
	});

	$("#styled").keyup( function(event){
		$("#parent").height($("#styled")[0].scrollHeight + 20);
		var input = $("#styled").clone().children().remove().end().text();
		$("#styled").children().each(function(){
			input = input + "\n" + $(this).text();
		});
		censor(words, input, function(newText){
			$("#underlay").html(newText);
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