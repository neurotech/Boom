echo "Building Boom and installing to WoW directory."

touch Boom.toc.tmp

cat Boom.toc > Boom.toc.tmp

sed -i "s/@project-version@/$(git describe --abbrev=0)/g" Boom.toc.tmp

mkdir -p /h/games/World\ of\ Warcraft/_classic_/Interface/AddOns/Boom/

cp *.lua *.ogg /h/games/World\ of\ Warcraft/_classic_/Interface/AddOns/Boom/

cp Boom.toc.tmp /h/games/World\ of\ Warcraft/_classic_/Interface/AddOns/Boom/Boom.toc

rm Boom.toc.tmp

echo "Complete."