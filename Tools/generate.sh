swift run swift-openapi-generator generate \
    --mode types --mode client \
    --output-directory ../OpenFoodFactsService/Sources/ \
    --config ../OpenFoodFactsService/Sources/openapi-generator-config.yaml \
    ../OpenFoodFactsService/Sources/openapi.yaml
