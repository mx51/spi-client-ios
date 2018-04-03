//
//  SPILoginTest.m
//  SPIClient-iOSTests
//
//  Created by Yoo-Jin Lee on 2017-11-27.
//  Copyright © 2017 Assembly Payments. All rights reserved.
//

#import <XCTest/XCTest.h>

#import "SPILogin.h"
#import "NSDate+Util.h"

@interface SPILoginTest : XCTestCase

@end

@implementation SPILoginTest

- (void)testExpiringSoon {
    NSDate    *expiresDate = [[NSDate date] dateByAddingTimeInterval:9 * 10];
    NSString  *expiresStr  = [expiresDate toString];
    SPIMessage *message    = [[SPIMessage alloc] initWithMessageId:@"lr" eventName:SPILoginResponseKey
                                                             data:@{@"expires_datetime":expiresStr,
                                                                    @"success":@YES} needsEncryption:YES];

    SPILoginResponse *loginResp = [[SPILoginResponse alloc] initWithMessage:message];

    XCTAssertTrue([loginResp expiringSoon:0]);
}

@end
