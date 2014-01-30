//
//  Created by Francesco Mattia on 21/01/2014.
//  Copyright (c) 2014 Francesco Mattia. All rights reserved.
//

#import "DraggableView.h"

@interface DraggableView ()  {
    CGPoint offset;
    CGPoint touch;
    CGPoint originalCenter;
    
    float   verticalDisplacement;
    float   horizontalDisplacement;
}

@end

@implementation DraggableView

#define kBorder 4.0f
#define screenHeight [UIScreen mainScreen].bounds.size.height
#define screenWidth  [UIScreen mainScreen].bounds.size.width

- (id)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame])
    {
        [self setUp];
    }
    return self;
}

- (void)setFrame:(CGRect)frame
{
    [super setFrame:frame];
    originalCenter = self.center;
    self.imageView.frame = CGRectMake(kBorder, kBorder, self.frame.size.width-kBorder*2, self.frame.size.height-kBorder*2);
}

//// FIXME observe if changes also the center
//
//- (void)setCenter:(CGPoint)center
//{
//    [super setCenter:center];
//    originalCenter = self.center;
//}

- (void)setUp
{
    self.displacementThreshold = 80.0f;
    self.allowedDirections = DirectionNone;
    self.shadowEffect = YES;
    
    originalCenter = self.center;
    self.backgroundColor = [UIColor whiteColor];
    self.imageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"firstImage.jpg"]];
    self.imageView.frame = CGRectMake(kBorder, kBorder, self.frame.size.width-kBorder*2, self.frame.size.height-kBorder*2);
    self.imageView.contentMode = UIViewContentModeScaleAspectFill;
    self.imageView.clipsToBounds = YES;
    self.layer.shadowOffset = CGSizeMake(0, 0);
    self.layer.shadowOpacity = 0.8f;
    self.layer.shadowRadius = 0;
    self.layer.shadowColor = [[UIColor blackColor] CGColor];
    self.layer.masksToBounds = NO;
    self.layer.shouldRasterize = YES;
    self.layer.rasterizationScale = [UIScreen mainScreen].scale;
    [self addSubview:self.imageView];
}

- (void)awakeFromNib
{
    [self setUp];
}

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    UITouch *aTouch = [touches anyObject];
    offset = [aTouch locationInView:self];
    touch = [aTouch locationInView:self.superview];
    
    //bring me to top
    [self.superview bringSubviewToFront:self];
}


- (void)touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event {
    UITouch *aTouch = [touches anyObject];
    CGPoint location = [aTouch locationInView:self.superview];
    
    CGPoint temp = CGPointMake(location.x - offset.x + self.frame.size.width/2.0, location.y - offset.y + self.frame.size.height/2.0);
    
    verticalDisplacement = location.y - touch.y;
    horizontalDisplacement = location.x - touch.x;
    
    if (self.shadowEffect) self.layer.shadowRadius = MIN(fabs(verticalDisplacement/2.0f),7.0f);
    self.center = temp;
    
    float xoff = MAX(MIN(((self.center.x-screenWidth/2.0)/30.0f),1),-1);
    float rotation = (xoff*verticalDisplacement/10.0f)/(screenWidth/2.0) * (M_PI/5);
    [self setTransform:CGAffineTransformMakeRotation(rotation)];
}

- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event
{
    void (^animationBlock)(CGPoint newCenter, DirectionsOptions direction) = ^(CGPoint newCenter, DirectionsOptions direction) {
        [UIView beginAnimations:nil context:nil];
        self.center = newCenter;
        if (self.shadowEffect) self.layer.shadowRadius = (direction == DirectionNone?0:7.0f);
        if (direction == DirectionNone) self.transform = CGAffineTransformIdentity;
        [UIView commitAnimations];
        if ([self.delegate respondsToSelector:@selector(draggableView:didSwipeToDirection:)])
            [self.delegate draggableView:self didSwipeToDirection:direction];
    };
    
    if (verticalDisplacement < -self.displacementThreshold && self.allowedDirections & DirectionUp)
    {
        CGPoint newPoint = CGPointMake((self.center.x>screenWidth/2.0?1:-1)*50.0f+self.center.x, -200.0f);
        animationBlock(newPoint, DirectionUp);
    }
    else if (verticalDisplacement > self.displacementThreshold && self.allowedDirections & DirectionDown)
    {
        CGPoint newPoint = CGPointMake((self.center.x>screenWidth/2.0?1:-1)*50.0f+self.center.x, screenHeight+200.0f);
        animationBlock(newPoint, DirectionDown);
    }
    else if (horizontalDisplacement < -self.displacementThreshold && self.allowedDirections & DirectionLeft)
    {
        CGPoint newPoint = CGPointMake(-200.0f, (self.center.y>screenHeight/2.0?1:-1)*50.0f+self.center.y);
        animationBlock(newPoint, DirectionLeft);
    }
    else if (horizontalDisplacement > self.displacementThreshold && self.allowedDirections & DirectionRight)
    {
        CGPoint newPoint = CGPointMake(screenWidth+200.0f, (self.center.y>screenHeight/2.0?1:-1)*50.0f+self.center.y);
        animationBlock(newPoint, DirectionRight);
    }
    else
    {
        animationBlock(originalCenter, DirectionNone);
    }
}

@end
