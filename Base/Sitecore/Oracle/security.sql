CREATE TABLE "RolesInRoles"(
        "Id" CHAR(32) DEFAULT (SYS_GUID()) NOT NULL,
        "MemberRoleName" NVARCHAR2(256) NULL,
        "TargetRoleName" NVARCHAR2(256) NULL,
        "ApplicationName" NVARCHAR2(256) NULL,
        "Created" TIMESTAMP(6) NOT NULL
)
/

CREATE INDEX ndxRolesInRolesMembers ON "RolesInRoles" ("MemberRoleName")
/

CREATE INDEX ndxRolesInRolesTarget ON "RolesInRoles" ("TargetRoleName")
/



CREATE TABLE "aspnet_Applications"(
        "ApplicationName" NVARCHAR2(256) NULL,
        "LoweredApplicationName" NVARCHAR2(256) NULL,
        "ApplicationId" CHAR(32)  DEFAULT (SYS_GUID()) NOT NULL PRIMARY KEY,
        "Description" NVARCHAR2(256) NULL
)
/

CREATE UNIQUE INDEX aspnet_Applications_Index ON "aspnet_Applications" ("LoweredApplicationName")
/



CREATE TABLE "aspnet_Membership"(
        "ApplicationId" CHAR(32) NOT NULL,
        "UserId" CHAR(32)  NOT NULL PRIMARY KEY,
        "Password" NVARCHAR2(128) NULL,
        "PasswordFormat" NUMBER(10,0) DEFAULT 0 NOT NULL,
        "PasswordSalt" NVARCHAR2(128) NULL,
        "MobilePIN" NVARCHAR2(16) NULL,
        "Email" NVARCHAR2(256) NULL,
        "LoweredEmail" NVARCHAR2(256) NULL,
        "PasswordQuestion" NVARCHAR2(256) NULL,
        "PasswordAnswer" NVARCHAR2(128) NULL,
        "IsApproved" NUMBER(10,0) NOT NULL,
        "IsLockedOut" NUMBER(10,0) NOT NULL,
        "CreateDate" TIMESTAMP(6) NOT NULL,
        "LastLoginDate" TIMESTAMP(6) NOT NULL,
        "LastPasswordChangedDate" TIMESTAMP(6) NOT NULL,
        "LastLockoutDate" TIMESTAMP(6) NOT NULL,
        "FailedPwdTryCount" NUMBER(10,0) NOT NULL,
        "FailedPwdTryWindowStart" TIMESTAMP(6) NOT NULL,
        "FailedPwdAnswerTryCount" NUMBER(10,0) NOT NULL,
        "FailedPwdAnswerTryWindowStart" TIMESTAMP(6) NOT NULL,
        "Comment" NCLOB NULL
)
/

CREATE INDEX aspnet_Membership_index ON "aspnet_Membership" ("ApplicationId", "LoweredEmail")
/


CREATE TABLE "aspnet_Paths"(
        "ApplicationId" CHAR(32) NOT NULL,
        "PathId" CHAR(32)  DEFAULT (SYS_GUID()) NOT NULL PRIMARY KEY,
        "Path" NVARCHAR2(256) NULL,
        "LoweredPath" NVARCHAR2(256) NULL
)
/

CREATE UNIQUE INDEX aspnet_Paths_index ON "aspnet_Paths" ("ApplicationId", "LoweredPath")
/


CREATE TABLE "aspnet_PersonalizationAllUsers"(
        "PathId" CHAR(32)  NOT NULL PRIMARY KEY,
        "PageSettings" BLOB NULL,
        "LastUpdatedDate" TIMESTAMP(6) NOT NULL
)
/


CREATE TABLE "aspnet_PersonalizationPerUser"(
        "Id" CHAR(32)  DEFAULT (SYS_GUID()) NOT NULL PRIMARY KEY,
        "PathId" CHAR(32) NULL,
        "UserId" CHAR(32) NULL,
        "PageSettings" BLOB NULL,
        "LastUpdatedDate" TIMESTAMP(6) NOT NULL
)
/

CREATE UNIQUE INDEX aspnet_PersPerUser_index1 ON "aspnet_PersonalizationPerUser" ("PathId", "UserId")
/



CREATE TABLE "aspnet_Profile"(
        "UserId" CHAR(32)  NOT NULL PRIMARY KEY,
        "PropertyNames" NCLOB NULL,
        "PropertyValuesString" NCLOB NULL,
        "PropertyValuesBinary" BLOB NULL,
        "LastUpdatedDate" TIMESTAMP(6) NOT NULL
)
/



CREATE TABLE "aspnet_Roles"(
        "ApplicationId" CHAR(32) NOT NULL,
        "RoleId" CHAR(32)  DEFAULT (SYS_GUID()) NOT NULL PRIMARY KEY,
        "RoleName" NVARCHAR2(256) NULL,
        "LoweredRoleName" NVARCHAR2(256) NULL,
        "Description" NVARCHAR2(256) NULL
)
/

CREATE UNIQUE INDEX aspnet_Roles_index1 ON "aspnet_Roles" ("ApplicationId", "LoweredRoleName")
/



CREATE TABLE "aspnet_SchemaVersions"(
        "Feature" NVARCHAR2(128) NULL,
        "CompatibleSchemaVersion" NVARCHAR2(128) NULL,
        "IsCurrentVersion" NUMBER(10,0) NOT NULL,
        PRIMARY KEY ("Feature", "CompatibleSchemaVersion")
)
/


CREATE TABLE "aspnet_Users"(
        "ApplicationId" CHAR(32) NOT NULL,
        "UserId" CHAR(32)  DEFAULT (SYS_GUID()) NOT NULL PRIMARY KEY,
        "UserName" NVARCHAR2(256) NULL,
        "LoweredUserName" NVARCHAR2(256) NULL,
        "MobileAlias" NVARCHAR2(16) NULL,
        "IsAnonymous" NUMBER(10,0) DEFAULT 0 NOT NULL,
        "LastActivityDate" TIMESTAMP(6) NOT NULL
)
/

CREATE INDEX aspnet_Users_Index2 ON "aspnet_Users" ("ApplicationId", "LastActivityDate")
/


CREATE TABLE "aspnet_UsersInRoles"(
        "UserId" CHAR(32) NOT NULL,
        "RoleId" CHAR(32) NOT NULL,
  PRIMARY KEY ( "UserId",   "RoleId")
)
/

CREATE INDEX aspnet_UsersInRoles_index ON "aspnet_UsersInRoles" ("RoleId")
/



CREATE TABLE "aspnet_WebEvent_Events"(
        "EventId" NVARCHAR2(32) PRIMARY KEY NULL,
        "EventTimeUtc" TIMESTAMP(6) NOT NULL,
        "EventTime" TIMESTAMP(6) NOT NULL,
        "EventType" NVARCHAR2(256) NULL,
        "EventSequence" NUMBER(19, 0) NOT NULL,
        "EventOccurrence" NUMBER(19, 0) NOT NULL,
        "EventCode" NUMBER(10,0) NOT NULL,
        "EventDetailCode" NUMBER(10,0) NOT NULL,
        "Message" NVARCHAR2(1024) NULL,
        "ApplicationPath" NVARCHAR2(256) NULL,
        "ApplicationVirtualPath" NVARCHAR2(256) NULL,
        "MachineName" NVARCHAR2(256) NULL,
        "RequestUrl" NVARCHAR2(1024) NULL,
        "ExceptionType" NVARCHAR2(256) NULL,
        "Details" NCLOB NULL
)
/


 CREATE VIEW "view_aspnet_Applications"
  AS SELECT "aspnet_Applications"."ApplicationName", "aspnet_Applications"."LoweredApplicationName", "aspnet_Applications"."ApplicationId", "aspnet_Applications"."Description"
  FROM "aspnet_Applications"
  
/
  
  
 CREATE VIEW "view_aspnet_MembershipUsers"
  AS SELECT "aspnet_Membership"."UserId",
            "aspnet_Membership"."PasswordFormat",
            "aspnet_Membership"."MobilePIN",
            "aspnet_Membership"."Email",
            "aspnet_Membership"."LoweredEmail",
            "aspnet_Membership"."PasswordQuestion",
            "aspnet_Membership"."PasswordAnswer",
            "aspnet_Membership"."IsApproved",
            "aspnet_Membership"."IsLockedOut",
            "aspnet_Membership"."CreateDate",
            "aspnet_Membership"."LastLoginDate",
            "aspnet_Membership"."LastPasswordChangedDate",
            "aspnet_Membership"."LastLockoutDate",
            "aspnet_Membership"."FailedPwdTryCount",
            "aspnet_Membership"."FailedPwdTryWindowStart",
            "aspnet_Membership"."FailedPwdAnswerTryCount",
            "aspnet_Membership"."FailedPwdAnswerTryWindowStart",
            "aspnet_Membership"."Comment",
            "aspnet_Users"."ApplicationId",
            "aspnet_Users"."UserName",
            "aspnet_Users"."MobileAlias",
            "aspnet_Users"."IsAnonymous",
            "aspnet_Users"."LastActivityDate"
  FROM "aspnet_Membership" INNER JOIN "aspnet_Users"
      ON "aspnet_Membership"."UserId" = "aspnet_Users"."UserId"
/
      
      
CREATE VIEW "view_aspnet_Profiles"
  AS SELECT "aspnet_Profile"."UserId", "aspnet_Profile"."LastUpdatedDate",
      LENGTH("aspnet_Profile"."PropertyNames")
                 + LENGTH("aspnet_Profile"."PropertyValuesString")
                 + LENGTH("aspnet_Profile"."PropertyValuesBinary") as "DataSize"
  FROM "aspnet_Profile"
/

CREATE VIEW "view_aspnet_Roles"
  AS SELECT "aspnet_Roles"."ApplicationId", "aspnet_Roles"."RoleId", "aspnet_Roles"."RoleName", "aspnet_Roles"."LoweredRoleName", "aspnet_Roles"."Description"
  FROM "aspnet_Roles"
/
  
CREATE VIEW "view_aspnet_Users"
  AS SELECT "aspnet_Users"."ApplicationId", "aspnet_Users"."UserId", "aspnet_Users"."UserName", "aspnet_Users"."LoweredUserName", "aspnet_Users"."MobileAlias", "aspnet_Users"."IsAnonymous", "aspnet_Users"."LastActivityDate"
  FROM "aspnet_Users"
/
  
CREATE VIEW "view_aspnet_UsersInRoles"
  AS SELECT "aspnet_UsersInRoles"."UserId", "aspnet_UsersInRoles"."RoleId"
  FROM "aspnet_UsersInRoles"
/
  
CREATE VIEW "view_aspnet_WPS_Paths"
  AS SELECT "aspnet_Paths"."ApplicationId", "aspnet_Paths"."PathId", "aspnet_Paths"."Path", "aspnet_Paths"."LoweredPath"
  FROM "aspnet_Paths"
/
  
CREATE VIEW "view_aspnet_WPS_Shared"
  AS SELECT "aspnet_PersonalizationAllUsers"."PathId", LENGTH("aspnet_PersonalizationAllUsers"."PageSettings") AS "DataSize", "aspnet_PersonalizationAllUsers"."LastUpdatedDate"
  FROM "aspnet_PersonalizationAllUsers"
/
  
CREATE VIEW "view_aspnet_WPS_User"
  AS SELECT "aspnet_PersonalizationPerUser"."PathId", "aspnet_PersonalizationPerUser"."UserId", LENGTH("aspnet_PersonalizationPerUser"."PageSettings") AS "DataSize", "aspnet_PersonalizationPerUser"."LastUpdatedDate"
  FROM "aspnet_PersonalizationPerUser"
/
exit
