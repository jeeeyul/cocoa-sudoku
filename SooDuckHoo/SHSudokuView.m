//
//  SudokuView.m
//  Suduckhoo
//
//  Created by 이지율 on 12. 9. 25..
//  Copyright (c) 2012년 이지율. All rights reserved.
//

#import "SHSudokuView.h"
#import "SHGame.h"
#import "SHSudokuCellItem.h"
#import "SHCellRenderingOptions.h"
#import <QuartzCore/QuartzCore.h>

@implementation SHSudokuView
{
    NSMutableArray* fCells;
    SHGame* fGame;
    bool fVisible;
}

@synthesize cellSpacing = fCellSpacing;
@synthesize margin = fMargin;
@synthesize areaSpacing = fAreaSpacing;


#pragma mark - 초기화
-(id)initWithFrame:(NSRect)frameRect
{
    self = [super initWithFrame:frameRect];
    if(self)
    {
        fMargin = 20;
        fCellSpacing = 5;
        fAreaSpacing = 5;
        fVisible = NO;
        
        fCells = [NSMutableArray new];
        
        for(int i=0; i<81; i++)
        {
            [fCells addObject: [SHSudokuCellItem cellItemWithParent:self]];
        }
        
        self.wantsLayer = YES;
    }
    return self;
}

# pragma mark - UI 핸들링
-(BOOL)acceptsFirstResponder
{
    return YES;
}

-(void)mouseDown:(NSEvent *)theEvent
{
    if(!self.visible){
        return;
    }
    
    NSPoint currentLocation = [self convertPoint:theEvent.locationInWindow fromView:nil];

    SHSudokuCellItem* item = [self cellItemWithPoint: currentLocation];
    self.selection = item;
    self.needsDisplay = YES;
}

-(void)mouseMoved:(NSEvent *)theEvent
{
    if(!self.visible){
        return;
    }
    
    NSPoint currentLocation = [self convertPoint:theEvent.locationInWindow fromView:nil];
    SHSudokuCellItem* item = [self cellItemWithPoint: currentLocation];

    if(self.hotItem != item){
        self.hotItem = item;
        self.needsDisplay = YES;
    }
}

-(void)keyDown:(NSEvent *)theEvent
{
    if(!self.visible){
        return;
    }
    
    printf("%d\n", theEvent.keyCode);
    switch(theEvent.keyCode)
    {
        // Delete
        case 49:
        case 51:
        case 117:
            if(self.selection != nil){
                self.selection.model.value = 0;
            }
            
            break;
            
        // LEFT
        case 123:
            if(self.selection != nil){
                int index = (int)[fCells indexOfObject: self.selection];
                int row = index / 9;
                int col = index % 9;
                if(col > 0){
                    col -= 1;
                    self.selection = [fCells objectAtIndex: row * 9 + col];
                    self.needsDisplay = YES;
                }
            }
            break;
 
        
        // RIGHT
        case 124:
            if(self.selection != nil){
                int index = (int)[fCells indexOfObject: self.selection];
                int row = index / 9;
                int col = index % 9;
                if(col < 8){
                    col += 1;
                    self.selection = [fCells objectAtIndex: row * 9 + col];
                    self.needsDisplay = YES;
                }
            }
            
            break;
            
        // DOWN
        case 125:
            if(self.selection != nil){
                int index = (int)[fCells indexOfObject: self.selection];
                int row = index / 9;
                int col = index % 9;
                if(row > 0){
                    row -= 1;
                    self.selection = [fCells objectAtIndex: row * 9 + col];
                    self.needsDisplay = YES;
                }
            }
            break;
       
        // UP
        case 126:
             if(self.selection != nil){
                int index = (int)[fCells indexOfObject: self.selection];
                int row = index / 9;
                int col = index % 9;
                if(row < 8){
                    row += 1;
                    self.selection = [fCells objectAtIndex: row * 9 + col];
                    self.needsDisplay = YES;
                }
            }
            break;

            
        default:
        {
            int number = [theEvent.characters intValue];
            if(number != 0 && self.selection != nil){
                self.selection.model.value = [NSNumber numberWithInt: number];
            }
        }
    }
}

# pragma mark - 랜더링 관련
-(void)setVisible:(bool)visible
{
    if(fVisible == visible){
        return;
    }
    [self willChangeValueForKey:@"visible"];
    fVisible = visible;
    self.needsDisplay = YES;
    [self didChangeValueForKey:@"visible"];
    
    if(fVisible){
        [self initializeLayer];
        
        CABasicAnimation* ani = [CABasicAnimation animationWithKeyPath:@"transform.rotation.y"];
        ani.duration = 0.5f;
        ani.autoreverses = NO;
        ani.fromValue = [NSNumber numberWithFloat: M_PI_2];
        ani.toValue = [NSNumber numberWithFloat:0.0f];
        ani.repeatCount = 1;
        [self.layer addAnimation: ani forKey:@"myRotation"];
    }
}

-(bool)visible
{
    return fVisible;
}

-(CATransform3D) defaultTransform
{
    CATransform3D transform = CATransform3DIdentity;
    transform.m34 = 1.0 / -2000;
    return transform;
}

-(void)drawRect:(NSRect)dirtyRect
{
    if(!self.visible){
        return;
    }
    
    NSGraphicsContext* gc = [NSGraphicsContext currentContext];
        
    NSEnumerator* iter = [fCells objectEnumerator];
    SHSudokuCellItem* each = nil;
    while(each = [iter nextObject])
    {
        [gc saveGraphicsState];
        SHCellRenderingOptions options;
        options.selected = self.selection == each;
        options.highlighted = self.hotItem == each;
        
        [each drawItemWithOptions: options];
        [gc restoreGraphicsState];
    }
}

-(void)viewWillDraw
{
    [self layoutItems];
}

-(void) layoutItems
{
    NSRect bounds = self.bounds;
    bounds.size.width -= fMargin * 2;
    bounds.size.height -= fMargin * 2;
    bounds.origin.x += fMargin;
    bounds.origin.y += fMargin;
    
    if(bounds.size.width > bounds.size.height){
        int delta = bounds.size.width - bounds.size.height;
        bounds.origin.x += delta / 2;
        bounds.size.width = bounds.size.height;
    }
    else{
        int delta = bounds.size.height - bounds.size.width;
        bounds.origin.y += delta / 2;
        bounds.size.height = bounds.size.width;
    }
    
    CGFloat boxWidth = (bounds.size.width - fCellSpacing * 8.0 - fAreaSpacing * 2) / 9.0;
    CGFloat boxHeight = (bounds.size.height - fCellSpacing * 8.0 - fAreaSpacing * 2) / 9.0;
    
    for(int i=0; i<81; i++)
    {
        int row = i / 9;
        int col = i % 9;
        
        NSRect eachBounds = NSMakeRect(col * boxWidth + bounds.origin.x , row * boxHeight + bounds.origin.y, boxWidth, boxHeight);

        eachBounds.origin.y += fCellSpacing * row + (row / 3) * fAreaSpacing;
        eachBounds.origin.x += fCellSpacing * col + (col / 3) * fAreaSpacing;
        
        SHSudokuCellItem* eachItem = [fCells objectAtIndex: i];
        eachItem.bounds = eachBounds;
    }
}

#pragma mark - Service APIs:

/**
 * 주어진 지점에 포함된 셀 아이템을 얻습니다.
 */
-(SHSudokuCellItem*) cellItemWithPoint:(NSPoint) point
{
    NSEnumerator* iter = [fCells objectEnumerator];
    SHSudokuCellItem* each = nil;
    
    while(each = [iter nextObject])
    {
        bool isContained = each.bounds.origin.x <= point.x && point.x <= each.bounds.origin.x + each.bounds.size.width && each.bounds.origin.y <= point.y && point.y <= each.bounds.origin.y + each.bounds.size.height;
        
        if(isContained)
        {
            return each;
        }
    }
    
    return nil;
}

-(void) handleModelChanged: (NSNotification*) notification
{
    NSLog(@"모델 수정됨");
}


#pragma mark - 모델 액세스
-(void)assignModelToCellItems
{
    for(int i=0; i<81; i++){
        SHSudokuCellItem* cellItem = [fCells objectAtIndex: i];
        SHSudokuCell* cellModel = nil;
        if(fGame != nil){
            cellModel = [fGame.cells objectAtIndex: i];
        }
        cellItem.model = cellModel;
    }
    self.needsDisplay = YES;
}

-(void)initializeLayer
{
    self.layer.transform = [self defaultTransform];
    self.layer.anchorPoint = NSMakePoint(0.5, 0.5);
    self.layer.position = CGPointMake(self.bounds.origin.x + self.bounds.size.width / 2.0 , self.bounds.origin.y + self.bounds.size.height / 2.0);
}

-(void)setGame:(SHGame *)game
{
    
    if(fGame == game)
    {
        return;
    }
    
    [self willChangeValueForKey:@"game"];
    fGame = game;
    [self assignModelToCellItems];
    [self didChangeValueForKey:@"game"];
    
    self.visible = YES;
    
}


-(SHGame*) game
{
    return fGame;
}


@end
