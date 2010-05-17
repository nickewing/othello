// Abstract weighted strategy
// Provides weighting method for board states

#import <Cocoa/Cocoa.h>
#import "Strategy.h"
#import "Board.h"

@interface WeightedStrategy : Strategy {
}

-(int)utilityOfBoard:(Board *)board forPlayer:(int)p withNegation:(BOOL)neg;

-(int)utilityWithCornerAdjustmentOfBoard:(Board *)board
			forPlayer:(int)p withNegation:(BOOL)neg;

@end
