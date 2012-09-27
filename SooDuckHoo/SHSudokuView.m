//
//  SudokuView.m
//  Suduckhoo
//
//  Created by 이지율 on 12. 9. 25..
//  Copyright (c) 2012년 이지율. All rights reserved.
//

#import "SHSudokuView.h"
#import "SHGame.h"
#import "SHSudokuCellItem.h"
#import "SHCellRenderingOptions.h"

@implementation SHSudokuView
{
    NSMutableArray* fCells;
    SHGame* fGame;
}

@synthesize cellSpacing = fCellSpacing;
@synthesize margin = fMargin;
@synthesize areaSpacing = fAreaSpacing;

#pragma mark - 초기화
-(id)initWithFrame:(NSRect)frameRect
{
    self = [super initWithFrame:frameRect];
    if(self)
    {
        fMargin = 5;
        fCellSpacing = 10;
        fAreaSpacing = 10;
        
        fCells = [NSMutableArray new];
        
        for(int i=0; i<81; i++)
        {
            [fCells addObject: [SHSudokuCellItem cellItemWithParent:self]];
        }
    }
    return self;

}


# pragma mark - UI 핸들링
-(BOOL)acceptsFirstResponder
{
    return YES;
}

-(void)mouseDown:(NSEvent *)theEvent
{
    NSPoint currentLocation = [self convertPoint:theEvent.locationInWindow fromView:nil];

    SHSudokuCellItem* item = [self cellItemWithPoint: currentLocation];
    self.selection = item;
    self.needsDisplay = YES;
}

-(void)mouseMoved:(NSEvent *)theEvent
{
    NSPoint currentLocation = [self convertPoint:theEvent.locationInWindow fromView:nil];
    SHSudokuCellItem* item = [self cellItemWithPoint: currentLocation];

    if(self.hotItem != item){
        self.hotItem = item;
        self.needsDisplay = YES;
    }
}

-(void)keyDown:(NSEvent *)theEvent
{
    printf("%d\n", theEvent.keyCode);
    int number = [theEvent.characters intValue];
    if(number != 0 && self.selection != nil){
        self.selection.model.value = [NSNumber numberWithInt: number];
    }
}

# pragma mark - 랜더링 관련
-(void)drawRect:(NSRect)dirtyRect
{
    NSGraphicsContext* gc = [NSGraphicsContext currentContext];
        
    NSEnumerator* iter = [fCells objectEnumerator];
    SHSudokuCellItem* each = nil;
    while(each = [iter nextObject])
    {
        [gc saveGraphicsState];
        SHCellRenderingOptions options;
        options.selected = self.selection == each;
        options.highlighted = self.hotItem == each;
        
        [each drawItemWithOptions: options];
        [gc restoreGraphicsState];
    }
}

-(void)viewWillDraw
{
    [self layoutItems];
}

-(void) layoutItems
{
    NSRect bounds = self.bounds;
    CGFloat boxWidth = (bounds.size.width - fMargin * 2.0 - fCellSpacing * 8.0 - fAreaSpacing * 2) / 9.0;
    CGFloat boxHeight = (bounds.size.height - fMargin * 2.0 - fCellSpacing * 8.0 - fAreaSpacing * 2) / 9.0;
    
    for(int i=0; i<81; i++)
    {
        int row = i / 9;
        int col = i % 9;
        
        NSRect bounds = NSMakeRect(col * boxWidth + fMargin, row * boxHeight + fMargin, boxWidth, boxHeight);

        bounds.origin.y += fCellSpacing * row + (row / 3) * fAreaSpacing;
        bounds.origin.x += fCellSpacing * col + (col / 3) * fAreaSpacing;
        
        SHSudokuCellItem* eachItem = [fCells objectAtIndex: i];
        eachItem.bounds = bounds;
    }
}

#pragma mark - Service APIs:

/**
 * 주어진 지점에 포함된 셀 아이템을 얻습니다.
 */
-(SHSudokuCellItem*) cellItemWithPoint:(NSPoint) point
{
    NSEnumerator* iter = [fCells objectEnumerator];
    SHSudokuCellItem* each = nil;
    
    while(each = [iter nextObject])
    {
        bool isContained = each.bounds.origin.x <= point.x && point.x <= each.bounds.origin.x + each.bounds.size.width && each.bounds.origin.y <= point.y && point.y <= each.bounds.origin.y + each.bounds.size.height;
        
        if(isContained)
        {
            return each;
        }
    }
    
    return nil;
}

-(void) handleModelChanged: (NSNotification*) notification
{
    NSLog(@"모델 수정됨");
}


#pragma mark - 모델 액세스
-(void)assignModelToCellItems
{
    for(int i=0; i<81; i++){
        SHSudokuCellItem* cellItem = [fCells objectAtIndex: i];
        SHSudokuCell* cellModel = nil;
        if(fGame != nil){
            cellModel = [fGame.cells objectAtIndex: i];
        }
        cellItem.model = cellModel;
    }
    self.needsDisplay = YES;
}

-(void)setGame:(SHGame *)game
{
    
    if(fGame == game)
    {
        return;
    }
    
    [self willChangeValueForKey:@"game"];
    fGame = game;
    [self assignModelToCellItems];

    [self didChangeValueForKey:@"game"];
}

-(SHGame*) game
{
    return fGame;
}


@end
