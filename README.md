![version](https://img.shields.io/badge/version-20%2B-E23089)
![platform](https://img.shields.io/static/v1?label=platform&message=mac-intel%20|%20mac-arm%20|%20win-64&color=blue)
[![license](https://img.shields.io/github/license/miyako/myna)](LICENSE)
![downloads](https://img.shields.io/github/downloads/miyako/myna/total)

# myna

マイナンバーカードの読み取り

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

* Windows版は待ち受け処理で固まるので`0.5.0`を使用
* Windows版は`.jp2`画像がサポートされていないので顔写真取得は不可
* 署名は`pkcs`エラーが返されるので不可
 
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

<img src="https://github.com/user-attachments/assets/2903fbd9-63af-4dac-a94b-5529e0fac2cd" width=500 height=auto />

<img src="https://github.com/user-attachments/assets/f6dac935-66c1-4ef5-a0c1-2f436887f5a0" width=500 height=auto />

### 謝辞

http://eswg.jnsa.org/matsuri/201711/20171101-P1-hamano.pdf
