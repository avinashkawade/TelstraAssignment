//
//  ConnectionHandler.m
//  TelstraAssignment
//
//  Created by Avinash on 1/25/17.
//  Copyright © 2017 Telstra. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ConnectionHandler.h"
#import "AFNetworking.h"
#import "TableData.h"

@implementation ConnectionHandler


- (void)initConnection
{
    
    NSURLSessionConfiguration *configuration = [NSURLSessionConfiguration defaultSessionConfiguration];
    AFURLSessionManager *manager = [[AFURLSessionManager alloc] initWithSessionConfiguration:configuration];
//
    NSURL *URL = [NSURL URLWithString:@"https://dl.dropboxusercontent.com/u/746330/facts.json"];

    NSURLRequest *request = [NSURLRequest requestWithURL:URL];
//

    NSURLSessionDownloadTask *downloadTask = [manager downloadTaskWithRequest:request progress:nil destination:^NSURL *(NSURL *targetPath, NSURLResponse *response) {
        NSURL *documentsDirectoryURL = [[NSFileManager defaultManager] URLForDirectory:NSDocumentDirectory inDomain:NSUserDomainMask appropriateForURL:nil create:NO error:nil];
        return [documentsDirectoryURL URLByAppendingPathComponent:[response suggestedFilename]];
    } completionHandler:^(NSURLResponse *response, NSURL *filePath, NSError *error) {
        NSLog(@"File downloaded to: %@", filePath);
        NSData *tData = [NSData dataWithContentsOfURL:filePath];
        NSString *string = [[NSString alloc] initWithData:tData encoding:NSASCIIStringEncoding];
        NSData* mainData = [string dataUsingEncoding:NSUTF8StringEncoding];
        NSDictionary *jsonData = [NSJSONSerialization JSONObjectWithData:mainData options:NSJSONReadingAllowFragments error:nil];
        NSArray *dataArray = [jsonData valueForKey:@"rows"];
        NSString *title = [jsonData valueForKey:@"title"];
        NSMutableArray *detailDataArray = [self getfilteredDataArray:dataArray];

        NSLog(@"File Data : %@", detailDataArray);
        [self.delegate handleResponseData:detailDataArray:title];

    }];
    [downloadTask resume];
}

-(NSMutableArray *)getfilteredDataArray:(NSArray *)dataArray
{
    NSMutableArray *detailDataArray = [[NSMutableArray alloc]init];
    for(NSDictionary *tempDict in dataArray)
    {
        TableData *infoObj = [[TableData alloc]init];
        if(!(([tempDict objectForKey:@"title"] == [NSNull null]) && ([tempDict objectForKey:@"description"] == [NSNull null]) && ([tempDict objectForKey:@"imageHref"] == [NSNull null])))
        {
            [infoObj setTitle:[tempDict objectForKey:@"title"]];
            [infoObj setDescriptionDetail:[tempDict objectForKey:@"description"]];
            [infoObj setImgUrl:[tempDict objectForKey:@"imageHref"]];
            
            [detailDataArray addObject:infoObj];
        }
    }
    return detailDataArray;
}

@end
