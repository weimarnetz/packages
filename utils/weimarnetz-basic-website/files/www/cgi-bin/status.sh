#!/bin/ash
echo "Content-Type: text/html"
echo

cat <<EOF
<?xml version="1.0" encoding="utf-8"?>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.1//EN" "http://www.w3.org/TR/xhtml11/DTD/xhtml11.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
</head>
<body style="background-color: white">
<h2>OLSR-Verbindungen</h2>
<h3>Übersicht über aktuell bestehende OLSR-Verbindungen</h3>
EOF

echo "<pre>"
echo "$(/usr/bin/neigh.sh)"
echo "</pre>"
echo "<p>Dieses Gerät verfügt nur über geringe Hardwareresourcen. Aus diesem Grund gibt es hier nur eine Sparversion der Übersichtsseite. Mehr Informationen findest du auf der <a href="/">Startseite</a>.</p>"
echo "</body></html>"
