//
//  NSDataCryptoTests.m
//  SPIClient-iOSTests
//
//  Created by Yoo-Jin Lee on 2017-12-03.
//  Copyright © 2017 Assembly Payments. All rights reserved.
//

#import <XCTest/XCTest.h>
#import "NSData+Crypto.h"
#import "NSString+Crypto.h"

@interface NSDataCryptoTests : XCTestCase

@end

@implementation NSDataCryptoTests

- (void)testSHA256 {
    NSString *str = @"802AEA1D8A1D3586A1D9DA82C246E9633F0A902F2C427E2B489E5D1BE8246D7F58EC77ED1B288E3B40025A845EF280327604EFBF87905A";
    NSData *data = [[str dataFromHexEncoding] SHA256];
    XCTAssertEqualObjects([data hexString], @"459294DA65B1D19AD79F1DE634323DD0062A4E7E9948A0FE91A9FEB139C7003B");
}

- (void)testEncrypt {}

@end
