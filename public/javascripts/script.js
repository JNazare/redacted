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

var tl=new Array(
"Welcome! ",
"Our goal is to inform everyone about censorship from the NSA. ",
"Make sure you have a secure internet connection, ",
"otherwise watch for the CIA white van outside. ",
"If you have an idea to promote internet privacy or freedom ",
"let us know!"
);
var speed=60;
var index=0; text_pos=0;
var str_length=tl[0].length;
var contents, row;
var clicked = false;


$( document ).ready(function() {

	$.get('/api/list', function(res){
		words = res.list;
	});

	$("#styled").click(function(){
		clicked = true;
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

    function type_text(){
    	if(!clicked){
		  $("#styled").attr('data-placeholder', "");
		  contents='';
		  row=Math.max(0,index-7);
		  while(row<index)
		    contents += tl[row++];
		  $("#styled").html(contents + tl[index].substring(0,text_pos) + "_");
		  $("#parent").height($("#styled")[0].scrollHeight + 20);
			var input = $("#styled").clone().children().remove().end().text();
			$("#styled").children().each(function(){
				input = input + "\n" + $(this).text();
			});
			censor(words, input, function(newText){
			$("#underlay").html(newText);
			});
		  if(text_pos++==str_length)
		  {
		    text_pos=0;
		    index++;
		    if(index!=tl.length)
		    {
		      str_length=tl[index].length;
		      setTimeout(type_text,1500);
		    }
		  } else{
		      setTimeout(type_text,speed);
		  }
		}
	}

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

	setTimeout(type_text, 5000);

});