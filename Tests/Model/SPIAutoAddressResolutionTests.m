//
//  SPIAutoAddressResolutionTests.m
//  Tests
//
//  Created by Metin Avci on 14/5/19.
//  Copyright © 2019 mx51. All rights reserved.
//

#import <XCTest/XCTest.h>
#import "SPIClient.h"

@interface SPIAutoAddressResolutionTests : XCTestCase

@end

@implementation SPIAutoAddressResolutionTests

- (void)testSetSerialNumber_ValidSerialNumber_IsSet {
    // arrange
    static NSString *serialNumber = @"111-111-111";
    SPIClient *client = [[SPIClient alloc] init];
    client.state.status = SPIStatusUnpaired;
    
    // act
    [client setSerialNumber:serialNumber];
    
    // assert
    XCTAssertTrue([client.serialNumber isEqualToString:serialNumber]);
}

- (void)testSetAutoAddressResolution_TurnOnAutoAddress_Enabled {
    // arrange
    static BOOL autoAddressResolutionEnable = true;
    SPIClient *client = [[SPIClient alloc] init];
    client.state.status = SPIStatusUnpaired;
    
    // act
    [client setAutoAddressResolutionEnable:autoAddressResolutionEnable];
    
    // assert
    XCTAssertEqual(autoAddressResolutionEnable, client.autoAddressResolutionEnable);
}

- (void)testRetrieveService_SerialNumberNotRegistered_NotFound {
    // arrange
    static NSString *apiKey = @"RamenPosDeviceAddressApiKey";
    static NSString *acquirerCode = @"wbc";
    static NSString *serialNumber = @"111-111-111";
    
    // act
    [[SPIDeviceService alloc] retrieveDeviceAddressWithSerialNumber:serialNumber apiKey:apiKey tenantCode:acquirerCode isTestMode:true completion:^(SPIDeviceAddressStatus *addressResponse) {
        // assert
        XCTAssertEqual(addressResponse.responseCode, 404);
    }];
    
    XCTestExpectation *expectation = [[XCTestExpectation alloc] initWithDescription:@"test expectation"];
    (void) [XCTWaiter waitForExpectations:@[expectation] timeout:1];
}

- (void)testRetrieveService_SerialNumberRegistered_Found {
    // arrange
    static NSString *apiKey = @"RamenPosDeviceAddressApiKey";
    static NSString *acquirerCode = @"wbc";
    static NSString *serialNumber = @"321-404-842";
    
    // act
    [[SPIDeviceService alloc] retrieveDeviceAddressWithSerialNumber:serialNumber apiKey:apiKey tenantCode:acquirerCode isTestMode:true completion:^(SPIDeviceAddressStatus *addressResponse) {
        
        // assert
        XCTAssertNotNil(addressResponse);
        XCTAssertNotNil(addressResponse.address);
        XCTAssertEqual(addressResponse.deviceAddressResponseCode, DeviceAddressResponseCodeSuccess);
    }];
    
    XCTestExpectation *expectation = [[XCTestExpectation alloc] initWithDescription:@"test expectation"];
    (void) [XCTWaiter waitForExpectations:@[expectation] timeout:1];
}

@end
