import { createApp } from 'vue'
import ElementPlus from 'element-plus'
import es from 'element-plus/es/locale/lang/es'
import 'element-plus/dist/index.css'
//import App from './App.vue'
import App from './App.vue'
import router from './router'
import store from './store'

import './assets/main.css'

const app = createApp(App)

app.use(store)
app.use(router)


app.use(ElementPlus, {
  locale: es,
})
app.mount('#app')
