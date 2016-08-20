
public with sharing class Migration_AttachmentDownload_Ctrl {
	  
	  public  String selectedParent {get;set ;}
	  public   List<MigrationObject> listMigrationObject ;
	  public  String header ;

     public Migration_AttachmentDownload_Ctrl (){
     	 system.debug('@NUR selectedParent '+ApexPages.currentPage().getParameters().get('objectName'));
     	selectedParent=ApexPages.currentPage().getParameters().get('objectName');
     
     
     }
     
     public String getHeader(){
     
           return 'Attachment Name,Attachment Id,Content Type,Object Type,Object ID,Owner Name,Owner Id,Owner isActive,Is Converted,File Name,File Id';
     
     }

	 public   List<MigrationObject> getListMigrationObject(){
     
         
         
         List<Attachment>listAttachment = [Select Name,Id,ParentId,Parent.Type,Owner.Name,Owner.Id ,Owner.IsActive ,ContentType,isPrivate from Attachment where Parent.Type =:selectedParent ];
         Map<Id,Attachment> mapAttachment = new Map<Id,Attachment>();
       
         for(Attachment att : listAttachment){
              mapAttachment.put(att.Id,att);
          }
         
            
         
         List<ContentVersion> listContent = [Select Id, ContentDocumentId, IsLatest, ContentUrl, VersionNumber, Title, Description, ReasonForChange,  Original_Record_ID__c, Original_Record_Owner_ID__c, Original_Record_Parent_ID__c FROM ContentVersion
                                              WHERE Original_Record_ID__c in :mapAttachment.keySet()];
                                              
         Map<Id,ContentVersion> mapContentVersion = new Map <Id,ContentVersion>();                                     
         for(ContentVersion c : listContent){
         
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
         
         return listMigrationObject;
      
    }
    
    

    public class MigrationObject {
         public Attachment attObject {get;set;}
         public ContentVersion contentObject {get;set;}
         public boolean isConverted {get;set;}
     }
       
    
}
