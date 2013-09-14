$( document ).ready(function() {

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