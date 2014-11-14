//
//  HttpSyncCommunication.h
//  TxDOT
//
//  Created by Qian on 9/19/13.
//  Copyright (c) 2013 Qian. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface HttpSyncCommunication : NSObject{
    NSString* serverAddr;
    
}

@property (nonatomic,strong) NSString* serverAddr;

+(HttpSyncCommunication*) singleHttpSync;

-(NSDictionary*) sendHTTPRequest:(NSDictionary*) requestData;

@end
