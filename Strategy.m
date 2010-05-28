// Copyright (c) 2010 Nick Ewing <nick@nickewing.net>

#import "Strategy.h"

@implementation Strategy

-(id)initWithController:(ApplicationController *)c andPlayer:(int)p {
	self = [super init];
  if (self != nil) {
		controller = c;
		player = p;
	}
  return self;
}

// called by the controller when action is needed
-(void)computeNextMoveForBoard:(Board *)board {
	[NSException raise:NSInternalInconsistencyException 
		format:@"You must override %@ in a subclass", NSStringFromSelector(_cmd)];
}

// send a move to the controller on the main thread
-(void)sendMove:(Coord *)move {
	[controller performSelectorOnMainThread:@selector(move:)
			withObject:move
			waitUntilDone:NO];
}

// send a pass to the controller on the main thread
-(void)sendPass {
	[controller performSelectorOnMainThread:@selector(pass)
			withObject:nil
			waitUntilDone:NO];
}

-(void)sleepIfTooFast:(NSDate *)date {
	NSTimeInterval timePassed = [date timeIntervalSinceNow] * -1;
	
	if (timePassed < STRAT_SLEEP_TIME) {
		NSLog([NSString stringWithFormat:@"Sleeping for %f", STRAT_SLEEP_TIME - timePassed]);
		[NSThread sleepForTimeInterval:STRAT_SLEEP_TIME - timePassed];
	}
}

// generate a new board from a given board and apply a move to it
-(Board *)newBoardFromBoard:(Board *)board withMove:(Coord *)move andPlayer:(int)p {
	Board *moveBoard = [[Board alloc] initWithBoard:board];
	[moveBoard makeMoveForPlayer:p AtRow:[move row] Column:[move col]];
	return [moveBoard autorelease];
}

@end
