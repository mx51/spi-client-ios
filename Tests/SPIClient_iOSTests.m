//
//  SPIClient_iOSTests.m
//  SPIClient-iOSTests
//
//  Created by Mike Gouline on 14/3/18.
//  Copyright © 2018 mx51. All rights reserved.
//

#import <XCTest/XCTest.h>
#import "SPIClient.h"

@interface SPIClient_iOSTests : XCTestCase

@end

@implementation SPIClient_iOSTests

- (void)setUp {
    [super setUp];
    // Put setup code here. This method is called before the invocation of each test method in the class.
}

- (void)tearDown {
    // Put teardown code here. This method is called after the invocation of each test method in the class.
    [super tearDown];
}

- (void)testGetVersion {
    NSString *version = [SPIClient getVersion];
    XCTAssertNotNil(version, "Version number not found");
    
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", @"^\\d+\\.\\d+\\.\\d+$"];
    XCTAssertTrue([predicate evaluateWithObject:version], @"Version number is not in a correct format");
}

- (void)testPerformanceExample {
    // This is an example of a performance test case.
    [self measureBlock:^{
        // Put the code you want to measure the time of here.
    }];
}

@end
