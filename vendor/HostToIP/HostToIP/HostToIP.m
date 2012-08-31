//
//  HostToIP.m
//  HostToIP
//
//  Created by Keyvan Fatehi on 8/31/12.
//  Copyright (c) 2012 Keyvan Fatehi. All rights reserved.
//

#import "HostToIP.h"

#include <sys/types.h>
#include <sys/socket.h>
#include <netdb.h>
#include <arpa/inet.h>

@implementation HostToIP
+(NSString *) IPAddress:(NSString *)host {
    struct hostent * hostentry;
    
    if (!host)
        return @"";
    
    hostentry = gethostbyname([host UTF8String]);
    
    struct in_addr **list = (struct in_addr **)hostentry->h_addr_list;
    NSString *addressString = [NSString stringWithCString: (char *) inet_ntoa(*list[0]) encoding:NSUTF8StringEncoding];
    return addressString;
}
@end
