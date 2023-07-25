{{/* vim: set filetype=mustache: */}}
{{/*
Determine the name depending on whether or not to use the release name.
*/}}
{{- define "otdsws.name" -}}
{{- if eq .Values.global.otdsUseReleaseName true }}
{{- printf "%s-%s" .Release.Name .Chart.Name -}}
{{- else }}
{{- printf "%s" .Chart.Name -}}
{{- end }}
{{- end -}}
{{/*
Determine the service name depending on whether or not to use the release name.
*/}}
{{- define "otdsws.service" -}}
{{- if eq .Values.global.otdsUseReleaseName true }}
{{- printf "%s-%s" .Release.Name .Values.serviceName -}}
{{- else }}
{{- printf "%s" .Values.serviceName -}}
{{- end }}
{{- end -}}
Determine the DB url to use
*/}}
{{- define "otdsws.dburl" -}}
    {{ required "A valid otdsws.otdsdb.url is required!" .Values.otdsdb.url | quote }}
{{- end -}}
{{/*
Create chart name and version as used by the chart label.
*/}}
{{- define "otdsws.chart" -}}
{{- printf "%s-%s" .Chart.Name .Chart.Version | replace "+" "_" | trunc 63 | trimSuffix "-" -}}
{{- end -}}
{{/*
Contruct a set of secret environment variables from custom secret. Could be used to refactor deployment
*/}}
{{- define "custom.secret.env" -}}
- name: OTDS_JAKARTA_PERSISTENCE_JDBC_PASSWORD
  valueFrom:
    secretKeyRef:
      name: {{ .Values.customSecretName }}
      key: OTDS_JAKARTA_PERSISTENCE_JDBC_PASSWORD
- name: OTDS_DIRECTORY_BOOTSTRAP_INITIALPASSWORD
  valueFrom:
    secretKeyRef:
      name: {{ .Values.customSecretName }}
      key: OTDS_DIRECTORY_BOOTSTRAP_INITIALPASSWORD
- name: OTDS_DIRECTORY_BOOTSTRAP_CRYPTSECRET
  valueFrom:
    secretKeyRef:
      name: {{ .Values.customSecretName }}
      key: OTDS_DIRECTORY_BOOTSTRAP_CRYPTSECRET
{{- if .Values.migration.enabled }}
- name: OTDS_DIRECTORY_BOOTSTRAP_PASSWORD
  valueFrom:
    secretKeyRef:
      name: {{ .Values.customSecretName }}
      key: OTDS_DIRECTORY_BOOTSTRAP_PASSWORD
{{- end }}{{- end -}}
{{/*
Common labels
*/}}
{{- define "otdsws.labels" -}}
app.kubernetes.io/name: {{ include "otdsws.name" . }}
helm.sh/chart: {{ include "otdsws.chart" . }}
app.kubernetes.io/instance: {{ .Release.Name }}
{{- if .Chart.AppVersion }}
app.kubernetes.io/version: {{ .Chart.AppVersion | quote }}
{{- end }}
app.kubernetes.io/managed-by: {{ .Release.Service }}
{{- end -}}
{{/*
Determine Pre Upgrade Job image tag
*/}}
{{- define "preupgrade.job.image.tag" -}}
{{- if .Values.migration.preUpgradeJob.image.tag -}}
{{ .Values.migration.preUpgradeJob.image.tag }}
{{- else }}
latest
{{- end }}
{{- end -}}
{{/*
Determine the DB url's host for automation
*/}}
{{- define "otdsdb.url.host" -}}
{{- if .Values.otdsdb.automaticDatabaseCreation.dbHost }}
  {{ .Values.otdsdb.automaticDatabaseCreation.dbHost }}
{{- else }}
  {{ required "A valid otdsws.otdsdb.url is required!" .Values.otdsdb.url | trimPrefix "jdbc:postgresql://" | regexFind "^[^:]*" | quote }}
{{- end }}
{{- end -}}
{{/*
OTDS server image
*/}}
{{- define "otds.image" -}}
{{- if .Values.image.source }}
    {{- if (regexFind "\\/$" .Values.image.source ) }}
    {{- printf "%s%s:%s" $.Values.image.source $.Values.image.name $.Values.image.tag -}}
  {{- else }}
    {{- printf "%s/%s:%s" $.Values.image.source $.Values.image.name $.Values.image.tag -}}
  {{- end }}
{{- else }}
  {{- printf "%s:%s" $.Values.image.name $.Values.image.tag -}}
{{- end }}
{{- end -}}
{{/*
database image e.g. for psql client running DB init
*/}}
{{- define "db.image" -}}
{{- if .Values.otdsdb.automaticDatabaseCreation.dbImage.source }}
  {{- if (regexFind "\\/$" .Values.otdsdb.automaticDatabaseCreation.dbImage.source ) }}
    {{- printf "%s%s:%s" $.Values.otdsdb.automaticDatabaseCreation.dbImage.source $.Values.otdsdb.automaticDatabaseCreation.dbImage.name $.Values.otdsdb.automaticDatabaseCreation.dbImage.tag -}}
  {{- else }}
    {{- printf "%s/%s:%s" $.Values.otdsdb.automaticDatabaseCreation.dbImage.source $.Values.otdsdb.automaticDatabaseCreation.dbImage.name $.Values.otdsdb.automaticDatabaseCreation.dbImage.tag -}}
  {{- end }}
{{- else }}
  {{- printf "%s:%s" $.Values.otdsdb.automaticDatabaseCreation.dbImage.name $.Values.otdsdb.automaticDatabaseCreation.dbImage.tag -}}
{{- end }}
{{- end -}}
{{/*
Determine the configmap name of initdb script depending on whether or not to use the release name.
*/}}
{{- define "initdb.script" -}}
{{- if eq .Values.global.otdsUseReleaseName true }}
{{- printf "%s-%s" .Release.Name "initdb-script" -}}
{{- else }}
{{- printf "%s" "initdb-script" -}}
{{- end }}
{{- end -}}
{{/*
Determine the role name of initdb.
*/}}
{{- define "initdb.role" -}}
{{- if eq .Values.global.otdsUseReleaseName true }}
{{- printf "%s-%s" .Release.Name "init-db-role" -}}
{{- else }}
{{- printf "%s" "init-db-role" -}}
{{- end }}
{{- end -}}
{{/*
Determine the rolebinding name of initdb.
*/}}
{{- define "initdb.rolebinding" -}}
{{- if eq .Values.global.otdsUseReleaseName true }}
{{- printf "%s-%s" .Release.Name "init-db-rbac" -}}
{{- else }}
{{- printf "%s" "init-db-rbac" -}}
{{- end }}
{{- end -}}