function goTo(time)
{
	document.getElementById('audio').currentTime = time;
}

document.getElementById('search').addEventListener("input",function()
{
	var text = this.value;
	document.getElementById('resultList').innerHTML = "";

	if(text=="")
	{
		return;
	}

	trackElement = document.getElementById("track");

	textTrack = trackElement.track;

	cues = textTrack.cues;

	for(var j=0 ; j<cues.length ; j++)
	{
		if(cues[j].text.toLowerCase().indexOf(text.toLowerCase())>-1 && text !="")
		{
			document.getElementById('resultList').innerHTML = document.getElementById('resultList').innerHTML+"<li onclick=\"goTo("+cues[j].startTime+");\">"+cues[j].text+"</li>";
		}
	}
});

document.getElementById('audio').play();
document.getElementById('audio').pause();
document.getElementById('audio').addEventListener("timeupdate",function()
{
	trackElement = document.getElementById("track");

	textTrack = trackElement.track;

	cues = textTrack.cues;

	for(var j = 0 ; j < cues.length ; j++)
	{
		if(this.currentTime > cues[j].startTime && this.currentTime < cues[j].endTime)
		{
			document.getElementById('data').innerHTML = cues[j].text;
			break;
		}
		else
		{
			document.getElementById('data').innerHTML = "";
		}
	}
});
