#rm -rf ref
#cp -r ~/Projects/FoodIntake/FoodDatabases/OFF/openfoodfacts-server/docs/api/ref .
cp ./ref/api.yml Sources/openapi.yaml
python process_yamls.py Sources/openapi.yaml
