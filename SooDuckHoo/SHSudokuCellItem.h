//
//  SHSudokuCellItem.h
//  SooDuckHoo
//
//  Created by 이지율 on 12. 9. 26..
//  Copyright (c) 2012년 이지율. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "SHSudokuCell.h"
#import "SHSudokuView.h"
@interface SHSudokuCellItem : NSObject

@property SHSudokuView* parent;
@property NSRect bounds;
@property SHSudokuCell* model;


-(void) drawItem;

@end
