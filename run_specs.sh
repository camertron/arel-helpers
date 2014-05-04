#! /bin/bash

versions=( "~> 3.1.0" "~> 3.2.0" "~> 4.0.0" "~> 4.1.0" )

for i in "${versions[@]}"
do
  export AR="$i"
  echo -e "\nTesting with activerecord $i"
  echo "Bundling..."
  bundle update activerecord > /dev/null
  echo "Running tests..."
  bundle exec rspec
done
