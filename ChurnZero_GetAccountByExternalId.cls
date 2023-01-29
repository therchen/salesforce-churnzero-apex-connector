global class ChurnZero_GetAccountByExternalId implements Database.Batchable < sObject > , Database.AllowsCallouts, Database.Stateful {
  global ChurnZero_Helpers helpers = new ChurnZero_Helpers();
  global List < Product_Usage_Panel__c > pupsUpdated = new List < Product_Usage_Panel__c > ();
  global Database.QueryLocator start(Database.BatchableContext BC) {
    if (!test.isRunningTest()) {
      return Database.getQueryLocator([SELECT Id, Account__c, Account_Number__c FROM Product_Usage_Panel__c WHERE Customer_Status__c = 'Current Customer'
        ORDER BY Last_Checked_in_Minutes__c DESC
      ]);
    } else {
      return Database.getQueryLocator([SELECT Id, Account__c, Account_Number__c FROM Product_Usage_Panel__c LIMIT 1]);
    }
  }
  global void execute(Database.BatchableContext BC, List < Product_Usage_Panel__c > pupsCurrent) {
    for (Product_Usage_Panel__c pupCurrent: pupsCurrent) {
      try {
        HttpRequest req = new HttpRequest();
        req.setEndpoint('https://xyz.us1app.churnzero.net/public/v1/Account(AccountExternalId=\'' + pupCurrent.Account_Number__c + '\')?');
        req.setMethod('GET');
        Blob headerValue = Blob.valueOf(Label.ChurnZeroUsername + ':' + Label.ChurnZeroKey);
        String authorizationHeader = 'Basic ' + EncodingUtil.base64Encode(headerValue);
        req.setHeader('Authorization', authorizationHeader);
        Http http = new Http();
        HTTPResponse res = new HTTPResponse();
        System.debug('res: ' + res);
        if (!test.isRunningTest()) {
          res = http.send(req);
        } else {
          String jsonString = '{' + '  \"Id\": 263214,' + '  \"CrmId\": \"0011W00002RMMQjQAP\",' + '  \"ExternalId\": \"27437\",' + '  \"IsActive\": true,' + '  \"Cf\": {' + '    \"AdminsPurchased\": 3,' + '    \"RepSeatsPurchased\": 3,' + '    \"GuestSeatsPurchased\": 3,' + '    \"AccessToSeries\": true,' + '    \"JobFeedActive\": false,' + '    \"NumberOfOpenHouseEventsToDate\": 0,' + '    \"UserSeatsWithAtLeast1Chat\": 0,' + '    \"NumberOfNetworkingEventsToDate\": 0,' + '    \"AdminAndRepSeatsUsed\": 3,' + '    \"DateOfNextUpcomingEvent\": "2015-04-28T18:26:22.000+0000",' + '    \"RecruitersSetup\": 0,' + '    \"NumberOfEventsCompletedToDate\": 2,' + '    \"NumberOfExpoEventsToDate\": 2,' + '    \"DateOfMostRecentCompletedEvent\": "2015-04-28T18:26:22.000+0000",' + '    \"FinalEventDate\": "2015-04-28T18:26:22.000+0000",' + '    \"NumberOfSponsoredEventsToDate\": 3,' + '    \"JobsAssignedToRecruiters\": 3,' + '    \"JobsWithEvents\": 3,' + '    \"NumberOfJobsInFeed\": 3,' + '    \"CostPerTalrooLead\": 3,' + '    \"NumberOfAccountAdmins\": 5,' + '    \"CountOfSponsoredJobs\": 3,' + '    \"TotalActiveUserSeatsOnAccount\": 3,' + '    \"TotalActiveGuestSeatsOnAccount\": 0,' + '    \"LicenseUtilizationLast30Days\": 66.66666666666666,' + '    \"LicenseUtilizationLast60Days\": 100,' + '    \"LicenseUtilizationLast90Days\": 100,' + '    \"LicenseUtilizationLast180Days\": 100,' + '    \"LicenseUtilizationLast365Days\": 900,' + '    \"Last7DaysTotalParticipantSignUps\": 5,' + '    \"Last14DaysTotalParticipantSignUps\": 5,' + '    \"Last30DaysTotalParticipantSignUps\": 5,' + '    \"Last90DaysTotalParticipantSignUps\": 5,' + '    \"Last7DaysTotalChats\": 5,' + '    \"Last14DaysTotalChats\": 5,' + '    \"Last30DaysTotalChats\": 5,' + '    \"Last90DaysTotalChats\": 5,' + '    \"Last90DaysTotalParticipantsChatted\": 0,' + '    \"Last90DaysTotalParticipantsAttended\": 0,' + '    \"Last90DaysTotalParticipantRegistrants\": 0,' + '    \"Last90DaysTotalParticipantsWithNextStepInterview\": 0,' + '    \"Last90DaysPercentageOfParticipantsWithNextStepInterview\": 0,' + '    \"DaysToNextPeerNetworkingEvent\": 5,' + '    \"DaysToNextMixedNetworkingEvent\": 5,' + '    \"DaysToNextOpenHouseEvent\": 5,' + '    \"DaysToNextExpoEvent\": 5,' + '    \"AvgNonrepAttendanceRate\": 5,' + '    \"ConsecEventsWithLowAttendance\": 5,' + '    \"OfNonrepAttendeesWhoChat\": 5,' + '    \"Last90DaysTotalRepsAssigned\": 0,' + '    \"Last90DaysTotalRepAttendees\": 0' + '  }' + '}';
          res.setHeader('Content-Type', 'application/json');
          res.setBody(jsonString);
          res.setStatusCode(200);
        }
          List < ChurnZero_Field_Transform__c > fieldTransforms = [SELECT Field_API_Name__c, Root_Path_String__c, Type__c FROM ChurnZero_Field_Transform__c WHERE Object_Name__c = 'Product Usage Panel' AND ChurnZero_Object_Name__c = 'Account'];
        Product_Usage_Panel__c pupUpdated = helpers.convertJsonStringToPup(pupCurrent.Id, res.getBody(), fieldTransforms);
        if (pupUpdated != null) {
          pupsUpdated.add(pupUpdated);
        }
      } catch (Exception e) {
        System.debug('Error:' + e.getMessage() + 'Line:' + e.getLineNumber());
      }
    }
  }
  global void finish(Database.BatchableContext BC) {
    if (!pupsUpdated.isEmpty()) {
      update pupsUpdated;
    }
  }
}
