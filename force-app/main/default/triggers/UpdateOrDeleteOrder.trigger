/**
* @author:MarwaAbroud marwa-majdoub@hotmail.com
* @description: Trigger On Order before update and after delete
* @date:27/12/2021
*/
trigger UpdateOrDeleteOrder on Order (before update, after delete) {

    /**
    *Before the activation of an order, if it does not have a product, 
    *the modification is blocked and an error message is displayed
    */
     if (Trigger.isUpdate) {

        //ordList : the Orders currently updating Status (Draft to Activated)
        List<Order> ordList = new List<Order>();
        for(Order ord: Trigger.new){
            if (Trigger.oldMap.get(ord.Id).Status==System.label.OrderStatus_Draft && Trigger.oldMap.get(ord.Id).Status != ord.Status && ord.Status==System.label.OrderStatus_Activated){
                ordList.add (ord);
            }
       }
        //ordWithout_Prod : Orders that do not have a product among ordList
        List<Order> ordWithout_Prod = P11_SRV_Order.order_WithoutProducts(ordList);
        for (Order ord: ordWithout_Prod){
        Trigger.newMap.get(ord.Id).addError(System.label.MessageErreurOrderHasProduct);
       }

    }
    /**
     *After deleting an order if the associated account has no more order it will be deactivated
     */
    else if (Trigger.isDelete){
       List<Order> ords = Trigger.old;
      P11_SRV_Order.deactivate_Account_WithoutOrder(ords);       
    }
}
