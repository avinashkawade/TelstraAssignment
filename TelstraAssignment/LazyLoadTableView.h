//
//  LazyLoadTableView.h
//  TelstraAssignment
//
//  Created by Avinash on 1/24/17.
//  Copyright © 2017 Telstra. All rights reserved.
//

#ifndef LazyLoadTableView_h
#define LazyLoadTableView_h


#endif /* LazyLoadTableView_h */
#import <UIKit/UIKit.h>
#import "ConnectionHandler.h"

@interface LazyLoadTableView: UIViewController <UITableViewDelegate, UITableViewDataSource,ConnectionHandlerProtocol>
{
    UITableView *lazyTableView;

}
@end
