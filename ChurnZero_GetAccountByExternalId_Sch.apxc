global class ChurnZero_GetAccountByExternalId_Sch implements Schedulable {
    public static String CRON_EXP = '0 00 * * * ?';
    global void execute(SchedulableContext sc) {
        CronTrigger ct = [SELECT Id, CronExpression FROM CronTrigger WHERE Id = :sc.getTriggerId()];
        ChurnZero_GetAccountByExternalId b = new ChurnZero_GetAccountByExternalId(); 
        database.executebatch(b, 1);
    }
}
