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


- (void)handleResponseData:(NSArray *)listData :(NSString *)title
{
    //NSLog(@"File Data : %@", listData);

    self.dataListArray = [NSMutableArray arrayWithArray:listData];
    [lazyTableView reloadData];

}
- (void)onError:(NSError *)error{

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
        NSString* imageName = dataObj.imgUrl;
        //NSLog(@"url: %@", imageURL);
        
        UIImage *image = [_imageCache objectForKey:[NSString stringWithFormat:@"%@",cell.title.text]];
        if(image){
            cell.imgThumbnail.image = image;

        }else{
            
        [self downloadThumbnailImage:cell : dataObj.imgUrl];
        }
        NSLog(@"Description -- >%@",dataObj.descriptionData);
        NSLog(@"Image Url -- >%@",dataObj.imgUrl);

    
    return cell;
}

-(void)downloadThumbnailImage:(CustomCell *)cell : (NSString *)urlString {
    
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_BACKGROUND, 0), ^{
        //NSString *tStrThumbnails = [[NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES) objectAtIndex:0] stringByAppendingPathComponent:@"Thumbnails"];
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

-(CGFloat)getHeightForCellRow:(NSString *)descriptionTxt{
    
    CGSize constraint = CGSizeMake([UIScreen mainScreen].bounds.size.width - 70, CGFLOAT_MAX);
    CGSize size;
    NSString *description = [[NSString alloc]initWithFormat:@"%@",descriptionTxt];
    NSLog(@"Description Height-- >%@",description);
    
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

@end
