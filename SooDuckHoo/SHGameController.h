//
//  SHGameController.h
//  SooDuckHoo
//
//  Created by Jeeeyul Lee on 12. 10. 10..
//  Copyright (c) 2012년 이지율. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "SHDocument.h"
#import "SHSudokuView.h"
#import "SHDifficultyChooser.h"
#import "SHGame.h"

@interface SHGameController : NSObject

@property IBOutlet SHDocument* document;
@property IBOutlet SHSudokuView* sudokuView;
@property IBOutlet NSWindow* gameWindow;
@property IBOutlet SHDifficultyChooser* difficultyChooser;
@property IBOutlet NSProgressIndicator* indicator;

@property SHGame* game;

-(void)documentDidLoadNib;

@end
