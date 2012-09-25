//
//  SudokuResolver.h
//  Suduckhoo
//
//  Created by 이지율 on 12. 9. 25..
//  Copyright (c) 2012년 이지율. All rights reserved.
//

#import <Foundation/Foundation.h>

/**
 * 스도쿠 문제 생성 및 풀이를 제공하는 서비스
 */
@interface SHSudokuResolver : NSObject

+ (SHSudokuResolver*) resolverWithPuzzle:(NSArray*) puzzle;

- (SHSudokuResolver*) initWithPuzzle:(NSArray*) puzzle;

- (int*) resolve;

@end
