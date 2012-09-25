//
//  SearchSequence.h
//  Suduckhoo
//
//  Created by 이지율 on 12. 9. 25..
//  Copyright (c) 2012년 이지율. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface SHSearchSequence : NSObject

+(SHSearchSequence*) sequenceWith: (NSArray*) sequence ;

-(SHSearchSequence*) initWithSequence: (NSArray*) sequence;

-(bool) canNext;
-(int) next;
-(int) current;

@end
