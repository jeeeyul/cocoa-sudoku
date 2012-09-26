//
//  SudokuView.m
//  Suduckhoo
//
//  Created by 이지율 on 12. 9. 25..
//  Copyright (c) 2012년 이지율. All rights reserved.
//

#import "SHSudokuView.h"
#import "SHGame.h"

@implementation SHSudokuView
{
    NSMutableArray* fCells;
}

@synthesize game = fGame;
@synthesize document = fDocument;


-(id)init
{
    self = [super init];
    if(self){
        fCells = [NSMutableArray new];
    }
    return self;
}


-(void)drawRect:(NSRect)dirtyRect
{
    NSGraphicsContext* gc = [NSGraphicsContext currentContext];
    
    [gc saveGraphicsState];
    
    [[NSColor blueColor] set];
    
    NSRect bounds = [self bounds];
    
    
    
    NSShadow* shadow = [NSShadow new];
    shadow.shadowOffset = NSMakeSize(5.0, -5.0);
    shadow.shadowBlurRadius = 10.0;
    [shadow set];
    
    NSBezierPath* path = [NSBezierPath new];
    path.lineWidth = 2.0;
    [path appendBezierPathWithRoundedRect:bounds
                                  xRadius:10.0
                                  yRadius:10.0];
    [path stroke];
    
    [gc restoreGraphicsState];
    
    NSEnumerator* iter = [fCells objectEnumerator];
    SHSudokuCell* each = nil;
    while(each = [iter nextObject]){
        
    }
}

-(void)viewWillDraw
{
    if(self.game == nil){
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
    }
    
    // 모델을 싱크하고 언두 매니저를 다시 켠다.
    [[fDocument managedObjectContext]processPendingChanges];
    [[fDocument undoManager]enableUndoRegistration];
    NSLog(@"새 게임을 작성하였습니다.");
    self.game = game;
}

@end
