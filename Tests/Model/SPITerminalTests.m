//
//  SPIPayAtTableTests.m
//  Tests
//
//  Created by Metin Avci on 18/7/19.
//  Copyright © 2019 Assembly Payments. All rights reserved.
//

#import <XCTest/XCTest.h>
#import "SPITerminal.h"

@interface SPITerminalTests : XCTestCase

@end

@implementation SPITerminalTests

- (void)testTerminalStatusRequest_OnValidRequest_ReturnObjects {
    // arrange
    SPITerminalStatusRequest *request = [[SPITerminalStatusRequest alloc] init];
    
    // act
    SPIMessage *msg = [request toMessage];
    
    // assert
    XCTAssertTrue([msg.eventName isEqualToString:@"get_terminal_status"]);
}

- (void)testTerminalStatusResponse_OnValidResponse_ReturnObjects {
    // arrange
    static NSString *jsonStr = @"{\"data\":{\"battery_level\":\"100\",\"charging\":true,\"status\":\"IDLE\",\"success\":true},\"datetime\":\"2019-06-18T13:00:38.820\",\"event\":\"terminal_status\",\"id\":\"trmnl4\"}";
    NSDictionary *jsonObject = [NSJSONSerialization JSONObjectWithData:[jsonStr dataUsingEncoding:NSUTF8StringEncoding] options:0 error:nil];
    
    // act
    SPIMessage *msg = [[SPIMessage alloc] initWithDict:jsonObject];
    SPITerminalStatusResponse *response  = [[SPITerminalStatusResponse alloc] initWithMessage:msg];
    
    // assert
    XCTAssertTrue([msg.eventName isEqualToString:@"terminal_status"]);
    XCTAssertTrue([response isSuccess]);
    XCTAssertTrue([response.getBatteryLevel isEqualToString:@"100"]);
    XCTAssertTrue([response.getStatus isEqualToString:@"IDLE"]);
    XCTAssertTrue([response getCharging]);
}

- (void)testTerminalBattery_OnValidResponse_ReturnObjects {
    // arrange
    static NSString *jsonStr = @"{\"data\":{\"battery_level\":\"40\"},\"datetime\":\"2019-06-18T13:02:41.777\",\"event\":\"battery_level_changed\",\"id\":\"C1.3\"}";
    NSDictionary *jsonObject = [NSJSONSerialization JSONObjectWithData:[jsonStr dataUsingEncoding:NSUTF8StringEncoding] options:0 error:nil];
    
    // act
    SPIMessage *msg = [[SPIMessage alloc] initWithDict:jsonObject];
    SPITerminalBattery *response  = [[SPITerminalBattery alloc] initWithMessage:msg];
    
    // assert
    XCTAssertTrue([msg.eventName isEqualToString:@"battery_level_changed"]);
    XCTAssertTrue([response.batteryLevel isEqualToString:@"40"]);
}

- (void)testTerminalConfigurationRequest_OnValidRequest_ReturnObjects {
    // arrange
    SPITerminalConfigurationRequest *request = [[SPITerminalConfigurationRequest alloc] init];
    
    // act
    SPIMessage *msg = [request toMessage];
    
    // assert
    XCTAssertTrue([msg.eventName isEqualToString:@"get_terminal_configuration"]);
}

- (void)testTerminalConfigurationResponse {
    // arrange
    static NSString *jsonStr = @"{\"data\":{\"comms_selected\":\"WIFI\",\"merchant_id\":\"22341842\",\"pa_version\":\"SoftPay03.16.03\",\"payment_interface_version\":\"02.02.00\",\"plugin_version\":\"v2.6.11\",\"serial_number\":\"321-404-842\",\"success\":true,\"terminal_id\":\"12348842\",\"terminal_model\":\"VX690\"},\"datetime\":\"2019-06-18T13:00:41.075\",\"event\":\"terminal_configuration\",\"id\":\"trmnlcnfg5\"}";
    NSDictionary *jsonObject = [NSJSONSerialization JSONObjectWithData:[jsonStr dataUsingEncoding:NSUTF8StringEncoding] options:0 error:nil];
    
    // act
    SPIMessage *msg = [[SPIMessage alloc] initWithDict:jsonObject];
    SPITerminalConfigurationResponse *response  = [[SPITerminalConfigurationResponse alloc] initWithMessage:msg];
    
    // assert
    XCTAssertTrue([msg.eventName isEqualToString:@"terminal_configuration"]);
    XCTAssertTrue([response isSuccess]);
    XCTAssertTrue([response.getCommsSelected isEqualToString:@"WIFI"]);
    XCTAssertTrue([response.getMerchantId isEqualToString:@"22341842"]);
    XCTAssertTrue([response.getPAVersion isEqualToString:@"SoftPay03.16.03"]);
    XCTAssertTrue([response.getPaymentInterfaceVersion isEqualToString:@"02.02.00"]);
    XCTAssertTrue([response.getPluginVersion isEqualToString:@"v2.6.11"]);
    XCTAssertTrue([response.getSerialNumber isEqualToString:@"321-404-842"]);
    XCTAssertTrue([response.getTerminalId isEqualToString:@"12348842"]);
    XCTAssertTrue([response.getTerminalModel isEqualToString:@"VX690"]);
}

@end
