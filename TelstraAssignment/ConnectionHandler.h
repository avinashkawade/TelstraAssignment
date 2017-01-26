//
//  ConnectionHandler.h
//  TelstraAssignment
//
//  Created by Avinash on 1/25/17.
//  Copyright © 2017 Telstra. All rights reserved.
//

#ifndef ConnectionHandler_h
#define ConnectionHandler_h


#endif /* ConnectionHandler_h */
/*-----------------------------------------------------------------------------------------
 // Description: Protocol Declaration for connection handler
 //-----------------------------------------------------------------------------------------
 */
@protocol ConnectionHandlerProtocol <NSObject>

- (void)handleResponseData:(NSArray *)listData :(NSString *)title;
- (void)handleResponseForError:(NSError *)error;

@end

@interface ConnectionHandler : NSObject

@property (nonatomic, weak) id delegate;
- (void)initConnection;


@end
