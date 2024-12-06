Class extends _Form

Class constructor
	
	Super:C1705()
	
	$window:=Open form window:C675("myna")
	DIALOG:C40("myna"; This:C1470; *)
	
Function onLoad()
	
	Form:C1466.myna:=cs:C1710.myna.new(cs:C1710._mynaUI_Controller)
	
	Form:C1466.getSecrets()
	
	If (Is Windows:C1573)
		//.jp2 not supported
		OBJECT SET ENABLED:C1123(*; "visual_photo"; False:C215)
	End if 
	
Function onUnload()
	
	Form:C1466.myna.terminate()
	
Function getSecrets()
	
	//ここに4桁暗証番号を保存している前提
	Form:C1466.pin4File:=Folder:C1567(fk home folder:K87:24).file("pin4")
	
	//ここに6+桁暗証番号を保存している前提
	Form:C1466.pin6File:=Folder:C1567(fk home folder:K87:24).file("pin6")
	
	return Form:C1466
	
Function obscure($in : Variant) : Text
	
	return Value type:C1509($in)=Is text:K8:3 ? "*"*Length:C16($in) : ""