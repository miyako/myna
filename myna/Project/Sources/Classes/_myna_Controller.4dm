Class extends _CLI_Controller

property _stdOUt : Collection
property _stdErr : Collection

Class constructor($CLI : cs:C1710._CLI)
	
	Super:C1705($CLI)
	
	This:C1470.init()
	
Function init() : cs:C1710._myna_Controller
	
	This:C1470._stdOut:=[]
	This:C1470._stdErr:=[]
	
	return This:C1470
	
Function onData($worker : 4D:C1709.SystemWorker; $params : Object)
	
	If ($worker.dataType="text")
		This:C1470._stdOut.combine(Split string:C1554($params.data; This:C1470.instance.EOL; sk ignore empty strings:K86:1))
	End if 
	
Function onDataError($worker : 4D:C1709.SystemWorker; $params : Object)
	
	If ($worker.dataType="text")
		This:C1470._stdErr.combine(Split string:C1554($params.data; This:C1470.instance.EOL; sk ignore empty strings:K86:1))
		Case of 
			: ($params.data="Error:@")
				This:C1470.worker.terminate()
			: ($params.data="署名用パスワード(6-16桁): ") && (This:C1470.pin6#Null:C1517)
				This:C1470.worker.postMessage(This:C1470.pin6+"\r")
			: ($params.data="暗証番号(4桁): ") && (This:C1470.pin4#Null:C1517)
				This:C1470.worker.postMessage(This:C1470.pin4+"\r")
			: (Match regex:C1019("[*]+"; $params.data))
			Else 
				
		End case 
	End if 
	
Function onResponse($worker : 4D:C1709.SystemWorker; $params : Object)
	
	This:C1470.instance.data:=$worker.response
	
Function onError($worker : 4D:C1709.SystemWorker; $params : Object)
	
Function onTerminate($worker : 4D:C1709.SystemWorker; $params : Object)
	