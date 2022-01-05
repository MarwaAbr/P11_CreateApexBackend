trigger UpdateAndDeleteOrder on Order (before update, after delete) {
    
    if (Trigger.isUpdate) {
   
        List<Order> ordList = new List<Order>();
        for(Order ord: Trigger.new){
            if (Trigger.oldMap.get(ord.Id).Status=='Draft' && Trigger.oldMap.get(ord.Id).Status != ord.Status && ord.Status=='Activated'){
                ordList.add (ord);
            }
       }
      // List<Order> ordWithout_Prod = P11_SRV_Order.order_WithoutProducts(ordList);
       for (Order ord: P11_SRV_Order.order_WithoutProducts(ordList)){

        Trigger.newMap.get(ord.Id).addError(System.label.MessageErreurOrderHasProduct);
       }
       
        /* for (Order ord : [SELECT Id FROM Order WHERE Status= 'Draft' AND Id IN :Trigger.New  AND (Id NOT IN (SELECT OrderId FROM OrderItem))])
        {
            if(Trigger.newMap.get(ord.Id).Status==System.label.OrderStatus_Activated){     
                    Trigger.newMap.get(ord.Id).addError(System.label.MessageErreurOrderHasProduct);
            }
        }*/

    }
    
    else if (Trigger.isDelete){
       List<Order> ords = Trigger.old;
      P11_SRV_Order.deactivate_Account_WithoutOrder(ords);
            
    }
}
