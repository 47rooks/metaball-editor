# Building from Source

## Prerequisites

Have a Haxe install configured for the right environment, in this case Windows.

## Submodules

All submodules are in `libs\` directory. Once you clone the repo and create a `.haxelib` you will need to point build hxcpp and lime from scratch and install them as dev haxelibs. All other libs can be installed directly as dev haxelibs.

## Build from Scratch

Clone project
```
cd <project parent directory>
git clone --resursive https://github.com/47rooks/metaball-editor.git
```
Create a project specific haxelib
```
cd metaball-editor
haxelib newrepo
```

Build hxcpp and lime from the libs submodule
```
haxelib dev hxcpp libs\hxcpp
haxelib dev hxp libs\hxp
haxelib dev format libs\format
haxelib dev lime libs\lime
haxelib run lime rebuild tools

Hit y to rebuild the hxcpp tools.

haxelib run lime rebuild hl
```

Install all remaining libs dependencies as dev deps.

```
haxelib dev openfl libs\openfl
haxelib dev haxeui-core libs\haxeui-core
haxelib dev haxeui-flixel libs\haxeui-flixel
haxelib dev flixel libs\flixel
haxelib dev flixel-addons libs\flixel-addons
haxelib dev formula libs\formula
haxelib dev polygonal-ds libs\polygonal-ds
```

Finally build the metaball-editor project, either in VSCode or from the shell
```
haxelib run lime test hl
```

## References

### Lime
https://github.com/openfl/lime#building-from-source

### On submodules
https://gist.github.com/gitaarik/8735255

https://stackoverflow.com/questions/1777854/how-can-i-specify-a-branch-tag-when-adding-a-git-submodule

