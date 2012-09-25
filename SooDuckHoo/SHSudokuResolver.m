//
//  SudokuResolver.m
//  Suduckhoo
//
//  Created by 이지율 on 12. 9. 25..
//  Copyright (c) 2012년 이지율. All rights reserved.
//

#import "SHSudokuResolver.h"
#import "SHSearchSequence.h"
#import "NSMutableArray_Shuffle.h"

@implementation SHSudokuResolver
{
    @private
    NSArray* fEmptyArray;
    NSArray* fAllNumbers;
    
    
    int* fPuzzle;
    int fIndex;
    bool* fFixed;
    NSMutableArray* fStack;
}


#pragma mark 초기화
/**
 * Static Initializer
 */
+ (SHSudokuResolver *) resolverWithPuzzle:(NSArray *)puzzle{
    return [[SHSudokuResolver alloc]initWithPuzzle: puzzle];
}

- (SHSudokuResolver*) init{
    NSMutableArray* puzzle = [NSMutableArray new];

    for(int i=0; i<81; i++){
        [puzzle addObject: [NSNumber numberWithInt: 0]];
    }
    
    return [self initWithPuzzle: puzzle];
}

- (SHSudokuResolver *) initWithPuzzle:(NSArray*) puzzle{
    if([puzzle count] != 81){
        [NSException raise:@"퍼즐의 크기는 81이어야 합니다" format: @"퍼즐의 크기가 %lu입니다, 81이어야 합니다", [puzzle count]];
    }
    
    fStack = [NSMutableArray new];
    fPuzzle = malloc(sizeof(int) * 81);
    fFixed = malloc(sizeof(bool) * 81);
    fIndex = -1;
    
    for(int i=0; i<81; i++){
        NSNumber* n = [puzzle objectAtIndex:i];
        
        fPuzzle[i] = [n intValue];
        
        if(fPuzzle[i] != 0){
            fFixed[i] = true;
        }else{
            fFixed[i] = false;
        }
    }
    return self;
}

#pragma mark 제공 서비스
-(int*) resolve
{
    while(![self isFilled])
    {
        [self step];
    }

    int size = sizeof(int) * 81;
    int* result = malloc(size);
    memcpy(result, fPuzzle, size);
    
    return result;
}

#pragma mark 비즈니스 로직
-(void) step
{
    bool isFilled = [self isFilled];
    
    // 스택이 비어있는 경우
    if([self currentSequence] == nil){
        NSArray* nextSequence = [self getAvailableNumberFor: fIndex + 1];
       
        if([nextSequence count] == 0){
            [NSException raise:@"해답이 존재하지 않음" format:@"해답이 존재하지 않습니다."];
        }
        
        [self push: [SHSearchSequence sequenceWith: nextSequence]];
        fPuzzle[fIndex] = [[self currentSequence]current];
        return;
    }

    // 가득 차있는 경우
    if(isFilled){
        if([[self currentSequence] canNext]){
            int next = [[self currentSequence] next];
            fPuzzle[fIndex] = next;
        }
            
        else{
            while(![[self currentSequence] canNext]){
                [self pop];
            }
            fPuzzle[fIndex] = [[self currentSequence]next];
        }
    }
    
    // 비어있는 경우
    else{
        NSArray* nextSeq = [self getAvailableNumberFor:fIndex + 1];
        bool hasNextBranch = [nextSeq count] > 0;
        
        if(!hasNextBranch && [[self currentSequence] canNext]){
            fPuzzle[fIndex] = [[self currentSequence]next];
        }
        
        else if(hasNextBranch){
            [self push: [SHSearchSequence sequenceWith:nextSeq]];
            fPuzzle[fIndex] = [[self currentSequence] current];
        }
        
        else{
            while(![[self currentSequence] canNext]){
                [self pop];
            }
            fPuzzle[fIndex] = [[self currentSequence]next];
        }
    }
}

-(NSArray*) getAvailableNumberFor: (int) index
{
    if(![self validate]){
         return [self emptyArray];
    }
    
    if(fFixed[index]){
        return [NSArray arrayWithObject: [NSNumber numberWithInt:fPuzzle[index]]];
    }
    
    
    NSMutableArray* result = [NSMutableArray new];
 
    int row = index / 9;
    int col = index % 9;
    
    [result addObjectsFromArray:[self allNumbers]];
    for(int x=0; x<9; x++){
        [result removeObject:[self getWithRow:x col:col]];
        [result removeObject:[self getWithRow:row col:x]];
    }
    
    int bRow = row / 3;
    int bCol = col / 3;
    
    for (int rd = 0; rd < 3; rd++) {
        for (int cd = 0; cd < 3; cd++) {
            [result removeObject:[self getWithRow:bRow * 3 + rd col:bCol * 3 + cd]];
        }
    }
    
    [result shuffle];
    return result;
}



#pragma mark 서비스 API
-(void) debug
{
    for(int i=0; i<81; i++){
        if(i % 9 == 0){
            printf("\r\n");
        }
        printf("%d", fPuzzle[i]);
    }
    printf("\r\n");
}

-(SHSearchSequence*) pop{
    SHSearchSequence* result = [fStack lastObject];
    [fStack removeObject: [fStack lastObject]];
    
    if(!fFixed[fIndex]){
        fPuzzle[fIndex] = 0;
    }
    fIndex--;
    return result;
}

-(SHSearchSequence*) push:(SHSearchSequence*) nextSequence
{
    [fStack addObject: nextSequence];
    fIndex++;
    return nextSequence;
}

-(NSArray*) emptyArray
{
    if(fEmptyArray == nil){
        fEmptyArray = [NSArray new];
    }
    return fEmptyArray;
}

-(NSArray*) allNumbers
{
    if(fAllNumbers == nil){
        NSMutableArray* result = [NSMutableArray new];

        for(int i=1; i<=9; i++){
            [result addObject:[NSNumber numberWithInt:i]];
        }

        fAllNumbers = result;
    }
    return fAllNumbers;
}


-(SHSearchSequence*) currentSequence
{
    return [fStack lastObject];
}

-(NSNumber*) getWithRow: (int) row col:(int) col
{
    return [NSNumber numberWithInt: fPuzzle[row * 9 + col]];
}

-(bool) isFilled{
    for(int i=0; i<81; i++){
        if(fPuzzle[i] == 0){
            return false;
        }
    }
    return true;
}

-(bool) validate
{
    // horizontal conflict
    for (int r = 0; r < 9; r++) {
        int flag = 0x0;
        
        for (int c = 0; c < 9; c++) {
            int val = [[self getWithRow:r col:c] intValue];
            if (val != 0) {
                int mask = 0x1 << (val - 1);
                if ((flag & mask) != 0) {
                    return false;
                } else {
                    flag |= mask;
                }
            }
        }
    }
    
    // vertical conflict
    for (int c = 0; c < 9; c++) {
        int flag = 0x0;
        for (int r = 0; r < 9; r++) {
            int val = [[self getWithRow:r col:c]intValue];
            if (val != 0) {
                int mask = 0x1 << (val - 1);
                if ((flag & mask) != 0) {
                    return false;
                } else {
                    flag |= mask;
                }
            }
        }
    }
    
    // box conflict
    for (int br = 0; br < 3; br++) {
        for (int bc = 0; bc < 3; bc++) {
            int flag = 0x00;
            for (int r = 0; r < 3; r++) {
                for (int c = 0; c < 3; c++) {
                    int index = (br * 3 + r) * 9 + bc * 3 + c;
                    if (fPuzzle[index] != 0) {
                        int mask = 0x1 << (fPuzzle[index] - 1);
                        if ((flag & mask) != 0) {
                            return false;
                        } else {
                            flag |= mask;
                        }
                    }
                }
            }
        }
    }
    
    return true;
}

@end
