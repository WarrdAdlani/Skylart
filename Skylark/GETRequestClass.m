//
//  GETRequestClass.m
//  SkylarkApp
//
//  Created by Warrd Adlani on 15/02/2016.
//  Copyright © 2016 Warrd Adlani. All rights reserved.
//  Desc: This class will be used to get data from Skylark

#import "GETRequestClass.h"
#import <UIKit/UIKit.h>

@implementation GETRequestClass
{
    NSURLSessionDataTask * dataTask;
    NSHTTPURLResponse *httpResponse;
    NSMutableData *responseData;
}

- (instancetype)init
{
    self = [super init];
    if (self) {
        // do something
        responseData = [NSMutableData new];
    }
    return self;
}

-(void)getDataWithEndPoint:(NSString *)paramEndPoint withCompletionBlock:(SuccessBlock)successBlock
{
    
    self.successBlock = successBlock;
    [UIApplication sharedApplication].networkActivityIndicatorVisible = YES;
    
    NSURLSessionConfiguration *defaultConfigObject = [NSURLSessionConfiguration defaultSessionConfiguration];
    
    // Assuming this will all be done on the main queue
    NSURLSession *defaultSession = [NSURLSession sessionWithConfiguration: defaultConfigObject delegate: self delegateQueue: [NSOperationQueue mainQueue]];
    NSString *urlAsString = [NSString stringWithFormat:@"http://feature-code-test.skylark-cms.qa.aws.ostmodern.co.uk:8000/api/%@/", paramEndPoint];
    NSURL * url = [NSURL URLWithString:urlAsString];
    NSMutableURLRequest * urlRequest = [NSMutableURLRequest requestWithURL:url];
    [urlRequest setHTTPMethod:@"GET"];
    
    NSLog(@"Request: %@", urlRequest.allHTTPHeaderFields);
    
    dataTask = [defaultSession dataTaskWithRequest:urlRequest];
    
    [dataTask resume];
}

#pragma - NSURLSession delegates
-(void)URLSession:(NSURLSession *)session dataTask:(NSURLSessionDataTask *)dataTask didReceiveResponse:(NSURLResponse *)response completionHandler:(void (^)(NSURLSessionResponseDisposition))completionHandler
{
    httpResponse = (NSHTTPURLResponse*)response;
    NSLog(@"Reponse received: %@", httpResponse);
    completionHandler(NSURLSessionResponseAllow);
}

-(void)URLSession:(NSURLSession *)session dataTask:(NSURLSessionDataTask *)dataTask didReceiveData:(NSData *)data
{
    NSString *responseString = [[NSString alloc]initWithData:data encoding:NSUTF8StringEncoding];
    NSLog(@"Data received %@", responseString);
    [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
    [responseData appendData:data];
}

-(void)URLSession:(NSURLSession *)session task:(NSURLSessionTask *)task didCompleteWithError:(NSError *)error
{
    if (httpResponse.statusCode == 200)
    {
        if (responseData.length > 0)
        {
            NSError *error;
            id json = [NSJSONSerialization JSONObjectWithData:responseData options:0 error:nil];
            NSLog(@"Dictionary: %@", json);
            
            if (error) {
                NSLog(@"Error occured during parsring: %@", error.localizedDescription);
                self.successBlock(nil, error);
            }
            else
            {
                self.successBlock(json, nil);
            }
        }
        else
        {
            NSMutableDictionary *errorDetail = [NSMutableDictionary dictionary];
            [errorDetail setValue:@"A failure occured." forKey:NSLocalizedDescriptionKey];
            NSError *error = [NSError errorWithDomain:@"Skylark" code:100 userInfo:errorDetail];
            self.successBlock(nil, error);
        }
    }
   
    [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
}

-(void)URLSession:(NSURLSession *)session didBecomeInvalidWithError:(NSError *)error
{
    NSLog(@"Connection failed: %@", [error localizedDescription]);
    [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
}

-(void)cancelConnection
{
    [dataTask cancel];
    [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
}

@end
