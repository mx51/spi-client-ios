//
//  SPIClientTests.m
//  Tests
//
//  Created by Amir Kamali on 18/6/18.
//  Copyright © 2018 Assembly Payments. All rights reserved.
//

#import <XCTest/XCTest.h>
#import "SPIClient.h"

@interface SPIClientTests : XCTestCase

@end

@implementation SPIClientTests


- (void)test_Client_can_set_posId {
    NSString *posId = @"test";
    SPIClient *client = [[SPIClient alloc] init];
    [client setPosId:posId];
    XCTAssertTrue([client.posId isEqualToString:posId]);
}

- (void)test_Client_can_set_posAddress {
    NSString *posAddress = @"test";
    SPIClient *client = [[SPIClient alloc] init];
    [client setEftposAddress:posAddress];
    NSString *generatedAddress =
    [NSString stringWithFormat:@"ws://%@", posAddress];
    XCTAssertTrue([client.eftposAddress isEqualToString:generatedAddress]);
}

- (void)testDoUnpair {
    //Initiate Client and set status
    SPIClient *client = [[SPIClient alloc] init];
    [client setSecretEncKey:@"1" hmacKey:@"2"];
    client.state.status = SPIStatusPairedConnected;
    
    //Perform unpair
    [client unpair];
    
    //Wait & check
    XCTestExpectation *expectation =
    [[XCTestExpectation alloc] initWithDescription:@"test expectation"];
    (void)[XCTWaiter waitForExpectations:@[ expectation ] timeout:1];
    XCTAssertEqual(client.state.status, SPIStatusUnpaired);
}

@end
