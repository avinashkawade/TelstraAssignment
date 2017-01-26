//
//  CustomCell.m
//  TelstraAssignment
//
//  Created by Avinash on 1/25/17.
//  Copyright © 2017 Telstra. All rights reserved.
//

#import "CustomCell.h"
#import "Constant.h"
@implementation CustomCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
        [self setSelectionStyle:UITableViewCellSelectionStyleNone];
        
        self.title = [UILabel new];
        [self.title setNumberOfLines:0];
        [self.title setTextColor:[UIColor blackColor]];
        [self.title setBackgroundColor:[UIColor clearColor]];
        [self.title setFont:kTitleFont];
        [self.title setTranslatesAutoresizingMaskIntoConstraints:NO];
        self.title.frame = CGRectMake(10, 10, self.contentView.frame.size.width, 15);
        [self.contentView addSubview:self.title];
        
        
        self.descriptionLabel = [UILabel new];
        [self.descriptionLabel setNumberOfLines:0];
        [self.descriptionLabel setTextColor:[UIColor blackColor]];
        [self.descriptionLabel setBackgroundColor:[UIColor clearColor]];
        [self.descriptionLabel setFont:kDescriptionFont];
        [self.descriptionLabel setTranslatesAutoresizingMaskIntoConstraints:NO];
        self.descriptionLabel.frame = CGRectMake(10, 30, self.contentView.frame.size.width-65, 90);

        [self.contentView addSubview:self.descriptionLabel];
        
        self.imgThumbnail = [[UIImageView alloc] init];
        self.imgThumbnail.backgroundColor = [UIColor darkGrayColor];
        self.imgThumbnail.translatesAutoresizingMaskIntoConstraints = NO;
        self.imgThumbnail.frame = CGRectMake(self.contentView.frame.size.width - 10, 30, 50, 50);

        [self.contentView addSubview:self.imgThumbnail];
        
        self.loadingIndicator = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhiteLarge];
        [self.imgThumbnail addSubview:self.loadingIndicator];
        [self.contentView layoutSubviews];
        
    }
    return self;
}



@end
