isCorrecting = false;
cue_id = null;
store = {};
index = lunr(function()
{
	this.field('text')
	this.ref('id')
});

function HHMMSSfromS(seconds)
{
	var date = new Date(null);
	date.setSeconds(seconds);
	var goodTime = date.toISOString().substr(11, 8);
	return goodTime;
}

function indexFilling()
{
	trackElement = document.getElementById("track");
	textTrack = trackElement.track;
	cues = textTrack.cues;
	for(var j = 0; j < cues.length ; j++)
	{
		index.add({ id: cues[j].id, text: cues[j].text });
		store[cues[j].id] = cues[j];

		document.getElementById('transcription').innerHTML = document.getElementById('transcription').innerHTML + '<p>' + HHMMSSfromS(cues[j].startTime) + ' : ' + cues[j].text + '</p>';
	}
}

function cueCorrectionBinding()
{
	document.getElementById('cue').addEventListener("click", function()
	{
		if(this.innerHTML != "" && false == isCorrecting)
		{
			document.getElementById('audio').pause();
			isCorrecting = true;
			document.getElementById('data').innerHTML = "<div class=\"col-lg-8 center-block\"><textarea id=\"correction\" type=\"text\" name=\"correction\" class=\"form-control\">" + this.innerHTML + "</textarea><input type=\"button\" class=\"btn btn-primary\" value=\"Proposer\" id=\"submitCorrection\"/></div>";
			document.getElementById('submitCorrection').addEventListener("click", function()
			{
				document.getElementById('audio').play();
				var correction = document.getElementById('correction').value;
				document.getElementById('data').innerHTML = "<p id=\"cue\">" + document.getElementById('correction').value + "</p>";
				var request = new XMLHttpRequest();
				request.open("POST",content_id+"/correct",true);
				request.setRequestHeader("X-CSRF-Token",document.getElementsByName('csrf-token')[0].getAttribute('content'));
				request.setRequestHeader("Content-type","application/x-www-form-urlencoded");
				request.send("cue_id="+cue_id+"&correction="+correction);
				isCorrecting = false;
				cueCorrectionBinding();
			});
		}
	});
}

document.addEventListener("DOMContentLoaded", function()
{
	document.getElementById('search').addEventListener("input",function()
	{
		var text = this.value;
		document.getElementById('resultList').innerHTML = "";

		if(text=="")
		{
			return;
		}

		var matches = index.search(text);
		for(var j=0 ; j<matches.length ; j++)
		{
			document.getElementById('resultList').innerHTML = document.getElementById('resultList').innerHTML+"<li class=\"list-group-item\" onclick=\"document.getElementById('audio').currentTime = "+store[matches[j].ref].startTime+";\">"+HHMMSSfromS(store[matches[j].ref].startTime)+" : "+store[matches[j].ref].text+"</li>";
		}
	});

	document.getElementById('audio').addEventListener("timeupdate",function()
	{
		if(isCorrecting)
			return;
		for(var j = 0 ; j < cues.length ; j++)
		{
			if(this.currentTime > cues[j].startTime && this.currentTime < cues[j].endTime)
			{
				document.getElementById('cue').innerHTML = cues[j].text;
				cue_id=cues[j].id;
				break;
			}
			else
			{
				document.getElementById('cue').innerHTML = "";
			}
		}
	});

	document.getElementById('audio').addEventListener("play", function()
	{
		if(isCorrecting)
		{
			document.getElementById('data').innerHTML = "<p id=\"cue\">" + document.getElementById('correction').value + "</p>";
			cueCorrectionBinding();
			isCorrecting = false;
		}
	});
});

window.onload = function()
{
	indexFilling();
	cueCorrectionBinding();
}
