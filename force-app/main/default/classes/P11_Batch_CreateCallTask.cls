global class P11_Batch_CreateCallTask implements Database.Batchable<SObject>{
    global Database.QueryLocator start(Database.BatchableContext info){ 
        //Requeter seulement les comptes qui n'ont pas des commandes ni des tâches de rappel
       
        set<id> TaskWhatIDs = new set<id>();
        for(Task t: [select WhatId from Task where what.type = 'Account']){
         TaskWhatIDs.add(t.whatId);
        }
      
        return Database.getQueryLocator('SELECT Id FROM Account WHERE Id NOT IN (SELECT AccountId FROM Order) AND Id NOT IN:TaskWhatIDs');
    }

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


