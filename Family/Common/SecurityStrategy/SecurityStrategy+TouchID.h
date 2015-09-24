//
//  SecurityStrategy+TouchID.h
//  FileBox
//
//  Created by jia on 15/9/14.
//  Copyright (c) 2015年 OrangeTeam. All rights reserved.
//

#import "SecurityStrategy.h"

@interface SecurityStrategy (TouchID)

#pragma mark - Touch ID
+ (BOOL)isTouchIDAvailable;

+ (void)authenticateTouchID:(NSString *)reason
                     succes:(void (^)(void))succesBlock
                    failure:(void (^)(void))failureBlock
                   canceled:(void (^)(void))canceledBlock;

@end
