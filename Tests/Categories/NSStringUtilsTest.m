//
//  NSStringUtilsTest.m
//  SPIClient-iOSTests
//
//  Created by Yoo-Jin Lee on 2017-12-03.
//  Copyright © 2017 mx51. All rights reserved.
//

#import <XCTest/XCTest.h>
#import "NSString+Crypto.h"
#import "NSData+Crypto.h"

@interface NSStringCryptoTest : XCTestCase

@end

@implementation NSStringCryptoTest

- (void)testHex {
    NSString *str = @"802AEA1D8A1D3586A1D9DA82C246E9633F0A902F2C427E2B489E5D1BE8246D7F58EC77ED1B288E3B40025A845EF280327604EFBF87905A";
    NSData *data = [str dataFromHexEncoding];
    NSString *result = [data convertToHexString];
    XCTAssertEqualObjects(result, str);
}

@end
