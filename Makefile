NAMESPACE := prod

build:
	docker build -t dataquestio/docs .

run:
	docker run --rm --name docs -p 80:80 dataquestio/docs

push:
	docker push dataquestio/docs

deploy:
	hyper pull dataquestio/docs:latest
	hyper service rolling-update --image dataquestio/docs:latest docs

check-links:
	wget --spider -e robots=off -r -p http://localhost:1313

gbuild:
	gcloud container builds submit --config cloudbuild.yaml .

reload:
	kubectl patch deployment docs -p "{\"spec\":{\"template\":{\"metadata\":{\"annotations\":{\"date\":\"`date +'%s'`\"}}}}}" -n $(NAMESPACE)
