// A greedy strategy
// Picks the move that maximizes the next state score given
// weighted states

#import <Cocoa/Cocoa.h>
#import "WeightedStrategy.h"
#import "Coord.h"

@interface GreedyStrategy : WeightedStrategy {
}

-(void)computeNextMoveForBoard:(Board *)board;

@end