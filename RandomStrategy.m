#import "RandomStrategy.h"
#import "Strategy.h"

@implementation RandomStrategy

-(void)computeNextMoveForBoard:(Board *)board {
	[NSThread sleepForTimeInterval:STRAT_SLEEP_TIME];
	
	NSArray *legalMoves = [[board legalMovesForPlayer:player] retain];
	int n = [legalMoves count];
	
	if (n == 0) {
		[self sendPass];
	} else {
		int i = random() % n;
		Coord *move = [legalMoves objectAtIndex:i];
		[self sendMove:move];
	}
	
	[legalMoves release];
}

@end
