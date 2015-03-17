#!/bin/sh

./bin/makeportalshtml.pl < $2 > portals.html.temp

cat > $1.html <<  _EOF
<!DOCTYPE html>
 <html>
 <head>
 <meta name="viewport" content="initial-scale=1.0, user-scalable=no">
 <meta charset="utf-8">
 <title>Megafield</title>
 <link href="default.css" rel="stylesheet">
 <script src="https://maps.googleapis.com/maps/api/js?v=3.exp&sensor=false"></script>
 <script>

 function initialize() {
 var myLatLng = new google.maps.LatLng(53.9, 27.55);
 var mapOptions = {
 zoom: 7,
 center: myLatLng,
 mapTypeId: google.maps.MapTypeId.ROADMAP
 };

 var map = new google.maps.Map(document.getElementById('map_canvas'),
 mapOptions);
_EOF
cat portals.html.temp >> $1.html
cat >> $1.html << _EOF
 }

 </script>
 </head>
 <body onload="initialize()">
 <div id="map_canvas"></div>
 </body>
 </html>
_EOF

