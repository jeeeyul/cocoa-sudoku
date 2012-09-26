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

@implementation SHSudokuView
{
    NSMutableArray* fCells;
    SHGame* fGame;
}

@synthesize cellSpacing = fCellSpacing;
@synthesize margin = fMargin;
@synthesize areaSpacing = fAreaSpacing;

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


-(void)mouseDown:(NSEvent *)theEvent
{
    NSLog(@"%@", theEvent);
}

-(void)drawRect:(NSRect)dirtyRect
{
    if([self inLiveResize])
    {
        [self layoutItems];
    }
    
    NSGraphicsContext* gc = [NSGraphicsContext currentContext];
        
    NSEnumerator* iter = [fCells objectEnumerator];
    SHSudokuCellItem* each = nil;
    while(each = [iter nextObject])
    {
        [gc saveGraphicsState];
        [each drawItem];
        [gc restoreGraphicsState];
    }
}

-(void)layout
{
    [super layout];
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
