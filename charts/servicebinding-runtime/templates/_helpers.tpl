{{/*
Expand the name of the chart.
*/}}
{{- define "servicebinding-runtime.name" -}}
{{- default .Chart.Name .Values.nameOverride | trunc 63 | trimSuffix "-" }}
{{- end }}

{{/*
Create a default fully qualified app name.
We truncate at 63 chars because some Kubernetes name fields are limited to this (by the DNS naming spec).
If release name contains chart name it will be used as a full name.
*/}}
{{- define "servicebinding-runtime.fullname" -}}
{{- if .Values.fullnameOverride }}
{{- .Values.fullnameOverride | trunc 63 | trimSuffix "-" }}
{{- else }}
{{- $name := default .Chart.Name .Values.nameOverride }}
{{- if contains $name .Release.Name }}
{{- .Release.Name | trunc 63 | trimSuffix "-" }}
{{- else }}
{{- printf "%s-%s" .Release.Name $name | trunc 63 | trimSuffix "-" }}
{{- end }}
{{- end }}
{{- end }}

{{/*
Create chart name and version as used by the chart label.
*/}}
{{- define "servicebinding-runtime.chart" -}}
{{- printf "%s-%s" .Chart.Name .Chart.Version | replace "+" "_" | trunc 63 | trimSuffix "-" }}
{{- end }}

{{/*
Common labels
*/}}
{{- define "servicebinding-runtime.labels" -}}
helm.sh/chart: {{ include "servicebinding-runtime.chart" . }}
{{ include "servicebinding-runtime.selectorLabels" . }}
{{- if .Chart.AppVersion }}
app.kubernetes.io/version: {{ .Chart.AppVersion | quote }}
{{- end }}
app.kubernetes.io/managed-by: {{ .Release.Service }}
{{- end }}

{{/*
Selector labels
*/}}
{{- define "servicebinding-runtime.selectorLabels" -}}
app.kubernetes.io/name: {{ include "servicebinding-runtime.name" . }}
app.kubernetes.io/instance: {{ .Release.Name }}
{{- end }}

{{/*
Create the name of the service account to use
*/}}
{{- define "servicebinding-runtime.serviceAccountName" -}}
{{- if .Values.serviceAccount.create }}
{{- default (include "servicebinding-runtime.fullname" .) .Values.serviceAccount.name }}
{{- else }}
{{- default "default" .Values.serviceAccount.name }}
{{- end }}
{{- end }}

{{/*
Create the name of the cluster role for aggregation rule to use
*/}}
{{- define "servicebinding-runtime.clusterRoleName" -}}
{{- if .Values.rbac.create }}
{{- default (include "servicebinding-runtime.fullname" .) .Values.rbac.clusterRole.name }}
{{- else }}
{{- default "default" .Values.rbac.clusterRole.name }}
{{- end }}
{{- end }}

{{/*
Create the name of the cluster role binding to use
*/}}
{{- define "servicebinding-runtime.clusterRoleBindingName" -}}
{{- if .Values.rbac.create }}
{{- default (include "servicebinding-runtime.fullname" .) .Values.rbac.clusterRoleBinding.name }}
{{- else }}
{{- default "default" .Values.rbac.clusterRoleBinding.name }}
{{- end }}
{{- end }}


{{/*
Create the name of the role binding for leader election to use
*/}}
{{- define "servicebinding-runtime.leaderElectionBindingName" -}}
{{- printf "%s-%s" .Chart.Name .Chart.Version | replace "+" "_" | trunc 63 | trimSuffix "-" }}
{{ include "servicebinding-runtime.name" . }}
{{- if .Values.rbac.create }}
{{- default (include "servicebinding-runtime.fullname" .) .Values.rbac.clusterRoleBinding.name }}
{{- else }}
{{- default "default" .Values.rbac.clusterRoleBinding.name }}
{{- end }}
{{- end }}
