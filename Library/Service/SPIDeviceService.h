//
//  SPIDeviceService.h
//  SPIClient-iOS
//
//  Created by Metin Avci on 26/11/18.
//  Copyright © 2018 mx51. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface SPIDeviceAddressStatus : NSObject <NSCopying>

typedef NS_ENUM(NSUInteger, SPIDeviceAddressResponseCode) {
    DeviceAddressResponseCodeSuccess,
    DeviceAddressResponseCodeInvalidSerialNumber,
    DeviceAddressResponseCodeAddressNotChanged,
    DeviceAddressResponseCodeSerialNumberNotChanged,
    DeviceAddressResponseCodeServiceError
};

@property (nonatomic, copy) NSString *address;
@property (nonatomic, copy) NSString *lastUpdated;
@property (nonatomic) NSInteger responseCode;
@property (nonatomic) SPIDeviceAddressResponseCode deviceAddressResponseCode;

- (instancetype)initWithJSONString:(NSString *)JSONString;

@end

typedef void(^DeviceAddressStatusResult)(SPIDeviceAddressStatus *);

@interface SPIDeviceService : NSObject

- (void)retrieveDeviceAddressWithSerialNumber:(NSString *)serialNumber
                                       apiKey:(NSString *)apiKey
                                   tenantCode:(NSString *)tenantCode
                                   isTestMode:(BOOL)isTestMode
                                   completion:(DeviceAddressStatusResult)completion;

@end
