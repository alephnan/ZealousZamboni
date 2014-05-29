import json
import sys
from datetime import datetime

TOTAL_LEVELS = 19

def mainloop():
	if len(sys.argv) < 2:
		print "enter json file"
		sys.exit(0)
	
	f = open(sys.argv[1]);
	players = json.loads(f.read());
	maxLevels = list()
	maxTime = -1
	#print "Number of players: %d" % len(players)
	for player in players:
		# I know for sure these are ours
		if player['uid'] != "3BD04335-7068-C88B-2C2B-F46936612340" and player['uid'] != "80836283-5BB6-6862-C96A-5527B1222647":
			#print ""
			#print "Player %s" % player['uid']
			levels = player['levels']
			playerMax = getPlayerMaxLevel(levels)
			maxLevels.append(playerMax)
			#print "Max level played: %d" % playerMax
	#print ""
	#print "Number active players: %d" % len(times)
	#print ", ".join(str(time) for time in times)
	#print "max time: %d" % max(times)
	#percents = list()
	for x in range(0, TOTAL_LEVELS):
		numActive = 0
		for ml in maxLevels:
			if ml >= x:
				numActive = numActive + 1
		#percents.append(float(numActive) / len(times))
		print "%f\t%f" % (x + 1, float(numActive) / len(maxLevels))
	
def getPlayerMaxLevel(levels):
	levelMap = [31337, 206, 208, 209, 101, 102, 211, 104, 105, 212, 213, 214, 215, 216, 220, 217, 218, 219, 221]
	maxLevel = -1
	for level in levels:
		i = 0
		while level['qid'] != levelMap[i] and i < len(levelMap):
			i = i + 1
		if i > maxLevel:
			maxLevel = i
	return maxLevel
	
mainloop()
