//
//  NSDateFormatterUtilTest.m
//  SPIClient-iOSTests
//
//  Created by Yoo-Jin Lee on 2018-01-14.
//  Copyright © 2018 Assembly Payments. All rights reserved.
//

#import <XCTest/XCTest.h>
#import "NSDateFormatter+Util.h"

@interface NSDateFormatterUtilTest : XCTestCase

@end

@implementation NSDateFormatterUtilTest

- (void)testDateNoTimeZoneFormatter {
    NSDate *tz1 = [[NSDateFormatter dateFormatter] dateFromString:@"2018-01-13T00:45:53.000"];
    NSDate *tz2 = [[NSDateFormatter dateNoTimeZoneFormatter] dateFromString:@"13012018004553"];
    XCTAssertEqualObjects(tz1, tz2);
}

@end