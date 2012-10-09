//
//  SHGameController.m
//  SooDuckHoo
//
//  Created by Jeeeyul Lee on 12. 10. 10..
//  Copyright (c) 2012년 이지율. All rights reserved.
//

#import <QuartzCore/QuartzCore.h>
#import "SHGameController.h"
#import "SHSudokuResolver.h"
#import "SHSudokuCell.h"

@implementation SHGameController

@synthesize sudokuView = _sudokuView;
@synthesize gameWindow = _gameWindow;
@synthesize document = _document;
@synthesize difficultyChooser = _difficultyChooser;
@synthesize indicator = _indicator;

# pragma mark - 초기화 관련
-(void)documentDidLoadNib
{
    self.gameWindow.acceptsMouseMovedEvents = YES;
    
    [self hook];
    
    // 개별 스레드에서 게임을 준비시킴.
    [[[NSThread alloc]initWithTarget:self selector:@selector(prepareGame) object:nil] start];
}

# pragma mark - 모델 변경 감시
-(void) hook
{
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(modelChanged:)
                                                 name:NSManagedObjectContextObjectsDidChangeNotification
                                               object:self.document.managedObjectContext];
    [self log:@"문서 감시 시작됨"];
}

-(void) modelChanged: (NSNotification*) noti
{
    self.sudokuView.needsDisplay = YES;
}


# pragma mark - 게임 구성 관련
/**
 * 게임을 준비한다, 별도의 독립 스레드에서 수행된다.
 */
-(void) prepareGame
{
    [CATransaction begin];
    [CATransaction setDisableActions: YES];
    
    [self.indicator startAnimation: self];

    self.game = [self ensureGame];
    
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

/*
 * 문서에 게임이 포함된 경우, 게임을 로드하고 그렇지 않은 경우 새로 만들고, 문서에 포함시킨 뒤 리턴한다.
 */
-(SHGame*) ensureGame
{
    SHGame* game;
    
    NSEntityDescription* entity = [NSEntityDescription entityForName:@"Game"
                                              inManagedObjectContext:self.document.managedObjectContext];
    // 먼저 문서에 게임이 포함되어 있는지 확인한다.
    NSFetchRequest* fr = [NSFetchRequest new];
    fr.entity = entity;
    
    NSError* error;
    NSArray* result = [self.document.managedObjectContext executeFetchRequest: fr
                                                               error: &error];
    if(result != nil && [result count] > 0){
        game = [result objectAtIndex: 0];
        [self log:@"게임을 로드하였습니다."];
        return game;
    }
    
    
    // 새로운 게임의 작성, 언두매니저를 잠시 중단 시킨다.
    [[self.document managedObjectContext] processPendingChanges];
    [[self.document undoManager]disableUndoRegistration];
    
    game = [NSEntityDescription insertNewObjectForEntityForName:@"Game"
                                         inManagedObjectContext: self.document.managedObjectContext];
    
    SHSudokuResolver* resolver = [SHSudokuResolver new];
    int* puzzle = [resolver resolve];
    
    for(int i=0; i<81; i++){
        SHSudokuCell* cell = [NSEntityDescription insertNewObjectForEntityForName:@"SudokuCell"
                                                           inManagedObjectContext:self.document.managedObjectContext];
        
        [game.cells addObject: cell];
        cell.value = [NSNumber numberWithInt:puzzle[i]];
    }
    
    // 모델을 싱크하고 언두 매니저를 다시 켠다.
    [[self.document managedObjectContext]processPendingChanges];
    [[self.document undoManager]enableUndoRegistration];
    [self log: @"새 게임을 작성하였습니다."];
    
    return game;
}


#pragma mark - 난이도 시트 관련

-(void)showDifficultySheet:(SHGame*) game
{
    [NSApp beginSheet:self.difficultyChooser.window
       modalForWindow:self.gameWindow
        modalDelegate:nil
       didEndSelector:nil
          contextInfo:nil];
    
    [NSApp runModalForWindow: _difficultyChooser.window];
    [NSApp endSheet:_difficultyChooser.window];
    
    [_difficultyChooser.window orderOut:self];
    
    [[self.document managedObjectContext] processPendingChanges];
    [[self.document undoManager]disableUndoRegistration];
    
    
    NSMutableArray* array = [NSMutableArray new];
    for(int i=0; i<81; i++){
        [array addObject: [NSNumber numberWithInt: i ]];
    }
    
    for(int i=0; i<_difficultyChooser.difficulty * 22; i++){
        int targetIndex = rand() % [array count];
        NSNumber* target = [array objectAtIndex:targetIndex];
        SHSudokuCell* cell = [game.cells objectAtIndex:[target intValue]];
        cell.value = 0;
        [array removeObjectAtIndex: targetIndex];
    }
    
    game.initialized = [NSNumber numberWithBool: YES];
    
    [[self.document managedObjectContext]processPendingChanges];
    [[self.document undoManager]enableUndoRegistration];
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
    
    [[self.document managedObjectContext] processPendingChanges];
    [[self.document undoManager]disableUndoRegistration];
    
    
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
    
    [[self.document managedObjectContext]processPendingChanges];
    [[self.document undoManager]enableUndoRegistration];
}



#pragma mark - 디버깅
-(void) log:(NSString*) obj, ...
{
    va_list args;
    va_start(args, obj);
    NSString* str = [[NSString alloc]initWithFormat:obj arguments:args];
    NSLog(@"SHGameController - %@", str);
    va_end(args);
}

@end
