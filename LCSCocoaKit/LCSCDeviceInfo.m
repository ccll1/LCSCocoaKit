//
//  LCSCDeviceInfo.m
//  LCSCocoaKit
//
//  Created by Christoph Lauterbach on 04.05.15.
//  Copyright (c) 2015 Christoph Lauterbach. All rights reserved.
//

#import "LCSCDeviceInfo.h"
#import <zlib.h>

@implementation LCSCDeviceInfo

+ (NSString*)deviceUUID
{
    static NSString *static_deviceUUID;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        io_service_t platformExpert = IOServiceGetMatchingService(kIOMasterPortDefault,IOServiceMatching("IOPlatformExpertDevice"));
        if (!platformExpert) {
            static_deviceUUID = @"undefined";
            return;
        }
        
        CFTypeRef serialNumberAsCFString = IORegistryEntryCreateCFProperty(platformExpert,CFSTR(kIOPlatformUUIDKey),kCFAllocatorDefault, 0);
        IOObjectRelease(platformExpert);
        if (!serialNumberAsCFString) {
            static_deviceUUID = @"undefined";
            return;
        }
        

        NSData *data = [((__bridge NSString *)serialNumberAsCFString) dataUsingEncoding:NSASCIIStringEncoding];
        unsigned long crc = crc32(0, Z_NULL, 0);
        int checksum = (int)crc32(crc, data.bytes, (unsigned int)data.length);

        static_deviceUUID = [NSString stringWithFormat:@"%d", checksum];
    });
    return static_deviceUUID;
}
@end
