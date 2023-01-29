@isTest
class ChurnZero_GetAccountByExternalId_SchTst {
    static testmethod void test() {
        Test.startTest();
        String jobId = System.schedule('ChurnZero_GetAccountByExternalId_Sch', ChurnZero_GetAccountByExternalId_Sch.CRON_EXP, new ChurnZero_GetAccountByExternalId_Sch());
        CronTrigger ct = [SELECT Id, CronExpression FROM CronTrigger WHERE Id = :jobId];
        System.assertEquals(ChurnZero_GetAccountByExternalId_Sch.CRON_EXP, ct.CronExpression);
        Test.stopTest();
    }
}
