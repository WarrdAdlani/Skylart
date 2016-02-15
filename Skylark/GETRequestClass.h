//
//  GETRequestClass.m
//  SkylarkApp
//
//  Created by Warrd Adlani on 15/02/2016.
//  Copyright © 2016 Warrd Adlani. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef void(^SuccessBlock)(id json, NSError *error);

@interface GETRequestClass : NSObject <NSURLSessionDelegate, NSURLSessionDataDelegate, NSURLSessionTaskDelegate>

// Properties
@property (strong, nonatomic) id delegate;

@property (strong, nonatomic) SuccessBlock successBlock;

// Methods/Functions
-(instancetype)init;
-(void)getDataWithEndPoint:(NSString *)paramEndPoint withCompletionBlock:(SuccessBlock)successBlock;
-(void)cancelConnection;

@end
