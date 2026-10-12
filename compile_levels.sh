echo "Game.prototype._levels = {" > levels/levels.js

mod=$1
# "default" is the levels/ folder itself (upstream uses a symlink, which breaks on Windows)
if [ "$mod" = "default" ]; then dir=levels; else dir=mods/$mod; fi

for lvl in $dir/*.jsx
do
	lvlfn=`basename $lvl`
	printf %s "    'levels/$lvlfn': '" >> levels/levels.js
	echo "$lvl" | xargs sed "s#\\\#\\\\\\\#g" | sed "s#'#\\\'#g" | tr '\n' '`' | sed "s/\`/\\\n/g" | sed -e "a\\
	',
	" | tr '\n' ' ' >> levels/levels.js
	echo "" >> levels/levels.js # dummy newline for style
done
echo "};" >> levels/levels.js
