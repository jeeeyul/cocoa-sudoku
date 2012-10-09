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
#import "SHGameController.h"
#import <QuartzCore/QuartzCore.h>


@implementation SHDocument

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
    
    [self.gameController documentDidLoadNib];
}

-(void) log:(NSString*) obj, ...
{
    va_list args;
    va_start(args, obj);
    NSString* str = [[NSString alloc]initWithFormat:obj arguments:args];
    NSLog(@"SHAppDelegate - %@", str);
    va_end(args);
}

@end
