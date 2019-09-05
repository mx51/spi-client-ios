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

- (void)testSetPosId_OnInvalidLength_IsSet {
    // arrange
    static NSString *posId = @"12345678901234567";
    SPIClient *client = [[SPIClient alloc] init];
    
    // act
    client.posId = posId;
    
    // assert
    XCTAssertFalse([client.posId isEqualToString:posId]);
}

- (void)testStart_OnInvalidLengthForPosId_IsSet {
    // arrange
    static NSString *posId = @"12345678901234567";
    static NSString *eftposAddress = @"10.20.30.40";
    static NSString *posVendorId = @"assembly";
    static NSString *posVersion = @"2.6.3";
    SPIClient *client = [[SPIClient alloc] init];
    client.posId = posId;
    client.eftposAddress = eftposAddress;
    client.posVendorId = posVendorId;
    client.posVersion = posVersion;
    
    // act
    [client start];

    
    // assert
    XCTAssertFalse([client.posId isEqualToString:posId]);
}

- (void)testSetPosId_OnValidCharacters_IsSet {
    // arrange
    static NSString *posId = @"RamenPos";
    SPIClient *client = [[SPIClient alloc] init];
    
    // act
    client.posId = posId;
    
    // assert
    XCTAssertTrue([client.posId isEqualToString:posId]);
}

- (void)testStart_OnValidCharactersForPosId_IsSet {
    // arrange
    static NSString *posId = @"RamenPos";
    static NSString *eftposAddress = @"10.20.30.40";
    static NSString *posVendorId = @"assembly";
    static NSString *posVersion = @"2.6.3";
    SPIClient *client = [[SPIClient alloc] init];
    client.posId = posId;
    client.eftposAddress = eftposAddress;
    client.posVendorId = posVendorId;
    client.posVersion = posVersion;
    
    // act
    [client start];
    
    // assert
    XCTAssertTrue([client.posId isEqualToString:posId]);
}

- (void)testSetPosId_OnInvalidCharacters_IsSet {
    // arrange
    static NSString *posId = @"RamenPos@";
    SPIClient *client = [[SPIClient alloc] init];
    
    // act
    client.posId = posId;
    
    // assert
    XCTAssertFalse([client.posId isEqualToString:posId]);
}

- (void)testStart_OnInvalidCharactersForPosId_IsSet {
    // arrange
    static NSString *posId = @"RamenPos@";
    static NSString *eftposAddress = @"10.20.30.40";
    static NSString *posVendorId = @"assembly";
    static NSString *posVersion = @"2.6.3";
    SPIClient *client = [[SPIClient alloc] init];
    client.posId = posId;
    client.eftposAddress = eftposAddress;
    client.posVendorId = posVendorId;
    client.posVersion = posVersion;
    
    // act
    [client start];
    
    // assert
    XCTAssertFalse([client.posId isEqualToString:posId]);
}

- (void)testSetEftposAddress_OnValidCharacters_IsSet {
    // arrange
    static NSString *eftposAddress = @"10.20.30.40";
    SPIClient *client = [[SPIClient alloc] init];
    
    // act
    client.eftposAddress = eftposAddress;
    NSString *clientEftposAddress = [client.eftposAddress stringByReplacingOccurrencesOfString:@"ws://" withString:@""];
    
    // assert
    XCTAssertTrue([clientEftposAddress isEqualToString:eftposAddress]);
}

- (void)testStart_OnValidCharactersForEftposAddress_IsSet {
    // arrange
    static NSString *posId = @"RamenPos";
    static NSString *eftposAddress = @"10.20.30.40";
    static NSString *posVendorId = @"assembly";
    static NSString *posVersion = @"2.6.3";
    SPIClient *client = [[SPIClient alloc] init];
    client.posId = posId;
    client.eftposAddress = eftposAddress;
    client.posVendorId = posVendorId;
    client.posVersion = posVersion;
    
    // act
    [client start];
    NSString *clientEftposAddress = [client.eftposAddress stringByReplacingOccurrencesOfString:@"ws://" withString:@""];
    
    // assert
    XCTAssertTrue([clientEftposAddress isEqualToString:eftposAddress]);
}

- (void)testEftposAddress_OnInvalidCharacters_IsSet {
    // arrange
    static NSString *eftposAddress = @"10.20.30";
    SPIClient *client = [[SPIClient alloc] init];
    
    // act
    client.eftposAddress = eftposAddress;
    NSString *clientEftposAddress = [client.eftposAddress stringByReplacingOccurrencesOfString:@"ws://" withString:@""];
    
    // assert
    XCTAssertFalse([clientEftposAddress isEqualToString:eftposAddress]);
}

- (void)testStart_OnInvalidCharactersForEftposAddress_IsSet {
    // arrange
    static NSString *posId = @"RamenPos";
    static NSString *eftposAddress = @"10.20.30";
    static NSString *posVendorId = @"assembly";
    static NSString *posVersion = @"2.6.3";
    SPIClient *client = [[SPIClient alloc] init];
    client.posId = posId;
    client.eftposAddress = eftposAddress;
    client.posVendorId = posVendorId;
    client.posVersion = posVersion;
    
    // act
    [client start];
    NSString *clientEftposAddress = [client.eftposAddress stringByReplacingOccurrencesOfString:@"ws://" withString:@""];
    
    // assert
    XCTAssertFalse([clientEftposAddress isEqualToString:eftposAddress]);
}

- (void)testUnpair_OnValid_IsSet {
    //Initiate Client and set status
    SPIClient *client = [[SPIClient alloc] init];
    [client setSecretEncKey:@"1" hmacKey:@"2"];
    client.state.status = SPIStatusPairedConnected;
    
    //Perform unpair
    [client unpair];
    
    //Wait & check
    XCTestExpectation *expectation = [[XCTestExpectation alloc] initWithDescription:@"test expectation"];
    (void)[XCTWaiter waitForExpectations:@[ expectation ] timeout:1];
    
    XCTAssertEqual(client.state.status, SPIStatusUnpaired);
}

@end
