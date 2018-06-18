//
//  NSObjectDynamicDescription.m
//  Tests
//
//  Created by Amir Kamali on 17/6/18.
//  Copyright © 2018 Assembly Payments. All rights reserved.
//

#import <XCTest/XCTest.h>
#import "NSObject+Util.h"
#import "SPIPurchase.h"
#import "SPIPurchaseHelper.h"
@interface NSObjectDynamicDescription : XCTestCase

@end

@implementation NSObjectDynamicDescription


- (void)testDynamicDescription {
    SPISecrets *secrets = [[SPISecrets alloc] initWithEncKey:@"2" hmacKey:@"1"];
    NSString *dynamicDescription = [secrets dynamicDescription];
    XCTAssertTrue([dynamicDescription containsString:@"hmacKey"]);
    XCTAssertTrue([dynamicDescription containsString:@"encKey"]);
}


@end
