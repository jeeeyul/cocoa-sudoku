//
//  NSMutableArray.h
//  Suduckhoo
//
//  Created by 이지율 on 12. 9. 25..
//  Copyright (c) 2012년 이지율. All rights reserved.
//

#import <Foundation/Foundation.h>

// 배열에 섞기 기능을 추가하기 위한 카테고리
@interface NSMutableArray (Shuffle)
- (void)shuffle;
@end
