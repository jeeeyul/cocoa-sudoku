//
//  SHDifficultyChooser.h
//  SooDuckHoo
//
//  Created by 이지율 on 12. 10. 9..
//  Copyright (c) 2012년 이지율. All rights reserved.
//

#import <Cocoa/Cocoa.h>

@interface SHDifficultyChooser : NSWindowController

@property int difficulty;

-(IBAction) didSimpsonSelected:(id)sender;
-(IBAction) didJeeeyulSelected:(id)sender;
-(IBAction) didSheldonSelected:(id)sender;


@end
