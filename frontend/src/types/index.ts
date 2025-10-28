export interface Product {
  id?: number
  name: string
  description: string
  price: number
  stock: number
  createdAt?: string
  updatedAt?: string
}

export interface HealthResponse {
  status: string
  service: string
  timestamp: number
}

export interface InfoResponse {
  application: string
  version: string
  description: string
}

