//
//  NSObjectDynamicDescription.m
//  Tests
//
//  Created by Amir Kamali on 17/6/18.
//  Copyright © 2018 mx51. All rights reserved.
//

#import <XCTest/XCTest.h>
#import "NSObject+Util.h"
#import "SPITransaction.h"
#import "SPIPurchaseHelper.h"
#import "NSString+Crypto.h"

@interface NSObjectDynamicDescription : XCTestCase

@end

@implementation NSObjectDynamicDescription

- (void)testDynamicDescription {
    SPISecrets *secrets = [[SPISecrets alloc] initWithEncKeyData:@"22".dataFromHexEncoding
                                                         hmacKey:@"11".dataFromHexEncoding];
    NSString *dynamicDescription = [secrets dynamicDescription];
    XCTAssertTrue([dynamicDescription containsString:@"hmacKey"]);
    XCTAssertTrue([dynamicDescription containsString:@"encKey"]);
}

@end
