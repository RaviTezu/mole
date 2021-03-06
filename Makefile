LDFLAGS := -X main.version=$(version)

.install:
	@go install github.com/davrodpin/mole/cmd/mole
.bin:
ifeq ($(version),)
	$(error usage: make bin version=X.Y.Z)
endif
	GOOS=darwin GOARCH=amd64 go build -o bin/mole -ldflags "$(LDFLAGS)" github.com/davrodpin/mole/cmd/mole
	cd bin && tar c mole | gzip > mole$(version).darwin-amd64.tar.gz && rm mole && cd -
	GOOS=linux GOARCH=amd64 go build -o bin/mole -ldflags "$(LDFLAGS)" github.com/davrodpin/mole/cmd/mole
	cd bin && tar c mole | gzip > mole$(version).linux-amd64.tar.gz && rm mole && cd -
test:
	@go test ./... -race -coverprofile=coverage.txt -covermode=atomic
.cover: test
	go tool cover -html=coverage.txt

