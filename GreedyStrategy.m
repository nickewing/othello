// Copyright (c) 2010 Nick Ewing <nick@nickewing.net>

#import "GreedyStrategy.h"
#import "Strategy.h"
#include <limits.h>

@implementation GreedyStrategy

-(void)computeNextMoveForBoard:(Board *)board {
	[NSThread sleepForTimeInterval:STRAT_SLEEP_TIME];
	
	NSArray *legalMoves = [[board legalMovesForPlayer:player] retain];
	int n = [legalMoves count];
	
	if (n == 0) {
		[self sendPass];
	} else {
		Coord *bestMove;
		int bestScore = INT_MIN;
		
		int moveCount = [legalMoves count];
		for (int i = 0; i < moveCount; i++) {
			Coord *move = [legalMoves objectAtIndex:i];
			Board *moveBoard =
				[[self newBoardFromBoard:board withMove:move andPlayer:player] retain];
			
			int moveScore = [self utilityOfBoard:moveBoard forPlayer:player withNegation:NO];
			
			//NSLog([NSString stringWithFormat:@"%d,%d: %d",[move row],[move col],moveScore]);
			
			if (moveScore > bestScore) {
				bestMove = move;
				bestScore = moveScore;
			}
			
			[moveBoard release];
		}
		
		//NSLog([NSString stringWithFormat:@"Chose %d,%d: %d",
		//					[bestMove row],[bestMove col],bestScore]);
		[self sendMove:bestMove];
	}
	
	[legalMoves release];
}

@end
