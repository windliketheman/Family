#import "AppNetworkMonitoring.h"

static AppNetworkMonitoring* s_instance = nil;

@interface AppNetworkMonitoring()

@property(nonatomic, retain) Reachability* curReachability;

@end

@implementation AppNetworkMonitoring

#pragma mark - networkIPAddrChanged

- (void)postNetworkIPAddrChanged
{
    if([NSThread isMainThread])
    {
        [[NSNotificationCenter defaultCenter] postNotificationName:kNotifyNetworkIPAddrChanged object:self];
    }
    else
    {
        [self performSelectorOnMainThread:@selector(postNetworkIPAddrChanged) withObject:nil waitUntilDone:NO];
    }
}

#pragma mark - networkStatusChanged

- (void)inMainThreadWithPreNStatus:(NetworkStatus)nstatus
{
    if([NSThread isMainThread])
    {
        [self laterPostNetworkStatusChangedWithPreNStatus:[NSNumber numberWithInt:nstatus]];
    }
    else
    {
        [self performSelectorOnMainThread:@selector(laterPostNetworkStatusChangedWithPreNStatus:) withObject:
         [NSNumber numberWithInt:nstatus] waitUntilDone:NO];
    }
}

- (void)laterPostNetworkStatusChangedWithPreNStatus:(NSNumber *)nstatus
{
    [self performSelector:@selector(postNetworkStatusChangedWithPreNStatus:)
               withObject:nstatus
               afterDelay:2.];
}

- (void)postNetworkStatusChangedWithPreNStatus:(NSNumber *)nstatus
{
    if ([nstatus intValue] != _networkStatus)
    {
        [[NSNotificationCenter defaultCenter] postNotificationName:kNotifyNetworkStatusChanged object:self];
    }
}

- (void)postNetworkStatusChanged
{
    if ([NSThread isMainThread])
    {
        [[NSNotificationCenter defaultCenter] postNotificationName:kNotifyNetworkStatusChanged object:self];
    }
    else
    {
        [self performSelectorOnMainThread:@selector(postNetworkStatusChanged) withObject:nil waitUntilDone:NO];
    }
}

#pragma mark - timer

- (void)networkMonitoringTimer:(NSTimer *)timer
{
    [self releaseCurReachability];
    
    self.curReachability = [Reachability reachabilityWithHostname:@"www.baidu.com"];
        
    if (!_curReachability || NotReachable == [_curReachability currentReachabilityStatus])
        self.curReachability = [Reachability reachabilityWithHostname:@"www.qq.com"];
    
    if (_curReachability)
    {
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(reachabilityChanged:) name:kReachabilityChangedNotification object:_curReachability];
        [_curReachability startNotifier];
    }
    else
    {
        if (_networkStatus != NotReachable)
        {
            NetworkStatus preStatus = _networkStatus;
            _networkStatus = NotReachable;
            self.curReachability = nil;
            [self inMainThreadWithPreNStatus:preStatus];
        }
    }
}


#pragma mark - curReachability

- (void)reachabilityChanged:(NSNotification *)notify
{
    static BOOL isFirstChanged = YES;
    
    Reachability *reachab = (Reachability*)[notify object];
    NetworkStatus netStatus = [reachab currentReachabilityStatus];
    
    if (isFirstChanged)
    {
        isFirstChanged = NO;
        _networkStatus = netStatus;
        [self postNetworkStatusChanged];
    }
    else if (_networkStatus != netStatus)
    {
        NetworkStatus preStatus = _networkStatus;
        _networkStatus = netStatus;
        [self inMainThreadWithPreNStatus:preStatus];
    }
    
    dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
    dispatch_async(queue, ^{
        
        NSString *ipaddr = [AppNetworkMonitoring getWifiOr3G_IPAddress];
        if(![_curIPAddress isEqualToString:ipaddr])
        {
            _curIPAddress = ipaddr;
            [self postNetworkIPAddrChanged];
        }
    });
}

#pragma mark - IP
+ (NSString *)getWifiOr3G_IPAddress
{
    struct ifaddrs *interfaces = NULL;
    struct ifaddrs *temp_addr = NULL;
    NSString *wifiAddress = nil;
    NSString *cellAddress = nil;
    
    // retrieve the current interfaces - returns 0 on success
    if(!getifaddrs(&interfaces))
    {
        // Loop through linked list of interfaces
        temp_addr = interfaces;
        while(temp_addr != NULL)
        {
            sa_family_t sa_type = temp_addr->ifa_addr->sa_family;
            
            if(sa_type == AF_INET || sa_type == AF_INET6)
            {
                NSString *name = [NSString stringWithUTF8String:temp_addr->ifa_name];
                NSString *addr = [NSString stringWithUTF8String:inet_ntoa(((struct sockaddr_in *)temp_addr->ifa_addr)->sin_addr)]; // pdp_ip0
                // NSLog(@"NAME: \"%@\" addr: %@", name, addr); // see for yourself
                
                if([name isEqualToString:@"en0"])
                {
                    // Interface is the wifi connection on the iPhone
                    if(NO==[addr isEqualToString:@"0.0.0.0"])
                        wifiAddress = addr;
                }
                else if([name isEqualToString:@"pdp_ip0"])
                {
                    // Interface is the cell connection on the iPhone
                    if(NO==[addr isEqualToString:@"0.0.0.0"])
                        cellAddress = addr;
                }
            }
            temp_addr = temp_addr->ifa_next;
        }
        // Free memory
        freeifaddrs(interfaces);
    }
    NSString *addr = wifiAddress ? wifiAddress : cellAddress;
    
    return addr ? addr : @"0.0.0.0";
}


- (void)releaseCurReachability
{
    if (_curReachability)
    {
        [_curReachability stopNotifier];
        [[NSNotificationCenter defaultCenter] removeObserver:self name:kReachabilityChangedNotification object:_curReachability];
        self.curReachability = nil;
    }
}

#pragma mark - init

- (id)init
{
    self = [super init];
    {
        Reachability *reachability =  [Reachability reachabilityForInternetConnection];
        _networkStatus = [reachability currentReachabilityStatus];
    }
    
    return self;
}

#pragma mark - timer

+ (NSThread *)threadForNetworkMonitoring
{
    static NSThread* s_thread;
    
    if (!s_thread)
    {
        @synchronized(self)
        {
            if (!s_thread)
            {
                s_thread = [[NSThread alloc] initWithTarget:self selector:@selector(runNetworkMonitoring) object:nil];
                [s_thread start];
            }
        }
    }
    return s_thread;
}


+ (void)runNetworkMonitoring
{
    CFRunLoopSourceContext context = {0, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL};
    
    // 和模式相关的源才会被监视并允许他们传递事件消息，源有 输入源 定时源
    CFRunLoopSourceRef source = CFRunLoopSourceCreate(kCFAllocatorDefault, 0, &context);
    
    NSTimer *timer = [NSTimer scheduledTimerWithTimeInterval:30.0 target:s_instance
                                                    selector:@selector(networkMonitoringTimer:)
                                                    userInfo:nil repeats:YES];
    
    CFRunLoopAddSource(CFRunLoopGetCurrent(), source, kCFRunLoopDefaultMode);
    
    // 输入源和runloop模式关联
    CFRunLoopAddTimer(CFRunLoopGetCurrent(), (__bridge CFRunLoopTimerRef)timer, kCFRunLoopDefaultMode);
    
    [timer fire];
    
    BOOL runAlways = YES;
    while (runAlways)
    {
        @autoreleasepool
        {
            CFRunLoopRunInMode(kCFRunLoopDefaultMode, 1.0e10, true);
        }
    }
    
    [timer invalidate];
    CFRunLoopRemoveTimer(CFRunLoopGetCurrent(), (__bridge CFRunLoopTimerRef)timer, kCFRunLoopDefaultMode);
    CFRunLoopRemoveSource(CFRunLoopGetCurrent(), source, kCFRunLoopDefaultMode);
    CFRelease(source);
}


#pragma mark - singleInstance

+ (AppNetworkMonitoring *)shareInstance
{
    if (!s_instance)
    {
        @synchronized(self)
        {
            if (!s_instance)
            {
                s_instance = [[super allocWithZone:nil] init];
                [self threadForNetworkMonitoring];
            }
        }
    }
    
    return s_instance;
}

+ (id)allocWithZone:(NSZone *)zone
{
    if ([AppNetworkMonitoring class] == self)
        return [self shareInstance];
    
    return [super allocWithZone:zone];
}

@end
