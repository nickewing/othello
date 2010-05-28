// Copyright (c) 2010 Nick Ewing <nick@nickewing.net>

#import <Cocoa/Cocoa.h>

#define EMPTY   0
#define BLACK  +1
#define WHITE  -1
#define BORDER  3

@interface Board : NSObject {
@private
	char grid[100];
}

-(id)init;
-(id)initWithBoard:(Board *)other;

-(int)squareAtRow:(int)row Column:(int)col;

-(BOOL)isLegalForMovePlayer:(int)player AtRow:(int)row Column:(int)col;
-(NSArray*)legalMovesForPlayer:(int)player;
-(BOOL)noMovesForplayer:(int)player;

-(void)makeMoveForPlayer:(int)player AtRow:(int)row Column:(int)col;

-(void)reset;

-(int)scoreForPlayer:(int)player;

-(NSArray *)neighborsOfRow:(int)row column:(int)col;

@end
