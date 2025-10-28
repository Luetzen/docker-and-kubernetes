import apiClient from './api'
import type { Product } from '@/types'

export const productService = {
  async getAll(): Promise<Product[]> {
    const response = await apiClient.get('/api/products')
    return response.data
  },

  async getById(id: number): Promise<Product> {
    const response = await apiClient.get(`/api/products/${id}`)
    return response.data
  },

  async create(product: Product): Promise<Product> {
    const response = await apiClient.post('/api/products', product)
    return response.data
  },

  async update(id: number, product: Product): Promise<Product> {
    const response = await apiClient.put(`/api/products/${id}`, product)
    return response.data
  },

  async delete(id: number): Promise<void> {
    await apiClient.delete(`/api/products/${id}`)
  },

  async search(name: string): Promise<Product[]> {
    const response = await apiClient.get('/api/products/search', {
      params: { name }
    })
    return response.data
  }
}

