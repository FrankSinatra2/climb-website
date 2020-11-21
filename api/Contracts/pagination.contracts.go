package Contracts

type PageLinks struct {
	Self string `json:"self"`
	First string `json:"first,omitempty"`
	Next string `json:"next,omitempty"`
	Previous string `json:"previous,omitempty"`
	Last string `json:"last,omitempty"`
}