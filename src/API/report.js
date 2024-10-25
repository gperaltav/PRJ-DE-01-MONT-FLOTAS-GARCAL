import axios from 'axios';

export const REAPI = axios.create({
  //baseURL: "http://localhost:7000/",
  baseURL: "http://51.222.25.71:8080/garcal-report-api/api/"
})