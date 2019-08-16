//
//  SPIPayAtTableTests.m
//  Tests
//
//  Created by Metin Avci on 27/5/19.
//  Copyright © 2019 Assembly Payments. All rights reserved.
//

#import <XCTest/XCTest.h>
#import "SPIPayAtTable.h"

@interface SPIPayAtTableTests : XCTestCase

@end

@implementation SPIPayAtTableTests

- (void)testGetOpenTablesResponseOnValidResponseReturnObjects {
    // arrange
    SPIOpenTablesEntry *openTablesEntry = [[SPIOpenTablesEntry alloc] init];
    openTablesEntry.tableId = @"1";
    openTablesEntry.label = @"1";
    openTablesEntry.outstandingAmount = 2000;
    SPIOpenTablesEntry *openTablesEntry2 = [[SPIOpenTablesEntry alloc] init];
    openTablesEntry2.tableId = @"2";
    openTablesEntry2.label = @"2";
    openTablesEntry2.outstandingAmount = 2500;
    NSMutableArray<SPIOpenTablesEntry *> *openTablesEntries = [NSMutableArray arrayWithObjects:openTablesEntry, openTablesEntry2, nil];
    
    // act
    SPIGetOpenTablesResponse *getOpenTablesResponse = [[SPIGetOpenTablesResponse alloc] init];
    getOpenTablesResponse.openTablesEntries = openTablesEntries;
    SPIMessage *msg = [[SPIMessage alloc] init];
    msg = [getOpenTablesResponse toMessage:@"111"];
    NSMutableArray *openTablesEntriesJSON = [[NSMutableArray alloc] init];
    for (NSDictionary *item in [msg getDataArrayValue:@"tables"]) {
        SPIOpenTablesEntry *openTablesEntry = [[SPIOpenTablesEntry alloc] initWithDictionary:item];
        [openTablesEntriesJSON addObject:openTablesEntry];
    }
    
    // assert
    XCTAssertEqual(openTablesEntriesJSON.count, getOpenTablesResponse.openTablesEntries.count);
    
    for (NSInteger i = 0; i < 2; i++) {
        SPIOpenTablesEntry *item = getOpenTablesResponse.openTablesEntries[i];
        SPIOpenTablesEntry *item2 = openTablesEntriesJSON[i];
        XCTAssertEqual(item.tableId, item2.tableId);
        XCTAssertEqual(item.label, item2.label);
        XCTAssertEqual(item.outstandingAmount, item2.outstandingAmount);
    }
}

- (void)testGetOpenTablesOnValidResponseIsSet {
    // arrange
    SPIOpenTablesEntry *openTablesEntry = [[SPIOpenTablesEntry alloc] init];
    openTablesEntry.tableId = @"1";
    openTablesEntry.label = @"1";
    openTablesEntry.outstandingAmount = 2000;
    NSMutableArray<SPIOpenTablesEntry *> *openTablesEntries = [NSMutableArray arrayWithObjects:openTablesEntry, nil];
    
    // act
    SPIGetOpenTablesResponse *getOpenTablesResponse = [[SPIGetOpenTablesResponse alloc] init];
    getOpenTablesResponse.openTablesEntries = openTablesEntries;
    NSMutableArray *openTablesEntriesResponse = [getOpenTablesResponse getOpenTables];
    
    // assert
    XCTAssertEqual(openTablesEntries.count, openTablesEntriesResponse.count);
}

@end
