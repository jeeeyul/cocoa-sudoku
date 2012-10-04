//
//  SHAppDelegate.m
//  SooDuckHoo
//
//  Created by 이지율 on 12. 9. 25..
//  Copyright (c) 2012년 이지율. All rights reserved.
//

#import "SHAppDelegate.h"

@implementation SHAppDelegate
{
    bool fRestored;
}

- (id)init
{
    self = [super init];
    if (self) {
        fRestored = NO;
    }
    return self;
}

    -(void)applicationDidFinishLaunching:(NSNotification *)notification
    {
        NSLog(@"App Dele - 런칭 피니시");
     
        // 리스토어된 도큐먼트 또는 로드된 도큐먼트가 없을 경우, 새 게임을 열도록 예약.
        NSInvocationOperation* op = [[NSInvocationOperation alloc]initWithTarget:self selector:@selector(openNewDocumentIfNeeded) object:nil];
        [[NSOperationQueue mainQueue] addOperation: op];
    }

    -(void)openNewDocumentIfNeeded
    {
        NSLog(@"App Dele - 확보된 도큐먼트 확인 시작");
        NSUInteger documentCount = [[[NSDocumentController sharedDocumentController] documents]count];
        NSLog(@"App Dele - %ld개의 도큐먼트", documentCount);
        
        if(documentCount == 0){
            [self newGame: self];
        }
    }


-(void)application:(NSApplication *)app didDecodeRestorableState:(NSCoder *)coder
{
    NSLog(@"App Dele - 리스토어");
    fRestored = YES;
}

-(void)newGame:(id)sender
{
    [[NSDocumentController sharedDocumentController]openUntitledDocumentAndDisplay:YES error: nil];
    NSLog(@"App Dele - 새 도큐먼트 작성");
}

-(void)application:(NSApplication *)app willEncodeRestorableState:(NSCoder *)coder
{
    NSLog(@"store");
}

@end
