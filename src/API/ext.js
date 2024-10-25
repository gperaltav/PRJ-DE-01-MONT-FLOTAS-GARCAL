import axios from 'axios';

export const API = axios.create({
  //baseURL: "http://localhost:7000/",
  baseURL: "http://51.222.25.71:8080/"
})