package router

import (
	"encoding/json"
	"fmt"
	"net/http"

	"github.com/gorilla/mux"

	"renatoaraujo/helloworld/internal/helloworld"
	"renatoaraujo/helloworld/pkg/logger"
)

type BirthdayRequest struct {
	DateOfBirth string `json:"dateOfBirth"`
}

type BirthdayResponse struct {
	Message string `json:"message"`
}

type RouterDependencies struct {
	LoggerClient logger.LoggerClient
}

func loggingMiddleware(next http.Handler, log logger.LoggerClient) http.Handler {
	return http.HandlerFunc(func(w http.ResponseWriter, r *http.Request) {
		log.Info(fmt.Sprintf("received request %s at %s", r.Method, r.RequestURI))
		next.ServeHTTP(w, r)
	})
}

func NewRouter(deps RouterDependencies) *mux.Router {
	r := mux.NewRouter()

	r.Use(func(next http.Handler) http.Handler {
		return loggingMiddleware(next, deps.LoggerClient)
	})

	helloWorldHandler := helloworld.NewHandler(deps.LoggerClient)

	r.HandleFunc("/hello/{username:[a-zA-Z]+}", func(w http.ResponseWriter, r *http.Request) {
		var req BirthdayRequest
		err := json.NewDecoder(r.Body).Decode(&req)
		if err != nil {
			deps.LoggerClient.Error("Error decoding request: ", err)
			http.Error(w, "invalid request", http.StatusBadRequest)
			return
		}

		username := helloworld.NewUsername(mux.Vars(r)["username"])
		birth := helloworld.NewDateOfBirth(req.DateOfBirth)
		err = helloWorldHandler.StoreUsername(username, birth)
		if err == nil {
			w.WriteHeader(http.StatusNoContent)
			return
		}

		http.Error(w, "failed to store user", http.StatusInternalServerError)
		return
	}).Methods("PUT")

	return r
}
