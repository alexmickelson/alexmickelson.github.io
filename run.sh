#!/bin/bash
export JEKYLL_VERSION=3.8
docker run --rm \
  --volume="$PWD:/srv/jekyll" \
  --volume="$PWD/vendor/bundle:/usr/local/bundle" \
  jekyll/jekyll:$JEKYLL_VERSION \
  jekyll build
docker run --rm \
  --volume="$PWD:/srv/jekyll" \
  --volume="$PWD/vendor/bundle:/usr/local/bundle" \
  -p 4000:4000 \
  jekyll/jekyll:$JEKYLL_VERSION \
  jekyll serve

# docker run --rm --volume="$PWD:/srv/jekyll" --volume="$PWD/assets/css/rougify.css:/assets/css/rougify.css" --volume="$PWD/vendor/bundle:/usr/local/bundle" -it jekyll/jekyll bash
# rougify style github > /assets/css/rougify.css
# rougify help style