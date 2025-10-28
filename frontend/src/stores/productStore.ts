import { defineStore } from 'pinia'
import { ref } from 'vue'
import { productService } from '@/services/productService'
import type { Product } from '@/types'

export const useProductStore = defineStore('product', () => {
  const products = ref<Product[]>([])
  const loading = ref(false)
  const error = ref<string | null>(null)

  async function fetchProducts() {
    loading.value = true
    error.value = null
    try {
      products.value = await productService.getAll()
    } catch (e: any) {
      error.value = e.message || 'Fehler beim Laden der Produkte'
      console.error(e)
    } finally {
      loading.value = false
    }
  }

  async function createProduct(product: Product) {
    loading.value = true
    error.value = null
    try {
      const created = await productService.create(product)
      products.value.push(created)
      return created
    } catch (e: any) {
      error.value = e.message || 'Fehler beim Erstellen des Produkts'
      console.error(e)
      throw e
    } finally {
      loading.value = false
    }
  }

  async function updateProduct(id: number, product: Product) {
    loading.value = true
    error.value = null
    try {
      const updated = await productService.update(id, product)
      const index = products.value.findIndex(p => p.id === id)
      if (index !== -1) {
        products.value[index] = updated
      }
      return updated
    } catch (e: any) {
      error.value = e.message || 'Fehler beim Aktualisieren des Produkts'
      console.error(e)
      throw e
    } finally {
      loading.value = false
    }
  }

  async function deleteProduct(id: number) {
    loading.value = true
    error.value = null
    try {
      await productService.delete(id)
      products.value = products.value.filter(p => p.id !== id)
    } catch (e: any) {
      error.value = e.message || 'Fehler beim Löschen des Produkts'
      console.error(e)
      throw e
    } finally {
      loading.value = false
    }
  }

  return {
    products,
    loading,
    error,
    fetchProducts,
    createProduct,
    updateProduct,
    deleteProduct
  }
})

