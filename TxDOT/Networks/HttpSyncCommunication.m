//
//  HttpSyncCommunication.m
//  TxDOT
//
//  Created by Qian on 9/19/13.
//  Copyright (c) 2013 Qian. All rights reserved.
//

#import "HttpSyncCommunication.h"
#import "SBJsonParser.h"

static HttpSyncCommunication* hsyncCommunication_Instance = nil;

@implementation NSString (NSString_Extended)

- (NSString *)urlencode {
    NSMutableString *output = [NSMutableString string];
    const unsigned char *source = (const unsigned char *)[self UTF8String];
    int sourceLen = (int)strlen((const char *)source);
    for (int i = 0; i < sourceLen; ++i) {
        const unsigned char thisChar = source[i];
        if (thisChar == ' '){
            [output appendString:@"+"];
        } else if (thisChar == '.' || thisChar == '-' || thisChar == '_' || thisChar == '~' ||
                   (thisChar >= 'a' && thisChar <= 'z') ||
                   (thisChar >= 'A' && thisChar <= 'Z') ||
                   (thisChar >= '0' && thisChar <= '9')) {
            [output appendFormat:@"%c", thisChar];
        } else {
            [output appendFormat:@"%%%02X", thisChar];
        }
    }
    return output;
}

@end

@implementation HttpSyncCommunication
@synthesize serverAddr;

+(HttpSyncCommunication*) singleHttpSync{

    //generate a singleton object for HTTP synchronous communications
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        if (hsyncCommunication_Instance == nil) {
            hsyncCommunication_Instance = [[HttpSyncCommunication alloc] init];
        }
        
    });
    
    return hsyncCommunication_Instance;
}

-(id) init{
    
    if (self = [super init]) {
        // init..
        serverAddr = @"address/file.php";
    }
    
    return self;
}


-(NSDictionary*) sendHTTPRequest:(NSDictionary*) requestData{
    if (requestData == nil) {
        NSLog(@"error request data is empty");
        return nil;
    }
    
    if ([requestData count] == 0 ) {
        NSLog(@"no data contained in requestData dictionary");
        
        return nil;
    }
    
    NSString* strParameters=[NSString stringWithFormat:@"%@?", serverAddr];
    for (NSString* key in requestData) {
        if([key rangeOfString:@"rowKey"].location == NSNotFound) {
            NSString* val = [requestData valueForKey:key];
            strParameters = [NSString stringWithFormat:@"%@%@=%@&",strParameters,key,[val urlencode]];
        }
    }
    
    // remove the last "&"
    if ( [strParameters length] > 0){
        
        strParameters = [strParameters substringToIndex:[strParameters length] - 1];

    }
        
    // OK, up to now strParatemers should contain a full HTTP string
    NSLog(@"%@", strParameters);
    

    
    NSString *submitString = [strParameters stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:submitString] cachePolicy:NSURLRequestReloadIgnoringLocalAndRemoteCacheData timeoutInterval:10];
    [request setHTTPMethod:@"GET"];
    [request addValue:@"text/xml; charset=utf-8" forHTTPHeaderField:@"Content-Type"];
    NSData* returnData = [NSURLConnection sendSynchronousRequest:request returningResponse:nil error:nil];
    NSString *responseString = [[NSString alloc]initWithData:returnData encoding:NSUTF8StringEncoding];
    NSLog(@"response: %@",responseString);
    if ([responseString isEqualToString:@"successful"]) {
        UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"Success" message:@"Your information was successfully submitted to the server" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
        [alert show];
    }
    else if(responseString==nil||[responseString isEqualToString:@""]) {
        NSLog(@"no internet connection");
        UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"Error" message:@"Please check your Internet connection" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
        [alert show];
    }
    else {
        NSLog(@"server error");
        UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"Error" message:@"Failed to connect to server. Please contact us at imkd.smartphoneHTS@gmail.com for help." delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
        [alert show];
    }
    return nil;
}

@end
