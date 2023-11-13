{{/*
Base name for all resources based on appName parameter.
*/}}
{{- define "app.name" -}}
{{- default .Values.appName | trunc 63 | trimSuffix "-" }}
{{- end }}

{{/*
Create chart name and version as used by the chart label.
*/}}
{{- define "app.chart" -}}
{{- printf "%s-%s" .Chart.Name .Chart.Version | replace "+" "_" | trunc 63 | trimSuffix "-" }}
{{- end }}

{{/*
Common labels
*/}}
{{- define "app.labels" -}}
helm.sh/chart-name: {{ include "app.chart" . }}
helm.sh/chart-version: {{ include "app.chart" . }}
app.kubernetes.io/release-name: {{ .Release.Name }}
{{ include "app.selectorLabels" . }}
{{- if .Chart.AppVersion }}
app.kubernetes.io/app-version: {{ .Chart.AppVersion }}
{{- end }}
app.kubernetes.io/managed-by: {{ .Release.Service }}
{{- end }}

{{/*
Selector labels
*/}}
{{- define "app.selectorLabels" -}}
app.kubernetes.io/name: {{ include "app.name" . }}
app.kubernetes.io/instance: {{ .Release.Name }}
{{- end }}

{{/*
Create the name of the service account to use
*/}}
{{- define "app.serviceAccountName" -}}
{{- printf "%s-%s" (include "app.name" .) "sa" }}
{{- end }}

{{/*
Create name for deployment
*/}}
{{- define "app.deploymentName" -}}
{{- printf "%s-%s" (include "app.name" .) "depl" }}
{{- end }}

{{/*
Create name for service
*/}}
{{- define "app.serviceName" -}}
{{- printf "%s-%s" (include "app.name" .) "svc" }}
{{- end }}

{{/*
Create name for ingress
*/}}
{{- define "app.ingressName" -}}
{{- printf "%s-%s" (include "app.name" .) "ing" }}
{{- end }}

{{/*
Create name for horizontal pod autoscaler
*/}}
{{- define "app.hpaName" -}}
{{- printf "%s-%s" (include "app.name" .) "hpa" }}
{{- end }}
