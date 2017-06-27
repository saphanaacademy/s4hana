#######################
# To be ran using SSH #
#######################

sudo su
[ENTER]
su hxeadm
[ENTER]
mkdir work/shadata
cd work/shadata
wget https://raw.githubusercontent.com/saphanaacademy/s4hana/master/GCP/LISTOFSALESORDERS.CSV
cat LISTOFSALESORDERS.CSV

###################################################
# To be ran using Web-based Development Workbench #
###################################################

DROP SCHEMA "ERPDATA" CASCADE;

CREATE SCHEMA "ERPDATA";

CREATE COLUMN TABLE "ERPDATA"."LISTOFSALESORDERS" ("PONUMBER" NVARCHAR(50), "DOCDATE" DATE CS_DAYDATE, "SALESDOCTY" NVARCHAR(50), "SALESDOC" NVARCHAR(50), "ITEM" BIGINT CS_FIXED, "MATERIAL" NVARCHAR(50), "ORDERQTY" BIGINT CS_FIXED, "SALESUNIT" NVARCHAR(50), "NETVALUE" DECIMAL(10,2) CS_FIXED, "CURRENCY" NVARCHAR(50), "SOLDTOPT" NVARCHAR(50)) UNLOAD PRIORITY 5  AUTO MERGE ;
COMMENT ON COLUMN "ERPDATA"."LISTOFSALESORDERS"."PONUMBER" is ' ';
COMMENT ON COLUMN "ERPDATA"."LISTOFSALESORDERS"."DOCDATE" is ' ';
COMMENT ON COLUMN "ERPDATA"."LISTOFSALESORDERS"."SALESDOCTY" is ' ';
COMMENT ON COLUMN "ERPDATA"."LISTOFSALESORDERS"."SALESDOC" is ' ';
COMMENT ON COLUMN "ERPDATA"."LISTOFSALESORDERS"."ITEM" is ' ';
COMMENT ON COLUMN "ERPDATA"."LISTOFSALESORDERS"."MATERIAL" is ' ';
COMMENT ON COLUMN "ERPDATA"."LISTOFSALESORDERS"."ORDERQTY" is ' ';
COMMENT ON COLUMN "ERPDATA"."LISTOFSALESORDERS"."SALESUNIT" is ' ';
COMMENT ON COLUMN "ERPDATA"."LISTOFSALESORDERS"."NETVALUE" is ' ';
COMMENT ON COLUMN "ERPDATA"."LISTOFSALESORDERS"."CURRENCY" is ' ';
COMMENT ON COLUMN "ERPDATA"."LISTOFSALESORDERS"."SOLDTOPT" is ' ';

IMPORT FROM CSV FILE '/usr/sap/HXE/HDB90/work/shadata/LISTOFSALESORDERS.CSV'
INTO "ERPDATA"."LISTOFSALESORDERS"
WITH
RECORD DELIMITED BY '\n'
FIELD DELIMITED BY ','
OPTIONALLY ENCLOSED BY '"';

###############################
# To build the OData Services #
###############################

-- .xsapp
{}

-- .xsaccess
{"exposed": true,"authentication": [{"method" : "Basic"}]}

-- services.xsodata
service namespace "ERP_SERVICES"
{
"ERPDATA"."LISTOFSALESORDERS" as "SALESORDERS"
  key generate local "GenID"
  create forbidden update forbidden delete forbidden;
}
 
-- OData Queries
http://???:8090/ERP_SERVICES/services.xsodata/
http://???:8090/ERP_SERVICES/services.xsodata/$metadata
http://???:8090/ERP_SERVICES/services.xsodata/SALESORDERS?$top=5
