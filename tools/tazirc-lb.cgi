#!/bin/sh
#
# Small CGI example to display TazIRC Log Bot logs.
#
. /usr/lib/slitaz/httphelper.sh

host="irc.freenode.net"
chan="slitaz"
logdir="log/$host/$chan"

# Send content type
header

# HTML Header
cat << EOT
<!DOCTYPE html>
<html lang="en">
<head>
	<meta charset="utf-8" />
	<title>TazIRC Log Bot</title>
	<link rel="stylesheet" type="text/css" href="style.css" />
	<style type="text/css">
		html { height: 102%; }
		body { margin: 40px 80px; font-size: 90%; }
	</style>
</head>
<body>
EOT

# Handle GET actions 
case " $(GET) " in
	*\ log\ *)
		log="$(GET log)"
		echo "<h2>#${chan} $log</h2>"
		IFS="|"
		cat ${logdir}/${log}.log | while read time user text
		do
		cat << EOT
<div>
[$time] <span style="color: blue;">$user:</span> $text
</div>
EOT
		done 
		unset IFS ;;
	*)
		# List all logs by date
		echo "<h2>#${chan} Logs</h2>"
		echo "<pre>"
		for log in $(ls $logdir/*.log | sort -r -n)
		do
			log="$(basename ${log%.log})"
			echo "<a href='?log=$log'>$log</a>"
		done
		echo "</pre>"
esac

# HTML Footer
cat << EOT
</body>
</html>
EOT
