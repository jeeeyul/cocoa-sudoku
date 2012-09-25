//
//  SearchSequence.m
//  Suduckhoo
//
//  Created by 이지율 on 12. 9. 25..
//  Copyright (c) 2012년 이지율. All rights reserved.
//

#import "SHSearchSequence.h"

@implementation SHSearchSequence
{
@private
    NSArray* fSequence;
    int fCurrentIndex;
}

+(SHSearchSequence *)sequenceWith:(NSArray *)sequence
{
    return [[SHSearchSequence alloc]initWithSequence: sequence];
}

-(SHSearchSequence *)initWithSequence:(NSArray *)sequence {
    fSequence = sequence;
    return self;
}

-(bool)canNext
{
    return fCurrentIndex < [fSequence count] - 1;
}

-(int)next
{
    fCurrentIndex++;
    return [self current];
}

-(int)current
{
    NSNumber* result = nil;
    
    @try{
        result = [fSequence objectAtIndex: fCurrentIndex];
    }
    @catch(NSException* e){
        NSLog(@"%@", e);
    }
    return [result intValue];
}


@end
