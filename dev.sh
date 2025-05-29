export CLASSIC_PATH="/mnt/c/Program Files (x86)/World of Warcraft/_classic_/Interface/AddOns/Boom"
export RETAIL_PATH="/mnt/c/Program Files (x86)/World of Warcraft/_retail_/Interface/AddOns/Boom"

directories=(
    "$CLASSIC_PATH"
    "$RETAIL_PATH"
)

echo "Building Boom and installing to WoW directories."

for dir in "${directories[@]}"; do
  touch Boom.toc.tmp

  cat Boom.toc > Boom.toc.tmp

  sed -i "s/@project-version@/$(git describe --abbrev=0)/g" Boom.toc.tmp

  mkdir -p "$dir"

  cp -r *.lua *.ogg "$dir"

  cp Boom.toc.tmp "$dir"/Boom.toc

  rm Boom.toc.tmp
done

echo "Complete."
