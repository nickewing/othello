// Copyright (c) 2010 Nick Ewing <nick@nickewing.net>

// Alpha beta strategy
// Uses min-max with alpha-beta pruning to find the next
// best move given possible future moves

#import <Cocoa/Cocoa.h>
#import "WeightedStrategy.h"
#import "Board.h"
#import "Coord.h"
#import "AlphaBetaMove.h"

@interface AlphaBetaStrategy : WeightedStrategy {
}

-(void)computeNextMoveForBoard:(Board *)board;

-(int)minimaxABWithBoard:(Board *)board andPlayer:(int)p andDepth:(int)d
			andA:(int)a andB:(int)b;

@end
