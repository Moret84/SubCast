// Place all the behaviors and hooks related to the matching controller here.
// All this logic will automatically be available in application.js.
function unsubscribe(kind,object_id,user_id)
{
	var request = new XMLHttpRequest();
	request.open("POST","unsubscribe",true);
	request.setRequestHeader("X-CSRF-Token",document.getElementsByName('csrf-token')[0].getAttribute('content'));
	request.setRequestHeader("Content-type","application/x-www-form-urlencoded");
	request.send("kind="+kind+"&object_id="+object_id+"&id="+user_id);
	object = document.getElementById(kind+object_id);
	object.parentNode.removeChild(object);
	$("#page-title").after("<div class=\"alert alert-success\">Vous avez bien été désabonné du "+kind+"</div>");
}
