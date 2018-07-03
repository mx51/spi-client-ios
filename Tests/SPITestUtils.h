//
//  SPITestUtils.h
//  Tests
//
//  Created by Mike Gouline on 3/7/18.
//  Copyright © 2018 Assembly Payments. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "SPIClient.h"

@interface SPITestUtils : NSObject

+ (SPIClient *)clientWithTestSecrets;

@end
