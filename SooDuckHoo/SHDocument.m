//
//  SHDocument.m
//  SooDuckHoo
//
//  Created by 이지율 on 12. 9. 25..
//  Copyright (c) 2012년 이지율. All rights reserved.
//

#import "SHDocument.h"
#import "SHGame.h"
#import "SHSudokuCell.h"
#import "SHSudokuResolver.h"
#import <QuartzCore/QuartzCore.h>


@implementation SHDocument
@synthesize sudokuView = _sudokuView;
@synthesize gameWindow = _gameWindow;
@synthesize difficultyChooser = _difficultyChooser;
@synthesize game = _game;
- (id)init
{
    self = [super init];
    if (self) {
        // Add your subclass-specific initialization here.
    }
    return self;
}

- (NSString *)windowNibName
{
    // Override returning the nib file name of the document
    // If you need to use a subclass of NSWindowController or if your document supports multiple NSWindowControllers, you should remove this method and override -makeWindowControllers instead.
    return @"SHDocument";
}

- (void)windowControllerDidLoadNib:(NSWindowController *)aController
{
    [super windowControllerDidLoadNib:aController];
    // Add any code here that needs to be executed once the windowController has loaded the document's window.
    [[aController window] setAcceptsMouseMovedEvents: YES];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(modelChanged:)
                                                 name:NSManagedObjectContextObjectsDidChangeNotification
                                               object:self.managedObjectContext];
    
    [[[NSThread alloc]initWithTarget:self selector:@selector(prepareGame) object:nil] start];
}



/**
 * 게임을 준비한다, 별도의 독립 스레드에서 수행된다.
 */
-(void) prepareGame
{
    [CATransaction begin];
    [CATransaction setDisableActions: YES];
    
    [self.indicator startAnimation: self];
    NSLog(@"SHDoc - 닙 로드 완료");
    self.game = [self ensureGame];
    NSLog(@"SHDoc - 게임 확보후 지정");
    
    /*
     * UI 스레드 내에서 뷰에 생성된 게임을 전달한다.
     */
    NSInvocationOperation* op = [[NSInvocationOperation alloc]initWithTarget:self
                                                                    selector:@selector(sendGameToView)
                                                                      object:nil];
    [[NSOperationQueue mainQueue]addOperation: op];
    [CATransaction commit];
}

-(void) sendGameToView
{
    if(self.game.initialized.boolValue == NO){
        [self showDifficultySheet];
    }
    
    self.sudokuView.game = self.game;
    [self.indicator stopAnimation: self];
}

-(void) modelChanged: (NSNotification*) noti
{
    self.sudokuView.needsDisplay = YES;
}

/*
 * 문서에 게임이 포함된 경우, 게임을 로드하고 그렇지 않은 경우 새로 만들고, 문서에 포함시킨 뒤 리턴한다.
 */
-(SHGame*) ensureGame
{
    SHGame* game;
    
    NSEntityDescription* entity = [NSEntityDescription entityForName:@"Game"
                                              inManagedObjectContext:self.managedObjectContext];
    // 먼저 문서에 게임이 포함되어 있는지 확인한다.
    NSFetchRequest* fr = [NSFetchRequest new];
    fr.entity = entity;
    
    NSError* error;
    NSArray* result = [self.managedObjectContext executeFetchRequest: fr
                                                               error: &error];
    if(result != nil && [result count] > 0){
        game = [result objectAtIndex: 0];
        NSLog(@"SHDoc - 게임을 로드하였습니다.");
        return game;
    }
    
    
    // 새로운 게임의 작성, 언두매니저를 잠시 중단 시킨다.
    [[self managedObjectContext] processPendingChanges];
    [[self undoManager]disableUndoRegistration];
    
    game = [NSEntityDescription insertNewObjectForEntityForName:@"Game"
                                                 inManagedObjectContext: self.managedObjectContext];
    
    SHSudokuResolver* resolver = [SHSudokuResolver new];
    int* puzzle = [resolver resolve];
    
    for(int i=0; i<81; i++){
        SHSudokuCell* cell = [NSEntityDescription insertNewObjectForEntityForName:@"SudokuCell"
                                                           inManagedObjectContext:self.managedObjectContext];
        
        [game.cells addObject: cell];
        cell.value = [NSNumber numberWithInt:puzzle[i]];
    }
    
    // 모델을 싱크하고 언두 매니저를 다시 켠다.
    [[self managedObjectContext]processPendingChanges];
    [[self undoManager]enableUndoRegistration];
    NSLog(@"SHDoc - 새 게임을 작성하였습니다.");
    
    return game;
}

-(void)showDifficultySheet
{
    [NSApp beginSheet:self.difficultyChooser.window
       modalForWindow:self.gameWindow
        modalDelegate:nil
       didEndSelector:nil
          contextInfo:nil];
    
    [NSApp runModalForWindow: _difficultyChooser.window];
    [NSApp endSheet:_difficultyChooser.window];

    [_difficultyChooser.window orderOut:self];
    
    [[self managedObjectContext] processPendingChanges];
    [[self undoManager]disableUndoRegistration];
    
    
    NSMutableArray* array = [NSMutableArray new];
    for(int i=0; i<81; i++){
        [array addObject: [NSNumber numberWithInt: i ]];
    }
    
    for(int i=0; i<_difficultyChooser.difficulty * 22; i++){
        int targetIndex = rand() % [array count];
        NSNumber* target = [array objectAtIndex:targetIndex];
        SHSudokuCell* cell = [self.game.cells objectAtIndex:[target intValue]];
        cell.value = 0;
        [array removeObjectAtIndex: targetIndex];
    }
    
    self.game.initialized = [NSNumber numberWithBool: YES];
    
    [[self managedObjectContext]processPendingChanges];
    [[self undoManager]enableUndoRegistration];
}


@end
