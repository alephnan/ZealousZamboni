import json
import sys
from datetime import datetime

def mainloop():
	if len(sys.argv) < 2:
		print "enter json file"
		sys.exit(0)
	
	f = open(sys.argv[1]);
	players = json.loads(f.read());
	
	print "Number of players: %d" % len(players)
	returns = list()
	for player in players:
		print ""
		print "Player %s" % player['uid']
		print "\tNumber of page loads (visits): %d" % len(player['pageloads'])
		print "\tNumber of levels played: %d" % len(player['levels'])
		if player['uid'] != "3BD04335-7068-C88B-2C2B-F46936612340" and player['uid'] != "80836283-5BB6-6862-C96A-5527B1222647" and player['uid'] != "AADAF50B-C884-C7A1-E81A-32B56D1E117D":
			returns.append(len(player['pageloads']) - 1)
	print "max visits: %d" % max(returns)
	numReturns = list()
	for x in range(0, max(returns) + 1):
		numReturns.append(0)
	for x in range(0, len(returns)):
		numReturns[returns[x]] = numReturns[returns[x]] + 1
	for x in range(0, max(returns) + 1):
		print "%d\t%f" % (x, float(numReturns[x]) / len(returns))
		
mainloop()
