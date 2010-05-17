#import "Board.h"
#import "Coord.h"
#include <string.h>

char directions[8] = {-11, -10, -9, -1, 1, 9, 10, 11};

// written out instead of programmed in to allow for simple memory copy on init
char initBoard[100] = {
	// 1      2       3       4       5       6       7       8       9       10
	BORDER, BORDER, BORDER, BORDER, BORDER, BORDER, BORDER, BORDER, BORDER, BORDER, // 1
	BORDER, EMPTY,  EMPTY,  EMPTY,  EMPTY,  EMPTY,  EMPTY,  EMPTY,  EMPTY,  BORDER, // 2
	BORDER, EMPTY,  EMPTY,  EMPTY,  EMPTY,  EMPTY,  EMPTY,  EMPTY,  EMPTY,  BORDER, // 3
	BORDER, EMPTY,  EMPTY,  EMPTY,  EMPTY,  EMPTY,  EMPTY,  EMPTY,  EMPTY,  BORDER, // 4
	BORDER, EMPTY,  EMPTY,  EMPTY,  WHITE,  BLACK,  EMPTY,  EMPTY,  EMPTY,  BORDER, // 5
	BORDER, EMPTY,  EMPTY,  EMPTY,  BLACK,  WHITE,  EMPTY,  EMPTY,  EMPTY,  BORDER, // 6
	BORDER, EMPTY,  EMPTY,  EMPTY,  EMPTY,  EMPTY,  EMPTY,  EMPTY,  EMPTY,  BORDER, // 7
	BORDER, EMPTY,  EMPTY,  EMPTY,  EMPTY,  EMPTY,  EMPTY,  EMPTY,  EMPTY,  BORDER, // 8
	BORDER, EMPTY,  EMPTY,  EMPTY,  EMPTY,  EMPTY,  EMPTY,  EMPTY,  EMPTY,  BORDER, // 9
	BORDER, BORDER, BORDER, BORDER, BORDER, BORDER, BORDER, BORDER, BORDER, BORDER  // 10
};

@implementation Board

-(id)init {
	self = [super init];
  if (self != nil) [self reset];
  return self;
}

// Initalize a new board with the values from another board
-(id)initWithBoard:(Board *)other {
	self = [super init];
  if (self != nil)
		for (int i = 0; i < 10; i++)
			for (int j = 0; j < 10; j++)
				grid[i * 10 + j] = [other squareAtRow: i Column: j];
  return self;	
}

// Get the value of the grid at the given row and column
-(int)squareAtRow:(int)row Column:(int)col {
	return grid[row * 10 + col];
}

// Determine if given coordinates are a valid move for a player
-(BOOL)isLegalForMovePlayer:(int)player AtRow:(int)row Column:(int)col {
	int l0 = row * 10 + col;
	if (grid[l0] != EMPTY) return NO;
	
	int otherPlayer = -player;
	for (int i = 0; i < 8; i++) {
		char d = directions[i];
		int l1 = l0 + d;
		if (grid[l1] == otherPlayer) {
			do { l1 += d; } while (grid[l1] == otherPlayer);
			if (grid[l1] == player) return YES;
		}
	}
	
	return NO;
}

// Get all valid move coordinates for a player
-(NSArray*)legalMovesForPlayer:(int)player {
	NSMutableArray *legalMoves = [[NSMutableArray alloc] init];
	
	for (int row = 1; row <= 8; row++) {
		for (int col = 1; col <= 8; col++) {
			if ([self isLegalForMovePlayer:player AtRow:row Column:col]) {
				Coord *move = [[Coord alloc] initWithRow:row Column:col];
				[legalMoves addObject:move];
				[move release];
			}
		}
	}
	return [legalMoves autorelease];
}

// Determine if a player is out of moves
-(BOOL)noMovesForplayer:(int)player {
	for (int row = 1; row <= 8; row++)
		for (int col = 1; col <= 8; col++)
			if ([self isLegalForMovePlayer:player AtRow:row Column:col])
				return NO;
	return YES;
}

// Execute a move on the board for a player
-(void)makeMoveForPlayer:(int)player AtRow:(int)row Column:(int)col {
	int l0 = row * 10 + col;
	int otherPlayer = -player;
	
	grid[l0] = player;
	for (int i = 0; i < 8; i++) {
		char d = directions[i];
		int l1 = l0 + d;
		if (grid[l1] == otherPlayer) {
			do { l1 += d; } while (grid[l1] == otherPlayer);
			if (grid[l1] == player) {
				do {
					grid[l1] = player;
					l1 -= d;
					
				} while (grid[l1] == otherPlayer);
			}
		}
	}
}

// Reset the board to its initial state
-(void)reset {
	memcpy(grid, initBoard, sizeof(initBoard));
}

// Calculate the current score for a player
-(int)scoreForPlayer:(int)player {
	int score = 0;
	for (int i = 1; i < 9; i++)
		for (int j = 1; j < 9; j++)
			if (grid[i * 10 + j] == player)
				++score;
	return score;
}

-(NSArray *)neighborsOfRow:(int)row column:(int)col {
	NSMutableArray *ret = [[NSMutableArray alloc] init];
	
	int l0 = row * 10 + col;
	
	for (int i = 0; i < 8; i++) {
		int l1 = l0 + directions[i];
		if (l1 < 100 && l1 >= 0 && grid[l1] != BORDER) {
			Coord *coord = [[Coord alloc] initWithRow:l1 / 10 Column:l1 % 10];
			[ret addObject:coord];
			[coord release];
		}
	}
	
	return [ret autorelease];
}

@end
