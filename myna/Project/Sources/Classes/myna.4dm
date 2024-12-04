Class extends _CLI

property text : Object

Class constructor($controller : 4D:C1709.Class)
	
	Super:C1705("myna"; $controller=Null:C1517 ? cs:C1710._myna_Controller : $controller)
	
Function terminate()
	
	This:C1470.controller.terminate()
	
Function getDigestInfo($data : Variant) : 4D:C1709.Blob
	
	var $src; $digest; $digestInfo : Blob
	
	Case of 
		: (Value type:C1509($data)=Is text:K8:3)
			CONVERT FROM TEXT:C1011($data; "utf-8-no-bom"; $src)
		: (Value type:C1509($data)=Is BLOB:K8:12) || ((Value type:C1509($data)=Is object:K8:27) && (OB Instance of:C1731($data; 4D:C1709.Blob)))
			$src:=$data
		: (Value type:C1509($data)=Is object:K8:27) && (OB Instance of:C1731($data; 4D:C1709.File)) && ($data.exists)
			$src:=$data.getContent()
	End case 
	
	//$algorithm:=SHA256 digest
	$algorithm:=SHA512 digest:K66:5
	
	$parameters_absent:=False:C215
	
	var $hash : Text
	$hash:=Generate digest:C1147($src; $algorithm)
	
	SET BLOB SIZE:C606($digest; Length:C16($hash)/2)
	ARRAY LONGINT:C221($pos; 0)
	ARRAY LONGINT:C221($len; 0)
	var $i; $n : Integer
	$i:=1
	$n:=0
	While (Match regex:C1019("([:hex_digit:]{2})"; $hash; $i; $pos; $len))
		$digest{$n}:=Formula from string:C1601("0x"+Substring:C12($hash; $pos{1}; $len{1})).call()
		$i:=$pos{1}+$len{1}
		$n+=1
	End while 
	
	SET BLOB SIZE:C606($digestInfo; 19+BLOB size:C605($digest))
	
	COPY BLOB:C558($digest; $digestInfo; 0; BLOB size:C605($digestInfo)-BLOB size:C605($digest); BLOB size:C605($digest))
	
	$digestInfo{0}:=0x0030  //SEQUENCE
	$digestInfo{1}:=0x0031  //length[49]
	
	//digestAlgorithm
	$digestInfo{2}:=0x0030  //SEQUENCE
	$digestInfo{3}:=0x000D  //length[13]
	
	//algorithm
	$digestInfo{4}:=0x0006  //OID
	$digestInfo{5}:=0x0009  //length[9]
	Case of 
		: ($algorithm=SHA256 digest:K66:4)
			
			$digestInfo{6}:=0x0060
			$digestInfo{7}:=0x0086
			$digestInfo{8}:=0x0048
			$digestInfo{9}:=0x0001
			$digestInfo{10}:=0x0065
			$digestInfo{11}:=0x0003
			$digestInfo{12}:=0x0004
			$digestInfo{13}:=0x0002
			$digestInfo{14}:=0x0001
			
		: ($algorithm=SHA512 digest:K66:5)
			
			$digestInfo{6}:=0x002A
			$digestInfo{7}:=0x0086
			$digestInfo{8}:=0x0048
			$digestInfo{9}:=0x0086
			$digestInfo{10}:=0x00F7
			$digestInfo{11}:=0x000D
			$digestInfo{12}:=0x0001
			$digestInfo{13}:=0x0001
			$digestInfo{14}:=0x000D
			
	End case 
	
	//parameters 
	$digestInfo{15}:=0x0005  //NULL
	$digestInfo{16}:=0x0000  //length[0]
	//digest
	$digestInfo{17}:=0x0004  //OCTET STRING
	$digestInfo{18}:=BLOB size:C605($digest)  //length
	
	return $digestInfo
	
Function get worker() : 4D:C1709.SystemWorker
	
	return This:C1470._controller.worker
	
Function get controller()->$controller : cs:C1710._myna_Controller
	
	$controller:=This:C1470._controller
	
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
					: ($option="--@") || (Match regex:C1019("-[a-z]"; $option))
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
	
Function version() : Text
	
	$command:=This:C1470.escape(This:C1470.executablePath)
	$command+=" --version"
	
	This:C1470.controller.execute($command)
	If (OB Instance of:C1731(This:C1470.controller; cs:C1710._mynaUI_Controller))
		This:C1470.controller.action:="version"
	Else 
		This:C1470.worker.wait()
		$version:=Split string:C1554(This:C1470.data; This:C1470.EOL; sk trim spaces:K86:2 | sk ignore empty strings:K86:1)
		return $version.length#0 ? $version[0] : ""
	End if 
	
Function text_mynumber($pin4 : Text) : Text
	
	This:C1470.controller.pin4:=$pin4
	
	This:C1470.perform(["text"; "mynumber"; "-p"; $pin4])
	If (OB Instance of:C1731(This:C1470.controller; cs:C1710._mynaUI_Controller))
		This:C1470.controller.action:="text_mynumber"
	Else 
		This:C1470.worker.wait()
		If (This:C1470.controller._stdOut.length#0)
			return This:C1470.controller._stdOut[0]
		End if 
	End if 
	
Function text_cert($pin4 : Text) : 4D:C1709.Blob
	
	This:C1470.controller.pin4:=$pin4
	
	This:C1470.perform(["text"; "cert"])  //-p not supported
	
	If (OB Instance of:C1731(This:C1470.controller; cs:C1710._mynaUI_Controller))
		This:C1470.controller.action:="text_cert"
		This:C1470.worker.wait()
	Else 
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
	End if 
	
Function text_signature($pin4 : Text) : Object
	
	This:C1470.controller.pin4:=$pin4
	
	This:C1470.perform(["text"; "signature"; "-p"; $pin4])
	
	If (OB Instance of:C1731(This:C1470.controller; cs:C1710._mynaUI_Controller))
		This:C1470.controller.action:="text_signature"
		This:C1470.worker.wait()
	Else 
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
	End if 
	
Function text_attr($pin4 : Text) : Object
	
	This:C1470.controller.pin4:=$pin4
	
	This:C1470.perform(["text"; "attr"; "-p"; $pin4])
	
	If (OB Instance of:C1731(This:C1470.controller; cs:C1710._mynaUI_Controller))
		This:C1470.controller.action:="text_attr"
		This:C1470.worker.wait()
	Else 
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
	End if 
	
Function text_info() : Object
	
	This:C1470.perform(["text"; "info"])
	
	If (OB Instance of:C1731(This:C1470.controller; cs:C1710._mynaUI_Controller))
		This:C1470.controller.action:="text_info"
		This:C1470.worker.wait()
	Else 
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
	End if 
	
Function test() : Object
	
	This:C1470.perform(["test"])
	
	If (OB Instance of:C1731(This:C1470.controller; cs:C1710._mynaUI_Controller))
		This:C1470.controller.action:="test"
		This:C1470.worker.wait()
	Else 
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
	End if 
	
Function visual_photo($pin4 : Text) : Picture
	
	This:C1470.controller.pin4:=$pin4
	
	$file:=Folder:C1567(Temporary folder:C486; fk platform path:K87:2).file(Generate UUID:C1066+".jpg")
	
	This:C1470.perform(["visual"; "photo"; "-o"; $file; "-p"; $pin4])
	
	If (OB Instance of:C1731(This:C1470.controller; cs:C1710._mynaUI_Controller))
		This:C1470.controller.action:="visual_photo"
		This:C1470.controller.file:=$file
	Else 
		This:C1470.worker.wait()
		READ PICTURE FILE:C678($file.platformPath; $jpg)
		$file.delete()
		return $jpg
	End if 
	
Function pin_status() : Object
	
	This:C1470.perform(["pin"; "status"])
	If (OB Instance of:C1731(This:C1470.controller; cs:C1710._mynaUI_Controller))
		This:C1470.controller.action:="pin_status"
	Else 
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
	End if 
	
Function jpki_cert_auth() : Object
	
	This:C1470.perform(["jpki"; "cert"; "auth"])
	
	If (OB Instance of:C1731(This:C1470.controller; cs:C1710._mynaUI_Controller))
		This:C1470.controller.action:="jpki_cert_auth"
	Else 
		This:C1470.worker.wait()
		$attr:={}
		ARRAY LONGINT:C221($pos; 0)
		ARRAY LONGINT:C221($len; 0)
		For each ($_attr; This:C1470.controller._stdErr)
			If (Match regex:C1019("([^:]+):\\s+(.+)"; $_attr; 1; $pos; $len))
				$key:=Substring:C12($_attr; $pos{1}; $len{1})
				$attr[$key]:=Substring:C12($_attr; $pos{2}; $len{2})
			End if 
		End for each 
		return $attr
	End if 
	
Function jpki_cert_sign($pin6 : Text) : Object
	
	This:C1470.controller.pin6:=$pin6
	
	This:C1470.perform(["jpki"; "cert"; "sign"; "-p"; $pin6])
	
	If (OB Instance of:C1731(This:C1470.controller; cs:C1710._mynaUI_Controller))
		This:C1470.controller.action:="jpki_cert_sign"
	Else 
		This:C1470.worker.wait()
		$attr:={}
		ARRAY LONGINT:C221($pos; 0)
		ARRAY LONGINT:C221($len; 0)
		For each ($_attr; This:C1470.controller._stdErr)
			If (Match regex:C1019("([^:]+):\\s+(.+)"; $_attr; 1; $pos; $len))
				$key:=Substring:C12($_attr; $pos{1}; $len{1})
				$attr[$key]:=Substring:C12($_attr; $pos{2}; $len{2})
			End if 
		End for each 
		return $attr
	End if 
	
Function jpki_cms_sign($data : Variant; $pin6 : Text) : 4D:C1709.Blob
	
	var $digestInfo : 4D:C1709.Blob
	$digestInfo:=This:C1470.getDigestInfo($data)
	
	This:C1470.controller.pin6:=$pin6
	
	var $in; $out : 4D:C1709.File
	$in:=Folder:C1567(Temporary folder:C486; fk platform path:K87:2).file(Generate UUID:C1066)
	$out:=Folder:C1567(Temporary folder:C486; fk platform path:K87:2).file(Generate UUID:C1066)
	$path:=$in.path
	
	Case of 
		: (Value type:C1509($data)=Is text:K8:3)
			CONVERT FROM TEXT:C1011($data; "utf-8-no-bom"; $src)
			$in.setContent($src)
		: (Value type:C1509($data)=Is BLOB:K8:12) || ((Value type:C1509($data)=Is object:K8:27) && (OB Instance of:C1731($data; 4D:C1709.Blob)))
			$in.setContent($data)
		: (Value type:C1509($data)=Is object:K8:27) && (OB Instance of:C1731($data; 4D:C1709.File)) && ($data.exists)
			$in:=$data
	End case 
	
	var $sign : Object
	
	This:C1470.perform(["jpki"; "cms"; "sign"; "-f"; "der"; "-m"; "sha256"; "-p"; $pin6; "-i"; $in; "-o"; $out])
	
	This:C1470.worker.wait()
	
	If ($out.exists)
		//$sign:={pem: $out.getText()}
		$sign:=$out.getContent()
		$out.delete()
	Else 
		$sign:={}
		ARRAY LONGINT:C221($pos; 0)
		ARRAY LONGINT:C221($len; 0)
		For each ($_attr; This:C1470.controller._stdErr)
			If (Match regex:C1019("([^:]+):\\s+(.+)"; $_attr; 1; $pos; $len))
				$key:=Substring:C12($_attr; $pos{1}; $len{1})
				$sign[$key]:=Substring:C12($_attr; $pos{2}; $len{2})
			End if 
		End for each 
	End if 
	
	File:C1566($path).delete()
	
	return $sign