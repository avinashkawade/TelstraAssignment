//
//  LazyLoadTableView.m
//  TelstraAssignment
//
//  Created by Avinash on 1/24/17.
//  Copyright © 2017 Telstra. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "LazyLoadTableView.h"
#import "Constant.h"
#import "ConnectionHandler.h"
#import "TableData.h"
#import "CustomCell.h"
#import "Masonry.h"

@interface LazyLoadTableView ()
{
    UINavigationBar *navgationBar;
}
@property(nonatomic, strong)NSMutableArray *dataListArray;

@end

@implementation LazyLoadTableView

- (void)viewDidLoad {
    [super viewDidLoad];
    ConnectionHandler *_connectionObj = [[ConnectionHandler alloc] init];
    [_connectionObj initConnection];
    [_connectionObj setDelegate:self];
    [self setupScreen];
   
}

/*-----------------------------------------------------------------------------------------
 // Function:-(void)handleResponseData
 // Description: Handle the response after the initial service call
 //-----------------------------------------------------------------------------------------
 */
- (void)handleResponseData:(NSArray *)listData :(NSString *)title
{
    //NSLog(@"File Data : %@", listData);

    self.dataListArray = [NSMutableArray arrayWithArray:listData];
    [lazyTableView reloadData];

}
- (void)handleResponseForError:(NSError *)error
{

    UIAlertController * alert=   [UIAlertController
                                  alertControllerWithTitle:@"Error Occured"
                                  message:@"Failed to download due to something technical issue."
                                  preferredStyle:UIAlertControllerStyleAlert];
    
    UIAlertAction* okAction = [UIAlertAction
                         actionWithTitle:@"OK"
                         style:UIAlertActionStyleDefault
                         handler:^(UIAlertAction * action)
                         {
                             [alert dismissViewControllerAnimated:YES completion:nil];
                             
                         }];
    
    [alert addAction:okAction];
    
    [self presentViewController:alert animated:YES completion:nil];
    
}
/*-----------------------------------------------------------------------------------------
 // Function:-(void)setupScreen
 // Description: Setup Initial view of tableview and navigation bar 
 //-----------------------------------------------------------------------------------------
 */
-(void)setupScreen{

        navgationBar = [[UINavigationBar alloc]init];
        UINavigationItem *navItem = [UINavigationItem alloc];
        [navgationBar pushNavigationItem:navItem animated:false];
        [navgationBar setFrame:CGRectMake(navgationBar.frame.origin.x, navgationBar.frame.origin.y, self.view.frame.size.width, kNavigationBarHeight)];
        [self.view addSubview:navgationBar];
        
        lazyTableView = [[UITableView alloc] init];
        lazyTableView.delegate =self;
        lazyTableView.dataSource = self;
        [lazyTableView setSeparatorStyle:UITableViewCellSeparatorStyleNone];
        [lazyTableView setFrame:CGRectMake(lazyTableView.frame.origin.x, kNavigationBarHeight, self.view.frame.size.width, self.view.frame.size.height-kNavigationBarHeight)];

        [lazyTableView setBackgroundColor:[UIColor clearColor]];
        [lazyTableView setSeparatorStyle:UITableViewCellSeparatorStyleSingleLine];
        [self.view addSubview:lazyTableView];
        _imageCache=[[NSMutableDictionary alloc]init];
    
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [self.dataListArray count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    static NSString *CellIdentifier = @"Cell";
    CustomCell *cell;
    
    cell = (CustomCell *)[tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    
    if(cell == nil){
        cell = [[CustomCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
    }
        TableData *dataObj = (TableData*) [self.dataListArray objectAtIndex:indexPath.row];
        cell.title.text = dataObj.title;
        cell.descriptionLabel.text = dataObj.descriptionData;
        cell.imgThumbnail.image = [UIImage imageNamed:@"defaultImage"];
        //NSString* imageName = dataObj.imgUrl;
        //NSLog(@"url: %@", imageURL);
        [self updateLabelConstrains:cell];

        UIImage *image = [_imageCache objectForKey:[NSString stringWithFormat:@"%@",cell.title.text]];
        if(image){
            cell.imgThumbnail.image = image;

        }else{
            
        [self downloadThumbnailImage:cell : dataObj.imgUrl];
        }
    

    
    return cell;
}

/*-----------------------------------------------------------------------------------------
 // Function:-(void)downloadThumbnailImage
 // Description: Download the image thumbnail in background
 //-----------------------------------------------------------------------------------------
 */
-(void)downloadThumbnailImage:(CustomCell *)cell : (NSString *)urlString {
    
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_BACKGROUND, 0), ^{
        NSURL *tImageFileURL = [NSURL URLWithString:urlString];
        NSData  *tImageData = [NSData dataWithContentsOfURL:tImageFileURL];
        
        if(tImageData) {
            
            dispatch_async(dispatch_get_main_queue(), ^{
                if(cell)
                {
                    cell.imgThumbnail.image = [UIImage imageWithData:tImageData];

               }
            });
            [_imageCache setObject:[UIImage imageWithData:tImageData] forKey:cell.title.text];
            
        }
    });
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    
    TableData *dataObject = [self.dataListArray objectAtIndex:indexPath.row];

    return [self getHeightForCellRow:dataObject.descriptionData];
   }

/*-----------------------------------------------------------------------------------------
 // Function:-(void)getHeightForCellRow
 // Description: Calculate the height of table row 
 //-----------------------------------------------------------------------------------------
 */
-(CGFloat)getHeightForCellRow:(NSString *)descriptionTxt{
    
    CGSize constraint = CGSizeMake([UIScreen mainScreen].bounds.size.width - 70, CGFLOAT_MAX);
    CGSize size;
    NSString *description = [[NSString alloc]initWithFormat:@"%@",descriptionTxt];
    
    NSStringDrawingContext *context = [[NSStringDrawingContext alloc] init];
    CGSize boundingBox = [description boundingRectWithSize:constraint
                                                   options:NSStringDrawingUsesLineFragmentOrigin
                                                attributes:@{NSFontAttributeName:kDescriptionFont}
                                                   context:context].size;
    
    size = CGSizeMake((boundingBox.width), (boundingBox.height));
    if(size.height > kMaximumHeight)
        return size.height + kCellPadding;
    
    else
        return kDefaultCellHeight;

}


- (void)didRotateFromInterfaceOrientation:(UIInterfaceOrientation)fromInterfaceOrientation {
    //[self updateViewConstraints];
    UIInterfaceOrientation orientation = [[UIApplication sharedApplication] statusBarOrientation];

    if (UIInterfaceOrientationIsLandscape(orientation))
    {
        [lazyTableView setFrame:CGRectMake(lazyTableView.frame.origin.x, lazyTableView.frame.origin.y, self.view.frame.size.width, self.view.frame.size.height-50)];
    }
    else
    {
        [lazyTableView setFrame:CGRectMake(lazyTableView.frame.origin.x, lazyTableView.frame.origin.y, self.view.frame.size.width, self.view.frame.size.height-50)];
    }
}

/*-----------------------------------------------------------------------------------------
 // Function:-(void)updateViewConstraints
 // Description: update the constraints for Views
 //-----------------------------------------------------------------------------------------
 */
-(void)updateViewConstraints{

UIEdgeInsets padding = UIEdgeInsetsMake(0, 50, 0, 0);
   
    [lazyTableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.view.superview.mas_top).with.offset(padding.top); //with is an optional semantic filler
        make.left.equalTo(self.view.superview.mas_left).with.offset(padding.left);
        make.bottom.equalTo(self.view.superview.mas_bottom).with.offset(-padding.bottom);
        make.right.equalTo(self.view.superview.mas_right).with.offset(-padding.right);
    }];
}

/*-----------------------------------------------------------------------------------------
 // Function:-(void)updateLabelConstrains
 // Description: update the constraints for cell components
 //-----------------------------------------------------------------------------------------
 */
-(void)updateLabelConstrains:(CustomCell *)cell{
    
    UIEdgeInsets padding = UIEdgeInsetsMake(10, 10, 10, 10);
    
    [cell.title mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(cell.contentView.mas_top).with.offset(padding.top); //with is an optional semantic filler
        make.left.equalTo(cell.contentView.mas_left).with.offset(padding.left);
        make.height.mas_equalTo(20);
        //make.bottom.equalTo(self.contentView.mas_bottom).with.offset(self.contentView.frame.size.height-self.descriptionLabel.frame.size.height);
        //make.right.equalTo(self.contentView.mas_right).with.offset(-padding.right);
    }];
    
    [cell.imgThumbnail mas_makeConstraints:^(MASConstraintMaker *make) {
        //make.top.equalTo(self.title.mas_bottom).with.offset(padding.top); //with is an optional semantic filler
        //make.left.equalTo(self.contentView.mas_left).with.offset(padding.left);
        make.width.mas_equalTo(50);
        make.height.mas_equalTo(50);
        make.centerY.mas_equalTo(cell.contentView.mas_centerY);
        //make.bottom.equalTo(self.contentView.mas_bottom).with.offset(-padding.bottom);
        make.right.equalTo(cell.contentView.mas_right).with.offset(-padding.right);
    }];
    
    [cell.descriptionLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(cell.title.mas_bottom).with.offset(5); //with is an optional semantic filler
        make.left.equalTo(cell.contentView.mas_left).with.offset(padding.left);
        make.bottom.equalTo(cell.contentView.mas_bottom).with.offset(-padding.bottom);
        make.right.equalTo(cell.imgThumbnail.mas_left).with.offset(-5);
    }];
    
}


@end
