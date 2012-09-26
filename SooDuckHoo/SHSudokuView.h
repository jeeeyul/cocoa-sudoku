//
//  SudokuView.h
//  Suduckhoo
//
//  Created by 이지율 on 12. 9. 25..
//  Copyright (c) 2012년 이지율. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import "SHGame.h"

@interface SHSudokuView : NSView
{

}

@property(setter = setGame:) SHGame* game;
@property int margin;
@property int cellSpacing;
@property int areaSpacing;

@property SHSudokuCell* selection;

@end
