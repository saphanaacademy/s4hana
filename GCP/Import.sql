###########################################################
# To be ran using SSH so can get CSV files to HANA Server #
###########################################################

sudo su
[ENTER]
su hxeadm
[ENTER]
mkdir work/shadata
cd work/shadata
wget https://raw.githubusercontent.com/saphanaacademy/s4hana/master/GCP/LISTOFSALESORDERS.CSV
wget https://raw.githubusercontent.com/saphanaacademy/s4hana/master/GCP/INVENTORYTURNOVERANALYSIS.CSV
wget https://raw.githubusercontent.com/saphanaacademy/s4hana/master/GCP/MANAGECUSTOMERITEMS.CSV
wget https://raw.githubusercontent.com/saphanaacademy/s4hana/master/GCP/MATERIALDOCUMENTSOVERVIEW.CSV

cat LISTOFSALESORDERS.CSV
cat INVENTORYTURNOVERANALYSIS.CSV
cat MANAGECUSTOMERITEMS.CSV
cat MATERIALDOCUMENTSOVERVIEW.CSV

##########################################################################################
# To build tables & load data. To be ran using Web-based Development Workbench : Catalog #
##########################################################################################

DROP SCHEMA "ERPDATA" CASCADE;

CREATE SCHEMA "ERPDATA";

CREATE COLUMN TABLE "ERPDATA"."LISTOFSALESORDERS" 
(
  "PONUMBER" NVARCHAR(50), 
  "DOCDATE" DATE CS_DAYDATE, 
  "SALESDOCTY" NVARCHAR(50), 
  "SALESDOC" NVARCHAR(50), 
  "ITEM" BIGINT CS_FIXED, 
  "MATERIAL" NVARCHAR(50), 
  "ORDERQTY" BIGINT CS_FIXED, 
  "SALESUNIT" NVARCHAR(50), 
  "NETVALUE" DECIMAL(10,2) CS_FIXED, 
  "CURRENCY" NVARCHAR(50), 
  "SOLDTOPT" NVARCHAR(50)
) UNLOAD PRIORITY 5  AUTO MERGE ;

IMPORT FROM CSV FILE '/usr/sap/HXE/HDB90/work/shadata/LISTOFSALESORDERS.CSV'
INTO "ERPDATA"."LISTOFSALESORDERS"
WITH
RECORD DELIMITED BY '\n'
FIELD DELIMITED BY ','
OPTIONALLY ENCLOSED BY '"';

CREATE COLUMN TABLE "ERPDATA"."INVENTORYTURNOVERANALYSIS" 
(
	"MATERIAL" NVARCHAR(50), 
	"MATERIAL_DESCRIPTION" NVARCHAR(50), 
	"AVG_INVENTORY_VALUE" DECIMAL(13,2) CS_FIXED, 
	"CURRENCY" NVARCHAR(50), 
	"INV_TURNOVER_FOR_GI" DECIMAL(13,2) CS_FIXED, 
	"COEFF_OF_VARC_FOR_GI" DECIMAL(13,2) CS_FIXED, 
	"INV_TURNOVER_PERIOD" DECIMAL(13,2) CS_FIXED, 
	"ANN_INVENTORY_TURNOVER" DECIMAL(13,2) CS_FIXED, 
	"INV_VALUE_CATGR_NAME" NVARCHAR(50), 
	"AVERAGE_STOCK" DECIMAL(13,2) CS_FIXED, 
	"BASE_UNIT_OF_MEASURE" NVARCHAR(50), 
	"MATERIAL_GROUP" NVARCHAR(50), 
	"MATERIAL_TYPE" NVARCHAR(50), 
	"PLANT" NVARCHAR(50), 
	"COEF_OF_VAR_FOR_CONS" DECIMAL(13,2) CS_FIXED, 
	"ABC_INDICATOR" NVARCHAR(50), 
	"START_DATE" DATE CS_DAYDATE, 
	"END_DATE" DATE CS_DAYDATE
) UNLOAD PRIORITY 5  AUTO MERGE ;

IMPORT FROM CSV FILE '/usr/sap/HXE/HDB90/work/shadata/INVENTORYTURNOVERANALYSIS.CSV'
INTO "ERPDATA"."INVENTORYTURNOVERANALYSIS"
WITH
RECORD DELIMITED BY '\n'
FIELD DELIMITED BY ','
OPTIONALLY ENCLOSED BY '"';

CREATE COLUMN TABLE "ERPDATA"."MANAGECUSTOMERITEMS" 
(
	"CUSTOMER" NVARCHAR(50), 
	"CUSTOMER_NAME" NVARCHAR(50), 
	"COMPANY_CODE" NVARCHAR(50), 
	"COMPANY_NAME" NVARCHAR(50), 
	"FISCAL_YEAR_OF_CLEARING_JOURNAL_ENTRY" BIGINT CS_FIXED, 
	"CL_ST" BIGINT CS_FIXED, 
	"ASSIGNMENT" NVARCHAR(50), 
	"JOURNAL_ENTRY_DATE" DATE CS_DAYDATE, 
	"JOURNAL_ENTRY" NVARCHAR(50), 
	"ITM" BIGINT CS_FIXED, 
	"JOURNAL_ENTRY_TYPE" NVARCHAR(50), 
	"SPECIAL_GL" NVARCHAR(50), 
	"DUE_NET" DECIMAL(13,2) CS_FIXED, 
	"AMOUNT_COCD_CUR" DECIMAL(12,2) CS_FIXED, 
	"LCURR" NVARCHAR(50), 
	"CLEARING_ENTRY" DECIMAL(13,2) CS_FIXED, 
	"FISCAL_YEAR" BIGINT CS_FIXED
) UNLOAD PRIORITY 5  AUTO MERGE ;

IMPORT FROM CSV FILE '/usr/sap/HXE/HDB90/work/shadata/MANAGECUSTOMERITEMS.CSV'
INTO "ERPDATA"."MANAGECUSTOMERITEMS"
WITH
RECORD DELIMITED BY '\n'
FIELD DELIMITED BY ','
OPTIONALLY ENCLOSED BY '"';

CREATE COLUMN TABLE "ERPDATA"."MATERIALDOCUMENTSOVERVIEW" 
(
	"MATERIAL_DOCUMENT" NVARCHAR(50), 
	"MATERIAL_DOCUMENT_YEAR" BIGINT CS_FIXED, 
	"MATERIAL" NVARCHAR(50), 
	"MATERIAL_DESCRIPTION" NVARCHAR(50), 
	"PLANT" NVARCHAR(50), 
	"PLANT_NAME" NVARCHAR(50), 
	"STORAGE_LOCATION" NVARCHAR(50), 
	"STORAGE_LOC_NAME" NVARCHAR(50), 
	"POSTING_DATE" DATE CS_DAYDATE, 
	"STOCK_TYPE" BIGINT CS_FIXED, 
	"SHORT_DESCRIPT" NVARCHAR(50), 
	"MATERIAL_DOC_ITEM" BIGINT CS_FIXED, 
	"STOCK_CHANGE" DECIMAL(13,2) CS_FIXED
) UNLOAD PRIORITY 5  AUTO MERGE ;

IMPORT FROM CSV FILE '/usr/sap/HXE/HDB90/work/shadata/MATERIALDOCUMENTSOVERVIEW.CSV'
INTO "ERPDATA"."MATERIALDOCUMENTSOVERVIEW"
WITH
RECORD DELIMITED BY '\n'
FIELD DELIMITED BY ','
OPTIONALLY ENCLOSED BY '"';

##############################################################################
# To build the OData Services using Web-based Development Workbench : Editor #
##############################################################################

-- create package, ie. googlecloudcontest

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

service namespace "ERP_SERVICES"
{
"ERPDATA"."INVENTORYTURNOVERANALYSIS" as "INVENTORYTURNOVERANALYSIS"
  key generate local "GenID"
  create forbidden update forbidden delete forbidden;
}

service namespace "ERP_SERVICES"
{
"ERPDATA"."MANAGECUSTOMERITEMS" as "MANAGECUSTOMERITEMS"
  key generate local "GenID"
  create forbidden update forbidden delete forbidden;
}

service namespace "ERP_SERVICES"
{
"ERPDATA"."MATERIALDOCUMENTSOVERVIEW" as "MATERIALDOCUMENTSOVERVIEW"
  key generate local "GenID"
  create forbidden update forbidden delete forbidden;
}

-- Sample OData Queries
http://???:8090/googlecloudcontest/ERP_SERVICES/services.xsodata/
http://???:8090/googlecloudcontest/ERP_SERVICES/services.xsodata/$metadata
http://???:8090/googlecloudcontest/ERP_SERVICES/services.xsodata/SALESORDERS?$top=5
