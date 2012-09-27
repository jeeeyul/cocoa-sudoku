//
//  SHAppDelegate.m
//  SooDuckHoo
//
//  Created by 이지율 on 12. 9. 25..
//  Copyright (c) 2012년 이지율. All rights reserved.
//

#import "SHAppDelegate.h"

@implementation SHAppDelegate

-(void)applicationDidFinishLaunching:(NSNotification *)notification
{
    if([[[NSDocumentController sharedDocumentController] documents]count] == 0){
        [[NSDocumentController sharedDocumentController]openUntitledDocumentAndDisplay:YES error: nil];
        NSLog(@"새 도큐먼트 작성");
    }
}

-(void)newGame:(id)sender
{
    [[NSDocumentController sharedDocumentController]openUntitledDocumentAndDisplay:YES error: nil];
    NSLog(@"새 도큐먼트 작성");
}

@end
