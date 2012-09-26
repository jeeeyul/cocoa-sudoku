//
//  SHSudokuCellItem.m
//  SooDuckHoo
//
//  Created by 이지율 on 12. 9. 26..
//  Copyright (c) 2012년 이지율. All rights reserved.
//

#import "SHSudokuCellItem.h"

@implementation SHSudokuCellItem
@synthesize parent = fParent;

#pragma mark 생성자
+(SHSudokuCellItem*) cellItemWithParent: (SHSudokuView*) parent
{
    return [[SHSudokuCellItem alloc]initWithParent: parent];
}


-(SHSudokuCellItem*) initWithParent: (SHSudokuView*) parent
{
    self = [super init];
    if(self){
        fParent = parent;
    }
    
    return self;
}


#pragma mark 랜더링

-(void)drawBackgroundWithSelection:(bool) selected
                     withHighlight:(bool) highlighted
{
    NSGraphicsContext* gc = [NSGraphicsContext currentContext];
    
    [gc saveGraphicsState];
    
   
    [[NSBezierPath bezierPathWithRoundedRect:self.bounds xRadius:5 yRadius:5]setClip];
    
    
    if(selected){
        [[NSColor colorWithCalibratedHue:0.5 saturation:0.5 brightness:0.8 alpha:1]set];
    }
    
    else if(highlighted){
        [[NSColor colorWithCalibratedHue:0.5 saturation:0.5 brightness:0.8 alpha:0.5]set];
    }
    
    else{
        [[NSColor colorWithCalibratedHue:0 saturation:0 brightness:0.8 alpha:1]set];
    }
    
    
    [NSBezierPath fillRect: self.bounds];
   
    NSRect expanded = NSMakeRect(self.bounds.origin.x - 10, self.bounds.origin.y - 10, self.bounds.size.width + 20, self.bounds.size.height + 20);

    
    NSBezierPath* outer = [[NSBezierPath alloc]init];
    
    [outer moveToPoint: expanded.origin];
    [outer lineToPoint: NSMakePoint(expanded.origin.x, expanded.origin.y + expanded.size.height)];
    [outer lineToPoint: NSMakePoint(expanded.origin.x + expanded.size.width, expanded.origin.y + expanded.size.height)];    
    [outer lineToPoint: NSMakePoint(expanded.origin.x + expanded.size.width, expanded.origin.y)];


    [outer lineToPoint: expanded.origin];
    
    [outer lineToPoint: NSMakePoint(self.bounds.origin.x + 5, self.bounds.origin.y)];
    [outer lineToPoint: NSMakePoint(self.bounds.origin.x + self.bounds.size.width - 5, self.bounds.origin.y)];
    [outer appendBezierPathWithArcWithCenter: NSMakePoint(self.bounds.origin.x + self.bounds.size.width - 5, self.bounds.origin.y + 5) radius:5 startAngle:270 endAngle:360];
    [outer lineToPoint: NSMakePoint(self.bounds.origin.x + self.bounds.size.width, self.bounds.origin.y + self.bounds.size.height - 5)];
    [outer appendBezierPathWithArcWithCenter:NSMakePoint(self.bounds.origin.x + self.bounds.size.width - 5, self.bounds.origin.y + self.bounds.size.height - 5) radius:5 startAngle:0 endAngle:90];
    [outer lineToPoint: NSMakePoint(self.bounds.origin.x + 5, self.bounds.origin.y + self.bounds.size.height)];
    [outer appendBezierPathWithArcWithCenter:NSMakePoint(self.bounds.origin.x + 5, self.bounds.origin.y + self.bounds.size.height - 5) radius:5 startAngle:90 endAngle:180];
    [outer lineToPoint: NSMakePoint(self.bounds.origin.x, self.bounds.origin.y + 5)];
    [outer appendBezierPathWithArcWithCenter:NSMakePoint(self.bounds.origin.x + 5, self.bounds.origin.y + 5) radius:5 startAngle:180 endAngle:270];
    [outer closePath];
    
    NSShadow* shadow = [NSShadow new];
    shadow.shadowOffset = NSMakeSize(0.0, -3.0);
    shadow.shadowBlurRadius = 7.0;
    shadow.shadowColor = [NSColor colorWithCalibratedHue:0 saturation:0 brightness:0 alpha:0.4];
    [shadow set];
    
    [outer fill];
  
  
    
    [gc restoreGraphicsState];
}

-(void) drawForegroundWithSelection:(bool) selected
                      withHighlight:(bool) highlighted
{
    NSGraphicsContext* gc = [NSGraphicsContext currentContext];
    
    [gc saveGraphicsState];
    NSShadow* shadow = [NSShadow new];
    shadow.shadowOffset = NSMakeSize(0.0, -1.0);
    shadow.shadowColor = [NSColor whiteColor];
    [shadow set];
    
    if(self.model != nil && self.model.value != nil){
        NSString* text = [NSString stringWithFormat: @"%@", self.model.value];
        NSRect textBounds = [text boundingRectWithSize:self.bounds.size options:0 attributes:nil];
        
        [text drawAtPoint:NSMakePoint(self.bounds.origin.x + (self.bounds.size.width - textBounds.size.width)/2.0, self.bounds.origin.y + (self.bounds.size.height - textBounds.size.height) /2.0)
           withAttributes:nil];
    }
    [gc restoreGraphicsState];

}

-(void)drawItemWithSelection:(bool)selected
                 highlighted:(bool)highlighted
{
    [self drawBackgroundWithSelection:selected withHighlight:highlighted];
    [self drawForegroundWithSelection:selected withHighlight:highlighted];
}

@end
