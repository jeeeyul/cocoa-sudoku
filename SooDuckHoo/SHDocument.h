//
//  SHDocument.h
//  SooDuckHoo
//
//  Created by 이지율 on 12. 9. 25..
//  Copyright (c) 2012년 이지율. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import "SHSudokuView.h"
#import "SHDifficultyChooser.h"

@interface SHDocument : NSPersistentDocument

@property SHGame* game;
@property IBOutlet SHSudokuView* sudokuView;
@property IBOutlet SHDifficultyChooser* difficultyChooser;
@property IBOutlet NSProgressIndicator* indicator;
@property IBOutlet NSWindow* gameWindow;


@end
