// Copyright (c) 2010 Nick Ewing <nick@nickewing.net>

#import "AlphaBetaStrategy.h"
#include <limits.h>

#define AB_PLIES 2

@implementation AlphaBetaStrategy

-(void)computeNextMoveForBoard:(Board *)board {
	NSAutoreleasePool *pool = [[NSAutoreleasePool	alloc] init];
	
	NSDate *date = [NSDate date];
	
	NSArray *legalMoves = [[board legalMovesForPlayer:player] retain];
	int n = [legalMoves count];
	
	if (n == 0) {
		[self sleepIfTooFast:date];
		[self sendPass];
	} else {
		Coord *bestMove = nil;
		int bestVal;
		
		for (int i = 0; i < n; i++) {
			Coord *m = [legalMoves objectAtIndex:i];
			Board *mBoard =
				[[self newBoardFromBoard:board withMove:m andPlayer:player] retain];
			
			int v = [self minimaxABWithBoard:mBoard andPlayer:player
										andDepth:AB_PLIES andA:INT_MIN andB:INT_MAX];
		  [mBoard release];
			
			if (!bestMove || v > bestVal) {
				bestMove = m;
				bestVal  = v;
			}
		}
		
		[self sleepIfTooFast:date];
		[self sendMove:bestMove];
	}
	
	[legalMoves release];
	
	[pool release];
}

-(int)minimaxABWithBoard:(Board *)board andPlayer:(int)p andDepth:(int)d
			andA:(int)a andB:(int)b {
	
	NSArray *legalMoves = [board legalMovesForPlayer:player];
	int n = [legalMoves count];
	
	if (d == 0 || n == 0)
		return [self utilityWithCornerAdjustmentOfBoard:board
								 forPlayer:p withNegation:YES];
	
	if (p != player) {
		for (int i = 0; i < n; i++) {
			Coord *m = [legalMoves objectAtIndex:i];
			Board *mBoard =
				[[self newBoardFromBoard:board withMove:m andPlayer:player] retain];
			
			int v = [self minimaxABWithBoard:mBoard andPlayer:-p andDepth:d-1 andA:a andB:b];
			[mBoard release];
			
			if (v < b) b = v;
			if (a > b) break;
		}
		
		return b;
	} else {
		for (int i = 0; i < n; i++) {
			Coord *m = [legalMoves objectAtIndex:i];
			Board *mBoard =
				[[self newBoardFromBoard:board withMove:m andPlayer:player] retain];
		
			int v = [self minimaxABWithBoard:mBoard andPlayer:-p andDepth:d-1 andA:a andB:b];
			[mBoard release];
			
			if (v > a) a = v;
			if (a > b) break;
		}
		
		return a;
	}
}

@end
