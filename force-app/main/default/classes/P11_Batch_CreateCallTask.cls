/**
* @author:MarwaAbroud marwa-majdoub@hotmail.com
* @description: a batch code that creates tasks for accounts that do not have orders and Call tasks
* @date:04/01/2022 
*/
global class P11_Batch_CreateCallTask implements Database.Batchable<SObject>{
    
    global Database.QueryLocator start(Database.BatchableContext info){ 
        //Request only accounts that do not have orders and call tasks

        set<id> TaskWhatIDs = new set<id>();
        for(Task t: [SELECT WhatId FROM Task WHERE what.type = 'Account' AND Subject='Call']){
         TaskWhatIDs.add(t.whatId);
        }
      
        return Database.getQueryLocator('SELECT Id FROM Account WHERE Id NOT IN (SELECT AccountId FROM Order) AND Id NOT IN:TaskWhatIDs');
    }
     
    /**
     * @author:MarwaAbroud marwa-majdoub@hotmail.com
     * @description: Execute the batch to create a call Task for each Account without Orders and call Tasks
     */
    global void execute(Database.BatchableContext info, List<Account> scope){

        List<Task> taskToInsert= new List<Task>();

        for(Account act:scope){

            Task callTask = new Task (WhatId=act.Id, Status='Not Started', Subject ='Call', Priority ='Normal', Description='Rappel automatique dans 5 jours');
            taskToInsert.add(callTask);
        }

        insert taskToInsert;
    
    }
    global void finish(Database.BatchableContext info){     
       
    } 
}


