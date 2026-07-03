.PHONY: bootstrap gen build test verify screenshots archive release

bootstrap:
	Scripts/bootstrap.sh
gen:
	Scripts/gen.sh
build:
	Scripts/build.sh
test:
	Scripts/test.sh
verify:
	Scripts/verify.sh
screenshots:
	Scripts/screenshots.sh
archive:
	Scripts/archive.sh
release:
	Scripts/release.sh
