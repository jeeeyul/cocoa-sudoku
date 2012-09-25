//
//  SHSudokuCell.h
//  SooDuckHoo
//
//  Created by 이지율 on 12. 9. 25..
//  Copyright (c) 2012년 이지율. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class SHGame;

@interface SHSudokuCell : NSManagedObject

@property (nonatomic, retain) NSString * bottomMemo;
@property (nonatomic, retain) NSNumber * fixed;
@property (nonatomic, retain) NSString * topMemo;
@property (nonatomic, retain) NSNumber * value;
@property (nonatomic, retain) SHGame *game;

@end
