//
//  SPIClientTests.m
//  Tests
//
//  Created by Amir Kamali on 18/6/18.
//  Copyright © 2018 mx51. All rights reserved.
//

#import <XCTest/XCTest.h>
#import "SPIClient.h"
#import "SPITestUtils.h"

@interface SPIClientTests : XCTestCase

@end

@implementation SPIClientTests

- (void)testSetPosId_OnInvalidLength_IsSet {
    // arrange
    static NSString *posId = @"12345678901234567";
    SPIClient *client = [[SPIClient alloc] init];
    SPIDummyDelegate *delegate = [SPIDummyDelegate new];
    client.delegate = delegate;
    // act
    client.posId = posId;
    
    // assert
    XCTAssertFalse([client.posId isEqualToString:posId]);
}

- (void)testStart_OnInvalidLengthForPosId_IsSet {
    // arrange
    static NSString *posId = @"12345678901234567";
    static NSString *eftposAddress = @"10.20.30.40";
    static NSString *posVendorId = @"mx51";
    static NSString *posVersion = @"2.6.6";
    SPIClient *client = [[SPIClient alloc] init];
    client.posId = posId;
    client.eftposAddress = eftposAddress;
    client.posVendorId = posVendorId;
    client.posVersion = posVersion;
    SPIDummyDelegate *delegate = [SPIDummyDelegate new];
    client.delegate = delegate;
    // act
    [client start];

    
    // assert
    XCTAssertFalse([client.posId isEqualToString:posId]);
}

- (void)testSetPosId_OnValidCharacters_IsSet {
    // arrange
    static NSString *posId = @"RamenPos";
    SPIClient *client = [[SPIClient alloc] init];
    SPIDummyDelegate *delegate = [SPIDummyDelegate new];
    client.delegate = delegate;
    // act
    client.posId = posId;
    
    // assert
    XCTAssertTrue([client.posId isEqualToString:posId]);
}

- (void)testStart_OnValidCharactersForPosId_IsSet {
    // arrange
    static NSString *posId = @"RamenPos";
    static NSString *eftposAddress = @"10.20.30.40";
    static NSString *posVendorId = @"mx51";
    static NSString *posVersion = @"2.6.6";
    SPIClient *client = [[SPIClient alloc] init];
    client.posId = posId;
    client.eftposAddress = eftposAddress;
    client.posVendorId = posVendorId;
    client.posVersion = posVersion;
    SPIDummyDelegate *delegate = [SPIDummyDelegate new];
    client.delegate = delegate;
    // act
    [client start];
    
    // assert
    XCTAssertTrue([client.posId isEqualToString:posId]);
}

- (void)testSetPosId_OnInvalidCharacters_IsSet {
    // arrange
    static NSString *posId = @"RamenPos@";
    SPIClient *client = [[SPIClient alloc] init];
    SPIDummyDelegate *delegate = [SPIDummyDelegate new];
    client.delegate = delegate;
    // act
    client.posId = posId;
    
    // assert
    XCTAssertFalse([client.posId isEqualToString:posId]);
}

- (void)testStart_OnInvalidCharactersForPosId_IsSet {
    // arrange
    static NSString *posId = @"RamenPos@";
    static NSString *eftposAddress = @"10.20.30.40";
    static NSString *posVendorId = @"mx51";
    static NSString *posVersion = @"2.6.6";
    SPIClient *client = [[SPIClient alloc] init];
    client.posId = posId;
    client.eftposAddress = eftposAddress;
    client.posVendorId = posVendorId;
    client.posVersion = posVersion;
    SPIDummyDelegate *delegate = [SPIDummyDelegate new];
    client.delegate = delegate;
    // act
    [client start];
    
    // assert
    XCTAssertFalse([client.posId isEqualToString:posId]);
}

- (void)testSetEftposAddress_OnValidCharacters_IsSet {
    // arrange
    static NSString *eftposAddress = @"10.20.30.40";
    SPIClient *client = [[SPIClient alloc] init];
    SPIDummyDelegate *delegate = [SPIDummyDelegate new];
    client.delegate = delegate;
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
    static NSString *posVendorId = @"mx51";
    static NSString *posVersion = @"2.6.6";
    SPIClient *client = [[SPIClient alloc] init];
    client.posId = posId;
    client.eftposAddress = eftposAddress;
    client.posVendorId = posVendorId;
    client.posVersion = posVersion;
    SPIDummyDelegate *delegate = [SPIDummyDelegate new];
    client.delegate = delegate;
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
    SPIDummyDelegate *delegate = [SPIDummyDelegate new];
    client.delegate = delegate;
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
    static NSString *posVendorId = @"mx51";
    static NSString *posVersion = @"2.6.6";
    SPIClient *client = [[SPIClient alloc] init];
    client.posId = posId;
    client.eftposAddress = eftposAddress;
    client.posVendorId = posVendorId;
    client.posVersion = posVersion;
    SPIDummyDelegate *delegate = [SPIDummyDelegate new];
    client.delegate = delegate;
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
    SPIDummyDelegate *delegate = [SPIDummyDelegate new];
    client.delegate = delegate;
    //Perform unpair
    [client unpair];
    
    //Wait & check
    XCTestExpectation *expectation = [[XCTestExpectation alloc] initWithDescription:@"test expectation"];
    (void)[XCTWaiter waitForExpectations:@[ expectation ] timeout:1];
    
    XCTAssertEqual(client.state.status, SPIStatusUnpaired);
}

- (void)testEnablePayAtTable {
    SPIClient *client = [[SPIClient alloc] init];
    SPIPayAtTable *pat = [client enablePayAtTable];
    XCTAssertNotNil(pat);
}

- (void)testPairingFlowStateChanged {
    SPIClient *client = [[SPIClient alloc] init];
    [client setEftposAddress:@"192.168.0.1"];
    [client setPosId:@"posID"];
    client.state.status = SPIStatusUnpaired;
    SPIDummyDelegate *delegate = [SPIDummyDelegate new];
    client.delegate = delegate;
    //Perform unpair
    
    SPIPairingFlowState *before = client.state.pairingFlowState;

    [client pair];
    
    SPIPairingFlowState *after = client.state.pairingFlowState;
    
    XCTAssertNotEqual(before, after);
}

- (void)testAutoResolveEftposAddress {
    SPIClient *client = [[SPIClient alloc] init];
    [client setTenantCode:@"gko"];
    [client setEftposAddress:@"1.1.1.1"];
    [client setSerialNumber:@"555-555-002"];
    [client setDeviceApiKey:@"RamenPosDeviceAddressApiKey"];
    [client setPosId:@"posID"];
    [client setTestMode:YES];
    [client setTestMode:NO];

    SPIDummyDelegate *delegate = [SPIDummyDelegate new];
    client.delegate = delegate;
    XCTestExpectation *expectation = [[XCTestExpectation alloc] initWithDescription:@"test expectation"];
    
    delegate.deviceAddressChangedBlock = ^() {
        XCTAssertNotEqual(client.eftposAddress, @"1.1.1.1");
    
        [expectation fulfill];
    };
    (void)[XCTWaiter waitForExpectations:@[ expectation ] timeout:2];
}





@end
