package router

import (
	"encoding/json"
	"fmt"
	"net/http"

	"github.com/gorilla/mux"

	"renatoaraujo/helloworld/internal/helloworld"
	"renatoaraujo/helloworld/pkg/logger"
	"renatoaraujo/helloworld/pkg/storage"
)

type BirthdayRequest struct {
	DateOfBirth string `json:"dateOfBirth"`
}

type BirthdayResponse struct {
	Message string `json:"message"`
}

type RouterDependencies struct {
	Logger  logger.LoggerClient
	Storage storage.DynamoDBClientInterface
}

func loggingMiddleware(next http.Handler, log logger.LoggerClient) http.Handler {
	return http.HandlerFunc(func(w http.ResponseWriter, r *http.Request) {
		log.Info(fmt.Sprintf("received request %s at %s", r.Method, r.RequestURI))
		next.ServeHTTP(w, r)
	})
}

func NewRouter(deps RouterDependencies) *mux.Router {
	r := mux.NewRouter()
	l := deps.Logger

	r.Use(func(next http.Handler) http.Handler {
		return loggingMiddleware(next, deps.Logger)
	})

	helloWorldHandler := helloworld.NewHandler(deps.Storage)

	r.HandleFunc("/hello/{username:[a-zA-Z]+}", func(w http.ResponseWriter, r *http.Request) {
		var req BirthdayRequest
		err := json.NewDecoder(r.Body).Decode(&req)
		if err != nil {
			l.Error("Error decoding request: ", err)
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

		l.Error("failed to store user", err)
		http.Error(w, "failed to store user", http.StatusInternalServerError)
		return
	}).Methods("PUT")

	r.HandleFunc("/hello/{username:[a-zA-Z]+}", func(w http.ResponseWriter, r *http.Request) {
		username := helloworld.NewUsername(mux.Vars(r)["username"])
		birthdayMessage, err := helloWorldHandler.GetBirthdayMessage(username)
		if err != nil {
			l.Error("failed to get user", err)
			http.Error(w, "failed to get user", http.StatusInternalServerError)
			return
		}

		response := map[string]string{
			"message": birthdayMessage,
		}

		jsonResponse, err := json.Marshal(response)
		if err != nil {
			l.Error("failed to marshal JSON", err)
			http.Error(w, "failed to generate response", http.StatusInternalServerError)
			return
		}

		w.Header().Set("Content-Type", "application/json")
		w.WriteHeader(http.StatusOK)
		w.Write(jsonResponse)
	}).Methods("GET")

	return r
}
