@isTest
public class Sync_Order_Line_Items_Test {
    @IsTest(SeeAllData=true)
    static void accountOpp() {
        
        Map<String, RecordType> recTypes = new Map<String, RecordType>();
        for (RecordType recType : 
             [SELECT SobjectType, Id, Name 
              FROM RecordType WHERE SobjectType = 'Account']) {
                  recTypes.put(recType.Name, recType);
              }
        Account testAcct = new Account(
            Name = 'Test Advertiser BE', Active__c = 'Active',
            BillingStreet = '2010 7777th Ave.', Market__c = 'US',
            BillingCity = 'Seattle', BillingState = 'Washington', 
            BillingCountry = 'United States', BillingPostalCode = '98109',
            Billing_Email_Address__c = 'test@test-advertuser-be.com',
            Billing_Company_Name__c = 'Test Advertiser BE',
            RecordTypeId = recTypes.get('Advertiser').Id);
        insert testAcct;
        
        Account testAcct2 = new Account(
            Name = 'Advertiser BE 2 Tester', Active__c = 'Active', 
            BillingStreet = '2011 7878th Ave.', Market__c = 'US',
            BillingCity = 'Seattle', BillingState = 'Washington', 
            BillingCountry = 'United States', BillingPostalCode = '98109',
            Billing_Company_Name__c = 'Test Advertiser BE2 Tester',
            RecordTypeId = recTypes.get('Advertiser').Id);
        insert testAcct2;
        
        Billing_Entity__c entity = new Billing_Entity__c(
            Advertiser__c = testAcct.Id,
            Amazon_Entity__c = 'US', Billing_Party__c = 'Advertiser');
        insert entity;
        
        Opportunity testOpp = new Opportunity(
            Name = 'Test Opp', AccountId = testAcct.Id, 
            StageName='Prospecting', 
            CloseDate = Date.today().addDays(30),
            Validation_Bypass__c = Datetime.now(),
            Market__c = 'SA',
            Billing_Entity__c = entity.Id);
        insert testOpp;
        
        AC__c adCampaign = new AC__c(
            Name = 'Test AC',
            Opportunity__c = testOpp.Id
        );
        insert adCampaign;
        
        Order_Line_Item__c  oliInsert = new Order_Line_Item__c (
            Name = 'UAE Package',
            Start_Date__c = date.today(),
            Ad_Campaign__c = adCampaign.Id
        );
        insert oliInsert;
        
        List<Order_Line_Item__c> items = 
	        new List<Order_Line_Item__c>{
	    	    new Order_Line_Item__c(
	    	         Name = 'Item 1', Line_Item_Name__c = 'Item 1',
	    	         Line_Item_Id__c = '1', Allocation_Percent__c = 0.5,
	    	         Floor_Price__c = 0.00001, Goal_Price__c = 0.0002,
	    	         Gross_Unit_Cost__c = 0.00005, 
	    	         Net_Cost__c = 0.005, Net_Unit_Cost__c = 0.005,
	    	         Rate_Card_Price__c = 0.001, 
	    	         Unit_Cost_Before_Discounts__c = 0.006,
		             Unit_Cost_Before_Discounts_with_Premium__c = 0.007,
		             Production_Quantity__c = 2, Quantity__c = 3,
		             Sort_Order__c = 1, Total_Discount__c = 0.001,
		             Property__c = 'IMDb', Product_Type__c = 'Standard', 
		             Creative_Spec__c = 'spec', Product__c ='IMDb ATF'),
		        new Order_Line_Item__c(
	    	         Name = 'Item 2', Line_Item_Name__c = 'Item 2',
	    	         Line_Item_Id__c = '2', Allocation_Percent__c = 0.5,
	    	         Floor_Price__c = 0.00001, Goal_Price__c = 0.0002,
	    	         Gross_Unit_Cost__c = 0.00005, 
	    	         Net_Cost__c = 0.005, Net_Unit_Cost__c = 0.005,
	    	         Rate_Card_Price__c = 0.001, 
	    	         Unit_Cost_Before_Discounts__c = 0.006,
		             Unit_Cost_Before_Discounts_with_Premium__c = 0.007,
		             Production_Quantity__c = 2, Quantity__c = 3,
		             Sort_Order__c = 2, Total_Discount__c = 0.001,
		             Archived__c = false,
		             Property__c = 'IMDb', Product_Type__c = 'Standard', 
		             Creative_Spec__c = 'spec', Product__c ='IMDb BTF'),
		        new Order_Line_Item__c(
	    	         Name = 'Item 3', Line_Item_Name__c = 'Item 3',
	    	         Line_Item_Id__c = '3', Allocation_Percent__c = 0.5,
	    	         Floor_Price__c = 0.00001, Goal_Price__c = 0.0002,
	    	         Gross_Unit_Cost__c = 0.00005, 
	    	         Net_Cost__c = 0.005, Net_Unit_Cost__c = 0.005,
	    	         Rate_Card_Price__c = 0.001, 
	    	         Unit_Cost_Before_Discounts__c = 0.006,
		             Unit_Cost_Before_Discounts_with_Premium__c = 0.007,
		             Production_Quantity__c = 2, Quantity__c = 3,
		             Sort_Order__c = 1, Total_Discount__c = 0.001,
		             Archived__c = false,
		             Property__c = 'IMDb', Product_Type__c = 'Standard', 
		             Creative_Spec__c = 'spec', Product__c ='IMDb Detail')
	        };
        
        String pageSize = '10'; 
        String pageNumber = '1';
        
        // When
        Test.startTest();
        Sync_Order_Line_Items.getPrimaryMarket(adCampaign.id);
        Sync_Order_Line_Items.getLineItemName();
        Sync_Order_Line_Items.fetchOrderLineItems(oliInsert.id, pageSize, pageNumber);
        Sync_Order_Line_Items.saveOrderLineItem(items);
        Sync_Order_Line_Items.updateOLI(items);
        Test.stopTest();
    }
}