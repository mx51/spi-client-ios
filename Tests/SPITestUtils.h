//
//  SPITestUtils.h
//  Tests
//
//  Created by Mike Gouline on 3/7/18.
//  Copyright © 2018 mx51. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "SPIConnection.h"
#import "SPIClient.h"

@interface SPITestUtils : NSObject

+ (SPIClient *)clientWithTestSecrets;

+ (SPISecrets *)setTestSecrets:(NSString *)encKey hmacKey:(NSString *)hmacKey;

+ (void)waitForAsync:(NSTimeInterval)seconds;

@end

@interface SPIDummyDelegate : NSObject<SPIDelegate>

typedef void (^CallbackBlock)(void);

@property (nonatomic, copy) CallbackBlock statusChangedBlock;

@property (nonatomic, copy) CallbackBlock pairingFlowStateChangedBlock;

@property (nonatomic, copy) CallbackBlock transactionFlowStateChangedBlock;

@property (nonatomic, copy) CallbackBlock secretsChangedBlock;

@property (nonatomic, copy) CallbackBlock deviceAddressChangedBlock;

@property (nonatomic, copy) CallbackBlock updateMessageReceivedBlock;

@end

