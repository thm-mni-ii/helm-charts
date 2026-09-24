{{- define "host" -}}
{{- if or (and (eq .Values.common.config.protocol "https:") (ne (toString .Values.common.config.port) "443")) (and (eq .Values.common.config.protocol "http:") (ne (toString .Values.common.config.port) "80")) -}}
{{ print .Values.common.config.protocol "//" .Values.common.config.hostname ":" .Values.common.config.port }}
{{- else -}}
{{ print .Values.common.config.protocol "//" .Values.common.config.hostname }}
{{- end -}}
{{- end -}}

{{- define "fbs-identity-image" -}}
{{ print .Values.identity.image.registry "/" .Values.identity.image.name ":" (default .Chart.AppVersion .Values.identity.image.tag) }}
{{- end -}}

{{- define "fbs-web-shell-image" -}}
{{ print .Values.webShell.image.registry "/" .Values.webShell.image.name ":" (default .Chart.AppVersion .Values.webShell.image.tag) }}
{{- end -}}

{{- define "fbs-course-management-web-image" -}}
{{ print .Values.courseManagementWeb.image.registry "/" .Values.courseManagementWeb.image.name ":" (default .Chart.AppVersion .Values.courseManagementWeb.image.tag) }}
{{- end -}}

{{- define "fbs-sql-playground-web-image" -}}
{{ print .Values.sqlPlaygroundWeb.image.registry "/" .Values.sqlPlaygroundWeb.image.name ":" (default .Chart.AppVersion .Values.sqlPlaygroundWeb.image.tag) }}
{{- end -}}

{{- define "oidc-issuer" -}}
{{- if and .Values.identity .Values.identity.config .Values.identity.config.oidc .Values.identity.config.oidc.issuer -}}
{{ .Values.identity.config.oidc.issuer }}
{{- else -}}
{{ include "host" . }}
{{- end -}}
{{- end -}}

{{- define "oidc-jwk-set-uri" -}}
{{- if and .Values.identity .Values.identity.config .Values.identity.config.oidc .Values.identity.config.oidc.jwkSetUri -}}
{{ .Values.identity.config.oidc.jwkSetUri }}
{{- else -}}
{{ print "http://" .Release.Name "-identity-service:8080/oauth2/jwks" }}
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

{{- define "fbs-collab-image" -}}
{{ print .Values.collab.image.registry "/" .Values.collab.image.name ":" (default .Chart.AppVersion .Values.collab.image.tag) }}
{{- end -}}

{{- define "fbs-qcm-backend-image" -}}
{{ print .Values.qcm.backend.image.registry "/" .Values.qcm.backend.image.name ":" (default .Chart.AppVersion .Values.qcm.backend.image.tag) }}
{{- end -}}

{{- define "fbs-qcm-frontend-image" -}}
{{ print .Values.qcm.frontend.image.registry "/" .Values.qcm.frontend.image.name ":" (default .Chart.AppVersion .Values.qcm.frontend.image.tag) }}
{{- end -}}

{{- define "parsr-image" -}}
{{ print .Values.parsr.image.registry "/" .Values.parsr.image.name ":" .Values.parsr.image.tag }}
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
