import axios from 'axios';

export const API = axios.create({
  //baseURL: "http://localhost:8080/garcal-erp-apiv1/api",
  baseURL: "http://51.222.25.71:8080/garcal-erp-apiv2/api/"
})