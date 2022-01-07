/**
* @author:MarwaAbroud marwa-majdoub@hotmail.com
* @description: a Test Class for the Scheduler "P11_Scheduler_batch.cls"
* @date:06/01/2022 
*/
@isTest
private  class P11_Test_Scheduler {
    public static String CRON_EXP = '0 0 0 ? * 2#1';

    /**
    * @author:MarwaAbroud marwa-majdoub@hotmail.com
    * @description: Assert that the execution of the scheduler execute the batch ,
    * and debug the date and time of the next execution
    */
    @isTest
    static void testScheduledJob() {
        List<Account> actList=P11_DataFactory.createAccounts(200);
        Test.startTest();
        // Schedule the test job
        P11_Scheduler_batch executeBatch= new P11_Scheduler_batch();
        String jobId = System.schedule('ScheduledApexTest', CRON_EXP, executeBatch);
        executeBatch.execute(null);
        // Verify the scheduled job has not run yet.
        List<Task> lt = [SELECT Id FROM Task WHERE WhatId IN (SELECT Id FROM Account)];
        System.assertEquals(0, lt.size(), 'Tasks exist before job has run');
        // Stopping the test will run the job synchronously
        Test.stopTest();
        // Now that the scheduled job has executed,
        // check that our tasks were created
        List<Task> lt1 = [SELECT Id FROM Task WHERE WhatId IN (SELECT Id FROM Account)];
        System.assertEquals(actList.size(), lt1.size(),'Tasks were not created');
        //Debug the date and time of the next execution 
        List<CronTrigger> cts = [SELECT Id, TimesTriggered, NextFireTime FROM CronTrigger WHERE Id=:jobId];
        System.debug('Next Fire Time'+ cts[0].NextFireTime );
    }
    
}
