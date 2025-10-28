import { createRouter, createWebHistory } from 'vue-router'
import ProductList from '../views/ProductList.vue'
import About from '../views/About.vue'

const router = createRouter({
  history: createWebHistory(import.meta.env.BASE_URL),
  routes: [
    {
      path: '/',
      name: 'products',
      component: ProductList
    },
    {
      path: '/about',
      name: 'about',
      component: About
    }
  ]
})

export default router

