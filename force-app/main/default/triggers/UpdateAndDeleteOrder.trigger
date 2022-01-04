trigger UpdateAndDeleteOrder on Order (before update, after delete) {
    
    if (Trigger.isUpdate) {

        List<Order> ordList = new List<Order>();
        for(Order ord: Trigger.new){
            if (Trigger.oldMap.get(ord.Id).Status != ord.Status){
                ordList.add (ord);
            }
       }
       List<Order> ordWithout_Prod = P11_SRV_Order.order_WithoutProducts(ordList);
       for (Order ord: ordWithout_Prod){

        Trigger.newMap.get(ord.Id).addError(System.label.MessageErreurOrderHasProduct);
       }
       
 /* for (Order ord : [SELECT Id FROM Order WHERE Status= 'Draft' AND Id IN :Trigger.New  AND (Id NOT IN (SELECT OrderId FROM OrderItem))])
        {
          // if(Trigger.oldMap.get(ord.Id).Status == 'Draft' && Trigger.newMap.get(ord.Id).Status==System.label.StatutOrderHasProduct){
            if(Trigger.newMap.get(ord.Id).Status==System.label.OrderStatus_Activated){    
                //if(!P11_SRV_Order.orderHasProducts(ord.Id)){
                    Trigger.newMap.get(ord.Id).addError(System.label.MessageErreurOrderHasProduct);
               //}
            }
        }*/

    }
    
    else if (Trigger.isDelete){
       List<Order> ords = Trigger.old;
      P11_SRV_Order.deactivate_Account_WithoutOrder(ords);
            
    }
}
