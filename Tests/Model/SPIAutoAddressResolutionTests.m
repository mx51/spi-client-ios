//
//  SPIAutoAddressResolutionTests.m
//  Tests
//
//  Created by Metin Avci on 14/5/19.
//  Copyright © 2019 Assembly Payments. All rights reserved.
//

#import <XCTest/XCTest.h>
#import "SPIClient.h"

@interface SPIAutoAddressResolutionTests : XCTestCase

@end

@implementation SPIAutoAddressResolutionTests

- (void)testSetSerialNumber {
    NSString *serialNumber = @"111-111-111";
    SPIClient *client = [[SPIClient alloc] init];
    client.state.status = SPIStatusUnpaired;
    [client setSerialNumber:serialNumber];
    XCTAssertTrue([client.serialNumber isEqualToString:serialNumber]);
}

- (void)testSetAutoAddressResolution {
    BOOL autoAddressResolutionEnable = true;
    SPIClient *client = [[SPIClient alloc] init];
    client.state.status = SPIStatusUnpaired;
    [client setAutoAddressResolutionEnable:autoAddressResolutionEnable];
    XCTAssertEqual(autoAddressResolutionEnable, client.autoAddressResolutionEnable);
}

- (void)testAutoResolveEftposAddressWithIncorectSerialNumberAsync {
    NSString *apiKey = @"RamenPosDeviceAddressApiKey";
    NSString *acquirerCode = @"wbc";
    NSString *serialNumber = @"111-111-111";
    
    [[SPIDeviceService alloc] retrieveServiceWithSerialNumber:serialNumber apiKey:apiKey acquirerCode:acquirerCode isTestMode:true completion:^(SPIDeviceAddressStatus *addressResponse) {
        XCTAssertNil(addressResponse);
    }];
}

- (void)testAutoResolveEftposAddressWithValidSerialNumberAsync {
    NSString *apiKey = @"RamenPosDeviceAddressApiKey";
    NSString *acquirerCode = @"wbc";
    NSString *serialNumber = @"321-404-842";
    
    [[SPIDeviceService alloc] retrieveServiceWithSerialNumber:serialNumber apiKey:apiKey acquirerCode:acquirerCode isTestMode:true completion:^(SPIDeviceAddressStatus *addressResponse) {
        XCTAssertNotNil(addressResponse);
        XCTAssertNotNil(addressResponse.address);
    }];
}

@end
