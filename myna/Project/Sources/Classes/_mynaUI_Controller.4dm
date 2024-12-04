Class extends _myna_Controller

Class constructor($CLI : cs:C1710._CLI)
	
	Super:C1705($CLI)
	
Function onDataError($worker : 4D:C1709.SystemWorker; $params : Object)
	
	Super:C1706.onDataError($worker; $params)
	
Function onData($worker : 4D:C1709.SystemWorker; $params : Object)
	
	Super:C1706.onData($worker; $params)
	
Function onResponse($worker : 4D:C1709.SystemWorker; $params : Object)
	
	Super:C1706.onResponse($worker; $params)
	
	If (Form:C1466#Null:C1517)
		Case of 
			: (This:C1470.action="jpki_cert_sign")
				$attr:={}
				ARRAY LONGINT:C221($pos; 0)
				ARRAY LONGINT:C221($len; 0)
				For each ($_attr; This:C1470._stdErr)
					If (Match regex:C1019("([^:]+):\\s+(.+)"; $_attr; 1; $pos; $len))
						$key:=Substring:C12($_attr; $pos{1}; $len{1})
						$attr[$key]:=Substring:C12($_attr; $pos{2}; $len{2})
					End if 
				End for each 
				Form:C1466.jpki_cert_sign:=$attr
			: (This:C1470.action="jpki_cert_auth")
				$attr:={}
				ARRAY LONGINT:C221($pos; 0)
				ARRAY LONGINT:C221($len; 0)
				For each ($_attr; This:C1470._stdErr)
					If (Match regex:C1019("([^:]+):\\s+(.+)"; $_attr; 1; $pos; $len))
						$key:=Substring:C12($_attr; $pos{1}; $len{1})
						$attr[$key]:=Substring:C12($_attr; $pos{2}; $len{2})
					End if 
				End for each 
				Form:C1466.jpki_cert_auth:=$attr
			: (This:C1470.action="text_cert")
				var $data : Blob
				ARRAY LONGINT:C221($pos; 0)
				ARRAY LONGINT:C221($len; 0)
				If (Match regex:C1019("cert:\\s&\\{\\[(.+)\\]\\}"; This:C1470.instance.data; 1; $pos; $len))
					$values:=Split string:C1554(Substring:C12(This:C1470.instance.data; $pos{1}; $len{1}); " ")
					SET BLOB SIZE:C606($data; $values.length)
					$i:=0
					For each ($value; $values)
						$data{$i}:=Num:C11($value)
						$i+=1
					End for each 
				End if 
				BASE64 ENCODE:C895($data; $text_signature)
				Form:C1466.text_cert:=$text_signature
			: (This:C1470.action="text_signature")
				$attr:={}
				ARRAY LONGINT:C221($pos; 0)
				ARRAY LONGINT:C221($len; 0)
				For each ($_attr; This:C1470._stdOut)
					If (Match regex:C1019("([^:]+):\\s+(.+)"; $_attr; 1; $pos; $len))
						$key:=Substring:C12($_attr; $pos{1}; $len{1})
						$attr[$key]:=Substring:C12($_attr; $pos{2}; $len{2})
					End if 
				End for each 
				Form:C1466.text_signature:=$attr
			: (This:C1470.action="test")
				$attr:={}
				ARRAY LONGINT:C221($pos; 0)
				ARRAY LONGINT:C221($len; 0)
				$i:=1
				While (Match regex:C1019("\\s*([^:\\n\\r]+):\\s+(.+)"; This:C1470.instance.data; $i; $pos; $len))
					$key:=Substring:C12(This:C1470.instance.data; $pos{1}; $len{1})
					$attr[$key]:=Substring:C12(This:C1470.instance.data; $pos{2}; $len{2})
					$i:=$pos{2}+$len{2}
				End while 
				Form:C1466.test:=$attr
			: (This:C1470.action="text_info")
				$attr:={}
				ARRAY LONGINT:C221($pos; 0)
				ARRAY LONGINT:C221($len; 0)
				For each ($_attr; This:C1470._stdOut)
					If (Match regex:C1019("([^:]+):\\s+(.+)"; $_attr; 1; $pos; $len))
						$key:=Substring:C12($_attr; $pos{1}; $len{1})
						$attr[$key]:=Substring:C12($_attr; $pos{2}; $len{2})
					End if 
				End for each 
				Form:C1466.text_info:=$attr
			: (This:C1470.action="text_attr")
				$attr:={}
				ARRAY LONGINT:C221($pos; 0)
				ARRAY LONGINT:C221($len; 0)
				For each ($_attr; This:C1470._stdOut)
					If (Match regex:C1019("([^:]+):\\s+(.+)"; $_attr; 1; $pos; $len))
						$key:=Substring:C12($_attr; $pos{1}; $len{1})
						$attr[$key]:=Substring:C12($_attr; $pos{2}; $len{2})
					End if 
				End for each 
				Form:C1466.text_attr:=$attr
			: (This:C1470.action="pin_status")
				$attr:={}
				ARRAY LONGINT:C221($pos; 0)
				ARRAY LONGINT:C221($len; 0)
				For each ($_attr; This:C1470._stdOut)
					If (Match regex:C1019("([^:]+):\\s+(.+)"; $_attr; 1; $pos; $len))
						$key:=Substring:C12($_attr; $pos{1}; $len{1})
						$attr[$key]:=Substring:C12($_attr; $pos{2}; $len{2})
					End if 
				End for each 
				Form:C1466.pin_status:=$attr
			: (This:C1470.action="visual_photo")
				READ PICTURE FILE:C678(This:C1470.file.platformPath; $jpg)
				Form:C1466.visual_photo:=$jpg  //JPEG2000
				This:C1470.file.delete()
			: (This:C1470.action="version")
				$version:=Split string:C1554(This:C1470.instance.data; This:C1470.instance.EOL; sk trim spaces:K86:2 | sk ignore empty strings:K86:1)
				Form:C1466.version:=$version.length#0 ? $version[0] : ""
			: (This:C1470.action="text_mynumber")
				If (This:C1470._stdOut.length#0)
					Form:C1466.text_mynumber:=Form:C1466.obscure(This:C1470._stdOut[0])
				End if 
		End case 
	End if 
	
Function onTerminate($worker : 4D:C1709.SystemWorker; $params : Object)