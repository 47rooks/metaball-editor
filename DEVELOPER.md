# Building from Source

## Prerequisites

Have a Haxe install configured for the right environment, in this case Windows.

## Installing dev libs and building from scratch

### lime
```
cd <dev stage dir>
git clone --recursive https://github.com/openfl/lime
haxelib newrepo
haxelib dev lime lime

haxelib git format https://github.com/HaxeFoundation/format.git
haxelib git hxp https://github.com/openfl/hxp.git

haxelib git hxcpp https://github.com/HaxeFoundation/hxcpp.git
haxelib dev hxcpp hxcpp

haxelib run lime rebuild tools

Hit y to rebuild the hxcpp tools.

haxelib run lime rebuild hl

```

### openfl

Again in <dev stage dir>
```
git clone https://github.com/openfl/openfl
haxelib dev openfl openfl
haxelib run openfl rebuild tools
```

### In the project

```
haxelib dev lime <dev stage dir>\lime
haxelib git openfl https://github.com/openfl/openfl
haxelib git hxp https://github.com/openfl/hxp
haxelib dev hxcpp <dev stage dir>\hxcpp
haxelib git haxeui-core https://github.com/haxeui/haxeui-core.git
haxelib git haxeui-flixel https://github.com/haxeui/haxeui-flixel.git
haxelib git format https://github.com/HaxeFoundation/format.git
haxelib git flixel https://github.com/HaxeFlixel/flixel master
haxelib git flixel-addons https://github.com/HaxeFlixel/flixel-addons master
haxelib git formula https://github.com/maitag/formula.git
haxelib git polygonal-ds https://github.com/polygonal/ds.git
```

Note, polygonal-ds changed its top level package from polygonal.ds to simply ds, in 2021. This impacts source imports.

## References

https://github.com/openfl/lime#building-from-source
