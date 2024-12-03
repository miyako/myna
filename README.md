# myna

## Go Build

```
GOOS=darwin GOARCH=amd64 go build -o myna-amd main.go
```

のように`GOARCH=amd64`と指定すると`GOOS=windows`だと勘違いするっぽい  

*Visual Studio Code* をRosettaで開いてもダメ
