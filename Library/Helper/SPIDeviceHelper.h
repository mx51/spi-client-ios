//
//  SPIDeviceHelper.h
//  SPIClient-iOS
//
//  Created by Doniyorjon Zuparov on 29/07/21.
//  Copyright © 2021 mx51. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "SPIDeviceService.h"

@interface SPIDeviceHelper : NSObject

+ (SPIDeviceAddressStatus *)generateDeviceAddressStatus:(SPIDeviceAddressStatus *)serviceResponse
               currentEftposAddress:(NSString *)currentEftposAddress;

@end
