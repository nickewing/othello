#import "AlphaBetaMove.h"

@implementation AlphaBetaMove

@synthesize move;
@synthesize score;

-(id)initWithMove:(Coord *)m andScore:(int)s {
	self = [super init];
  if (self != nil) {
    move = [m retain];
		score = s;
  }
  return self;
}

-(void)dealloc {
	[move release];
	[super dealloc];
}

@end
