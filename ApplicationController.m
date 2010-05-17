#import "ApplicationController.h"
#import "Strategy.h"
#import "RandomStrategy.h"
#import "GreedyStrategy.h"
#import "AlphaBetaStrategy.h"

#define DEFAULT_PLAYERS 1
#define DEFAULT_DIFF 2

@implementation ApplicationController

// Application should close when window closes
-(BOOL)applicationShouldTerminateAfterLastWindowClosed:(NSApplication *)theApplication {
	return YES;
}

// Setup game on load
-(void)awakeFromNib {
	[NSApp setDelegate:self];
	
	players = DEFAULT_PLAYERS;
	difficulty = DEFAULT_DIFF;
	[self updateOptionMenus];
	[waitSpinner startAnimation:self];
	[self newGame];
}

// Respond to a click on the game grid
-(IBAction)matrixButtonClicked:(id)sender {
	int row = [sender selectedRow];
	int col = [sender selectedColumn];
	Coord *coord = [[Coord alloc] initWithRow:row+1 Column:col+1];
	[self move:coord];
	[coord release];
}

// Respond to user pressing pass button
-(IBAction)passButtonClicked:(id)sender {
	[self pass];
}

// Respond to user requesting a new game from menu
-(IBAction)newGame:(id)sender {
	[self newGame];
}

// Respond to difficulty menu item click
// Change difficulty, update menu, and start a new game
-(IBAction)difficultyMenuItemClicked:(id)sender {
	difficulty = [sender tag];
	
	[self updateOptionMenus];
	[self newGame];
}

// Respond to player selecting a new player option
// Set player count, update menus, and start a new game
-(IBAction)playersMenuItemClicked:(id)sender {
	players = [sender tag];
	
	[self updateOptionMenus];
	[self newGame];
}

// Respond to help menu item click
// Open wikipedia article on game
-(IBAction)helpClicked:(id)sender {
	[[NSWorkspace sharedWorkspace] openURL:
		[NSURL URLWithString:@"http://en.wikipedia.org/wiki/Reversi"]];
}

// Update menu items to reflect current game settings
-(void)updateOptionMenus {
	NSArray *playerItems = [playersMenu itemArray];
	int n = [playerItems count];
	for (int i = 0; i < n; i++) {
		NSMenuItem *item = [playerItems objectAtIndex:i];
		[item setState:[item tag] == players ? NSOnState : NSOffState];
	}
	
	NSArray *diffItems = [difficultyMenu itemArray];
	n = [diffItems count];
	for (int i = 0; i < n; i++) {
		NSMenuItem *item = [diffItems objectAtIndex:i];
		[item setState:[item tag] == difficulty ? NSOnState : NSOffState];
	}
}

// Enable or disable menu items
-(void)setMenuItemsEnabled:(BOOL)state {
	[newGameMenuItem setEnabled:state];
	
	NSArray *playerItems = [playersMenu itemArray];
	int n = [playerItems count];
	for (int i = 0; i < n; i++) {
		[[playerItems objectAtIndex:i] setEnabled:state];
	}
	
	NSArray *diffItems = [difficultyMenu itemArray];
	n = [diffItems count];
	for (int i = 0; i < n; i++) {
		[[diffItems objectAtIndex:i] setEnabled:state];
	}
	
}

// Update the board and other gui controls to reflect current state
-(void)updateGUI {
	blackScore = whiteScore = 0;
	
	BOOL human = ![self currentPlayerUsingAI];
	[waitSpinner setHidden:human];
	[boardMatrix setEnabled:human];
	[passButton setEnabled:human];
	[self setMenuItemsEnabled:human];
			
	for (int j = 0; j < 8; j++) {
		for (int i = 0; i < 8; i++) {
			int square = [currentBoard squareAtRow:j+1 Column:i+1];
			NSButtonCell *cell = [boardMatrix cellAtRow:j column:i];
			
			[cell setEnabled:
				human && [currentBoard isLegalForMovePlayer:currentPlayer
																						  AtRow:j+1
																						 Column:i+1]];
			
			if (square == EMPTY) {
				[cell setImage:nil];
			} else if (square == BLACK) {
				++blackScore;
				[cell setImage:[NSImage imageNamed:@"blackpiece"]];
			} else if (square == WHITE) {
				++whiteScore;
				[cell setImage:[NSImage imageNamed:@"whitepiece"]];
			}
		}
	}
	
	[blackScoreField setStringValue:[NSString stringWithFormat:@"%d", blackScore]];
	[whiteScoreField setStringValue:[NSString stringWithFormat:@"%d", whiteScore]];
}

// Get the next move from either a human player or AI
-(void)getNextMove {
	[self updateGUI];
	
	BOOL blackHasNoMoves = [currentBoard noMovesForplayer:BLACK];
	BOOL whiteHasNoMoves = [currentBoard noMovesForplayer:WHITE];
	
	if (blackHasNoMoves && whiteHasNoMoves) {
		if (blackScore == whiteScore) {
			[messageField setStringValue: @"Tie game"];
		} else if (blackScore > whiteScore) {
			[messageField setStringValue: @"Dark wins"];
		} else {
			[messageField setStringValue: @"Light wins"];
		}
		
		[waitSpinner setHidden:YES];
		[boardMatrix setEnabled:NO];
		[passButton setEnabled:NO];
		[self setMenuItemsEnabled:YES];
	} else {
		NSString *playerColor = currentPlayer == 1 ? @"Dark" : @"Light";
		
		if ([self currentPlayerUsingAI]) {
			[messageField setStringValue:
				[NSString stringWithFormat:@"%@ is thinking...", playerColor]];
			
			[waitSpinner setHidden:NO];
			
			Strategy *strat = currentPlayer == BLACK ? blackStrategy : whiteStrategy;
			NSOperation *op = [[NSInvocationOperation alloc]
														initWithTarget:strat
														selector:@selector(computeNextMoveForBoard:)
														object:currentBoard];
			[aiOpQueue addOperation:op];
			[op release];
		} else {
			[messageField setStringValue:
				[NSString stringWithFormat:@"%@'s turn", playerColor]];
			[waitSpinner setHidden:YES];
		}
	}
}

// Alloc a strategy based on current difficulty setting
-(Strategy *)allocStrategy {
	switch (difficulty) {
	case 1:		return [GreedyStrategy alloc]; break;
	case 2:		return [AlphaBetaStrategy alloc]; break;
	default:	return [RandomStrategy alloc]; break;
	}
}

// Start a new game
-(void)newGame {
	BOOL blackUsesAI = players == 0;
	BOOL whiteUsesAI = players <= 1;
	
	currentPlayer = BLACK;
	blackScore    = whiteScore = 0;
	
	if (blackStrategy) {
		[blackStrategy release];
		blackStrategy = nil;
	}
	
	if (whiteStrategy) {
		[whiteStrategy release];
		whiteStrategy = nil;
	}
	
	if (blackUsesAI || whiteUsesAI) {
		if (aiOpQueue) {
			[aiOpQueue cancelAllOperations];
			[aiOpQueue waitUntilAllOperationsAreFinished];
		} else {
			aiOpQueue  = [[NSOperationQueue alloc] init];
		}
	}
	
	if (blackUsesAI)
		blackStrategy = [[self allocStrategy] initWithController:self andPlayer:BLACK];
	if (whiteUsesAI)
		whiteStrategy = [[self allocStrategy] initWithController:self andPlayer:WHITE];
	
	if (currentBoard) {
		[currentBoard reset];
	} else {
		currentBoard = [[Board alloc] init];
	}
	
	[self getNextMove]; // initiate game play
}

// Switch to the next player
-(void)nextPlayer {
	currentPlayer = -currentPlayer;
}

// Execute a move
-(void)move:(Coord *)coord {
	[currentBoard makeMoveForPlayer:currentPlayer AtRow:[coord row] Column:[coord col]];
	[self nextPlayer];
	[self getNextMove];
}

// Execute a pass
-(void)pass {
	[self nextPlayer];
	[self getNextMove];
}

// Determine if the current player is a computer
-(BOOL)currentPlayerUsingAI {
	return (currentPlayer == BLACK && blackStrategy != nil)
			|| (currentPlayer == WHITE && whiteStrategy != nil);
}

@end
