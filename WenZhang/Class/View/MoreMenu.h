//
//  MoreMenu.h
//  WenZhang
//
//  Created by LJJ on 11/28/14.
//  Copyright (c) 2014 LJJ. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MoreMenu : UIView
@property (weak, nonatomic) IBOutlet UIButton *firstButton;
@property (weak, nonatomic) IBOutlet UIButton *secondButton;

+ (MoreMenu *)sharedMoreView;
+ (void)showFromPoint:(CGPoint)point inView:(UIView *)aView;
@end
