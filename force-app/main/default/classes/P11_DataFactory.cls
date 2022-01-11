/**
* @author:MarwaAbroud marwa-majdoub@hotmail.com
* @description: Generate data for tests
* @date:04/01/2022 
*/
@isTest
public with sharing class P11_DataFactory {

   /**
     * @author:MarwaAbroud marwa-majdoub@hotmail.com
     * @description: create a number of Accounts with a number of Orders without Products
     */
    public static List<Order> createAccounts_WithOrders_WithoutProducts(Integer actNumber,Integer ordNumber){
       List<Account> actList = new List<Account> ();
        for (Integer i=0; i<actNumber; i++) {
        Account act = new Account(Name='actTest'+i);
        actList.add(act);
       }
       insert actList;
       List<Order> ordList = new List<Order>();
       if(ordNumber>0){
           List<Contract> contrList = new List<Contract>();
           for (Integer j=0;j<actNumber;j++) {
                Account acct = actList[j];
                Contract contract = new Contract (AccountId=acct.Id, StartDate=System.today(), ContractTerm =1, Status ='Draft');
                contrList.add(contract);
                for (Integer k=0; k<ordNumber; k++){
                    Order ord = new Order (AccountId=contract.AccountId, ContractId=contract.Id, Status = 'Draft', EffectiveDate = System.today());
                    ordList.add (ord);
                } 
            }
            insert contrList;
            for (Contract contr: contrList){
             contr.Status ='Activated';
            }
            update contrList;  
        }
        insert ordList;

        return ordList;
    }

    /**
     * @author:MarwaAbroud marwa-majdoub@hotmail.com
     * @description: create an Order with a Product
     */
    public static Order createOrder_WithProduct(){
        PricebookEntry pbe =  creatProduct ();
        Account act = new Account(Name='actTest');
        insert act;
        Contract contract = new Contract (AccountId=act.Id, StartDate=System.today(), ContractTerm =1, Status ='Draft');
        insert contract;
        contract.Status = 'Activated';
        update contract;
        Order ord = new Order (AccountId=act.Id, ContractId=contract.Id, Status = 'Draft', EffectiveDate = System.today(), Pricebook2Id =pbe.Pricebook2Id);
        insert ord;
        OrderItem ordI =new OrderItem (OrderId = ord.Id, PricebookEntryId = pbe.Id, Quantity=20, UnitPrice = 1000);
        insert ordI;
        return ord;
    }

    /**
     * @author:MarwaAbroud marwa-majdoub@hotmail.com
     * @description: Create a number of Accounts
     */
    public static List<Account> createAccounts(Integer actNumber){
        List<Account> actList = new List<Account> ();
        for (Integer i=0; i<actNumber; i++) {
            Account act = new Account(Name='actTest'+i);
            actList.add(act);
        }
       insert actList;
       return actList;
    }
    
    /**
     * @author:MarwaAbroud marwa-majdoub@hotmail.com
     * @description: this method is called in this class to create a product in an Order
     */
    private static PricebookEntry creatProduct (){
    Product2 pd1 = new Product2(Name = 'Chemise Verte longue XYX', Family = 'Chemise');
    Insert pd1;
    //Create the PricebookEntry
    PricebookEntry pbe = new PricebookEntry(
        Pricebook2Id = Test.getStandardPricebookId(),
        Product2Id = pd1.Id,
        UnitPrice = 1020,
        IsActive = true);
    insert pbe;
    return pbe;
   } 
}
