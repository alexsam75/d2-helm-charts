{{/* vim: set filetype=mustache: */}}

{{- define "generatekfklist" -}}
{{- $nodeCount := $.fluentdConf.kafkabroker.replica | int }}
  {{- range $index0 := until $nodeCount -}}
    {{- $index1 := $index0 | add1 -}}
{{ $.fluentdConf.kafkabroker.name }}-{{ $index0 }}.{{ $.fluentdConf.kafkabroker.name }}.{{ $.fluentdConf.kafkabroker.domain }}:{{ $.fluentdConf.kafkabroker.port }}{{ if ne $index1 $nodeCount }},{{ end }}
  {{- end -}}
{{- end -}}
