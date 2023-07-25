{{/* vim: set filetype=mustache: */}}

{{- define "generatezkprlist" -}}
{{- $nodeCount := $.zookeeper.replica | int }}
  {{- range $index0 := until $nodeCount -}}
    {{- $index1 := $index0 | add1 -}}
{{ $.zookeeper.name }}-{{ $index0 }}.{{ $.zookeeper.name }}.{{ $.zookeeper.domain }}:{{ $.zookeeper.port }}{{ if ne $index1 $nodeCount }},{{ end }}
  {{- end -}}
{{- end -}}
