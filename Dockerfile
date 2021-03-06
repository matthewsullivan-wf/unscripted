FROM drydock-prod.workiva.net/workiva/smithy-runner-dart:1293220 as build

ARG BUILD_ID
ARG BUILD_NUMBER
ARG BUILD_URL
ARG GIT_COMMIT
ARG GIT_BRANCH
ARG GIT_TAG
ARG GIT_COMMIT_RANGE
ARG GIT_HEAD_URL
ARG GIT_MERGE_HEAD
ARG GIT_MERGE_BRANCH
WORKDIR /build/
ADD . /build/
RUN echo "Starting the script sections" && \
		dartfmt --set-exit-if-changed -n lib test tool example && \
		timeout 5m pub get && \
		pub run test && \
		tar -czvf unscripted.pub.tgz pubspec.yaml lib README.md LICENSE && \
		echo "Script sections completed"
ARG BUILD_ARTIFACTS_PUBSPEC_LOCK=/build/pubspec.lock
ARG BUILD_ARTIFACTS_PUB=/build/unscripted.pub.tgz
FROM scratch
