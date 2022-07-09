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

## Updating Submodules

To update the git submodule, from the project directory do:

```
git submodule update --remote libs/haxeui-core
git commit 'update <submodule> to <commit>'
git push origin main
```

If the haxelib reference was directly to git it now needs to be updated to be a dev reference as above. Otherwise just rebuild.

## Building Lime from Scratch

If necessary you can rebuild lime itself from scratch like this. In a staging dir do this:

```
git clone --recursive https://github.com/openfl/lime
git clone https://github.com/HaxeFoundation/format.git
git clone https://github.com/openfl/hxp.git

cd lime
haxelib newrepo
haxelib dev lime lime
haxelib dev format <stagedir>\format
haxelib dev hxp <stagedir>\hxp
haxelib install hxcpp     <- I don't know how to clone and build this from source properly yet>

haxelib run lime rebuild tools
haxelib run lime rebuild hl
```

## References

### Lime
https://github.com/openfl/lime#building-from-source

### On submodules
https://gist.github.com/gitaarik/8735255

https://stackoverflow.com/questions/1777854/how-can-i-specify-a-branch-tag-when-adding-a-git-submodule

