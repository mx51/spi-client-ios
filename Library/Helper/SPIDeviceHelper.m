//
//  SPIDeviceHelper.m
//  SPIClient-iOS
//
//  Created by Doniyorjon Zuparov on 29/07/21.
//  Copyright © 2021 mx51. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "SPIDeviceHelper.h"

@implementation SPIDeviceHelper: NSObject

+ (SPIDeviceAddressStatus *)generateDeviceAddressStatus:(SPIDeviceAddressStatus *)serviceResponse
                                   currentEftposAddress:(NSString *)currentEftposAddress {
    
    SPIDeviceAddressStatus *currentDeviceAddressStatus = [SPIDeviceAddressStatus new];
    
    if (serviceResponse == nil) {
        currentDeviceAddressStatus.deviceAddressResponseCode = DeviceAddressResponseCodeServiceError;
        
        return currentDeviceAddressStatus;
    }
    
    if (serviceResponse.address.length == 0) {
        if (serviceResponse.responseCode == 404) {
            currentDeviceAddressStatus.deviceAddressResponseCode = DeviceAddressResponseCodeInvalidSerialNumber;
            return currentDeviceAddressStatus;
        } else {
            currentDeviceAddressStatus.deviceAddressResponseCode = DeviceAddressResponseCodeServiceError;
            return currentDeviceAddressStatus;
        }
    }
    
    if ([serviceResponse.address isEqual:currentEftposAddress]) {
        currentDeviceAddressStatus.deviceAddressResponseCode = DeviceAddressResponseCodeAddressNotChanged;
        return currentDeviceAddressStatus;
    }
    
    currentDeviceAddressStatus.address = serviceResponse.address;
    currentDeviceAddressStatus.lastUpdated = serviceResponse.lastUpdated;
    currentDeviceAddressStatus.deviceAddressResponseCode = DeviceAddressResponseCodeSuccess;
    
    return currentDeviceAddressStatus;
}


@end
