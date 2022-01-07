/**
     * @author:MarwaAbroud marwa-majdoub@hotmail.com
     * @description: Service class called from the trigger in order to verify the orders and their associated accounts
     * @date:27/12/2021
     */
public with sharing class P11_SRV_Order {

    /**
     * @author:MarwaAbroud marwa-majdoub@hotmail.com
     * @description: select and return orders that have no products
     */
    public static List<Order> order_WithoutProducts( List<Order> ordList){

        List<Order> ordWithout_prod =[SELECT Id FROM Order WHERE Id IN :ordList AND Id NOT IN (SELECT OrderId FROM OrderItem WHERE Product2Id!=null)];
        return ordWithout_prod;
    }

    /**
     * @author:MarwaAbroud marwa-majdoub@hotmail.com
     * @description: select parent accounts of orders and deactivate accounts that no longer have orders
     */
    public static void deactivate_Account_WithoutOrder(List<Order> ordlist){
         //Select AccountId from Order
       set<id> accountsIds = new set<id>();
        for(Order ord: ordlist){
            accountsIds.add(ord.AccountId);
        }

        //Desactivate Accounts without Orders
       List<Account> accountToUpdate = new List<Account>();
       for (Account act : [SELECT Id, Active__c FROM Account WHERE Id IN :accountsIds AND Id NOT IN (SELECT AccountId FROM Order)]){
           if (act.Active__c == 'Yes'){
               act.Active__c = 'No';
               accountToUpdate.add(act);
            }
        } 
        update accountToUpdate;

    }
}

