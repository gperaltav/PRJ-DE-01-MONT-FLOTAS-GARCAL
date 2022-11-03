import { createApp } from 'vue'
import ElementPlus from 'element-plus'
import es from 'element-plus/es/locale/lang/es'
import 'element-plus/dist/index.css'
import App from './App.vue'
import router from './router'
import store from './store'

import VueMobileDetection from 'vue-mobile-detection'

import './assets/main.css'

const app = createApp(App)

app.use(store)
app.use(router)
app.use(VueMobileDetection)


app.use(ElementPlus, {
  locale: es,
})
app.mount('#app')
