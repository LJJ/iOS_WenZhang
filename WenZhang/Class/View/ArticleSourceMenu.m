//
//  ArticleSourceMenu.m
//  WenZhang
//
//  Created by LJJ on 11/28/14.
//  Copyright (c) 2014 LJJ. All rights reserved.
//

#import "ArticleSourceMenu.h"
@interface ArticleSourceMenu()
@property (weak, nonatomic) IBOutlet UIView *menuBackgroundView;
@property (weak, nonatomic) IBOutlet UIButton *firstBT;
@property (weak, nonatomic) IBOutlet UIButton *secondBT;
@property (weak, nonatomic) IBOutlet UIButton *ThirdBT;
@end

@implementation ArticleSourceMenu
- (void)awakeFromNib
{
    [_menuBackgroundView.layer setMasksToBounds:YES];
    [_menuBackgroundView.layer setCornerRadius:5];
    for (id aView in _menuBackgroundView.subviews) {
        if ([aView isKindOfClass:[UIButton class]]) {
            UIButton *btn = (UIButton *)aView;
            [btn.layer setMasksToBounds:YES];
            [btn.layer setCornerRadius:3];
            [btn setBackgroundImage:[[UIImage imageNamed:@"button_red.png"] stretchableImageWithLeftCapWidth:10 topCapHeight:10] forState:UIControlStateSelected];
        }
    }
}
/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

- (void)showFromPoint:(CGPoint)point inView:(UIView *)aView
{
    self.frame = CGRectMake(point.x-self.frame.size.width/2, point.y, self.frame.size.width, self.frame.size.height);
    [aView addSubview:self];
}

- (void)selectButtonAtRow:(NSInteger)row
{
    [self p_turnOffAllButton];
    switch (row) {
        case 0:
            _firstBT.selected = YES;
            break;
        case 1:
            _secondBT.selected = YES;
            break;
        case 2:
            _ThirdBT.selected = YES;
            break;
            
        default:
            break;
    }
}

- (void)p_turnOffAllButton
{
    for (id aView in _menuBackgroundView.subviews) {
        if ([aView isKindOfClass:[UIButton class]]) {
            UIButton *btn = (UIButton *)aView;
            btn.selected = NO;
        }
    }
}

#pragma mark - action
- (IBAction)firstAction:(UIButton *)sender {
    [self p_turnOffAllButton];
    sender.selected = YES;
    if ([_delegate respondsToSelector:@selector(articleSourceMenuSelectSourceAtRow:)]) {
        [_delegate articleSourceMenuSelectSourceAtRow:0];
    }
    
}

- (IBAction)secondAction:(UIButton *)sender {
    [self p_turnOffAllButton];
    sender.selected = YES;
    if ([_delegate respondsToSelector:@selector(articleSourceMenuSelectSourceAtRow:)]) {
        [_delegate articleSourceMenuSelectSourceAtRow:0];
    }
}

- (IBAction)thirdAction:(UIButton *)sender {
    [self p_turnOffAllButton];
    sender.selected = YES;
    if ([_delegate respondsToSelector:@selector(articleSourceMenuSelectSourceAtRow:)]) {
        [_delegate articleSourceMenuSelectSourceAtRow:0];
    }
}

@end
