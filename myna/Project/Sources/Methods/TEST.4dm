//%attributes = {}
$pin4:=Folder:C1567(fk home folder:K87:24).file("pin4").getText()
$pin6:=Folder:C1567(fk home folder:K87:24).file("pin6").getText()

var $myna : cs:C1710.myna
$myna:=cs:C1710.myna.new()

//$version:=$myna.version()
//$mynumber:=$myna.text_mynumber($pin4)
//$photo:=$myna.visual_photo($pin4)
//SET PICTURE TO PASTEBOARD($photo)
//$attr:=$myna.text_attr($pin4)
//$status:=$myna.pin_status()
//$info:=$myna.text_info()
//$test:=$myna.test()
//$signature:=$myna.text_signature($pin4)
//$cert:=$myna.text_cert($pin4)
//$auth:=$myna.jpki_cert_auth()
//$sign:=$myna.jpki_cert_sign($pin6)

//$sign:=$myna.jpki_cms_sign("abcde"; $pin6)
//pkcs7: cannot convert encryption algorithm to oid, unknown private key type libmyna.JPKISignSigner
