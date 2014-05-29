import json
import sys
from datetime import datetime

def mainloop():
	if len(sys.argv) < 2:
		print "enter json file"
		sys.exit(0)
	
	f = open(sys.argv[1]);
	players = json.loads(f.read());
	times = list()
	maxTime = -1
	print "Number of players: %d" % len(players)
	for player in players:
		if player['uid'] != "3BD04335-7068-C88B-2C2B-F46936612340" and player['uid'] != "80836283-5BB6-6862-C96A-5527B1222647":
			print ""
			print "Player %s" % player['uid']
			levels = player['levels']
			time = activeTimePlayed(levels)
			print "Active play time(seconds): %s" % time
			if time > 5:
				times.append(time)
	times.sort(key=int)
	print ""
	print "Number active players: %d" % len(times)
	print ", ".join(str(time) for time in times)
	print "max time: %d" % max(times)
	percents = list()
	maxTime = int(max(times))
	for x in range(0, maxTime):
		numActive = 0
		for time in times:
			if time >= x:
				numActive = numActive + 1
		percents.append(float(numActive) / len(times))
		print "%f\t%f" % (float(x) / 60, float(numActive) / len(times))

INACTIVITY_LIMIT = 15000	#15 seconds

def activeTimePlayed(levels):
	totalActiveTime = 0;
	for level in levels:
		actions = level["actions"]
		activeTime = 0;
		lastTimeStamp = 0;
		currentTimeStamp = -1;
		for action in actions:
			currentTimeStamp = action["ts"]
			difference = currentTimeStamp - lastTimeStamp
			if difference > INACTIVITY_LIMIT:
				difference = INACTIVITY_LIMIT
			activeTime = activeTime + difference
			lastTimeStamp = currentTimeStamp
			totalActiveTime = totalActiveTime + activeTime
	return float(totalActiveTime) / 1000
	
mainloop()
