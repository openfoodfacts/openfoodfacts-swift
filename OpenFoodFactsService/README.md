curl -s https://api.github.com/repos/openfoodfacts/openfoodfacts-server/contents/docs/api/ref | jq -r '.[].download_url' > file_urls.txt

wget https://raw.githubusercontent.com/openfoodfacts/openfoodfacts-server/main/docs/api/ref/api.yml