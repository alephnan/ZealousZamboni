import json
import sys
from datetime import datetime

def mainloop():
	if len(sys.argv) < 2:
		print "enter json file"
		sys.exit(0)
	
	f = open(sys.argv[1]);
	players = json.loads(f.read());
	
	for player in players:
		print ""
		print "Player %s" % player['uid']
		print "\tNumber of page loads (visits): %d" % len(player['pageloads'])
		print "\tNumber of levels played: %d" % len(player['levels'])
		levels = player['levels']
		print "Active play time(seconds): %d" % activeTimePlayed(levels)

# Calculates the amount of active time played in seconds. Players sometimes space out or walk away from the
# computer for long periods of time, so it's useful to just look at the amount of time that they spent actively
# interacting with your game. This function calculates the amount of active time a player spends in your time by
# counting the amount of time between each logged action.  If the player does not perform any actions for more 
# than 30 seconds, this function just adds 30 seconds onto the active time and ignores any additional time between
# actions. Depending on how often your game logs actions, you might want to change the inactivity limit

INACTIVITY_LIMIT = 30000 #time in milliseconds that we consider inactve (i.e. 30 seconds)

def activeTimePlayed(levels):
	totalActiveTime = 0
	for level in levels:
		if level["dqid"] is not None:
			actions = level["actions"]
			activeTime = 0
			lastTimeStamp = 0
			currentTimeStamp = -1
			for action in actions:
				currentTimeStamp = action["ts"]
				difference = currentTimeStamp - lastTimeStamp
				if difference > INACTIVITY_LIMIT:
					difference = INACTIVITY_LIMIT
				activeTime = activeTime + difference				
				lastTimeStamp = currentTimeStamp
				print "level: ",level["qid"]," activeTime: ",activeTime 		
				totalActiveTime = totalActiveTime + activeTime
	return totalActiveTime/1000
mainloop()
