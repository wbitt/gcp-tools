FROM google/cloud-sdk:alpine as gcsdk

ENV HELM_VERSION v3.9.3

RUN     apk update && apk add curl openssl \
    &&  gcloud components list \
    &&  gcloud components install kubectl gke-gcloud-auth-plugin -q  \
    &&  rm -fr /var/cache/apk/* \
               /google-cloud-sdk/bin/anthoscli \
               /google-cloud-sdk/bin/kubectl.* \
               /google-cloud-sdk/bin/bq \
               /google-cloud-sdk/.install/.backup \
               $(find google-cloud-sdk/ -regex ".*/__pycache__") \
    &&  curl -s https://raw.githubusercontent.com/kubernetes/helm/master/scripts/get > get_helm.sh \
    &&  chmod +x get_helm.sh \
    &&  ./get_helm.sh --version ${HELM_VERSION}


FROM alpine as target
ENV  PATH "/google-cloud-sdk/bin:$PATH"
ENV  USE_GKE_GCLOUD_AUTH_PLUGIN=True
RUN      apk update \
     &&  apk add bash ca-certificates curl openssl python3 \
     &&  rm -rf /var/cache/apk/*
COPY --from=gcsdk /google-cloud-sdk   /google-cloud-sdk
COPY --from=gcsdk /usr/local/bin/     /usr/local/bin/






#####################################################################################################

# Notes:
# -----
# * The step "gcloud components remove anthoscli bq -q" can be executed as first RUN step,
#     but we are not going to waste time removing stuff using "gcloud .. remove ..",
#     as we are deleting certain files anyway using "rm -f" from the source image.
# * Available tools: docker, gcloud, gsutil, kubectl, helm + standard unix tools
# * Later possibilities: git, gnupg, libc-compat, py3-crcmod
# * In the target container,
#   * Helm needs: curl, openssl
#   * GCloud needs: python3
# * The new auth plugin is required from kubernetes 1.25+ .
#     To be able to use it before 1.25 arrives, we install it, and,
#     set an ENV variable USE_GKE_GCLOUD_AUTH_PLUGIN=True .

# Other notes:
# -----------
#
# The following does not work:
#      && echo 'export PATH=/google-cloud-sdk/bin:${PATH}' >> /etc/profile
# OR:
#      && echo 'export PATH=/google-cloud-sdk/bin:${PATH}' > /etc/profile.d/gcloud.sh
#
# So, the following is used, which sets up the PATH in the container environment at runtime:
# ENV  PATH "/google-cloud-sdk/bin:$PATH"
