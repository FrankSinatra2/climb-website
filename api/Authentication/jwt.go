package Authentication

import (
	"fmt"
	"api/Config"
	"github.com/dgrijalva/jwt-go"
)

type ClimbWebsiteClaims struct {
	User string `json:"user"`
	jwt.StandardClaims
}

const expiresAt = 15000
const issuer = "climb-website.com"

func GenerateJwt(username string, id string) (string, error) {

	claims := ClimbWebsiteClaims{
		User: fmt.Sprintf("%s|%s", id, username),
		StandardClaims: jwt.StandardClaims{
			ExpiresAt: expiresAt,
        	Issuer:    issuer,
		},
	}

	token := jwt.NewWithClaims(jwt.SigningMethodHS256, claims)

	tokenString, err := token.SignedString([]byte(Config.GetConfig().JwtSecret))

	if err != nil {
		return "", err
	}

	return tokenString, nil
}

func ExtractClaims(tokenString string) (*ClimbWebsiteClaims, error) {

	token, err := jwt.Parse(tokenString, func(token *jwt.Token) (interface{}, error) {
		if _, ok := token.Method.(*jwt.SigningMethodHMAC); !ok {
			return nil, fmt.Errorf("Unexpected signing method: %v", token.Header["alg"])
		}
		return Config.GetConfig().JwtSecret, nil
	})

	if err != nil {
		return nil, err
	}
	
	if claims, ok := token.Claims.(ClimbWebsiteClaims); ok && token.Valid {
		return &claims, nil
	}

	return nil, fmt.Errorf("Failed to extract claims")
}