#import "Coord.h"

@implementation Coord

@synthesize row;
@synthesize col;

-(id)initWithRow:(int)r Column:(int)c {
	self = [super init];
  if (self != nil) {
    row = r;
    col = c;
  }
  return self;
}

@end
