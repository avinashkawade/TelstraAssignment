//
//  TableData.m
//  TelstraAssignment
//
//  Created by Avinash on 1/25/17.
//  Copyright © 2017 Telstra. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "TableData.h"

@implementation TableData

@synthesize title;
@synthesize descriptionData;
@synthesize imgUrl;

-(id) init
{
    title=@"";
    descriptionData=@"";
    imgUrl = @"";
    return self;
}

@end
