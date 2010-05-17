// Abstract game strategy
// Provides methods for communicating with the controller
// and board state generation

#import <Cocoa/Cocoa.h>
#import "ApplicationController.h"
#import "Board.h"

// sleep time used to slow down some AI actions
#define STRAT_SLEEP_TIME 0.2

@interface Strategy : NSObject {
@protected
	ApplicationController *controller;
	int player;
}

-(id)initWithController:(ApplicationController *)c andPlayer:(int)p;
-(void)computeNextMoveForBoard:(Board *)board;

-(void)sleepIfTooFast:(NSDate *)date;

-(void)sendMove:(Coord *)move;
-(void)sendPass;

-(Board *)newBoardFromBoard:(Board *)board withMove:(Coord *)move andPlayer:(int)p;

@end
