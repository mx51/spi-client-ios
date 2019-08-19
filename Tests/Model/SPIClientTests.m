//
//  SPIClientTests.m
//  Tests
//
//  Created by Amir Kamali on 18/6/18.
//  Copyright © 2018 Assembly Payments. All rights reserved.
//

#import <XCTest/XCTest.h>
#import "SPIClient.h"

@interface SPIClientTests : XCTestCase

@end

@implementation SPIClientTests

- (void)testSetPosIdOnValidCharactersIsSet {
    // arrange
    static NSString *posId = @"test";
    static NSString *regexItemsForPosId = @"^[a-zA-Z0-9 ]*$";
    NSRegularExpression *regex = [NSRegularExpression regularExpressionWithPattern:regexItemsForPosId options:NSRegularExpressionCaseInsensitive error:nil];
    NSUInteger match = [regex numberOfMatchesInString:posId options:0 range:NSMakeRange(0, [posId length])];
    SPIClient *client = [[SPIClient alloc] init];
    
    // act
    client.posId = posId;
    
    // assert
    XCTAssertTrue([client.posId isEqualToString:posId]);
    XCTAssertEqual(1, match);
}

- (void)testSetPosIdOnInvalidLengthIsSet {
    // arrange
    static NSString *posId = @"12345678901234567";
    static NSUInteger lengthOfPosId = 16;
    SPIClient *client = [[SPIClient alloc] init];
    
    // act
    client.posId = posId;
    
    // assert
    XCTAssertFalse([client.posId isEqualToString:posId]);
    XCTAssertNotEqual(lengthOfPosId, posId.length);
}

- (void)testSetPosIdOnInvalidCharactersIsSet {
    // arrange
    static NSString *posId = @"test@";
    static NSString *regexItemsForPosId = @"^[a-zA-Z0-9 ]*$";
    NSRegularExpression *regex = [NSRegularExpression regularExpressionWithPattern:regexItemsForPosId options:NSRegularExpressionCaseInsensitive error:nil];
    NSUInteger match = [regex numberOfMatchesInString:posId options:0 range:NSMakeRange(0, [posId length])];
    SPIClient *client = [[SPIClient alloc] init];
    
    //
    client.posId = posId;
    
    XCTAssertTrue([client.posId isEqualToString:posId]);
    XCTAssertNotEqual(1, match);
}

- (void)testSetPosAddressOnValidCharactersIsSet {
    // arrange
    static NSString *posAddress = @"127.0.0.1";
    static NSString *regexItemsForEftposAddress = @"^[0-9]{1,3}\\.[0-9]{1,3}\\.[0-9]{1,3}\\.[0-9]{1,3}$";
    NSRegularExpression *regex = [NSRegularExpression regularExpressionWithPattern:regexItemsForEftposAddress options:NSRegularExpressionCaseInsensitive error:nil];
    NSUInteger match = [regex numberOfMatchesInString:posAddress options:0 range:NSMakeRange(0, [posAddress length])];
    SPIClient *client = [[SPIClient alloc] init];
    
    // act
    [client setEftposAddress:posAddress];
    NSString *generatedAddress = [NSString stringWithFormat:@"ws://%@", posAddress];
    
    // assert
    XCTAssertTrue([client.eftposAddress isEqualToString:generatedAddress]);
    XCTAssertEqual(1, match);
}

- (void)testSetPosAddressOnInvalidCharactersIsSet {
    // arrange
    NSString *posAddress = @"127.0.0.1@";
    static NSString *regexItemsForEftposAddress = @"^[0-9]{1,3}\\.[0-9]{1,3}\\.[0-9]{1,3}\\.[0-9]{1,3}$";
    NSRegularExpression *regex = [NSRegularExpression regularExpressionWithPattern:regexItemsForEftposAddress options:NSRegularExpressionCaseInsensitive error:nil];
    NSUInteger match = [regex numberOfMatchesInString:posAddress options:0 range:NSMakeRange(0, [posAddress length])];
    SPIClient *client = [[SPIClient alloc] init];
    
    // act
    [client setEftposAddress:posAddress];
    NSString *generatedAddress = [NSString stringWithFormat:@"ws://%@", posAddress];
    
    // assert
    XCTAssertTrue([client.eftposAddress isEqualToString:generatedAddress]);
    XCTAssertNotEqual(1, match);
}

- (void)testUnpair {
    //Initiate Client and set status
    SPIClient *client = [[SPIClient alloc] init];
    [client setSecretEncKey:@"1" hmacKey:@"2"];
    client.state.status = SPIStatusPairedConnected;
    
    //Perform unpair
    [client unpair];
    
    //Wait & check
    XCTestExpectation *expectation = [[XCTestExpectation alloc] initWithDescription:@"test expectation"];
    (void)[XCTWaiter waitForExpectations:@[ expectation ] timeout:1];
    
    XCTAssertEqual(client.state.status, SPIStatusUnpaired);
}

@end
