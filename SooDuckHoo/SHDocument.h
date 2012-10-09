//
//  SHDocument.h
//  SooDuckHoo
//
//  Created by 이지율 on 12. 9. 25..
//  Copyright (c) 2012년 이지율. All rights reserved.
//

#import <Cocoa/Cocoa.h>
@class SHGameController;

@interface SHDocument : NSPersistentDocument

@property IBOutlet SHGameController* gameController;

@end
