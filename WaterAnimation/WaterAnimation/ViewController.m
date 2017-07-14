//
//  ViewController.m
//  WaterAnimation
//
//  Created by tang on 17/4/21.
//  Copyright © 2017年 tang. All rights reserved.
//

#import "ViewController.h"

static CGFloat maxPeak = 1;
static CGFloat originInset = 5;
@interface ViewController ()

@property (weak, nonatomic) IBOutlet UIImageView *backImgView;
@property (weak, nonatomic) IBOutlet UIImageView *cosImgView;
@property (weak, nonatomic) IBOutlet UIImageView *sinImgView;
@property (nonatomic, strong) CADisplayLink *displayLink;
@property (nonatomic, strong) CAShapeLayer *sinLayer;
@property (nonatomic, strong) CAShapeLayer *cosLayer;
@property (nonatomic, assign) CGFloat offset;
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    CGFloat width = CGRectGetWidth(self.backImgView.frame);
    CGFloat height = CGRectGetHeight(self.backImgView.frame);
    
    CAShapeLayer *sinLayer = [CAShapeLayer layer];
    sinLayer.frame = CGRectMake(0, height - originInset, width, height);
    self.sinImgView.layer.mask = sinLayer;
    self.sinLayer = sinLayer;
    
    CAShapeLayer *cosLayer = [CAShapeLayer layer];
    cosLayer.frame = CGRectMake(0, height - originInset, width, height);
    self.cosImgView.layer.mask = cosLayer;
    self.cosLayer = cosLayer;
    
    CADisplayLink *displayLink = [CADisplayLink displayLinkWithTarget:self selector:@selector(animate)];
    [displayLink addToRunLoop:[NSRunLoop currentRunLoop] forMode:NSRunLoopCommonModes];
    self.displayLink = displayLink;

}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)begin:(id)sender {
    
    [self addVerticalAnimationForLayer:self.sinLayer];
    
    [self addVerticalAnimationForLayer:self.cosLayer];
    
    // frame.origin.x = position.x - anchorPoint.x * bounds.size.width；
    // frame.origin.y = position.y - anchorPoint.y * bounds.size.height；
}

- (void)addVerticalAnimationForLayer:(CALayer *)layer {
    CGFloat height = CGRectGetHeight(self.backImgView.frame);
    CABasicAnimation *sinBasicAnimation = [CABasicAnimation animation];
    CGPoint position = layer.position;
    sinBasicAnimation.fromValue = [NSValue valueWithCGPoint:position];
    position.y = layer.anchorPoint.y * height;
    sinBasicAnimation.toValue = [NSValue valueWithCGPoint:position];
    sinBasicAnimation.duration = 5.0;
    sinBasicAnimation.keyPath = @"position";
    sinBasicAnimation.removedOnCompletion = false;
    sinBasicAnimation.fillMode = kCAFillModeForwards;
    [layer addAnimation:sinBasicAnimation forKey:@"xxx"];
}

- (void)animate {
    self.offset += 10;
    
    self.sinLayer.path = [self pathForRect:self.sinLayer.frame isSin:true].CGPath;
    self.cosLayer.path = [self pathForRect:self.cosLayer.frame isSin:false].CGPath;
}

- (UIBezierPath *)pathForRect:(CGRect)rect isSin:(BOOL)sin {
    CGFloat width = CGRectGetWidth(rect);
    CGFloat height = CGRectGetHeight(rect);
    UIBezierPath *path = [UIBezierPath bezierPath];
    CGFloat currX = 0;
    for (NSInteger i = 0; i < width; i++) {
        currX = i;
        CGFloat y = 0;
        if (sin) {
            y = sinf(i * M_PI * 2 / width + self.offset * ( M_PI / 180)) * maxPeak + maxPeak;
        } else {
            y = cosf(i * M_PI * 2 / width + self.offset * ( M_PI / 180)) * maxPeak + maxPeak;
        }
        if (i == 0) {
            [path moveToPoint:CGPointMake(i, y)];
            continue;
        }
        [path addLineToPoint:CGPointMake(i, y)];
    }
    
    [path addLineToPoint:CGPointMake(currX, height)];
    [path addLineToPoint:CGPointMake(0, height)];
    return path;
}
@end
