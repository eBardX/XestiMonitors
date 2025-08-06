.PHONY: all build clean lint reset test update

all: clean update build

build:
	@ swift build -c release

clean:
	@ swift package clean

lint:
	@ swiftlint lint --fix
	@ swiftlint lint

reset:
	@ swift package reset

test:
	@ swift test --enable-code-coverage

update:
	@ swift package update
