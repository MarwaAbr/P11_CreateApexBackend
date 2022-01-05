global class P11_Scheduler_Batch implements Schedulable{

        global void execute(SchedulableContext sc)
         {
         P11_Batch_CreateCallTask b = new P11_Batch_CreateCallTask();
           database.executebatch(b);
         }

        /***The code to execute this Scheduler throw Developer Console***:
    
        P11_Scheduler_Batch executeBatch= new P11_Scheduler_Batch();
        string sch = '0 0 0 ? * 2#1';
        system.schedule ('Batch', sch, executeBatch);
    */
}
