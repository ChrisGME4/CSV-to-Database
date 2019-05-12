################################################
# Configure variables below for connecting to the SQL database
################################################
$CSVFileName = "C:\Users\Datas.csv"
$SQLInstance = "####"
$SQLDatabase = "####"
$SQLTable = "####"
##############################################
# Prompting for SQL credentials
##############################################
$SQLCredentials = Get-Credential -Message "Enter your SQL username & password"
$SQLUsername = $SQLCredentials.UserName
$SQLPassword = $SQLCredentials.GetNetworkCredential().Password
##############################################
# Start of time taken benchmark
##############################################
$Start = Get-Date
##############################################
# Importing CSV and processing data
##############################################
$CSVImport = Import-CSV $CSVFileName
$CSVRowCount = $CSVImport.Count
##############################################
# ForEach CSV Line Inserting a row into the Temp SQL table
##############################################
"Inserting $CSVRowCount rows from CSV into SQL Table $SQLTable"
ForEach ($CSVLine in $CSVImport)
{
# Setting variables for the CSV line
$CSVProductId = $CSVLine.ProductId
$CSVSpecificationId = $CSVLine.SpecificationId
$CSVValue = $CSVLine.Value
##############################################
# SQL INSERT of CSV Line/Row
##############################################
$SQLInsert = "USE $SQLDatabase
INSERT INTO $SQLTable (ProductId, SpecificationId, Value)
VALUES('$CSVProductId', '$CSVSpecificationId', '$CSVValue m²');"
# Running the INSERT Query
Invoke-SQLCmd -Query $SQLInsert -ServerInstance $SQLInstance -Username $SQLUsername -Password $SQLPassword
# End of ForEach CSV line below
}
# End of ForEach CSV line above
##############################################
# End of time taken benchmark
##############################################
$End = Get-Date
$TimeTaken = New-Timespan -Start $Start -End $End | Select -ExpandProperty TotalSeconds
$TimeTaken = [Math]::Round($TimeTaken, 0)
"CSV Import Finished In $TimeTaken Seconds"
##############################################
# End of script
##############################################
