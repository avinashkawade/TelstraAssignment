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

@interface LazyLoadTableView ()
{
    UINavigationBar *navgationBar;
}
@property(nonatomic, strong)NSMutableArray *dataListArray;

@end

@implementation LazyLoadTableView

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setupScreen];
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
    return 15;//[_dataListArray count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    static NSString *CellIdentifier = @"Cell";
    UITableViewCell *cell;
    cell = (UITableViewCell *)[tableView dequeueReusableCellWithIdentifier:CellIdentifier];
   
    if(cell == nil){
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
    }
    return cell;
}

@end
