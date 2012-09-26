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

-(void)drawBackground
{
    NSGraphicsContext* gc = [NSGraphicsContext currentContext];
    
    [gc saveGraphicsState];
    
    [[NSColor yellowColor] set];
    
    NSShadow* shadow = [NSShadow new];
    shadow.shadowOffset = NSMakeSize(2, -2);
    shadow.shadowBlurRadius = 5.0;
    [shadow set];
    
    NSBezierPath* path = [NSBezierPath new];
    [path appendBezierPathWithRoundedRect:self.bounds xRadius:10 yRadius:10];
    [path fill];
    
    [gc restoreGraphicsState];
}

-(void) drawForeground
{
    NSGraphicsContext* gc = [NSGraphicsContext currentContext];
    
    [gc saveGraphicsState];
    if(self.model != nil && self.model.value != nil){
        NSString* text = [NSString stringWithFormat: @"%@", self.model.value];
        [text drawInRect:[self bounds] withAttributes:nil];
    }
    [gc restoreGraphicsState];

}

-(void)drawItem
{
    [self drawBackground];
    [self drawForeground];
}

@end
