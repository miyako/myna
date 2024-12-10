//%attributes = {}
$pin4:=Folder:C1567(fk home folder:K87:24).file("pin4").getText()
$pin6:=Folder:C1567(fk home folder:K87:24).file("pin6").getText()

var $myna : cs:C1710.myna
$myna:=cs:C1710.myna.new()

$version:=$myna.version()

