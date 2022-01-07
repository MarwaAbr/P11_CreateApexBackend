/**
* @author:MarwaAbroud marwa-majdoub@hotmail.com
* @description: a Scheduler Class that execute the Batch "P11_Batch_CreateCallTask.cls"
* @date:04/01/2022 
*/
global class P11_Scheduler_batch implements Schedulable{

        global void execute(SchedulableContext sc)
         {
         P11_Batch_CreateCallTask b = new P11_Batch_CreateCallTask();
           database.executebatch(b);
         }

        /***The code to execute this Scheduler throw Developer Console***:
    
        P11_Scheduler_batch executeBatch= new P11_Scheduler_batch();
        string sch = '0 0 0 ? * 2#1';
        system.schedule ('Batch', sch, executeBatch);
    */
}
