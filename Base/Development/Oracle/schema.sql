/
CREATE TABLE "Descendants"(
	"ID" CHAR(32) NULL,
	"Ancestor" CHAR(32) NOT NULL,
	"Descendant" CHAR(32) NOT NULL,
 CONSTRAINT "Descendants_PK" PRIMARY KEY  
(
	"Ancestor",
	"Descendant"
)
) 
/
CREATE  INDEX "Descendant_Descendants" ON "Descendants" 
(
	"Descendant"
)
/
CREATE TABLE "Links"(
	"ID" CHAR(32) DEFAULT  (SYS_GUID()) NOT NULL,
	"SourceDatabase" NVARCHAR2(50) NULL,
	"SourceItemID" CHAR(32) NOT NULL,
	"SourceLanguage" NVARCHAR2(50) DEFAULT  ('') NULL,
	"SourceVersion" NUMBER(10,0) DEFAULT  ((0)) NOT NULL,
	"SourceFieldID" CHAR(32) NOT NULL,
	"TargetDatabase" NVARCHAR2(50) NULL,
	"TargetItemID" CHAR(32) NOT NULL,
	"TargetLanguage" NVARCHAR2(50) DEFAULT  ('') NULL,
	"TargetPath" NCLOB NULL,
	"TargetVersion" NUMBER(10,0) DEFAULT  ((0)) NOT NULL
)  
/
CREATE UNIQUE  INDEX "ndxID_Links" ON "Links" 
(
	"ID"
)
/
CREATE  INDEX "ndxSourceItemID_Links" ON "Links" 
(
	"SourceItemID"
)
/
CREATE  INDEX "ndxTargetItemID_Links" ON "Links" 
(
	"TargetItemID"
)
/
CREATE TABLE "AccessControl"(
	"Id" CHAR(32) NOT NULL,
	"EntityId" NVARCHAR2(255) NULL,
	"TypeName" NVARCHAR2(255) NULL,
	"AccessRules" NCLOB NULL,
 CONSTRAINT "PK_AccessControl" PRIMARY KEY  
(
	"Id"
)
) 
/
CREATE UNIQUE  INDEX "IX_AccessControl_AccessControl" ON "AccessControl" 
(
	"EntityId",
	"TypeName"
)



/
CREATE TABLE "EventQueue"(
	"Id" CHAR(32) NOT NULL,
	"EventType" NVARCHAR2(256) NULL,
	"InstanceType" NVARCHAR2(256) NULL,
	"InstanceData" NCLOB NULL,
	"InstanceName" NVARCHAR2(128) NULL,
	"RaiseLocally" NUMBER(10,0) NOT NULL,
	"RaiseGlobally" NUMBER(10,0) NOT NULL,
	"UserName" NVARCHAR2(128) NULL,
	"Stamp" NUMBER(20,0) NOT NULL,
	"Created" TIMESTAMP(3)  DEFAULT sysdate NOT NULL 
) 



/
CREATE  INDEX "IX_Stamp_EventQueue" ON "EventQueue" 
(
	"Stamp"
)
/
CREATE TABLE "WorkflowHistory"(
	"ID" CHAR(32) DEFAULT  (SYS_GUID()) NOT NULL,
	"ItemID" CHAR(32) NOT NULL,
	"Language" NVARCHAR2(20) NULL,
	"Version" NUMBER(10,0) NOT NULL,
	"OldState" NVARCHAR2(200) NULL,
	"NewState" NVARCHAR2(200) NULL,
	"Text" NVARCHAR2(2000) NULL,
	"User" NVARCHAR2(100) NULL,
	"Date" TIMESTAMP(3) NOT NULL,
	"Sequence" NUMBER(10,0)  NOT NULL
) 
/
CREATE UNIQUE  INDEX "ndxID_WorkflowHistory" ON "WorkflowHistory" 
(
	"ID"
)
/
CREATE  INDEX "ndxItemID_WorkflowHistory" ON "WorkflowHistory" 
(
	"ItemID"
)
/
CREATE TABLE "Tasks"(
	"ID" CHAR(32) NOT NULL,
	"NextRun" TIMESTAMP(3) NOT NULL,
	"taskType" NVARCHAR2(500) NULL,
	"Parameters" NCLOB NULL,
	"Recurrence" NVARCHAR2(200) NULL,
	"ItemID" CHAR(32) NOT NULL,
	"Database" NVARCHAR2(50) NULL,
	"Pending" NUMBER(10,0) NOT NULL,
	"Disabled" NUMBER(10,0) NOT NULL,
	"InstanceName" NVARCHAR2(128) NULL
)  
/
CREATE UNIQUE  INDEX "ndxID_Tasks" ON "Tasks" 
(
	"ID"
)
/
CREATE TABLE "ClientData"(
	"ID" CHAR(32) DEFAULT  (SYS_GUID()) NOT NULL,
	"SessionKey" NVARCHAR2(50) NULL,
	"Data" NCLOB NULL,
	"Accessed" TIMESTAMP(3) NOT NULL
)  
/
CREATE UNIQUE  INDEX "ndxID_ClientData" ON "ClientData" 
(
	"ID"
)
/
CREATE  INDEX "ndxKey_ClientData" ON "ClientData" 
(
	"SessionKey"
)
/
CREATE TABLE "Properties"(
	"ID" CHAR(32) DEFAULT  (SYS_GUID()) NOT NULL,
	"Key" NVARCHAR2(256) NULL,
	"Value" NCLOB NULL
)  
/
CREATE UNIQUE  INDEX "ndxID_Properties" ON "Properties" 
(
	"ID"
)
/
CREATE  INDEX "ndxKey_Properties" ON "Properties" 
(
	"Key"
)
/
CREATE TABLE "PublishQueue"(
	"ID" CHAR(32) DEFAULT  (SYS_GUID()) NOT NULL,
	"ItemID" CHAR(32) NOT NULL,
	"Language" NVARCHAR2(50) DEFAULT  ('en') NULL,
	"Version" NUMBER(10,0) DEFAULT  (1) NOT NULL,
	"Action" NVARCHAR2(50) DEFAULT  ('') NULL,
	"Date" TIMESTAMP(3) NOT NULL,
	"Index" NUMBER(10,0)  NOT NULL
) 
/
CREATE  INDEX "ndxDate_PublishQueue" ON "PublishQueue" 
(
	"Date"
)
/
CREATE UNIQUE  INDEX "ndxID_PublishQueue" ON "PublishQueue" 
(
	"ID"
)
/
CREATE TABLE "IDTable"(
	"ID" CHAR(32) DEFAULT  (SYS_GUID()) NOT NULL,
	"Prefix" NVARCHAR2(255) NULL,
	"Key" NVARCHAR2(255) NULL,
	"ParentID" CHAR(32) NOT NULL,
	"CustomData" NVARCHAR2(255) NULL
) 
/
CREATE UNIQUE  INDEX "ndxID_IDTable" ON "IDTable" 
(
	"ID"
)
/
CREATE  INDEX "ndxPrefixKey_IDTable" ON "IDTable" 
(
	"Prefix",
	"Key"
)
/
CREATE TABLE "Shadows"(
	"ID" CHAR(32) DEFAULT  (SYS_GUID()) NOT NULL,
	"ProxyID" CHAR(32) NOT NULL,
	"TargetID" CHAR(32) NOT NULL,
	"ShadowID" CHAR(32) NOT NULL
) 
/
CREATE  INDEX "ndxProxyTarget_Shadows" ON "Shadows" 
(
	"ProxyID",
	"TargetID"
)
/
CREATE  INDEX "ndxShadowID_Shadows" ON "Shadows" 
(
	"ShadowID"
)
/
CREATE  INDEX "ndxTargetID_Shadows" ON "Shadows" 
(
	"TargetID"
)
/
CREATE TABLE "SharedFields"(
	"Id" CHAR(32) DEFAULT  (SYS_GUID()) NOT NULL,
	"ItemId" CHAR(32) NOT NULL,
	"FieldId" CHAR(32) NOT NULL,
	"Value" NCLOB NULL,
	"Created" TIMESTAMP(3) NOT NULL,
	"Updated" TIMESTAMP(3) NOT NULL
) 
LOB("Value") STORE AS (ENABLE STORAGE IN ROW CHUNK 4K)
/
CREATE UNIQUE  INDEX "ndxUnique_SharedFields" ON "SharedFields" 
(
	"ItemId",
	"FieldId"
)
/
CREATE TABLE "UnversionedFields"(
	"Id" CHAR(32) DEFAULT  (SYS_GUID()) NOT NULL,
	"ItemId" CHAR(32) NOT NULL,
	"Language" NVARCHAR2(50) NULL,
	"FieldId" CHAR(32) NOT NULL,
	"Value" NCLOB NULL,
	"Created" TIMESTAMP(3) NOT NULL,
	"Updated" TIMESTAMP(3) NOT NULL
) 
LOB("Value") STORE AS (ENABLE STORAGE IN ROW CHUNK 4K)
/
CREATE UNIQUE  INDEX "ndxUnique_UnversionedFields" ON "UnversionedFields" 
(
	"ItemId",
	"Language",
	"FieldId"
)
/
CREATE TABLE "VersionedFields"(
	"Id" CHAR(32) DEFAULT  (SYS_GUID()) NOT NULL,
	"ItemId" CHAR(32) NOT NULL,
	"Language" NVARCHAR2(50) NULL,
	"Version" NUMBER(10,0) NOT NULL,
	"FieldId" CHAR(32) NOT NULL,
	"Value" NCLOB NULL,
	"Created" TIMESTAMP(3) NOT NULL,
	"Updated" TIMESTAMP(3) NOT NULL
) 
LOB("Value") STORE AS (ENABLE STORAGE IN ROW CHUNK 4K)
/
CREATE UNIQUE  INDEX "ndxUnique_VersionedFields" ON "VersionedFields" 
(
	"ItemId",
	"Language",
	"Version",
	"FieldId"
)
/
CREATE TABLE "Items"(
	"ID" CHAR(32) NOT NULL,
	"Name" NVARCHAR2(256) NULL,
	"TemplateID" CHAR(32) NOT NULL,
	"MasterID" CHAR(32) NOT NULL,
	"ParentID" CHAR(32) NOT NULL,
	"Created" TIMESTAMP(3) NOT NULL,
	"Updated" TIMESTAMP(3) NOT NULL
) 
/
CREATE UNIQUE  INDEX "ndxID_Items" ON "Items" 
(
	"ID"
)
/
CREATE  INDEX "ndxName_Items" ON "Items" 
(
	"Name"
)
/
CREATE  INDEX "ndxParentID_Items" ON "Items" 
(
	"ParentID"
)
/
CREATE  INDEX "ndxTemplateID_Items" ON "Items" 
(
	"TemplateID"
)
/
CREATE TABLE "History"(
	"Id" CHAR(32) DEFAULT  (SYS_GUID()) NOT NULL,
	"Category" NVARCHAR2(50) NULL,
	"Action" NVARCHAR2(50) NULL,
	"ItemId" CHAR(32) NOT NULL,
	"ItemLanguage" NVARCHAR2(50) NULL,
	"ItemVersion" NUMBER(10,0) NOT NULL,
	"ItemPath" NCLOB DEFAULT  ('') NULL,
	"UserName" NVARCHAR2(250) NULL,
	"TaskStack" NCLOB DEFAULT  ('') NULL,
	"AdditionalInfo" NCLOB DEFAULT  ('') NULL,
	"Created" TIMESTAMP(3) NOT NULL
) 
/
CREATE  INDEX "ndxCreated_History" ON "History" 
(
	"Created"
)
/
CREATE TABLE "Blobs"(
	"Id" CHAR(32) DEFAULT  (SYS_GUID()) NOT NULL,
	"BlobId" CHAR(32) NOT NULL,
	"Index" NUMBER(10,0) NOT NULL,
	"Data" BLOB NULL,
	"Created" TIMESTAMP(3) NOT NULL
)  
/
CREATE  INDEX "ndxBlobId_Blobs" ON "Blobs" 
(
	"BlobId"
)
/
CREATE TABLE "Archive"(
	"ArchivalId" CHAR(32) NOT NULL,
	"ItemId" CHAR(32) NOT NULL,
	"ParentId" CHAR(32) NOT NULL,
	"Name" NVARCHAR2(256) NULL,
	"OriginalLocation" NCLOB NULL,
	"ArchiveDate" TIMESTAMP(3) NOT NULL,
	"ArchivedBy" NVARCHAR2(50) NULL,
	"ArchiveName" NVARCHAR2(50) NULL,
 CONSTRAINT "PK_Archive" PRIMARY KEY  
(
	"ArchivalId"
)
) 
/
CREATE  INDEX "ndx_ItemId_Archive" ON "Archive" 
(
	"ItemId"
)
/
CREATE TABLE "ArchivedItems"(
	"RowId" CHAR(32) NOT NULL,
	"ArchivalId" CHAR(32) NOT NULL,
	"ItemId" CHAR(32) NOT NULL,
	"Name" NVARCHAR2(256) NULL,
	"TemplateID" CHAR(32) NOT NULL,
	"MasterID" CHAR(32) NOT NULL,
	"ParentID" CHAR(32) NOT NULL,
	"Created" TIMESTAMP(3) NOT NULL,
	"Updated" TIMESTAMP(3) NOT NULL
) 
/
CREATE  INDEX "ndx_ArchivalId_ArchivedItems" ON "ArchivedItems" 
(
	"ArchivalId"
)
/
CREATE TABLE "ArchivedFields"(
	"RowId" CHAR(32) NOT NULL,
	"ArchivalId" CHAR(32) NOT NULL,
	"SharingType" NVARCHAR2(50) NULL,
	"ItemId" CHAR(32) NOT NULL,
	"Language" NVARCHAR2(50) NULL,
	"Version" NUMBER(10,0) NOT NULL,
	"FieldId" CHAR(32) NOT NULL,
	"Value" NCLOB NULL,
	"Created" TIMESTAMP(3) NOT NULL,
	"Updated" TIMESTAMP(3) NOT NULL
) 
/
CREATE  INDEX "ndx_ArchivalId_ArchivedFields" ON "ArchivedFields" 
(
	"ArchivalId"
)

/
CREATE TABLE "Notifications"(
	"Id" CHAR(32) NOT NULL,
	"ItemId" CHAR(32) NOT NULL,
	"Language" NVARCHAR2(50) NULL,
	"Version" NUMBER(10,0) NOT NULL,
	"Processed" NUMBER(10,0) NOT NULL,
	"InstanceType" NVARCHAR2(256) NULL,
	"InstanceData" NCLOB NULL,
	"Created" TIMESTAMP(3) NOT NULL,
 CONSTRAINT "PK_Notifications" PRIMARY KEY  
(
	"Id"
)
) 

/
CREATE GLOBAL TEMPORARY TABLE "TemplateFields" ( "ID" CHAR(32) PRIMARY KEY) ON COMMIT DELETE ROWS
/
CREATE GLOBAL TEMPORARY TABLE "BlobReferences" ( "ID" CHAR(32) ) ON COMMIT DELETE ROWS
/
CREATE INDEX "BlobReferencesID" ON "BlobReferences" ("ID")
/

CREATE VIEW "Fields"
AS
SELECT     "Id", "ItemId", NULL "Language", "FieldId", "Value", "Created", "Updated"
FROM         "SharedFields"
UNION ALL
SELECT     "Id", "ItemId", "Language", "FieldId", "Value", "Created", "Updated"
FROM         "UnversionedFields"
UNION ALL
SELECT     "vf"."Id", "vf"."ItemId", "vf"."Language", "vf"."FieldId", "vf"."Value", "vf"."Created", "vf"."Updated"
FROM         
   "VersionedFields" "vf" 
INNER JOIN (SELECT     "ItemId", "Language", MAX("Version") "Version"
                FROM          "VersionedFields" "vf1"
                GROUP BY "ItemId", "Language") "b"
       ON ("vf"."ItemId" = "b"."ItemId" AND "vf"."Language" = "b"."Language" AND "vf"."Version" = "b"."Version")
/
CREATE SEQUENCE INDEX_SEQ INCREMENT BY 1 START WITH 
    1 MAXVALUE 1.0E28 MINVALUE 1 NOCYCLE 
    CACHE 20 NOORDER
/
CREATE SEQUENCE WORKWFLOW_SEQ INCREMENT BY 1 START WITH 
    1 MAXVALUE 1.0E28 MINVALUE 1 NOCYCLE 
    CACHE 20 NOORDER
/
CREATE SEQUENCE EVENTQUEUE_SEQ INCREMENT BY 1 START WITH 
    1 MAXVALUE 1.0E28 MINVALUE 1 NOCYCLE 
    CACHE 20 NOORDER
/
CREATE OR REPLACE TRIGGER PQINDEX BEFORE
INSERT ON "PublishQueue" FOR EACH ROW 
begin
    if :new."Index" is null then
        select INDEX_SEQ.nextval into :new."Index" from dual;
    end if;
end;
/
CREATE OR REPLACE TRIGGER WORKFLOW_INDEX BEFORE
INSERT ON "WorkflowHistory" FOR EACH ROW 
begin
    if :new."Sequence" is null then
        select WORKWFLOW_SEQ.nextval into :new."Sequence" from dual;
    end if;
end;
/
CREATE OR REPLACE TRIGGER EVENTQUEUE_INSERT BEFORE
INSERT ON "EventQueue" FOR EACH ROW 
begin
    if :new."Stamp" is null then
        select EVENTQUEUE_SEQ.nextval into :new."Stamp" from dual;
    end if;
end;
/
exit

