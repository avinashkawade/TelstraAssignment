//
//  CustomCell.h
//  TelstraAssignment
//
//  Created by Avinash on 1/25/17.
//  Copyright © 2017 Telstra. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CustomCell : UITableViewCell
{
    
}
@property(nonatomic, retain) UILabel *title;
@property(nonatomic, retain) UILabel *descriptionLabel;
@property(nonatomic, retain) UIImageView *imgThumbnail;
@property(nonatomic, retain) UIView *separatorLineView;
@property(nonatomic, strong) NSString *imgThumbnailUrlString;
@property(nonatomic, strong) UIActivityIndicatorView *loadingIndicator;

-(void)downloadThumbnailImage:(NSString *)urlString;

@end
