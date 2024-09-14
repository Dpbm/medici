package api

import (
  "io"
  "fmt"	
  "errors"
  "strings"
	"math/rand"
	"net/http"
	"github.com/gin-gonic/gin"
  "encoding/json"
)

var app *gin.Engine

type Data struct{
  IdProduto int64 `json:"idProduto"`
  NumeroRegistro string `json:"numeroRegistro"`
  NomeProduto string `json:"nomeProduto"`
  Expediente string `json:"expediente"`
  RazaoSocial string `json:"razaoSocial"`
  Cnpj string `json:"cnpj"`
  NumeroTransacao string `json:"numeroTransacao"`
  Data string `json:"data"`
  NumProcesso string `json:"numProcesso"`
  IdBulaPacienteProtegido string `json:"idBulaPacienteProtegido"`
  IdBulaProfissionalProtegido string `json:"idBulaProfissionalProtegido"`
  DataAtualizacao string `json:"dataAtualizacao"`
}

type ResponseData struct{
  Content []Data `json:"content"`
  TotalElements int16 `json:"totalElements"`
  TotalPages int16 `json:"totalPages"`
  Last bool `json:"last"`
  NumberOfElements int8 `json:"numberOfElements"`
  First bool `json:"first"`
  Sort any `json:"sort"`
  Size int8 `json:"size"`
  Number int8 `json:"number"`
}

const TotalAgents = 10;
var Agents = [TotalAgents]string{
	"Mozilla/5.0 (Windows NT 6.2; rv:20.0) Gecko/20121202 Firefox/20.0",
	"Mozilla/5.0 (X11; Fedora; Linux x86_64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/52.0.2743.116 Safari/537.36",
	"Mozilla/5.0 (X11; Linux i686; rv:16.0) Gecko/20100101 Firefox/16.0",
	"Opera/9.80 (X11; Linux i686) Presto/2.12.388 Version/12.16",
	"Mozilla/5.0 (iPad; U; CPU OS 3_2 like Mac OS X; en-us) AppleWebKit/531.21.10 (KHTML, like Gecko) Version/4.0.4 Mobile/7B334b Safari/531.21.10",
	"Mozilla/5.0 (iPad; U; CPU OS 4_2_1 like Mac OS X; ja-jp) AppleWebKit/533.17.9 (KHTML, like Gecko) Version/5.0.2 Mobile/8C148 Safari/6533.18.5",
	"Mozilla/5.0 (Linux; Android 4.4.2; LG-V410 Build/KOT49I.V41010d) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/30.0.1599.103 Safari/537.36",
	"Mozilla/5.0 (Linux; Android 7.0; Moto G (5) Plus Build/NPNS25.137-35-5) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/60.0.3112.107 Mobile Safari/537.36",
	"Mozilla/5.0 (Windows NT 6.1; WOW64) AppleWebKit/535.7 (KHTML, like Gecko) Chrome/16.0.912.36 Safari/535.7",
	"Mozilla/5.0 (Windows; U; Windows NT 5.1; en-US) AppleWebKit/531.21.8 (KHTML, like Gecko) Version/4.0.4 Safari/531.21.10"}


func construct_consult_url(name string) string{
	name = strings.ReplaceAll(name, " ", "+")
	return "https://consultas.anvisa.gov.br/api/consulta/bulario?count=1&filter%5BnomeProduto%5D=" + name +"&page=1"
}

func construct_pdf_url(id string) string{
	return "https://consultas.anvisa.gov.br/api/consulta/medicamentos/arquivo/bula/parecer/"+id+"/?Authorization="
}

func get_random_agent() string{
	return Agents[rand.Intn(TotalAgents)]
}

func consult_medicine(name string) (string, error, int) {
  url := construct_consult_url(name)

  client := &http.Client{}
  req, request_setup_err := http.NewRequest("GET", url, nil)
  if request_setup_err != nil {
    fmt.Println(request_setup_err)
    return "", errors.New("Request Setup Failed!"), http.StatusInternalServerError
  }
  
  req.Header.Set("UserAgent", get_random_agent())
  req.Header.Set("accept", "application/json, text/plain, */*")
  req.Header.Set("accept-language", "pt-BR,pt;q=0.9,en-US;q=0.8,en;q=0.7")
  req.Header.Set("authorization", "Guest")
  req.Header.Set("cache-control", "no-cache")
  req.Header.Set("if-modified-since", "Mon, 26 Jul 1997 05:00:00 GMT")
  req.Header.Set("pragma", "no-cache")
  req.Header.Set("sec-ch-ua-mobile", "?0")
  req.Header.Set("sec-ch-ua-platform", "\"Windows\"")
  req.Header.Set("sec-fetch-dest", "empty")
  req.Header.Set("sec-fetch-mode", "cors")
  req.Header.Set("sec-fetch-site", "same-origin")
  req.Header.Set("cookie", "FGTServer=77E1DC77AE2F953D7ED796A08A630A01A53CF6FE5FD0E106412591871F9A9BBCFBDEA0AD564FD89D3BDE8278200B; FGTServer=77E1DC77AE2F953D7ED796A08A630A01A53CF6FE5FD0E106412591871F9A9BBCFBDEA0AD564FD89D3BDE8278200B; FGTServer=77E1DC77AE2F953D7ED796A08A630A01A53CF6FE5FD0E106412591871F9A9BBCFBDEA0AD564FD89D3BDE8278200B; _pk_id.42.210e=8eca716434ce3237.1690380888.; FGTServer=77E1DC77AE2F953D7ED796A08A630A01A53CF6FE5FD0E106412591871F9A9BBCFBDEA0AD564FD89D3BDE8278200B; _cfuvid=L.SzxLLxZoWYrYqhaiRgS5MTkV77mwE5uIyLNWvyufk-1690462598410-0-604800000; _pk_ref.42.210e=%5B%22%22%2C%22%22%2C1690462669%2C%22https%3A%2F%2Fwww.google.com%2F%22%5D; _pk_ses.42.210e=1; cf_clearance=tk5QcLSYPlUQfr8s2bTGXyvC2KZdHcEIYU8r6HCgNvQ-1690462689-0-160.0.0")
  req.Header.Set("Referer", "https://consultas.anvisa.gov.br/")
  req.Header.Set("Referrer-Policy", "no-referrer-when-downgrade")
  
  response, request_err := client.Do(req)
  if request_err != nil {
    fmt.Println(request_err)
    return "", errors.New("Request Failed!"), http.StatusInternalServerError
  }

  defer response.Body.Close()

  body, parse_data_err := io.ReadAll(response.Body)
  if parse_data_err != nil{
    fmt.Println(parse_data_err);
    return "", errors.New("Parse data Failed!"), http.StatusInternalServerError
  } 

  var data ResponseData
  json_parse_err := json.Unmarshal(body, &data) 
  if json_parse_err != nil {
    fmt.Println(json_parse_err)
    return "", errors.New("Json parse Failed!"), http.StatusInternalServerError
  }

  if data.TotalElements < 1{
    fmt.Println("No elements were found!")
    return "", errors.New("No elements were found"), http.StatusNotFound
  }
 
  return data.Content[0].IdBulaPacienteProtegido, nil, http.StatusOK

}

func get_leaflet(c *gin.Context){
  name := c.Param("name")
  medicine_id, consult_err, status := consult_medicine(name)
	
  if consult_err != nil{
    c.JSON(status, gin.H{
      "message":consult_err.Error(),
    })
    return
  }

  c.JSON(http.StatusOK, gin.H{
	  "pdf_url":construct_pdf_url(medicine_id),
  })
}

func routes(){
  app.GET("/api/medicine/:name", get_leaflet)
}

func init(){
	app = gin.New()
  routes()
}

func Run(){
  app = gin.Default()
  routes()
  app.Run("localhost:3030")
}

func Handler(w http.ResponseWriter, r *http.Request) {
  app.ServeHTTP(w, r);
}
