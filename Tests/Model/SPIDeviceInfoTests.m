//
//  SPIDeviceInfoTests.m
//  Tests
//
//  Created by Doniyorjon Zuparov on 22/07/21.
//  Copyright © 2021 mx51. All rights reserved.
//

#import <XCTest/XCTest.h>
#import "SPIDeviceInfo.h"
@interface SPIDeviceInfoTests : XCTestCase

@end

@implementation SPIDeviceInfoTests

- (void)testGetAppDeviceInfo {
    UIDevice *device = UIDevice.currentDevice;
    NSDictionary *bundleInfo = [NSBundle bundleForClass: [[SPIDeviceInfo new] class] ].infoDictionary;
    
    NSDictionary *testInfo = [SPIDeviceInfo getAppDeviceInfo];
    
    NSString *deviceSystem = [NSString stringWithFormat:@"%@ %@", device.systemName, device.systemVersion];
    
    XCTAssertEqual([testInfo objectForKey:@"device_name"], [device name]);
    XCTAssertEqual([testInfo objectForKey:@"device_system"], deviceSystem);
    XCTAssertEqual([testInfo objectForKey:@"app_display_name"], [bundleInfo objectForKey:@"CFBundleName"]);
    XCTAssertEqual([testInfo objectForKey:@"app_bundle_id"], [bundleInfo objectForKey:@"CFBundleIdentifier"]);
    XCTAssertEqual([testInfo objectForKey:@"app_version"], [bundleInfo objectForKey:@"CFBundleShortVersionString"]);
    XCTAssertEqual([testInfo objectForKey:@"app_build"], [bundleInfo objectForKey:@"CFBundleVersion"]);
}

@end

