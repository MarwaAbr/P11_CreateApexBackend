public with sharing class P11_SRV_Order {
   

    public static List<Order> order_WithoutProducts( List<Order> ordList){

        List<Order> ordWithout_prod =[SELECT Id FROM Order WHERE Id IN :ordList AND Id NOT IN (SELECT OrderId FROM OrderItem WHERE Product2Id!=null)];
       return ordWithout_prod;
    }


    public static void deactivate_Account_WithoutOrder(List<Order> ordlist){
         
       List<Id> actIds = new List<Id>();
       List<Account> AccountToUpdate = new List<Account>();

       for (Order ord : ordlist)
       {
           Id actId = ord.AccountId;
           actIds.add (actId);
       }

       for (Account act : [SELECT Id, Active__c FROM Account WHERE Id IN :actIds AND Id NOT IN (SELECT AccountId FROM Order)]){
           if (act.Active__c == 'Yes'){
               act.Active__c = 'No';
               AccountToUpdate.add(act);
            }
        } 
        update AccountToUpdate;

    }
}

