@isTest
private class P11_Test_UpdateAndDeleteOrder_Trigger {
    
    @isTest 
    static void updateStatus_OrderWithoutProducts (){
        Order ord =P11_DataFactory.createOrder_WithoutProducts();
        Test.startTest();
        ord.Status =System.label.OrderStatus_Activated;
        Database.SaveResult result = Database.update (ord, false);  
        Test.stopTest();
        System.assert (!result.isSuccess());
        System.assert (result.getErrors().size() > 0);
        System.assertEquals('Please enter products before activating your Order.',
                         result.getErrors()[0].getMessage());
    }   

    @isTest 
    static void updateStatus_OrdersWithoutProducts (){
        List<Order> ordList=P11_DataFactory.createOrders_WithoutProducts(200);
        List<Order> ordToUpdate = new List<Order> ();
        Test.startTest();
        for (Order ord: ordList){
            ord.Status =System.label.OrderStatus_Activated;
            ordToUpdate.add(ord);
        }
        Database.SaveResult[] results = Database.Update(ordToUpdate, false);
        Test.stopTest();

    
        for (Database.SaveResult result : results){
            System.assert (!result.isSuccess());
            System.assert (result.getErrors().size() > 0);
            System.assertEquals('Please enter products before activating your Order.', result.getErrors()[0].getMessage());
        }
    }  

    @isTest 
    static void updateStatus_OrderWithProducts (){
        Order ord =P11_DataFactory.createOrder_WithProduct();
        Test.startTest();
        ord.Status =System.label.OrderStatus_Activated;
        Database.SaveResult result = Database.update (ord, false); 
        Test.stopTest();
        System.assert (result.isSuccess());
        System.assert (result.getErrors().size() == 0);

    }  

   @isTest 
    static void delete_Order_AccountWithoutOthersOrder (){
        Order ord = P11_DataFactory.createOrder_WithoutProducts();
       // Order ord = [SELECT Id FROM Order];
        Account act1 = [SELECT Id, Active__c FROM Account LIMIT 1];
        act1.Active__c='Yes';
        update act1;
        Test.startTest();
        delete ord;
        Test.stopTest();
        Account act2 = [SELECT Id, Active__c FROM Account LIMIT 1];
        System.assertEquals (act2.Active__c ,'No');
    }  

    @isTest 
    static void delete_Order_AccountWithOthersOrder (){
        List<Order> ords = P11_DataFactory.createOrders_WithoutProducts(2);
        Account act1 = [SELECT Id, Active__c FROM Account LIMIT 1];
        act1.Active__c='Yes';
        update act1;
        Test.startTest();
        delete ords[0];
        Test.stopTest();
        Account act2 = [SELECT Id, Active__c FROM Account LIMIT 1];
        System.assertEquals (act2.Active__c ,'Yes');
    }  
    @isTest 
    static void delete_AllOrder_AccountWithoutOtherOrder (){
        List<Order> ords = P11_DataFactory.createOrders_WithoutProducts(200);
        Account act1 = [SELECT Id, Active__c FROM Account LIMIT 1];
        act1.Active__c='Yes';
        update act1;
        Test.startTest();
        delete ords;
        Test.stopTest();
        Account act2 = [SELECT Id, Active__c FROM Account LIMIT 1];
        System.assertEquals (act2.Active__c ,'No');
    }  
    @isTest 
    static void delete_Orders_AccountsWithoutOtherOrder (){
        List<Order> ords = P11_DataFactory.createOrders_WithoutProducts_Accounts(200, 1);
        List<Account> actList = [SELECT Id, Active__c FROM Account];
        for (Account act: actList){
            act.Active__c='Yes';
        }
        update actList;
        Test.startTest();
        delete ords;
        Test.stopTest();
        List<Account> actList1 = [SELECT Id, Active__c FROM Account];
        for (Account act1 :actList1){
            System.assertEquals (act1.Active__c ,'No');
        }
        
    }  
   
}
