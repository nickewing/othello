#import "WeightedStrategy.h"

@implementation WeightedStrategy


// Weights from Norvig's lisp implementation:
// http://norvig.com/paip/othello.lisp
char weights[100] = {
	0,   0,   0,  0,  0,  0,  0,   0,   0, 0,
	0, 120, -20, 20,  5,  5, 20, -20, 120, 0,
	0, -20, -40, -5, -5, -5, -5, -40, -20, 0,
	0,  20,  -5, 15,  3,  3, 15,  -5,  20, 0,
	0,   5,  -5,  3,  3,  3,  3,  -5,   5, 0,
	0,   5,  -5,  3,  3,  3,  3,  -5,   5, 0,
	0,  20,  -5, 15,  3,  3, 15,  -5,  20, 0,
	0, -20, -40, -5, -5, -5, -5, -40, -20, 0,
	0, 120, -20, 20,  5,  5, 20, -20, 120, 0,
	0,   0,   0,  0,  0,  0,  0,   0,   0, 0
};


char corners[] = {11, 18, 81, 88};

// Calculate the score for a given board by summing the weights of
// squares owned by the player and subtracting the sum of the weights
// not owned by the player
-(int)utilityOfBoard:(Board *)board forPlayer:(int)p withNegation:(BOOL)neg {
	int util = 0;
	
	for (int i = 1; i < 9; i++) {
		for (int j = 1; j < 9; j++) {
			int v = [board squareAtRow:i Column:j];
			if (v == p) {
				util += weights[i * 10 + j];
			} else if (neg && v == -p) {
				util -= weights[i * 10 + j];
			}
		}
	}
	
	return util;
}

// Calculate the score for a given board by summing the weights of
// squares owned by the player and subtracting the sum of the weights
// not owned by the player
-(int)utilityWithCornerAdjustmentOfBoard:(Board *)board
			forPlayer:(int)p withNegation:(BOOL)neg {
	
	int util = [self utilityOfBoard:board forPlayer:p withNegation:neg];
	
	for (int i = 0; i < 4; i++) {
		int row = corners[i] / 10;
		int col = corners[i] % 10;
		
		if ([board squareAtRow:row Column:col] == EMPTY) continue;
		
		// will be auto released
		NSArray *neighbors = [board neighborsOfRow:row column:col];
		
		for (int j = 0; j < [neighbors count]; j++) {
			Coord *c = [neighbors objectAtIndex:j];
			int cPos = c.row * 10 + c.col;
			
			char val = [board squareAtRow:c.row Column:c.col];
			
			if (val == EMPTY) continue;
			
			util += (5 - weights[cPos]) * (val == p ? 1 : -1);
		}
	}
	
	return util;
}

@end
