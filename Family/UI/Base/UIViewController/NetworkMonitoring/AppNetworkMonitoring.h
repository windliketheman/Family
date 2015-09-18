#import <Foundation/Foundation.h>
#import "Reachability.h"

#define kNotifyNetworkStatusChanged  @"_notifyNetworkStatusChanged_"
#define kNotifyNetworkIPAddrChanged  @"_notifyNetworkIPAddrChanged_"

@interface AppNetworkMonitoring : NSObject

@property (nonatomic, readonly, assign) NetworkStatus networkStatus;
@property (nonatomic, readonly, strong) NSString     *curIPAddress;

+ (AppNetworkMonitoring *)shareInstance;

@end
