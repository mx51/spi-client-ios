//
//  SPITestUtils.h
//  Tests
//
//  Created by Mike Gouline on 3/7/18.
//  Copyright © 2018 mx51. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "SPIClient.h"

@interface SPITestUtils : NSObject

+ (SPIClient *)clientWithTestSecrets;

+ (SPISecrets *)setTestSecrets:(NSString *)encKey hmacKey:(NSString *)hmacKey;

+ (void)waitForAsync:(NSTimeInterval)seconds;

@end
