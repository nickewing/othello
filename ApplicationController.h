// Copyright (c) 2010 Nick Ewing <nick@nickewing.net>

// Main controller for game, handles GUI interactions

#import <Cocoa/Cocoa.h>
#import "Board.h"
#import "Coord.h"

@class Strategy;

@interface ApplicationController : NSObject {
	IBOutlet NSMatrix *boardMatrix;
	IBOutlet NSTextField *blackScoreField;
	IBOutlet NSTextField *whiteScoreField;
	IBOutlet NSButton *passButton;
	IBOutlet NSProgressIndicator *waitSpinner;
	IBOutlet NSMenuItem *newGameMenuItem;
	IBOutlet NSTextField *messageField;
	IBOutlet NSMenu *playersMenu;
	IBOutlet NSMenu *difficultyMenu;

@protected
	Board *currentBoard;
	int currentPlayer;
	int blackScore;
	int whiteScore;
	Strategy *blackStrategy;
	Strategy *whiteStrategy;
	NSOperationQueue *aiOpQueue;
	int players;
	int difficulty;
}

-(void)awakeFromNib;

-(IBAction)matrixButtonClicked:(id)sender;
-(IBAction)passButtonClicked:(id)sender;
-(IBAction)newGame:(id)sender;
-(IBAction)difficultyMenuItemClicked:(id)sender;
-(IBAction)playersMenuItemClicked:(id)sender;
-(IBAction)helpClicked:(id)sender;

-(void)updateOptionMenus;
-(void)updateGUI;
-(void)getNextMove;

-(void)newGame;
-(void)nextPlayer;
-(void)move:(Coord *)coord;
-(void)pass;

-(Strategy *)allocStrategy;
-(BOOL)currentPlayerUsingAI;

@end
