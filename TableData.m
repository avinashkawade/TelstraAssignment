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
@synthesize descriptionDetail;
@synthesize imgUrl;

-(id) init
{
    title=@"";
    descriptionDetail=@"";
    imgUrl = @"";
    return self;
}

-(id) setData:(NSDictionary *)infoDict
{
    [self setTitle:[infoDict objectForKey:@"title"]];
    [self setDescriptionDetail:[infoDict objectForKey:@"description"]];
    [self setImgUrl:[infoDict objectForKey:@"imageHref"]];
    
    return self;
}
@end
