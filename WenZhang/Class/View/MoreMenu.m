//
//  MoreMenu.m
//  WenZhang
//
//  Created by LJJ on 11/28/14.
//  Copyright (c) 2014 LJJ. All rights reserved.
//

#import "MoreMenu.h"
@interface MoreMenu()
@property (weak, nonatomic) IBOutlet UIView *menuBackgroundView;
@property (nonatomic, strong) UIButton *canvasView;
@end

@implementation MoreMenu
static MoreMenu* instance ;
+ (MoreMenu *)sharedMoreView
{
    if (instance == nil) {
        static dispatch_once_t once;
        dispatch_once(&once, ^{
            NSArray *array = [[NSBundle mainBundle] loadNibNamed:@"MoreMenu" owner:self options:nil];
            instance = array[0];
        });
    }
    return instance;
}

- (void)awakeFromNib
{
    self.canvasView = [[UIButton alloc] init];
    [_canvasView addTarget:self action:@selector(removeFromSuperview) forControlEvents:UIControlEventTouchUpInside];
    _canvasView.backgroundColor = [UIColor clearColor];
    [_menuBackgroundView.layer setMasksToBounds:YES];
    [_menuBackgroundView.layer setCornerRadius:5];
    if ([[[NSUserDefaults standardUserDefaults] objectForKey:CONKeyIsLogin] boolValue]) {
        [_secondButton setTitle:@"注销" forState:UIControlStateNormal];
    }
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

#pragma mark - method
+ (void)showFromPoint:(CGPoint)point inView:(UIView *)aView
{
    if (!instance) {
        [MoreMenu sharedMoreView];
    }
    instance.canvasView.frame = aView.bounds;
    [aView addSubview:instance.canvasView];
    instance.frame = CGRectMake(point.x-107, point.y, instance.frame.size.width, instance.frame.size.height);
    [aView addSubview:instance];
}

- (void)removeFromSuperview
{
    [super removeFromSuperview];
    [_canvasView removeFromSuperview];
}

@end
