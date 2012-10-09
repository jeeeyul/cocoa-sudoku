//
//  SHGame.h
//  SooDuckHoo
//
//  Created by 이지율 on 12. 10. 9..
//  Copyright (c) 2012년 이지율. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class SHSudokuCell;

@interface SHGame : NSManagedObject

@property (nonatomic, retain) NSNumber * initialized;
@property (nonatomic, retain) NSMutableOrderedSet *cells;
@end

