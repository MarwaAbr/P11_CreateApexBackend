/**
* @author:MarwaAbroud marwa-majdoub@hotmail.com
* @description: Test class for the Bacth "P11_Batch_CreateCallTask.cls"
* @date:04/01/2022
*/
@isTest
private class P11_Test_Batch_CreateCallTask {

    /**
    * @author:MarwaAbroud marwa-majdoub@hotmail.com
    * @description: Batch test for 200 accounts without orders, which only one account has a call task
    */
    @isTest 
    static void Test200AccountsWithoutOrders (){
        List<Account> actList=P11_DataFactory.createAccounts(200);
        Account act=actList[0];
        Task tsk = new Task (WhatId=act.Id, Status='Not Started', Subject ='Call', Priority ='Normal');
        insert tsk;
        Test.startTest();
        P11_Batch_CreateCallTask testBatch =new P11_Batch_CreateCallTask();
        Id batchId = Database.executeBatch(testBatch);
        List<Task> existTasks = [SELECT Id FROM Task WHERE Subject ='Call'];
        //Assert that there is one task before the execution of the batch
        System.assertEquals(existTasks.size(), 1);
        Test.stopTest();
        //Assert that 199 Tasks are created and with the existing one, in all there are 200 tasks 
        List<Task> allTask = [SELECT Id FROM Task WHERE WhatId IN (SELECT Id FROM Account ) AND Subject ='Call'];
        System.assertEquals(allTask.size(),200);
    }

    /**
    * @author:MarwaAbroud marwa-majdoub@hotmail.com
    * @description: Batch test for 200 accounts each account has an order
    */
    @isTest 
    static void Test200AccountsWithOrders (){
        P11_DataFactory.createAccounts_WithOrders_WithoutProducts(200, 1);
        Test.startTest();
        P11_Batch_CreateCallTask testBatch =new P11_Batch_CreateCallTask();
        Id batchId = Database.executeBatch(testBatch);
        Test.stopTest();
       //Assert that no Tasks are created beacause all accounts have orders
        List<Task> taskCreated = [SELECT Id FROM Task WHERE Subject ='Call'];
        System.assertEquals(taskCreated.size(), 0);
    }
}
