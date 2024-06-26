#!/bin/bash

install_zip_dependencies(){
	echo "Installing and zipping dependencies..."
	mkdir python
	git config --global url."https://${INPUT_GIT_ACCESS_TOKEN}@github.com".insteadOf "https://git@github.com" 
	pip install --prefer-binary --compile --target=python -r "${INPUT_REQUIREMENTS_TXT}"
	if [ -z "${INPUT_LAMBDA_FUNCTION_NAME}" ]
	then
		cp -R "${INPUT_LAMBDA_DIRECTORY}"/* ./python
		rm -rf ./python/.git*
	fi
	
	# Removing biggest packages loaded from different layer
	rm -r ./python/pip*
	rm -r ./python/pkg_resources*
	rm -r ./python/setuptools*
	rm -r ./python/pandas*
	rm -r ./python/numpy*
	
	# Removing nonessential files
	#find ./python -name '*.so' -type f -exec strip "{}" \;
	find ./python -wholename "*/tests/*" -type f -delete
	find ./python -wholename "*/docs/*" -type f -delete
	find ./python -regex '^.*\(__pycache__\|\.py[co]\)$' -delete
	zip -r dependencies.zip ./python
	ls -l
}

publish_dependencies_as_layer(){
	echo "Publishing dependencies as a layer..."
	local result=$(aws lambda publish-layer-version --layer-name "${INPUT_LAMBDA_LAYER_ARN}" --zip-file fileb://dependencies.zip)
	LAYER_VERSION=$(jq '.Version' <<< "$result")
	rm -rf python
	rm dependencies.zip
}

publish_function_code(){
	echo "Deploying the code itself..."
	cd "${INPUT_LAMBDA_DIRECTORY}"
	zip -r code.zip . -x \*.git\*
	aws lambda update-function-code --function-name "${INPUT_LAMBDA_FUNCTION_NAME}" --zip-file fileb://code.zip
}

update_function_layers(){
	echo "Using the layer in the function..."
	aws lambda update-function-configuration --function-name "${INPUT_LAMBDA_FUNCTION_NAME}" --layers "${INPUT_LAMBDA_LAYER_ARN}:${LAYER_VERSION}" "${INPUT_LAMBDA_EXTERNAL_LAYER}"
}

deploy_lambda_function(){
	install_zip_dependencies
	publish_dependencies_as_layer
	[ ! -z "${INPUT_LAMBDA_FUNCTION_NAME}" ] && publish_function_code && update_function_layers
}

deploy_lambda_function
echo "Done."
