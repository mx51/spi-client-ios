//
//  SPISettlementTests.m
//  Tests
//
//  Created by Amir Kamali on 18/6/18.
//  Copyright © 2018 mx51. All rights reserved.
//

#import <XCTest/XCTest.h>
#import "SPISettlement.h"
#import "SPIPurchaseHelper.h"
#import "NSDate+Util.h"
#import "SPIClient.h"
#import "SPIClient+Internal.h"
#import "SPITestUtils.h"

@interface SPISettlementTests : XCTestCase

@end

@implementation SPISettlementTests

- (void)testSettlementEnquiry {
    NSString *jsonStr = @"{\"data\":{\"accumulated_purchase_count\":\"1\",\"accumulated_purchase_value\":\"1000\",\"accumulated_refund_count\":\"1\",\"accumulated_refund_value\":\"-1000\",\"accumulated_settle_by_acquirer_count\":\"0\",\"accumulated_settle_by_acquirer_value\":\"0\",\"accumulated_total_count\":\"2\",\"accumulated_total_value\":\"0\",\"bank_date\":\"18062018\",\"bank_time\":\"011720\",\"host_response_code\":\"000\",\"host_response_text\":\"APPROVED\",\"merchant_acquirer\":\"EFTPOS FROM WESTPAC\",\"merchant_address\":\"213 Miller Street\",\"merchant_city\":\"Sydney\",\"merchant_country\":\"Australia\",\"merchant_name\":\"Merchant4\",\"merchant_postcode\":\"2060\",\"merchant_receipt\":\"EFTPOS FROM WESTPAC\\r\\nMerchant4\\r\\n213 Miller Street\\r\\nSydney 2060\\r\\n\\r\\nAustralia\\r\\n\\r\\n\\r\\n SETTLEMENT INQUIRY\\r\\nTSP     100312348845\\r\\nTIME   18JUN18 01:17\\r\\nTRAN   000148-000149\\r\\nFROM   17JUN18 20:15\\r\\nTO     18JUN18 01:17\\r\\n\\r\\nDebit\\r\\nREF     1    $-10.00\\r\\nTOT     1    $-10.00\\r\\n\\r\\nMasterCard\\r\\nPUR     1     $10.00\\r\\nTOT     1     $10.00\\r\\n\\r\\nVisa\\r\\nTOT     0      $0.00\\r\\n\\r\\nSTOTAL  0      $0.00\\r\\n\\r\\nAmex\\r\\nTOT     0      $0.00\\r\\n\\r\\nDiners\\r\\nTOT     0      $0.00\\r\\n\\r\\nJCB\\r\\nTOT     0      $0.00\\r\\n\\r\\nUnionPay\\r\\nTOT     0      $0.00\\r\\n\\r\\nTOTAL\\r\\nPUR     1     $10.00\\r\\nREF     1    $-10.00\\r\\nTOT     2      $0.00\\r\\n\\r\\n   (000) APPROVED\\r\\n\\r\\n\\r\\n\\r\\n\\r\\n\\r\\n\\r\\n\\r\\n\\r\\n\\r\\n\",\"schemes\":[{\"scheme_name\":\"Debit\",\"settle_by_acquirer\":\"Yes\",\"total_count\":\"1\",\"total_refund_count\":\"1\",\"total_refund_value\":\"-1000\",\"total_value\":\"-1000\"},{\"scheme_name\":\"MasterCard\",\"settle_by_acquirer\":\"Yes\",\"total_count\":\"1\",\"total_purchase_count\":\"1\",\"total_purchase_value\":\"1000\",\"total_value\":\"1000\"},{\"scheme_name\":\"Visa\",\"settle_by_acquirer\":\"Yes\",\"total_count\":\"0\",\"total_value\":\"0\"},{\"scheme_name\":\"Amex\",\"settle_by_acquirer\":\"No\",\"total_count\":\"0\",\"total_value\":\"0\"},{\"scheme_name\":\"Diners\",\"settle_by_acquirer\":\"No\",\"total_count\":\"0\",\"total_value\":\"0\"},{\"scheme_name\":\"JCB\",\"settle_by_acquirer\":\"No\",\"total_count\":\"0\",\"total_value\":\"0\"},{\"scheme_name\":\"UnionPay\",\"settle_by_acquirer\":\"No\",\"total_count\":\"0\",\"total_value\":\"0\"}],\"settlement_period_end_date\":\"18Jun18\",\"settlement_period_end_time\":\"01:17\",\"settlement_period_start_date\":\"17Jun18\",\"settlement_period_start_time\":\"20:15\",\"settlement_triggered_date\":\"18Jun18\",\"settlement_triggered_time\":\"01:17:20\",\"stan\":\"000000\",\"success\":true,\"terminal_id\":\"100312348845\",\"transaction_range\":\"000148-000149\"},\"datetime\":\"2018-06-18T01:17:32.291\",\"event\":\"settlement_enquiry_response\",\"id\":\"stlenq3\"}";
    
    NSDictionary *jsonObject = [NSJSONSerialization JSONObjectWithData:[jsonStr dataUsingEncoding:NSUTF8StringEncoding] options:0 error:nil];
    
    SPIMessage *msg = [[SPIMessage alloc] initWithDict:jsonObject];
    SPISettlement *response  = [[SPISettlement alloc] initWithMessage:msg];
    XCTAssertEqual([response getSettleByAcquirerCount], 0);
    XCTAssertEqual([response getSettleByAcquirerValue], 0);
    XCTAssertEqual([response getTotalCount], 2);
    XCTAssertEqual([response getTotalValue], 0);
    XCTAssertEqual([response getSettleByAcquirerCount], 0);
    XCTAssertTrue([[[response getPeriodStartTime] toString] isEqualToString:@"2018-06-17T20:15:00.000"]);
    XCTAssertTrue([[[response getPeriodEndTime] toString] isEqualToString:@"2018-06-18T01:17:00.000"]);
    XCTAssertNotNil([response getTriggeredTime]);
    XCTAssertTrue([[response getResponseText] isEqualToString:@"APPROVED"]);
    XCTAssertNotNil([response getMerchantReceipt]);
    XCTAssertTrue([[response getTransactionRange] isEqualToString:@"000148-000149"]);
    XCTAssertTrue([[response getTerminalId] isEqualToString:@"100312348845"]);
    XCTAssertGreaterThan([response getSchemeSettlementEntries].count, 0);
}

- (void)testHandleSettlementResponse {
    SPIClient *client = [SPITestUtils clientWithTestSecrets];
    
    client.deviceApiKey = @"testPos";
    client.testMode = YES;
    client.tenantCode = @"gko";
    client.transactionReport = [SPITransactionReportHelper createTransactionReportEnvelope:@"test" posVersion:@"2.9.0" libraryLanguage:@"ios" libraryVersion:@"2.9.0" serialNumber:@"555-555-555"];
    // Initiate request
    client.state.status = SPIStatusPairedConnected;
    [client initiateSettleTx:@"TEST" completion:^(SPIInitiateTxResult *result) {}];
    NSString *jsonStr = @"{\"enc\":\"71EF1DB91443BE9E3D8DE270E603F8CB9078FB78D313A98360CD2523856D99A1238BA2953AA9E40BF61060236F0B5C131F1544C2B49FA29035F4DF775B139B0376C342804A6F3AFADDEF1267991C424DBDB0C315FCDAF111108DB272481BD3623F750467CB4F355889A4337CF892253F723011AF76910AC916C90AA938A99194A9138A0FCE5CE452F6008045E1BA73CB2138F4B4C97D62DC2BF87B4B61BF76FB5F20E7DB8011188DEFB6F9A813B31D55AF730B425C0CB7ED5E762A6588FA6777D2F0322C35026C9DE6FEC141E9D0188259F0229D7024D7AAA11C28DDA60C54E332E4F166FA7C2DAB8C0651933892CD122ABDA5BA1BE717B2C893981D80EFB353B7E41C1B357651E1F19A8C5DE9662241CFEF026D60EEC887D340D545DB539A706EB83A6C52D1C5F938D9EA30675143E9F6FABE548FACC61F2A649F190A7179212D1178712F1B8617BE9342B23CB2B0A350BA4E34463B8D6DB5F1559AD45B7AFCF8B4C7C3B2FB1BF0850D5B83430F5C93C1459CC56096E2FE368E49FEA7D61A2EFAA7452C0607EA1451B95F653A8B888FAD85F1A4716C1E23E2BD5DCB4B2DC025D9A45491C4705F0C7863A5B4741D3651496416C9615BAA21F97179F833021EBA0B33A904B01A7B0FC0DFBA8FA6A615EF7BE21EE02A13A8D68006A785CA62BE604C8024472391C9F43F66BA422C73114A37FF6DF944602E677D30B8CC98E933D534B3E824B9DA558B50ECD8E987CF5ECD1938C3A0B3725143B065D7793F8B6FF486828E69699DC76001E38542BEF8C31495202062DA9E5AC25C05E3C8046E343E7E2D2A2E0C0CA36AF0F1B6EC39EBE0741E5CA9B782C9049C5067678E18AC7E30D6BE0AB9A51674188D32395244881BB583BCAFDB08D4019C72B308BC398FA6E15B15CD68074F9529DD0BCDF02358C6A4B665C5DA6801172A79CFB22A2BD24E131340751EFABF60F3D4A1D1B2E687F559AC37B27B84640E9E9FD28C7FACBBFDEEBE07CF4E8AA3368F8AAFF6CE768107BEFC43760DBBED5963FC7CEDD97270F3BCF2477BC13F36B95B452BC584B5834D2ECE8AF16E4230AB91CC9E68C92AF3F462BC4AA6B93CD43F25A32658B9DD4EC8E12306FDE0213BF643492610C872F4B6F933A47A9094849C1EF244F8F3F73041719EBE889B41DB60565FD71C3A545CE2F80D2B704CC192BEEF1BB5A1D5841033EDF65C0EA04EC607CFA338A822763B305E592916AC804C5BBDEB1F451437D96A4B9A8BBEABE7C7E05DAD9C3D4A4053428EAFB4766741EBEC3A7A38314EE929B3FE433839FBB64F64E67C62B0AA9FF0380A8DB08818284755BBC9F8243F20D6B3CBDD6D3B35E6A75104514AE78366E9BF018886721E58B9A08103FDB30B018444B5D7336E9708FD6DDC82EF8497D560AFFC617160E10404A01A65060E800704E9A19DF281C0F4E32BA91BCFBAF60E80DD1B8F5435391C9ADB144CA9C85308BC0A44158BD689DAA4197E4676DEC5213D0ABC9E4E2586C4222176961FC1C7AC16F8013EBF870F22288B756F483194BCA8ACB73C995581B53ED3D1F4CA4F839453539C981A120E66D7C3A31B3D396E669EBAD2AAD3FBE4B3F8FCBC61DCD5BF187C6EA6E1B9E2F3D535FA8CD62538A002D86EAF981021F87866D33F4C40E5383B5233C9FE87DA19A656600172EA950E024F044765FB2F239E1163C699C80E2FEF4AB8966685598F105C45A3C202359D524CED532B79139EB3F33ED8857A333A1D9613495E7ED82FFAFD1101B2AD111C4940749E9A5B992782078820CA250907C669E901A6B357E94320DCC4CB91C25508FA3F341AF8D4585EB59346438915B828DE40191CB83C10C552D487DD929A53E0F00496004FE45A22B482D3C605EA2AA72840918A2D8C47B770246E7BF106CA68B4E89CF0175B8A5BCD69BCDCB7663D1C3B0CC987C5107D070A5AD38BA14CD6E0514AB5B86775461CC4AD576CE48F2639BD0EC7514FA8ACE1427F7F6A33C5DC7DE80D3253CBEBA358E2B3F73DE4997F4435A1762EEC22B11F1599D165D8091FAB009339246939FA50CA6997F8DEA9D5D02E4C446D1D1928F3510F655C0E092B2B717637B1AC786DEEC34FE05EA17F9EBD0964EC980FB52730FAFB328015CA5FADE4D3D29799B9EDAAF18C3BFF9B930D1CA84B61E68EBAF40DAC528331074CAF340A1BFCE1A8075811A1AEC49C90E6EA2305821F6B3F3105AFF84C20B450520E4253A8B23193ABE0886A9D484861905FB3144B7D43FE3BBB8E3A21105AF5A1F1A8C9569E8112383FA18F326D306CF74B550ABF403CB47B4B30A5CF6980C9A71D808246C71EBEBA41DD4097F46AC409EFF2EA1F3D39F6E183F2618C8EBC01653DAFFAB9335B46F31248A95E4222EB4A83B29C2EFFA0DCAFFB5F3A360466B171A85C190925F4B7759D5AD2F8391CEF52F278B5641ECF4C209FAA6EF5CAE6A01F48C5AD62EA80E655F95B78664437944F87BB3BED9720C840DBC281C04889B87D385CDDAC127F4ED52D0FE1B196E9FF67443CA44608A08E7F7281946CD35FF8E0D10A570B1725F4072A47D7C39DE378D46F14ABEA9CC7C749CD99A7460980F57D9B526E58002965224FDF955C9A8A367F8079CC95666257BDB622AA0455557605EA9B2F4A9FFC4A1B4D6932A982E2E0938783158D4E9B4292AD55F940E9DC12AE0B442D31D492B294C13F5A979C93E6913663F289E4E82030B89E2DA1EFCCE59CE6A8207BE917E9705CD809FFB20DE771ECA911B9DAF56ACA3729DAA8565372CA5F8FCB8A4E39D055E85B4DC7D305B03CD52A51B9D9A5FD80D1397EC0EC240FB800854DA6B12B85923A27E1E8D1EFBE8387D2025A3655FDA50C9C3F5D20A0CDB39C267BCFBC264B4E82B06126DC5D9EC4955EFFB8DB79CDE2178EA83381482C9E64E9151E35DE16C321A16D567A9E2E1A9EA5FD0C99DB937261462F1EC3BDE0B4ED71F1E451C3E63C63A044B662E6FE18E938BB47F82285ED4FDB759F964E962FFF1FAF98FDCB9576F9CDF282C4D4132FB8400CB81B8BE6706EAF1356075697251883DAE41E23911CA843BDF9E78CDFF3DA1D22F3593AF86E8C2666F1FBFD9FAF0A1EC923DA0087CE004EDCDD9930A2B0D5ABF2BA0A0222ED71BF530FA66478029E00018357FDE86CBCA3FB89020F2E4DF75A97ABC25BAB659794557DF240861800FFBC266CC3DFEE6748EE8C89482C51D912B3DC9245B2AD3F3F07572883FF91FC14FFA2FD8B2426E25193D0BF7B9CB42A3CB2A4F36E6AA22527750097AE6E1865F24A0713479132A63845D850B9141EE73BA900B6E262D3645C0011BE43B781B25490F690E52F74E65E76BAFFB6D6597C438B2411AA21F7DDD3CE1F079708139118C834771FF61BAD1DEB7C202815178390F19B6F6A3E16A3095ED0A2DA14B321D5099611842FC58FDD0116AB250344364562134251AECC37BB14650DF71C176311D85795CB1F23373AF25F24270C171979CA1E6E7DE17BDE3A2899390A26017EE68D0CE6CC944D1D48292B4B8F61A4D6955FB2D7391F12E83B14EB1A5A058C19BDB10D7CD875F011D6AA74DDAFB5A5973A0B83E141F389A580EF861368D1AFAEF20D884C378DB380799B487CE510F7C0F94BDEE5CB1477D60A6FDBCAA8354FFC8479948E8FD1573A42A146882088D7A243106D6A276BA4BF03C4F2B239F7FC2477E5F2E352DC503BB68F87DC1BBF70BF2EBBEB0493D3ACF8D61A49F28F6EF687C0ADFD7510CCEB99E4D2A228E455DA2B20BA6C6306CE08D500B4B170B5A69A46ABABFA6970A2F81DED88E4220799F6EEDBE6B87A653F901B9D5B288F388431CC7B179354FA17826727E21B776454DA977F46F19584EBD3496E1C89C8C70239A202DA64F25D8FE1039BB86EA1F6750C695E71338B4FE8931C12BCCF01E33C173A449C139F5F2AD9F33351BC021C31197547E70101D9E6C81BF5265AA90A0B83EA87173982B0E6A0BFDFE37D9E5FC725E5E1BFDD261CD03713FF120FACFAD392933569AC8182A8BFB0F8F18F2A2B73268CB3B9541DEE81FF9CFFE7476D648444BB0F95F4FF5D4BB2FCC8F36F450B2049A6474C2B3CE38ED3A839844FC61E1AABFF54563048646305F8BCFA48572908C8026326D6CA\",\"hmac\":\"82D747DCA2764F105BC0CABB41518AD7BE586DA80B0964C224365014C3F2EBAE\"}";
    [client onSpiMessageReceived:jsonStr];
    
    XCTestExpectation *expectation = [[XCTestExpectation alloc] initWithDescription:@"test expectation"];
    (void) [XCTWaiter waitForExpectations:@[expectation] timeout:1];
    
    XCTAssertTrue([client.state.txFlowState.displayMessage isEqualToString:@"Settle transaction ended"]);
}

@end
