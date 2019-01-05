//
//  SortMenuControl.m
//  SortMenu
//
//  Created by Pulkit Rohilla on 28/09/16.
//  Copyright © 2016 PulkitRohilla. All rights reserved.
//

#import "SortMenuControl.h"

@implementation SortMenuControl{
    
    UIColor *fColor, *bColor;
    
    UILabel *lblTitle;
    UIButton *prevButton;

    UIView *shapeView, *backgroundView, *menuView;
    
    BOOL isActive;

    NSArray *arrayMenuOptions;
    
    int optionIndex;
}

NSString *const iconFilter = @"";
NSString *const iconDown = @"";
CGFloat const animationDuration = 0.3f;

-(void)awakeFromNib{

    [self setupInitialUI];

    [super awakeFromNib];
}

- (CGSize)intrinsicContentSize
{
    CGSize size = CGSizeMake(50, 50);
    return size ;
}

-(void)prepareForInterfaceBuilder{

    [self setupInitialUI];
}

-(void)setBackColor:(UIColor *)backColor{
    
    bColor = backColor;
}

-(void)setForeColor:(UIColor *)foreColor{
    
    fColor = foreColor;
}

-(void)setHighlighted:(BOOL)highlighted{
    
    if (highlighted) {
        
        lblTitle.alpha = 0.5f;
    }
    else
    {
        lblTitle.alpha = 1.0f;
    }
    
    [super setHighlighted:highlighted];
}

-(void)endTrackingWithTouch:(UITouch *)touch withEvent:(UIEvent *)event{
    
    CGPoint location = [touch locationInView:self];
    if (CGRectContainsPoint(self.bounds, location)) {
        
        if (isActive) {
            
            [self deactivateControl];
        }
        else
        {
            [self activateControl];

        }
    }
    
}

-(void)updateConstraints{

    [super updateConstraints];
    
    NSDictionary *viewsDictionary = NSDictionaryOfVariableBindings(lblTitle);
    
    
    NSArray *arrayHConstraints = [NSLayoutConstraint constraintsWithVisualFormat:@"H:|-0-[lblTitle]-0-|"
                                                                         options:NSLayoutFormatAlignAllCenterY
                                                                         metrics:nil
                                                                           views:viewsDictionary];
    NSArray *arrayVConstraints = [NSLayoutConstraint constraintsWithVisualFormat:@"V:|-0-[lblTitle]-0-|"
                                                                         options:NSLayoutFormatAlignAllCenterX
                                                                         metrics:nil
                                                                           views:viewsDictionary];
    
    
    NSDictionary *shapeViewsDictionary = NSDictionaryOfVariableBindings(shapeView);
    
    NSArray *arrayShapeHConstraints = [NSLayoutConstraint constraintsWithVisualFormat:@"H:|-0-[shapeView]-0-|"
                                                                              options:NSLayoutFormatAlignAllCenterY
                                                                              metrics:nil
                                                                                views:shapeViewsDictionary];
    NSArray *arrayShapeVConstraints = [NSLayoutConstraint constraintsWithVisualFormat:@"V:|-0-[shapeView]-0-|"
                                                                              options:NSLayoutFormatAlignAllCenterX
                                                                              metrics:nil
                                                                                views:shapeViewsDictionary];
    
    [self addConstraints:arrayHConstraints];
    [self addConstraints:arrayVConstraints];
    
    [self addConstraints:arrayShapeHConstraints];
    [self addConstraints:arrayShapeVConstraints];

}

#pragma mark - UIButton

- (void)actionOptionClick:(UIButton *)sender {
    
    _selectedIndex = sender.tag;
    
    [self sendActionsForControlEvents:UIControlEventValueChanged];

    [self deactivateControl];    
}

#pragma mark - Other Methods

-(void)setupInitialUI{
    
    shapeView = [self returnShapeView];
    
    lblTitle = [self returnTitleLabel];
    
    [self addSubview:shapeView];

    [self addSubview:lblTitle];
}

-(void)activateControl{
    
    if (!isActive) {
        
        isActive = YES;
        
        CABasicAnimation *rotationAnimation = [CABasicAnimation animationWithKeyPath:@"transform.rotation"];
        rotationAnimation.fromValue = [NSNumber numberWithFloat:-M_PI];
        rotationAnimation.toValue = [NSNumber numberWithFloat:0];
        [rotationAnimation setDuration:animationDuration];
        rotationAnimation.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseOut];

        // Add animation to the view's layer
        [[lblTitle layer] addAnimation:rotationAnimation forKey:@"rotationAnimation"];
        lblTitle.text = iconDown;
        
        NSDictionary *dictEdit = @{@"title": @"ID",
                                   @"icon":@"ID"};
        
        NSDictionary *dictRedirect = @{@"title": @"Date",
                                       @"icon":@""};
        
        NSDictionary *dictAuthor = @{@"title": @"Author",
                                       @"icon":@""};
        
        arrayMenuOptions = @[dictEdit, dictRedirect, dictAuthor];
        
        [self showMenu];
    }
}

-(void)deactivateControl{
    
    if (isActive) {
        
        isActive = NO;
        
        [self hideMenu];
        
        CABasicAnimation *rotationAnimation =  [CABasicAnimation animationWithKeyPath:@"transform.rotation"];
        rotationAnimation.fromValue = [NSNumber numberWithFloat:M_PI];
        rotationAnimation.toValue = [NSNumber numberWithFloat:0];
        [rotationAnimation setDuration:0.3f];
        rotationAnimation.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseOut];
        
        // Add animation to the view's layer
        [[lblTitle layer] addAnimation:rotationAnimation forKey:@"rotationAnimation"];
        lblTitle.text = iconFilter;
    }

}

-(UIView *)returnShapeView{
    
    UIView *view = [UIView new];
    [view setTranslatesAutoresizingMaskIntoConstraints:NO];
    [view setUserInteractionEnabled:NO];
    
    CGRect rect = CGRectMake(0, 0, 50, 50);
    
    int radius = rect.size.width/2;
    
    CGPoint center = CGPointMake(CGRectGetMidX(rect), CGRectGetMidY(rect) );
    CGPoint pathCenter = CGPointMake(CGRectGetMidX(rect) - radius, CGRectGetMidY(rect) - radius);
    
    CAShapeLayer *backLayer = [CAShapeLayer layer];
    backLayer.bounds = rect;
    backLayer.position = center;
    
    CAShapeLayer *shape = [CAShapeLayer layer];
    UIBezierPath *path = [UIBezierPath bezierPathWithRoundedRect:CGRectMake(0, 0, 2.0*radius, 2.0*radius)
                                                    cornerRadius:radius];
    shape.path = path.CGPath;
    shape.position = pathCenter;
    shape.fillColor = bColor.CGColor;
    
    [shape setShadowOffset:CGSizeMake(1, 1)];
    [shape setShadowOpacity:0.25];
    [shape setShadowRadius:3];
    
    [view.layer addSublayer:shape];
    [view.layer addSublayer:backLayer];

    return view;
}

-(UILabel *)returnTitleLabel{
    
    UILabel *lbl = [UILabel new];
    [lbl setTranslatesAutoresizingMaskIntoConstraints:NO];
    [lbl setText:iconFilter];
    [lbl setTextColor:fColor];
    [lbl setTextAlignment:NSTextAlignmentCenter];
    [lbl setFont:[UIFont fontWithName:@"fontAwesome" size:22.0f]];
    
    return lbl;
}

-(void)showMenu{
    
    backgroundView = [[UIView alloc] initWithFrame:self.superview.frame];
    backgroundView.alpha = 1;
    backgroundView.backgroundColor = [[UIColor lightGrayColor] colorWithAlphaComponent:0.8];
    
    [backgroundView setAutoresizingMask:UIViewAutoresizingFlexibleWidth|UIViewAutoresizingFlexibleHeight];

    UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(deactivateControl)];
    [backgroundView addGestureRecognizer:tapGesture];
    
    [UIView beginAnimations:@"MoveIn" context:nil];
    self.alpha = 1.0;
    [UIView commitAnimations];
    
    [self.superview insertSubview:backgroundView belowSubview:self];
    
    menuView = [UIView new];
    menuView.backgroundColor = [UIColor clearColor];
    [menuView setTranslatesAutoresizingMaskIntoConstraints:NO];

    [self.superview insertSubview:menuView aboveSubview:backgroundView];
  
    [self.superview addConstraint:[NSLayoutConstraint constraintWithItem:menuView
                                                     attribute:NSLayoutAttributeCenterX
                                                     relatedBy:NSLayoutRelationEqual
                                                        toItem:self
                                                     attribute:NSLayoutAttributeCenterX
                                                    multiplier:1.f constant:0.0f]];
    
    [self.superview addConstraint:[NSLayoutConstraint constraintWithItem:menuView
                                                               attribute:NSLayoutAttributeBottom
                                                               relatedBy:NSLayoutRelationEqual
                                                                  toItem:self
                                                               attribute:NSLayoutAttributeBottom
                                                              multiplier:1.f constant:0.0f]];
    
    optionIndex = 0;
    prevButton = nil;
    
    [NSTimer scheduledTimerWithTimeInterval:0.005f target:self selector:@selector(insertOptions:) userInfo:nil repeats:YES];
}

-(void)hideMenu{

    [backgroundView removeFromSuperview];
    [menuView removeFromSuperview];
}

-(void)insertOptions:(NSTimer*)timer{

    NSDictionary *dictAction = [arrayMenuOptions objectAtIndex:optionIndex];
    
    //        NSString *title = [dictAction objectForKey:@"title"];
    NSString *icon = [dictAction objectForKey:@"icon"] ;
    
    UIButton *btnOption = [UIButton buttonWithType:UIButtonTypeSystem];
    [btnOption setTranslatesAutoresizingMaskIntoConstraints:NO];
    [btnOption setTag:optionIndex];
    [btnOption.titleLabel setFont:[UIFont fontWithName:@"fontAwesome" size:22.0f]];
    [btnOption.layer setCornerRadius:shapeView.frame.size.width/2];
    [btnOption setBackgroundColor:bColor];
    [btnOption setTitle:icon forState:UIControlStateNormal];
    [btnOption setTitleColor:fColor forState:UIControlStateNormal];
    [btnOption.layer setShadowOffset:CGSizeMake(1, 1)];
    [btnOption.layer setShadowOpacity:0.25];
    [btnOption.layer setShadowRadius:3];
    
    [btnOption addTarget:self action:@selector(actionOptionClick:) forControlEvents:UIControlEventTouchUpInside];
    
    [menuView addSubview:btnOption];
    
    NSLayoutConstraint* width = [NSLayoutConstraint constraintWithItem:btnOption attribute:NSLayoutAttributeWidth relatedBy:NSLayoutRelationEqual toItem:nil attribute:NSLayoutAttributeNotAnAttribute multiplier:1.0 constant:shapeView.frame.size.width];
    NSLayoutConstraint* height = [NSLayoutConstraint constraintWithItem:btnOption attribute:NSLayoutAttributeHeight relatedBy:NSLayoutRelationEqual toItem:nil attribute:NSLayoutAttributeNotAnAttribute multiplier:1.0 constant:shapeView.frame.size.height];
    
    [btnOption addConstraints:@[width,height]];
    
    NSDictionary *viewsDictionary;
    
    if (prevButton) {
        
        viewsDictionary = NSDictionaryOfVariableBindings(prevButton, btnOption);
    }
    else
    {
        viewsDictionary = NSDictionaryOfVariableBindings(btnOption);
        
    }
    
    NSNumber *bottomMargin = [NSNumber numberWithFloat:shapeView.frame.size.height + 10];
    NSNumber *verticalSpacing = [NSNumber numberWithInt:10];
    
    NSDictionary *btnMetrics = @{@"bottomMargin":bottomMargin,
                                 @"verticalSpacing":verticalSpacing  };
    
    
    NSArray *btnHConstraints = [NSLayoutConstraint constraintsWithVisualFormat:@"H:|-10-[btnOption]-10-|"
                                                                       options:0
                                                                       metrics:nil
                                                                         views:viewsDictionary];
    
    NSArray *btnVConstraints;
    
    if (optionIndex == 0) {
        
        btnVConstraints = [NSLayoutConstraint constraintsWithVisualFormat:@"V:[btnOption]-bottomMargin-|"
                                                                  options:NSLayoutFormatAlignAllCenterX
                                                                  metrics:btnMetrics
                                                                    views:viewsDictionary];
        
    }
    else if(optionIndex == arrayMenuOptions.count - 1)
    {
        btnVConstraints = [NSLayoutConstraint constraintsWithVisualFormat:@"V:|-verticalSpacing-[btnOption]-verticalSpacing-[prevButton]"
                                                                  options:NSLayoutFormatAlignAllCenterX
                                                                  metrics:btnMetrics
                                                                    views:viewsDictionary];
    }
    else
    {
        btnVConstraints = [NSLayoutConstraint constraintsWithVisualFormat:@"V:[btnOption]-verticalSpacing-[prevButton]"
                                                                  options:NSLayoutFormatAlignAllCenterX
                                                                  metrics:btnMetrics
                                                                    views:viewsDictionary];
    }

    
    
    [menuView addConstraints:btnHConstraints];

    [menuView addConstraints:btnVConstraints];
    
    prevButton = btnOption;
    
    CATransition *animation = [CATransition animation];
    [animation setDuration:animationDuration];
    [animation setType:kCATransitionMoveIn];
    [animation setSubtype:kCATransitionFromTop];
    [animation setTimingFunction:[CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseOut]];
    
    [[btnOption layer] addAnimation:animation forKey:@"addOption"];

    if(optionIndex < [arrayMenuOptions count])
    {
        if(optionIndex == arrayMenuOptions.count - 1)
        {
            [timer invalidate];
        }
        else
        {
            optionIndex++;
        }
    }
}

@end
