//
//  LoadMoreFooterView.m
//  HuiLife
//
//  Created by LJJ on 9/12/14.
//  Copyright (c) 2014 LJJ. All rights reserved.
//

#import "LoadMoreFooterView.h"
@interface LoadMoreFooterView()
@property (nonatomic, strong) UILabel *statusLabel;
@property (nonatomic, strong) UIActivityIndicatorView *indicatorView;
@property (nonatomic, strong) UIImageView *refreshImageView;
@end

@implementation LoadMoreFooterView

-(void)awakeFromNib {
    [self buildView];
}

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        [self buildView];
    }
    return self;
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/

-(void)buildView
{
    self.statusLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 25, 320, 20)];
    _statusLabel.backgroundColor = [UIColor clearColor];
    _statusLabel.font = [UIFont systemFontOfSize:12];
    _statusLabel.textAlignment = NSTextAlignmentCenter;
    _statusLabel.textColor = RGB(145, 145, 145);
    [self addSubview:_statusLabel];
    
    self.indicatorView = [[UIActivityIndicatorView alloc] initWithFrame:CGRectMake(80,25,20,20)];
    [_indicatorView setActivityIndicatorViewStyle:UIActivityIndicatorViewStyleGray];
    [self addSubview:_indicatorView];
    
    self.refreshImageView = [[UIImageView alloc] initWithFrame:CGRectMake(70, 22, 25, 25)];
    _refreshImageView.image = [UIImage imageNamed:@"refresh.png"];
    [self addSubview:_refreshImageView];
    _refreshImageView.hidden = YES;
    
    self.backgroundColor = [UIColor whiteColor];
    
    if (IsPad) {
        self.backgroundColor = HexColor(@"f4f0ed");
        _statusLabel.font = [UIFont systemFontOfSize:16];
        _statusLabel.textColor = [UIColor blackColor];
        _statusLabel.frame = CGRectMake(0, 25, 700, 30);
        _statusLabel.center = CGPointMake(self.frame.size.width/2, self.frame.size.height/2);
        _indicatorView.frame = CGRectMake(200, 25, 30, 30);
    }
}

- (void)footerViewStatusLoading
{
    [_indicatorView startAnimating];
    _statusLabel.text = @"正在加载";
    _refreshImageView.hidden = YES;
    self.gestureRecognizers = nil;
}

- (void)footerViewStatusLastPage
{
    [_indicatorView stopAnimating];
    _statusLabel.text = @"已加载所有数据";
    _refreshImageView.hidden = YES;
    self.gestureRecognizers = nil;
}

- (void)footerViewStatusNoData
{
    [_indicatorView stopAnimating];
    _statusLabel.text = @"没有数据";
    _refreshImageView.hidden = YES;
    self.gestureRecognizers = nil;
}

- (void)footerViewStatusFinishLoading
{
    [_indicatorView stopAnimating];
    _statusLabel.text = @"加载更多";
    _refreshImageView.hidden = YES;
    self.gestureRecognizers = nil;
}

- (void)footerViewShowStatus:(NSString *)title isLoading:(BOOL)isLoading
{
    _refreshImageView.hidden = YES;
    self.gestureRecognizers = nil;
    if (isLoading)
    {
        CGSize size = [title sizeWithAttributes:@{NSFontAttributeName:_statusLabel.font}];
        _indicatorView.center = CGPointMake(_statusLabel.center.x-size.width/2.0 - 20, _statusLabel.center.y);
        [_indicatorView startAnimating];
    }
    else [_indicatorView stopAnimating];
    
    _statusLabel.text = title;
}

- (void)resignFirstResponse
{
    [_indicatorView stopAnimating];
    _statusLabel.text = @"";
    _refreshImageView.hidden = YES;
    self.gestureRecognizers = nil;
}

- (void)footerViewShowStatus:(NSString *)title refreshMode:(BOOL)refresh addTarget:(id)target selector:(SEL)selector
{
    [_indicatorView stopAnimating];
    _refreshImageView.hidden = !refresh;
     _statusLabel.text = title;
    CGSize size = [title sizeWithAttributes:@{NSFontAttributeName:_statusLabel.font}];
    _refreshImageView.center = CGPointMake(_statusLabel.center.x-size.width/2.0 - 20, _statusLabel.center.y);
    UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:target action:selector];
    [self addGestureRecognizer:tapGesture];
}

@end
