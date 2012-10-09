//
//  SHAppDelegate.m
//  SooDuckHoo
//
//  Created by 이지율 on 12. 9. 25..
//  Copyright (c) 2012년 이지율. All rights reserved.
//

#import "SHAppDelegate.h"
#import "SHDocument.h"

@implementation SHAppDelegate
{
    bool fRestored;
}

- (id)init
{
    self = [super init];
    if (self) {
        fRestored = NO;
        srand((int)clock());
    }
    return self;
}

    -(void)applicationDidFinishLaunching:(NSNotification *)notification
    {
        [self log:@"실행 됨"];
     
        // 리스토어된 도큐먼트 또는 로드된 도큐먼트가 없을 경우, 새 게임을 열도록 예약.
        NSInvocationOperation* op = [[NSInvocationOperation alloc]initWithTarget:self selector:@selector(openNewDocumentIfNeeded) object:nil];
        [[NSOperationQueue mainQueue] addOperation: op];
    }

    -(void)openNewDocumentIfNeeded
    {
        NSUInteger documentCount = [[[NSDocumentController sharedDocumentController] documents]count];
        
        if(documentCount == 0){
            [self newGame: self];
        }
    }


-(void)application:(NSApplication *)app didDecodeRestorableState:(NSCoder *)coder
{
    fRestored = YES;
}

-(void)newGame:(id)sender
{
    [[NSDocumentController sharedDocumentController]openUntitledDocumentAndDisplay:YES error: nil];
    [self log:@"새 도큐먼트 작성함"];
}

-(void)application:(NSApplication *)app willEncodeRestorableState:(NSCoder *)coder
{
    NSLog(@"store");
}

-(void)duplicateGame: (id) sender
{
    SHDocument* doc = [[NSDocumentController sharedDocumentController] currentDocument];
    [doc duplicateDocument: doc];
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
