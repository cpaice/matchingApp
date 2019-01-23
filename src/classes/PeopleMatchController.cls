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
        Contact userContact = [SELECT Id,ProfilePhoto__c,Name,Title,Account.Name FROM Contact WHERE Id = :contactId];
        return userContact;
    }

    @AuraEnabled
    public static List<Contact> getContactsToMatch() {
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
                                    AND Id NOT IN
                                    (SELECT Matched_Contact__c FROM Contact_Match__c WHERE Owning_Contact__c = :contactId)];
        return contacts;
    }
}