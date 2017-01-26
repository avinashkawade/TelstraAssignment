//
//  CustomCell.m
//  TelstraAssignment
//
//  Created by Avinash on 1/25/17.
//  Copyright © 2017 Telstra. All rights reserved.
//

#import "CustomCell.h"
#import "Constant.h"
#import "Masonry.h"

@implementation CustomCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

/*-----------------------------------------------------------------------------------------
 // Function:- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
 // Description: Setup Initial Custom Cell Labels and ImageView
 //-----------------------------------------------------------------------------------------
 */
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
        [self.contentView addSubview:self.title];
        
        
        self.descriptionLabel = [UILabel new];
        [self.descriptionLabel setNumberOfLines:0];
        [self.descriptionLabel setTextColor:[UIColor blackColor]];
        [self.descriptionLabel setBackgroundColor:[UIColor clearColor]];
        [self.descriptionLabel setFont:kDescriptionFont];
        [self.contentView addSubview:self.descriptionLabel];
        
        
        self.imgThumbnail = [[UIImageView alloc] init];
        self.imgThumbnail.backgroundColor = [UIColor lightGrayColor];
        [self.contentView addSubview:self.imgThumbnail];
        
        
        self.loadingIndicator = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhiteLarge];
        [self.imgThumbnail addSubview:self.loadingIndicator];
        [self.contentView layoutSubviews];
    }
    return self;
}


@end
