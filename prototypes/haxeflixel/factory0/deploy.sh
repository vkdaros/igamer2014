#!/bin/bash

index="
<html>
    <head>
        <title>Ice Cream Factory</title>
    </head>
    <body bgcolor="#dddddd">
        <object classid="clsid:d27cdb6e-ae6d-11cf-96b8-444553540000"
                width="960" height="552" id="haxe" align="middle">
            <param name="movie" value="factory0.swf"/>
            <param name="allowScriptAccess" value="always" />
            <param name="quality" value="high" />
            <param name="scale" value="noscale" />
            <param name="salign" value="lt" />
            <param name="bgcolor" value="#ffffff"/>
            <embed src="factory0.swf" bgcolor="#ffffff"
                   width="960" height="552"
                   name="haxe" quality="high" align="middle"
                   allowScriptAccess="always"
                   type="application/x-shockwave-flash"
                   pluginspage="http://www.macromedia.com/go/getflashplayer"
            />
        </object>
    </body>
</html>
"

echo "Building flash export."
lime build flash

echo "Creating index.html file."
echo "$index" > /tmp/index.html

echo "Sending files to Rede IME."
scp /tmp/index.html export/flash/bin/*.swf vkdaros@ime.usp.br:www/igamer2014/

echo "Deleting index.html"
rm /tmp/index.html

echo "Done"
echo "Check it out at: http://www.ime.usp.br/~vkdaros/igamer2014/"
