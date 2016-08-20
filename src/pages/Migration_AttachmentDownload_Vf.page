<apex:page controller="Migration_AttachmentDownload_Ctrl" contentType="application/vnd.csv#{!selectedParent}_download.csv" cache="true" >{!header}
     <apex:repeat value="{!listMigrationObject}" var="obj">
     {!obj.attObject.Name},{!obj.attObject.Id},{!obj.attObject.ContentType},{!obj.attObject.Parent.Type},{!obj.attObject.ParentId},{!obj.attObject.Owner.Name},{!obj.attObject.Owner.Id}, {!obj.attObject.Owner.isActive},{!obj.isConverted},{!obj.contentObject.Title},{!obj.contentObject.Id}
     </apex:repeat>
 </apex:page>
