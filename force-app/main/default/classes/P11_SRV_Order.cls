public with sharing class P11_SRV_Order {
   

    public static List<Order> order_WithoutProducts( List<Order> ordList){

    List<Order> ordWithout_prod =[SELECT Id FROM Order WHERE Id IN :ordList AND Status=: System.label.OrderStatus_Draft AND Id NOT IN (SELECT OrderId FROM OrderItem WHERE Product2Id!=null)];
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
    /*
    public static boolean orderHasProducts( Id ordId) {
         
        List <OrderItem> ordItem = [SELECT Id, Product2Id FROM OrderItem WHERE OrderId=: ordId AND Product2Id != null ];
    
        if (ordItem.size()>=1 && ordItem[1].Product2Id != null){ 
            return true;
        }
        else  return false;
    
  }*/
  /*
    public static void deactivate_AccountWithoutOrder (Order ord){
    Id actId =ord.AccountId;
    Account act = [SELECT Id, Active__c FROM Account WHERE Id=: actId];
    List<Order> ords = [SELECT Id FROM Order WHERE AccountId =: actId];
    if (ords.size()==0) {
        if (act.Active__c =='Yes'){
          act.Active__c = 'No';
          update act;
        }
    }
    }*/
}

