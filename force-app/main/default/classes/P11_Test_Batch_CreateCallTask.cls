@isTest
private class P11_Test_Batch_CreateCallTask {

    @isTest 
    static void test (){
        List<Account> actList=P11_DataFactory.createAccounts(200);
        Account act=actList[0];
        Task tsk = new Task (WhatId=act.Id, Status='Not Started', Subject ='Call', Priority ='Normal');
        insert tsk;
        Test.startTest();
        P11_Batch_CreateCallTask testBatch =new P11_Batch_CreateCallTask();
        Id batchId = Database.executeBatch(testBatch);
        Test.stopTest();
       //List<Account> actWithTask = [SELECT Id FROM Account WHERE Id IN (SELECT WhatId FROM Task WHERE Subject ='Call')];
       List<Task> taskCreated = [SELECT Id FROM Task WHERE WhatId IN: actList AND Subject ='Call'];
       System.assertEquals(200, taskCreated.size());
    }
}
