{{- define "host" -}}
{{- if or (and (eq .Values.common.config.protocol "https:") (ne (toString .Values.common.config.port) "443")) (and (eq .Values.common.config.protocol "http:") (ne (toString .Values.common.config.port) "80")) -}}
{{ print .Values.common.config.protocol "//" .Values.common.config.hostname ":" .Values.common.config.port }}
{{- else -}}
{{ print .Values.common.config.protocol "//" .Values.common.config.hostname }}
{{- end -}}
{{- end -}}

{{- define "fbs-core-image" -}}
{{ print .Values.core.image.registry "/" .Values.core.image.name ":" (default .Chart.AppVersion .Values.core.image.tag) }}
{{- end -}}

{{- define "fbs-runner-image" -}}
{{ print .Values.runner.image.registry "/" .Values.runner.image.name ":" (default .Chart.AppVersion .Values.runner.image.tag) }}
{{- end -}}

{{- define "fbs-eat-image" -}}
{{ print .Values.eat.image.registry "/" .Values.eat.image.name ":" (default .Chart.AppVersion .Values.eat.image.tag) }}
{{- end -}}

{{- define "digital-classroom-url" -}}
{{- if .Values.digitalClassroom.enabled -}}
{{ print (include "host" .) .Values.digitalClassroom.config.path }}
{{- else -}}
{{ .Values.core.config.digitalClassroom.url }}
{{- end -}}
{{- end -}}

{{- define "digital-classroom-secret" -}}
{{- if .Values.digitalClassroom.enabled -}}
{{ .Values.digitalClassroom.config.secret }}
{{- else -}}
{{ .Values.core.config.digitalClassroom.secret }}
{{- end -}}
{{- end -}}
