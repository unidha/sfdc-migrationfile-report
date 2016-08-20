public with sharing class Migration_AttachmentReport_Ctrl {
	
	public String selectedParent{get;set;} 
	public List<Attachment> listAttachment =new List<Attachment>();
	public List<MigrationObject> listMigrationObject {get;set;}
	
	

	
	public Migration_AttachmentReport_Ctrl(){
	   selectedParent='None';
	}
	
	
	public List<SelectOption> getAttachmentObjects()
      {
            List<SelectOption> options = new List<SelectOption>();
            
            AggregateResult[] listParent =[Select parent.Type parent ,count(Name) totalAtt from Attachment group by Parent.Type];
              options.add(new SelectOption('None','----None----'));
              for(AggregateResult  a: listParent ){
              	   String parent = a.get('parent')!=null?String.valueOf(a.get('parent')):'';
                   options.add(new SelectOption(parent,parent+' ('+String.valueOf(a.get('totalAtt'))+')'));
              	
              }
           
            return options;
      }
      
      public Integer getTotalAttachment(){
      	 Integer countInt =Database.countQuery('select count() from Attachment');
         
         return countInt;
      }
      
      public Integer getTotalInactiveOwner(){
          AggregateResult[] result =[SELECT COUNT_DISTINCT(OwnerId) total from Attachment where Owner.isActive =false];
         Integer countInt=Integer.valueOf(result[0].get('total'));
         return countInt;
      
      
      }
      
  
    public   void retrieveAttachmentReport(){
        if(selectedParent<>'None'){
 
         Map<Id,Attachment> mapAttachment = new Map<Id,Attachment>();
       
        for(Attachment att : [Select Name,Id,ParentId,Parent.Type,Owner.Name,Owner.Id ,Owner.IsActive ,ContentType,isPrivate from Attachment where Parent.Type =:selectedParent ]){
              mapAttachment.put(att.Id,att);
         }
         
         /**List<ContentVersion> listContent = [Select Id, ContentDocumentId, IsLatest, ContentUrl, VersionNumber, Title, Description, ReasonForChange,  Original_Record_ID__c, Original_Record_Owner_ID__c, Original_Record_Parent_ID__c FROM ContentVersion
                                              WHERE Original_Record_ID__c in :mapAttachment.keySet()];
         ****/
                                              
         Map<Id,ContentVersion> mapContentVersion = new Map <Id,ContentVersion>();                                     
         for(ContentVersion c : [Select Id, ContentDocumentId, IsLatest, ContentUrl, VersionNumber, Title, Description, ReasonForChange,  Original_Record_ID__c, Original_Record_Owner_ID__c, Original_Record_Parent_ID__c FROM ContentVersion
                                              WHERE Original_Record_ID__c in :mapAttachment.keySet()]){
         
                mapContentVersion.put(c.Original_Record_ID__c,c);
         
         
         }
         
         List<MigrationObject> listMigObj= new List<MigrationObject>();
         
         for(Id key:mapAttachment.keySet()){
         	  MigrationObject migObj = new MigrationObject();
              migObj.attObject = mapAttachment.get(key);
              if(mapContentVersion.containsKey(key)){
                 migObj.contentObject=mapContentVersion.get(key);
                 migObj.isConverted=true;
              }
              else {
                 migObj.isConverted=false;
              }
              listMigObj.add(migObj);
              
         }
         
         listMigrationObject=listMigObj;
                                              
        }
       
     
    }
    
    public PageReference downloadReport(){
    
      PageReference pageRef = new PageReference('/apex/Migration_AttachmentDownload_Vf');
     //PageReference pageRef = Page.Migration_AttachmentDownload_Vf;
      pageRef.getParameters().put('objectName',selectedParent);
      pageRef.setRedirect(true);
      
      return pageRef;
    
    
    }
    
    public class MigrationObject {
         public Attachment attObject {get;set;}
         public ContentVersion contentObject {get;set;}
         public boolean isConverted {get;set;}
     }
       
       
	
    
}
