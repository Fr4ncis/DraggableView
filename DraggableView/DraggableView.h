//
//  Created by Francesco Mattia on 21/01/2014.
//  Copyright (c) 2014 Francesco Mattia. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef NS_OPTIONS(NSUInteger, DirectionsOptions) {
    DirectionNone       = 0,
    DirectionUp         = 1,
    DirectionDown       = 2,
    DirectionUpDown     = 3,
    DirectionLeft       = 1 << 2,
    DirectionRight      = 2 << 2,
    DirectionLeftRight  = 3 << 2,
    DirectionAll        = 15
};

@interface DraggableView : UIView

@property (nonatomic, assign) DirectionsOptions allowedDirections;
@property (nonatomic, assign) BOOL shadowEffect;
@property (nonatomic, assign) float displacementThreshold;
@property (nonatomic, strong) UIImageView *imageView;

@end

@protocol DraggableViewDelegate <NSObject>

- (void)draggableView:(DraggableView*)draggableView didSwipeToDirection:(DirectionsOptions)direction;

@end

@interface DraggableView ()

@property (nonatomic, weak) id<DraggableViewDelegate> delegate;

@end
