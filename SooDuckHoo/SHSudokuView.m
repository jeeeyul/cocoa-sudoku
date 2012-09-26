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
}

@synthesize game = fGame;
@synthesize document = fDocument;
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
        
        [self setupLayer];
    }
    return self;

}

-(void) setupLayer
{
    self.layer.cornerRadius = 10.0;
    self.layer.borderWidth = 1.0f;
    self.layer.shadowOffset = CGSizeMake(0.0f, 2.0f);
    self.layer.shadowOpacity = 1.5f;
    self.layer.shadowRadius = 2.5f;
    self.layer.anchorPoint = CGPointMake(0.5f, 0.5f);
}

-(void)mouseDown:(NSEvent *)theEvent
{
    NSLog(@"%@", theEvent);
}

-(void)drawRect:(NSRect)dirtyRect
{
    if([self inLiveResize])
    {
        [self layout];
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

-(void) layout
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

-(void) viewWillDraw
{
    if(self.game == nil)
    {
        [self ensureGame];
    }
}

-(void) ensureGame
{
    NSEntityDescription* entity = [NSEntityDescription entityForName:@"Game"
                                              inManagedObjectContext:fDocument.managedObjectContext];
    // 먼저 문서에 게임이 포함되어 있는지 확인한다.
    NSFetchRequest* fr = [NSFetchRequest new];
    fr.entity = entity;
    
    NSError* error;
    NSArray* result = [fDocument.managedObjectContext executeFetchRequest: fr
                                                                    error: &error];
    if(result != nil && [result count] > 0){
        fGame = [result objectAtIndex: 0];
        NSLog(@"게임을 로드하였습니다.");
        return;
    }
    
    
    // 새로운 게임의 작성, 언두매니저를 잠시 중단 시킨다.
    [[fDocument managedObjectContext] processPendingChanges];
    [[fDocument undoManager]disableUndoRegistration];
    
    SHGame* game = [NSEntityDescription insertNewObjectForEntityForName:@"Game"
                                                 inManagedObjectContext: fDocument.managedObjectContext];
   
    for(int i=0; i<81; i++){
        SHSudokuCell* cell = [NSEntityDescription insertNewObjectForEntityForName:@"SudokuCell"
                                                           inManagedObjectContext:fDocument.managedObjectContext];

        [game.cells addObject: cell];
        cell.value = [NSNumber numberWithInt:i];
        
        
        SHSudokuCellItem* cellUI = [fCells objectAtIndex: i];
        cellUI.model = cell;
    }
    
    // 모델을 싱크하고 언두 매니저를 다시 켠다.
    [[fDocument managedObjectContext]processPendingChanges];
    [[fDocument undoManager]enableUndoRegistration];
    NSLog(@"새 게임을 작성하였습니다.");
    self.game = game;
}

@end
