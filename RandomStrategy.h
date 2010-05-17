// A random strategy
// chooses a random legal move if possible, otherwise passes

#import <Cocoa/Cocoa.h>
#import "Strategy.h"
#import "Coord.h"

@interface RandomStrategy : Strategy {
}

-(void)computeNextMoveForBoard:(Board *)board;

@end
