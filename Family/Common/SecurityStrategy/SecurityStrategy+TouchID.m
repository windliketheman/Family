//
//  SecurityStrategy+TouchID.m
//  FileBox
//
//  Created by jia on 15/9/14.
//  Copyright (c) 2015年 OrangeTeam. All rights reserved.
//

#import "SecurityStrategy+TouchID.h"
#import <LocalAuthentication/LocalAuthentication.h>
// #import <Security/Security.h>

#define kApplicationRetryLimitExceeded            -1
#define kCanceledByUser                           -2
#define kFallbackAuthenticationMechanismSelected  -3

@implementation SecurityStrategy (TouchID)

+ (BOOL)isTouchIDAvailable
{
    LAContext *lac = [[LAContext alloc] init];
    return [lac canEvaluatePolicy:LAPolicyDeviceOwnerAuthenticationWithBiometrics error:nil];
}

+ (void)authenticateTouchID:(NSString *)reason
                     succes:(void (^)(void))succesBlock
                    failure:(void (^)(void))failureBlock
                   canceled:(void (^)(void))canceledBlock
{
    LAContext *lac = [[LAContext alloc] init];
    [lac evaluatePolicy:LAPolicyDeviceOwnerAuthenticationWithBiometrics localizedReason:reason reply:^(BOOL succes, NSError *error)
     {
         if (succes)
         {
             if (succesBlock)
             {
                 succesBlock();
             }
         }
         else
         {
             // long long code = error.code;
             // NSString *str = [NSString stringWithFormat:@"%@",error.localizedDescription];
             if (kCanceledByUser == error.code ||
                 kFallbackAuthenticationMechanismSelected == error.code)
             {
                 if (canceledBlock)
                 {
                     canceledBlock();
                 }
             }
             else
             {
                 if (failureBlock)
                 {
                     failureBlock();
                 }
             }
         }
     }];
}

@end
