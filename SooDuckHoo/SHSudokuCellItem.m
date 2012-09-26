//
//  SHSudokuCellItem.m
//  SooDuckHoo
//
//  Created by 이지율 on 12. 9. 26..
//  Copyright (c) 2012년 이지율. All rights reserved.
//

#import "SHSudokuCellItem.h"

@implementation SHSudokuCellItem
@synthesize parent = fParent;

#pragma mark 생성자
+(SHSudokuCellItem*) cellItemWithParent: (SHSudokuView*) parent
{
    return [[SHSudokuCellItem alloc]initWithParent: parent];
}


-(SHSudokuCellItem*) initWithParent: (SHSudokuView*) parent
{
    self = [super init];
    if(self){
        fParent = parent;
    }
    
    return self;
}


#pragma mark 랜더링

-(void)drawItem
{
    
}

@end
