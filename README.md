# myna

[jpki/myna](https://github.com/jpki/myna) wrapper

## Go Build

```
GOOS=darwin GOARCH=amd64 go build -o myna-amd main.go
$Env:GOOS = "darwin"; $Env:GOARCH = "amd64"; go build -o myna-amd main.go
```

のように`GOARCH=amd64`と指定するとリンクエラーになった 

*Visual Studio Code* をRosettaで開いてもダメ

https://github.com/ebfe/scard/blob/master/scard_darwin.go

おそらくIntel Macでビルドすれば良いのだろう

仕方がないので[jpki/myna](https://github.com/jpki/myna/releases)からダウンロードした後

```
xattr -rc
```

で検疫フラグをクリアした後`--entitlements`指定で`codesign`および`xcrun notarytool`
