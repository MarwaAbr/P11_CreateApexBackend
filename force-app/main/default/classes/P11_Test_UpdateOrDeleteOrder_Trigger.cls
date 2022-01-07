/**
* @author:MarwaAbroud marwa-majdoub@hotmail.com
* @description: Test class for the Trigger "UpdateOrDeleteOrder.trigger"
* @date:28/12/2022
*/
@isTest
private class P11_Test_UpdateOrDeleteOrder_Trigger {
    /**
    * @author:MarwaAbroud marwa-majdoub@hotmail.com
    * @description: Testing the activation of an order that does not have a product
    */
    @isTest 
    static void updateStatus_OrderWithoutProducts (){
        Order ord =P11_DataFactory.createOrder_WithoutProducts();
        Test.startTest();
        ord.Status =System.label.OrderStatus_Activated;
        Database.SaveResult result = Database.update (ord, false);  
        Test.stopTest();
        Order ord1 = [SELECT Id, Status FROM Order LIMIT 1];
        //Asssert that the activation of order is blocked and an error is made
        System.assertEquals(ord1.Status, System.label.OrderStatus_Draft);
        System.assert (!result.isSuccess());
        System.assert (result.getErrors().size() > 0);
        System.assertEquals(System.label.MessageErreurOrderHasProduct,
                         result.getErrors()[0].getMessage());
    }  

    /**
    * @author:MarwaAbroud marwa-majdoub@hotmail.com
    * @description: Testing the activation of 200 orders that do not have a product
    */ 
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

        //Asssert that the activation of all orders is blocked and an error is made for each order
        for (Order ord: [SELECT Status FROM Order]){

            System.assertEquals(ord.Status, System.label.OrderStatus_Draft);
        }
        for (Database.SaveResult result : results){
            System.assert (!result.isSuccess());
            System.assert (result.getErrors().size() > 0);
            System.assertEquals(System.label.MessageErreurOrderHasProduct, result.getErrors()[0].getMessage());
        }
    } 
    
    /**
    * @author:MarwaAbroud marwa-majdoub@hotmail.com
    * @description: Testing the activation of an order that has products
    */ 
    @isTest 
    static void updateStatus_OrderWithProducts (){
        Order ord =P11_DataFactory.createOrder_WithProduct();
        Test.startTest();
        ord.Status =System.label.OrderStatus_Activated;
        Database.SaveResult result = Database.update (ord, false); 
        Test.stopTest();
        //Asssert that the activation  is validated and no errors are made 
        Order ord1 =[SELECT Id, Status FROM Order LIMIT 1];
        System.assertEquals(ord1.Status, System.label.OrderStatus_Activated);
        System.assert (result.isSuccess());
        System.assert (result.getErrors().size() == 0);

    } 

    /**
    * @author:MarwaAbroud marwa-majdoub@hotmail.com
    * @description: Test Deletion of an Order whose parent Account does not have other Orders
    */
    @isTest 
    static void delete_Order_AccountWithoutOthersOrder (){
        Order ord = P11_DataFactory.createOrder_WithoutProducts();
        Account act1 = [SELECT Id, Active__c FROM Account LIMIT 1];
        act1.Active__c='Yes';
        update act1;
        Test.startTest();
        //deletion of the Order
        delete ord;
        Test.stopTest();
        //Asssert that the Account is deactivated
        Account act2 = [SELECT Id, Active__c FROM Account LIMIT 1];
        System.assertEquals (act2.Active__c ,'No');
    }  

    /**
    * @author:MarwaAbroud marwa-majdoub@hotmail.com
    * @description: Test Deletion of an Order whose parent Account has another Order
    */
    @isTest 
    static void delete_Order_AccountWithOthersOrder (){
        List<Order> ords = P11_DataFactory.createOrders_WithoutProducts(2);
        Account act1 = [SELECT Id, Active__c FROM Account LIMIT 1];
        act1.Active__c='Yes';
        update act1;
        Test.startTest();
        //deletion of one order among two
        delete ords[0];
        Test.stopTest();
        //Asssert that the Account remained Active.
        Account act2 = [SELECT Id, Active__c FROM Account LIMIT 1];
        System.assertEquals (act2.Active__c ,'Yes');
    } 
    
    /**
    * @author:MarwaAbroud marwa-majdoub@hotmail.com
    * @description: Test Deletion of 200 orders whose the parent account has no other orders
    */
    @isTest 
    static void delete_AllOrder_AccountWithoutOtherOrder (){
        List<Order> ords = P11_DataFactory.createOrders_WithoutProducts(200);
        Account act1 = [SELECT Id, Active__c FROM Account LIMIT 1];
        act1.Active__c='Yes';
        update act1;
        Test.startTest();
        //delation of all orders
        delete ords;
        Test.stopTest();
        //Asssert that the parent Account is deactivated.
        Account act2 = [SELECT Id, Active__c FROM Account LIMIT 1];
        System.assertEquals (act2.Active__c ,'No');
    }
    
    /**
    * @author:MarwaAbroud marwa-majdoub@hotmail.com
    * @description: Test Deletion of 200 orders whose parents accounts has no other orders
    */
    @isTest 
    static void delete_Orders_AccountsWithoutOtherOrder (){
        List<Order> ords = P11_DataFactory.createAccounts_WithOrders_WithoutProducts(200, 1);
        List<Account> actList = [SELECT Id, Active__c FROM Account];
        for (Account act: actList){
            act.Active__c='Yes';
        }
        update actList;
        Test.startTest();
        //deletion of all Orders
        delete ords;
        Test.stopTest();
        //Assert that all Account are deactivated
        List<Account> actList1 = [SELECT Id, Active__c FROM Account];
        for (Account act1 :actList1){
            System.assertEquals (act1.Active__c ,'No');
        }  
    }  
}
