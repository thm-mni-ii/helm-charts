{{- define "host" -}}
{{ print .Values.common.config.protocol "//" .Values.common.config.hostname ":" .Values.common.config.port }}
{{- end -}}

{{- define "fbs-core-image" -}}
{{ print .Values.core.image.registry "/" .Values.core.image.name ":" (default .Chart.AppVersion .Values.core.image.tag) }}
{{- end -}}

{{- define "fbs-runner-image" -}}
{{ print .Values.runner.image.registry "/" .Values.runner.image.name ":" (default .Chart.AppVersion .Values.runner.image.tag) }}
{{- end -}}
