//
//  AppDelegate.h
//  TelstraAssignment
//
//  Created by Avinash on 1/24/17.
//  Copyright © 2017 Telstra. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "LazyLoadTableView.h"

@interface AppDelegate : UIResponder <UIApplicationDelegate>

@property (strong, nonatomic) UIWindow *window;
@property (retain, nonatomic) LazyLoadTableView *lazyLoadTableViewController;


@end

