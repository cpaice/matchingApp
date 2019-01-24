public with sharing class PeopleMatchController {
    @AuraEnabled
    public static Contact getUserContact() {
        User currentUser = [SELECT Id,ContactId FROM User WHERE Id = :userInfo.getUserId()];
        Id contactId;
        if (currentUser.ContactId == null) {
            contactId = '0031U000006BABiQAO';
        } else {
            contactId = currentUser.ContactId;
        }
        Contact userContact = [SELECT Id,ProfilePhoto__c,Name,Title,Account.Name,Matching_Opt_In__c FROM Contact WHERE Id = :contactId];
        return userContact;
    }

    @AuraEnabled
    public static Contact getContactToMatch() {
        User currentUser = [SELECT Id,ContactId FROM User WHERE Id = :userInfo.getUserId()];
        Id contactId;
        if (currentUser.ContactId == null) {
            contactId = '0031U000006BABiQAO';
        } else {
            contactId = currentUser.ContactId;
        }
        List<Contact> contacts = [SELECT Id,ProfilePhoto__c,Name,Title,Account.Name
                                    FROM Contact
                                    WHERE Matching_Opt_In__c = true
                                    AND Id != :contactId
                                    AND Id NOT IN
                                    (SELECT Matched_Contact__c FROM Contact_Match__c WHERE Owning_Contact__c = :contactId)
                                    LIMIT 1];
        if (contacts.size() == 1) {
            return contacts[0];
        } else {
            return null;
        }
    }

    @AuraEnabled
    public static Integer getMatchPercentage() {
        User currentUser = [SELECT Id,ContactId FROM User WHERE Id = :userInfo.getUserId()];
        Id contactId;
        if (currentUser.ContactId == null) {
            contactId = '0031U000006BABiQAO';
        } else {
            contactId = currentUser.ContactId;
        }
        List<Contact> contacts = [SELECT Id,ProfilePhoto__c,Name,Title,Account.Name
                                    FROM Contact
                                    WHERE Matching_Opt_In__c = true
                                    AND Id != :contactId
                                    AND Id NOT IN
                                    (SELECT Matched_Contact__c FROM Contact_Match__c WHERE Owning_Contact__c = :contactId)];
        List<Contact> allOptedIn = [SELECT Id FROM Contact WHERE Matching_Opt_In__c = true AND Id != :contactId];
        Decimal unmatchedSize = contacts.size();
        Decimal allSize = allOptedIn.size();
        Decimal decNum = unmatchedSize/allSize;
        Integer unmatchedNum = Integer.valueOf(decNum*100);
        return unmatchedNum;
    }

    @AuraEnabled
    public static Map<String,String> getButtonLabelsAndValues() {
        Schema.DescribeFieldResult fieldResult = Contact_Match__c.Relationship_Level__c.getDescribe();
        List<Schema.PicklistEntry> ple = fieldResult.getPicklistValues();
        Map<String,String> options = new Map<String,String>();
        for (Schema.PicklistEntry pe : ple) {
            options.put(pe.getLabel(), pe.getValue());
        }
        return options;
    }

    @AuraEnabled
    public static Contact saveNewContactMatch(String matchedContactId, String relationshipLevel) {
        User currentUser = [SELECT Id,ContactId FROM User WHERE Id = :userInfo.getUserId()];
        Id contactId;
        if (currentUser.ContactId == null) {
            contactId = '0031U000006BABiQAO';
        } else {
            contactId = currentUser.ContactId;
        }
        Contact_Match__c newMatch = new Contact_Match__c(
                Owning_Contact__c = contactId,
                Matched_Contact__c = matchedContactId,
                Relationship_Level__c = relationshipLevel
        );
        //todo add try/catch to handle error presentation
        insert newMatch;
        return getContactToMatch();
    }
}