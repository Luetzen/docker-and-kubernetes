{{/*
Expand the name of the chart.
*/}}
{{- define "fullstack-app.name" -}}
{{- default .Chart.Name .Values.nameOverride | trunc 63 | trimSuffix "-" }}
{{- end }}

{{/*
Create a default fully qualified app name.
*/}}
{{- define "fullstack-app.fullname" -}}
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
{{- define "fullstack-app.chart" -}}
{{- printf "%s-%s" .Chart.Name .Chart.Version | replace "+" "_" | trunc 63 | trimSuffix "-" }}
{{- end }}

{{/*
Common labels
*/}}
{{- define "fullstack-app.labels" -}}
helm.sh/chart: {{ include "fullstack-app.chart" . }}
{{ include "fullstack-app.selectorLabels" . }}
{{- if .Chart.AppVersion }}
app.kubernetes.io/version: {{ .Chart.AppVersion | quote }}
{{- end }}
app.kubernetes.io/managed-by: {{ .Release.Service }}
{{- end }}

{{/*
Selector labels
*/}}
{{- define "fullstack-app.selectorLabels" -}}
app.kubernetes.io/name: {{ include "fullstack-app.name" . }}
app.kubernetes.io/instance: {{ .Release.Name }}
{{- end }}

{{/*
Database labels
*/}}
{{- define "fullstack-app.database.labels" -}}
{{ include "fullstack-app.labels" . }}
app: {{ .Values.database.name }}
component: database
{{- end }}

{{/*
Backend labels
*/}}
{{- define "fullstack-app.backend.labels" -}}
{{ include "fullstack-app.labels" . }}
app: {{ .Values.backend.name }}
component: backend
{{- end }}

{{/*
Frontend labels
*/}}
{{- define "fullstack-app.frontend.labels" -}}
{{ include "fullstack-app.labels" . }}
app: {{ .Values.frontend.name }}
component: frontend
{{- end }}

