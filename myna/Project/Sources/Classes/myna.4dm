Class extends _CLI

property text : Object

Class constructor()
	
	Super:C1705("myna"; cs:C1710._myna_Controller)
	
Function get worker() : 4D:C1709.SystemWorker
	
	return This:C1470._controller.worker
	
Function get controller()->$controller : cs:C1710._myna_Controller
	
	$controller:=This:C1470._controller
	
Function _terminate()
	
	This:C1470.controller.terminate()
	
Function version() : Text
	
	$command:=This:C1470.escape(This:C1470.executablePath)
	$command+=" --version"
	
	This:C1470.controller.execute($command)
	This:C1470.worker.wait()
	
	$version:=Split string:C1554(This:C1470.data; This:C1470.EOL; sk trim spaces:K86:2 | sk ignore empty strings:K86:1)
	
	return $version.length#0 ? $version[0] : ""
	
Function perform($options : Collection) : cs:C1710.myna
	
	$command:=This:C1470.escape(This:C1470.executablePath)
	
	var $option : Variant
	For each ($option; $options)
		
		Case of 
			: (Value type:C1509($option)=Is collection:K8:32)
				
				This:C1470.perform($option)
				
			: (Value type:C1509($option)=Is object:K8:27)
				Case of 
					: (OB Instance of:C1731($option; 4D:C1709.File)) || (OB Instance of:C1731($option; 4D:C1709.Folder))
						$command+=" "+This:C1470.escape(This:C1470.expand($option).path)
				End case 
				
			: (Value type:C1509($option)=Is text:K8:3)
				Case of 
					: ($option="--@")
						$command+=" "+$option
					Else 
						$command+=" "+This:C1470.escape($option)
				End case 
				
			Else 
				$command+=" "+This:C1470.escape(String:C10($option))
		End case 
		
	End for each 
	
	This:C1470.controller.init().execute($command)
	
	return This:C1470
	
Function text_mynumber($pin4 : Text) : Text
	
	This:C1470.controller.pin4:=$pin4
	
	This:C1470.perform(["text"; "mynumber"])
	
	This:C1470.worker.wait()
	
	If (This:C1470.controller._stdOut.length#0)
		return This:C1470.controller._stdOut[0]
	End if 
	
Function text_cert($pin4 : Text) : 4D:C1709.Blob
	
	This:C1470.controller.pin4:=$pin4
	
	This:C1470.perform(["text"; "cert"])
	
	This:C1470.worker.wait()
	
	var $data : Blob
	
	ARRAY LONGINT:C221($pos; 0)
	ARRAY LONGINT:C221($len; 0)
	
	If (Match regex:C1019("cert:\\s&\\{\\[(.+)\\]\\}"; This:C1470.data; 1; $pos; $len))
		$values:=Split string:C1554(Substring:C12(This:C1470.data; $pos{1}; $len{1}); " ")
		SET BLOB SIZE:C606($data; $values.length)
		$i:=0
		For each ($value; $values)
			$data{$i}:=Num:C11($value)
			$i+=1
		End for each 
	End if 
	
	return $data
	
Function text_signature($pin4 : Text) : Object
	
	This:C1470.controller.pin4:=$pin4
	
	This:C1470.perform(["text"; "signature"])
	
	This:C1470.worker.wait()
	
	$attr:={}
	
	ARRAY LONGINT:C221($pos; 0)
	ARRAY LONGINT:C221($len; 0)
	
	For each ($_attr; This:C1470.controller._stdOut)
		If (Match regex:C1019("([^:]+):\\s+(.+)"; $_attr; 1; $pos; $len))
			$key:=Substring:C12($_attr; $pos{1}; $len{1})
			$attr[$key]:=Substring:C12($_attr; $pos{2}; $len{2})
		End if 
	End for each 
	
	return $attr
	
Function text_attr($pin4 : Text) : Object
	
	This:C1470.controller.pin4:=$pin4
	
	This:C1470.perform(["text"; "attr"])
	
	This:C1470.worker.wait()
	
	$attr:={}
	
	ARRAY LONGINT:C221($pos; 0)
	ARRAY LONGINT:C221($len; 0)
	
	For each ($_attr; This:C1470.controller._stdOut)
		If (Match regex:C1019("([^:]+):\\s+(.+)"; $_attr; 1; $pos; $len))
			$key:=Substring:C12($_attr; $pos{1}; $len{1})
			$attr[$key]:=Substring:C12($_attr; $pos{2}; $len{2})
		End if 
	End for each 
	
	return $attr
	
Function text_info() : Object
	
	This:C1470.perform(["text"; "info"])
	
	This:C1470.worker.wait()
	
	$attr:={}
	
	ARRAY LONGINT:C221($pos; 0)
	ARRAY LONGINT:C221($len; 0)
	
	For each ($_attr; This:C1470.controller._stdOut)
		If (Match regex:C1019("([^:]+):\\s+(.+)"; $_attr; 1; $pos; $len))
			$key:=Substring:C12($_attr; $pos{1}; $len{1})
			$attr[$key]:=Substring:C12($_attr; $pos{2}; $len{2})
		End if 
	End for each 
	
	return $attr
	
Function test() : Object
	
	This:C1470.perform(["test"])
	
	This:C1470.worker.wait()
	
	$attr:={}
	
	ARRAY LONGINT:C221($pos; 0)
	ARRAY LONGINT:C221($len; 0)
	
	$i:=1
	
	While (Match regex:C1019("\\s*([^:\\n\\r]+):\\s+(.+)"; This:C1470.data; $i; $pos; $len))
		$key:=Substring:C12(This:C1470.data; $pos{1}; $len{1})
		$attr[$key]:=Substring:C12(This:C1470.data; $pos{2}; $len{2})
		$i:=$pos{2}+$len{2}
	End while 
	
	return $attr
	
Function visual_photo($pin4 : Text) : Picture
	
	This:C1470.controller.pin4:=$pin4
	
	$file:=Folder:C1567(Temporary folder:C486; fk platform path:K87:2).file(Generate UUID:C1066+".jpg")
	
	This:C1470.perform(["visual"; "photo"; "-o"; $file])
	
	This:C1470.worker.wait()
	
	READ PICTURE FILE:C678($file.platformPath; $jpg)
	
	$file.delete()
	
	return $jpg
	
Function pin_status() : Object
	
	This:C1470.perform(["pin"; "status"])
	
	This:C1470.worker.wait()
	
	$attr:={}
	
	ARRAY LONGINT:C221($pos; 0)
	ARRAY LONGINT:C221($len; 0)
	
	For each ($_attr; This:C1470.controller._stdOut)
		If (Match regex:C1019("([^:]+):\\s+(.+)"; $_attr; 1; $pos; $len))
			$key:=Substring:C12($_attr; $pos{1}; $len{1})
			$attr[$key]:=Substring:C12($_attr; $pos{2}; $len{2})
		End if 
	End for each 
	
	return $attr
	