public class ChurnZero_Helpers {
  public Product_Usage_Panel__c convertJsonStringToPup(String pupId, String jsonString, List < ChurnZero_Field_Transform__c > fieldTransforms) {
    Product_Usage_Panel__c pup = new Product_Usage_Panel__c(Id = pupId, Json_String__c = JSON.serialize(jsonString), Last_Checked_Datetime__c = System.now());
    if (!fieldTransforms.isEmpty()) {
      JSONParse root = new JSONParse(jsonString);
      for (ChurnZero_Field_Transform__c fieldTransform: fieldTransforms) {
        if (root.get(fieldTransform.Root_Path_String__c).getStringValue() != null) {
            if (fieldTransform.Type__c == 'Boolean') {pup.put(fieldTransform.Field_API_Name__c, root.get(fieldTransform.Root_Path_String__c).getBooleanValue());} 
            else if (fieldTransform.Type__c == 'Datetime') {pup.put(fieldTransform.Field_API_Name__c, root.get(fieldTransform.Root_Path_String__c).getDatetimeValue());} 
            else if (fieldTransform.Type__c == 'Double') {pup.put(fieldTransform.Field_API_Name__c, root.get(fieldTransform.Root_Path_String__c).getDoubleValue());} 
            else if (fieldTransform.Type__c == 'String') {pup.put(fieldTransform.Field_API_Name__c, root.get(fieldTransform.Root_Path_String__c).getStringValue());} 
        }
      }
    }
    System.debug('pup: ' + pup);
    return pup;
  }
}
