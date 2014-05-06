---
layout: default
title: Credits
---
	
<h3>
<a name="credits" class="anchor" href="#credits"><span class="octicon octicon-link"></span></a>Credits</h3>

<p>A number of people have helped with suggestions and pointers.</p>

- **Luca Foschini &amp; Alessio Signorini** Luca's questions are what led to the whole idea of summarized data, which is adequate for several types of analysis. (Detailed data might be an overkill.) His friend Alessio Signorini tipped me off to the ways to fetch the summarized data cleanly. 
- **Felipe Carillo** has asked for waterdata from [(http://waterdata.usgs.gov/nwis)](http://waterdata.usgs.gov/nwis) and from CDEC http://cdec.water.ca.gov/cgi-progs/selectQuery? These are not currently available, but maybe some day.
- **Edward P. Morris** was the one who suggested having multiple options depending on which columns users were interested in. His suggestions 
led to the creation of the three flags: `opt_all_columns`, `opt_temperature_colunns` & `opt_custom_columns.` In fact, he was the one who 
came up with the idea for having a vector for `custom_columns.`
- **Martin Lavoie** reported that several flags in `getWeatherData` weren't getting set properly. Some of his examples have been added to insts/tests.


<h3>
		<a name="suggestions" class="anchor" href="#suggestions"><span class="octicon octicon-link"></span></a>Suggestions</h3>

Suggestions are welcome! If you would have a particular need for weather data,
let me know what changes you'd like to see in the package. If you find bugs, please do report it. Fetching data from the web can be fragile. Please consider submitting an Issue.

[Back](index.html)
