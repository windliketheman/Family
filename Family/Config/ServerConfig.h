//
//  ServerConfig.h
//  Family
//
//  Created by jia on 15/9/10.
//  Copyright (c) 2015年 jia. All rights reserved.
//

#ifndef Family_ServerConfig_h
#define Family_ServerConfig_h

#if DEBUG
#define ServerConfig @"api_dev"
// #define ServerConfig @"api"
#else
#define ServerConfig @"api"
#endif

#import "CommonData.h"
#define ServerURL [CommonData serverURL]

#define GetUserInfoInterface @"EnnewManager_V2/user/getUserByUid.action"

#endif
