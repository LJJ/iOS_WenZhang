//
//  ArticleTableViewCell.m
//  WenZhang
//
//  Created by LJJ on 11/30/14.
//  Copyright (c) 2014 LJJ. All rights reserved.
//

#import "ArticleTableViewCell.h"
@interface ArticleTableViewCell()
@property (weak, nonatomic) IBOutlet UILabel *articleTitleLabel;
@property (weak, nonatomic) IBOutlet UILabel *contentLabel;
@property (weak, nonatomic) IBOutlet UILabel *timeLabel;
@end


@implementation ArticleTableViewCell

- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)setArticleCellWithTitle:(NSString *)title articleContent:(NSString *)articleContent time:(NSString *)time
{
    _articleTitleLabel.text = title;
    _contentLabel.text = articleContent;
    _timeLabel.text = time;
}

@end
