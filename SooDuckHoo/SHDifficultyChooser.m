//
//  SHDifficultyChooser.m
//  SooDuckHoo
//
//  Created by 이지율 on 12. 10. 9..
//  Copyright (c) 2012년 이지율. All rights reserved.
//

#import "SHDifficultyChooser.h"
@implementation SHDifficultyChooser
@synthesize difficulty;

- (id)initWithWindow:(NSWindow *)window
{
    self = [super initWithWindow:window];
    if (self) {
        // Initialization code here.
    }
    
    return self;
}

- (void)windowDidLoad
{
    [super windowDidLoad];
    
    // Implement this method to handle any initialization after your window controller's window has been loaded from its nib file.
}

- (NSString *)windowNibName
{
     return @"SHDifficultyChooser";
}

-(void)didSimpsonSelected:(id)sender
{
    self.difficulty = 1;
    [[self window] close];
    [NSApp stopModal];
}

-(void)didJeeeyulSelected:(id)sender
{
    self.difficulty = 2;
    [[self window] close];
    [NSApp stopModal];
}

-(void)didSheldonSelected:(id)sender
{
    self.difficulty = 3;
    [[self window] close];
    [NSApp stopModal];
}

@end
