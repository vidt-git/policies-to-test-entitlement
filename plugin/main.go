// Copyright IBM Corp. 2025, 2026

package main

import(
  "fmt"
  "io"
  "net/http"
  "strings"


  "github.com/hashicorp/terraform-policy-plugin-framework/policy-plugin/plugins"
)

func main() {
  plugins.RegisterFunction("echo", echo)
  plugins.RegisterFunction("trim", trim)
  plugins.RegisterFunction("http_get", http_get)
  plugins.Serve()
}

func echo(value string) (string, error) {
  return value, nil
}

func trim(value, prefix string) (string, error) {
  return strings.TrimPrefix(value, prefix), nil
}

func http_get(urlPath string) (string, error) {
	resp, err := http.Get(urlPath)
	if err != nil {
		return fmt.Sprintf("{\"message\": {}, \"error\": \"%s\"}", err.Error()), nil
	}
	defer resp.Body.Close()

	if resp.StatusCode < 200 || resp.StatusCode >= 300 {
		return fmt.Sprintf("{\"message\": {}, \"error\": \"HTTP status code: %d\"}", resp.StatusCode), nil
	}

	body, err := io.ReadAll(resp.Body)
	if err != nil {
		return fmt.Sprintf("{\"message\": {}, \"error\": \"%s\"}",err.Error()), nil
	}

	return fmt.Sprintf("{\"message\": %s, \"error\": \"\"}", string(body)), nil
}
