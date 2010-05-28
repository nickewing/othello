// Copyright (c) 2010 Nick Ewing <nick@nickewing.net>

// Stores a score and a move for the alpha-beta algorithm

#import <Cocoa/Cocoa.h>
#import "Coord.h"

@interface AlphaBetaMove : NSObject {
	Coord *move;
	int score;
}

@property (readonly) Coord *move;
@property (readonly) int score;

-(id)initWithMove:(Coord *)move andScore:(int)score;
-(void)dealloc;

@end
