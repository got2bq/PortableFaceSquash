//
//  ViewController.m
//  PortableFaceSquash
//
//  Created by Brian Quach on 2017/02/21.
//  Copyright © 2017 Brian Quach. All rights reserved.
//

#import "ViewController.h"
#import "PFSSquasherView.h"
#import "PFSVertexHandle.h"

@interface ViewController () <PFSVertexHandleDelegate>

@property (weak, nonatomic) IBOutlet UIView *editView;
@property (weak, nonatomic) IBOutlet PFSSquasherView *squasherView;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setupVertexHandlesInView:self.editView];
}

- (void)setupVertexHandlesInView:(UIView *)view {
    NSArray<NSValue *> *initialPositions =
    @[[NSValue valueWithCGPoint:CGPointMake(0, view.frame.size.height - 10)],
      [NSValue valueWithCGPoint:CGPointMake(view.frame.size.width - 10, view.frame.size.height - 10)],
      [NSValue valueWithCGPoint:CGPointMake(view.frame.size.width - 10, 0)],
      [NSValue valueWithCGPoint:CGPointMake(0, 0)]
      ];
    
    [initialPositions enumerateObjectsUsingBlock:^(NSValue * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        CGPoint p = obj.CGPointValue;
        PFSVertexHandle *vertex = [[PFSVertexHandle alloc] initWithFrame:CGRectMake(p.x, p.y, 10, 10)];
        vertex.delegate = self;
        vertex.tag = idx;
        [view addSubview:vertex];
    }];
}

#pragma mark - PFSVertexHandleDelegate

- (void)vertexHandle:(PFSVertexHandle *)vertexHandle didPan:(UIPanGestureRecognizer *)gestureRecognizer {
    if (gestureRecognizer.state == UIGestureRecognizerStateChanged) {
        CGPoint translation = [gestureRecognizer translationInView:self.view];
        CGPoint center = vertexHandle.center;
        
        center.x += translation.x;
        center.y += translation.y;
        vertexHandle.center = center;
        [gestureRecognizer setTranslation:CGPointZero inView:self.view];
        
        UIView *superview = vertexHandle.superview;
        CGPoint normalizedPoint = CGPointMake(center.x / superview.frame.size.width,
                                              center.y / superview.frame.size.height);
        
        [self.squasherView updateHandle:vertexHandle.tag position:normalizedPoint];
        [self.squasherView render];
    }
}

@end
