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
    NSLog(@"File Data : %@", listData);

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
        [self.view addSubview:lazyTableView];
        
    
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
    UITableViewCell *cell;
    cell = (UITableViewCell *)[tableView dequeueReusableCellWithIdentifier:CellIdentifier];
   
    if(cell == nil){
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
        TableData *dataObj = (TableData*) [self.dataListArray objectAtIndex:indexPath.row];
        cell.textLabel.text = dataObj.title;
    }
    return cell;
}

@end
