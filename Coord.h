#import <Cocoa/Cocoa.h>


@interface Coord : NSObject {
@private
	int row;
	int col;
}

@property (readonly) int row;
@property (readonly) int col;

-(id)initWithRow:(int)row Column:(int)col;

@end
