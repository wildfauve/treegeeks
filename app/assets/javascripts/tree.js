$(function() {
	
	$("#navigation ul li:last a").hover(function() {
     $(this).slideToggle();
   },function(){
     $(this).show("slow");
   });
/*
	$(".tree").hover(function() {
			$(this).hide();
		}, function() {
			$(this).show();		
	});
*/

});