![version](https://img.shields.io/badge/version-20%2B-E23089)
![platform](https://img.shields.io/static/v1?label=platform&message=mac-intel%20|%20mac-arm%20|%20win-64&color=blue)
[![license](https://img.shields.io/github/license/miyako/myna)](LICENSE)
![downloads](https://img.shields.io/github/downloads/miyako/myna/total)

# myna

## dependencies.json

 ```json
{
    "dependencies": {
        "myna": {
            "github": "miyako/myna",
            "version": "*"
        }
    }
}
```

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

で検疫フラグをクリアした後，`--entitlements`指定で`codesign`および`xcrun notarytool`
