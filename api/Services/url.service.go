package Services

import (
	"strings"
	"fmt"
)

func CreateFullUrl(proto string, host string, path string) string {
	normalizedProto := strings.ToLower(strings.Split(proto, "/")[0])
	return fmt.Sprintf("%s://%s%s", normalizedProto, host, path)
}