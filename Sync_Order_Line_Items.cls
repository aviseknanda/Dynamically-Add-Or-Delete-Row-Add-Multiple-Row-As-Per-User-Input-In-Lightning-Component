public with sharing class Sync_Order_Line_Items {
	@AuraEnabled
	public static void saveOrderLineItem(List<Order_Line_Item__c > oliList){
		Insert oliList;
	}
	@AuraEnabled
	public static String getPrimaryMarket(String recordId){
		String primaryMarket;
		Set<String> marketPlaces = new Set<String> {'AE','SA','BR','NL','SG'};
		List<AC__c> adCampaign = [SELECT Id, Market__c FROM AC__c WHERE Id = :recordId LIMIT 1];
		if(adCampaign.size() != 0 && marketPlaces.contains(adCampaign[0].Market__c)) {
			primaryMarket = adCampaign[0].Market__c;
		}
		return primaryMarket;
	}
	// Get the OrderLine Name From the Picklist
	@AuraEnabled
	public static Map<String, String> getLineItemName(){
		Map<String, String> options = new Map<String, String>();
		Schema.DescribeFieldResult fieldResult = Order_Line_Item__c.Select_the_Package_Name__c.getDescribe();
		List<Schema.PicklistEntry> pList = fieldResult.getPicklistValues();
		for (Schema.PicklistEntry p: pList) {
			options.put(p.getValue(), p.getLabel());
		}
		return options;
	}
}