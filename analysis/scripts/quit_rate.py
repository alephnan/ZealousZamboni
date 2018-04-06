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
	quits = list()
	for x in range(0, TOTAL_LEVELS + 1):
		quits.append(0)
	for ml in maxLevels:
		quits[ml] = quits[ml] + 1
	for x in range(0, TOTAL_LEVELS + 1):
		print "%d\t%f" % (x + 1, float(quits[x]) / len(maxLevels))
	
def getPlayerMaxLevel(levels):
	levelMap = [31337, 301, 302, 303, 101, 102, 211, 104, 105, 212, 213, 214, 215, 216, 220, 217, 218, 219, 221]
	maxLevel = -1
	for level in levels:
		i = 0
		while i < len(levelMap) and level['qid'] != levelMap[i]:
			i = i + 1
		if i > maxLevel:
			maxLevel = i
	return maxLevel
	
mainloop()
