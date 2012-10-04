//
//  SHDocument.h
//  SooDuckHoo
//
//  Created by 이지율 on 12. 9. 25..
//  Copyright (c) 2012년 이지율. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import "SHSudokuView.h"

@interface SHDocument : NSPersistentDocument

@property IBOutlet SHSudokuView* sudokuView;
@property IBOutlet NSProgressIndicator* indicator;


@end
