//
//  SPISecrets.m
//  SPIClient-iOS
//
//  Created by Yoo-Jin Lee on 2017-11-25.
//  Copyright © 2017 mx51. All rights reserved.
//

#import "SPISecrets.h"

@implementation SPISecrets

- (instancetype)initWithEncKeyData:(NSData *)encKey hmacKey:(NSData *)hmacKey {
    self = [super init];
    
    if (self) {
        _encKeyData = [encKey copy];
        _hmacKeyData = [hmacKey copy];
    }
    
    return self;
}

@end
