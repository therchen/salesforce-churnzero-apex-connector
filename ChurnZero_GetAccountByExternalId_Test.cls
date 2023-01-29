@isTest
public class ChurnZero_GetAccountByExternalId_Test {
  public static User getTestUser() {
    Profile p = [SELECT Id FROM Profile WHERE Name = 'System Administrator'];
    String uniqueUserName = 'testuser' + DateTime.now().getTime() + '@test.com';
    User u = new User(Alias = 'testuser', Email = 'testuser@test.com', EmailEncodingKey = 'UTF-8', LastName = 'TestLastName', LanguageLocaleKey = 'en_US', LocaleSidKey = 'en_US', ProfileId = p.Id, TimeZoneSidKey = 'America/Los_Angeles', UserName = uniqueUserName);
    insert u;
    return u;
  }
  @isTest(SeeAllData = true)
  public static void testBatch() {
    User u = ChurnZero_GetAccountByExternalId_Test.getTestUser();
    System.runAs(u) {
      Account a = new Account(Name = 'Test Account', Website = 'www.test.com');
      insert a;
      List < Product_Usage_Panel__c > pups = new List < Product_Usage_Panel__c > ();
      Integer numPups = 200;
      for (Integer i = 0; i < numPups; i++) {
        Product_Usage_Panel__c pup = new Product_Usage_Panel__c(Account__c = a.Id);
        pups.add(pup);
      }
      insert pups;
      Test.startTest();
      Database.executeBatch(new ChurnZero_GetAccountByExternalId());
      Test.stopTest();
      System.assertEquals(numPups, [SELECT COUNT() FROM Product_Usage_Panel__c WHERE Account__c = : a.Id AND(Last_Checked_in_Minutes__c > 10 OR Last_Checked_Datetime__c = NULL)]);
    }
  }
}
