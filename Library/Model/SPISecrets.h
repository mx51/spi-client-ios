//
//  SPISecrets.h
//  SPIClient-iOS
//
//  Created by Yoo-Jin Lee on 2017-11-25.
//  Copyright © 2017 mx51. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface SPISecrets : NSObject

@property (readonly) NSData *encKeyData;
@property (readonly) NSData *hmacKeyData;

- (instancetype)initWithEncKeyData:(NSData *)encKey hmacKey:(NSData *)hmacKey;

@end
